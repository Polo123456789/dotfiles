local ROOT_MARKERS = { '.git', '.hg', 'package.json', 'stylua.toml', '.luarc.json', '.luarc.jsonc' }
local VISUAL_BLOCK = string.char(22)
local STARTUP_DELAY_MS = 4000
local READY_RETRIES = 40
local READY_DELAY_MS = 200
local APPEND_RETRIES = 20
local APPEND_DELAY_MS = 250
local unpack_args = table.unpack or unpack

local instances = {}
local next_instance_id = 0
local curl_bin = nil

local function notify(msg, level)
    local notify_fn = function()
        vim.notify(tostring(msg), level or vim.log.levels.INFO, { title = 'opencode' })
    end

    if vim.in_fast_event() then
        vim.schedule(notify_fn)
        return
    end

    notify_fn()
end

local function safe_call(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then
        notify(err, vim.log.levels.ERROR)
    end
end

local function safe_async(fn)
    return function(...)
        local args = { ... }
        safe_call(function()
            fn(unpack_args(args))
        end)
    end
end

local function defer(ms, fn)
    vim.defer_fn(safe_async(fn), ms)
end

local function next_id()
    next_instance_id = next_instance_id + 1
    return next_instance_id
end

local function now_ms()
    return vim.uv.now()
end

local function ensure_executable(bin)
    local path = vim.fn.exepath(bin)

    if path == '' then
        error(string.format('`%s` no esta en PATH', bin))
    end

    return path
end

local function get_curl_bin()
    if not curl_bin then
        curl_bin = ensure_executable('curl')
    end

    return curl_bin
end

local function current_workdir()
    return vim.uv.cwd() or vim.fn.getcwd()
end

local function find_project_root(start_path)
    local found = vim.fs.find(ROOT_MARKERS, { path = start_path, upward = true })[1]
    if found then
        return vim.fs.dirname(found)
    end
end

local function current_project_root()
    local file = vim.api.nvim_buf_get_name(0)
    if file ~= '' then
        local file_dir = vim.fs.dirname(file)
        local file_root = file_dir and find_project_root(file_dir)
        if file_root then
            return vim.fs.normalize(file_root)
        end
    end

    local cwd = current_workdir()
    return vim.fs.normalize(find_project_root(cwd) or cwd)
end

local function relative_path(root)
    local file = vim.api.nvim_buf_get_name(0)
    if file == '' then
        error('no hay archivo actual')
    end

    return vim.fs.relpath(root, file) or vim.fn.fnamemodify(file, ':~:.')
end

local function file_reference(root)
    return '@' .. relative_path(root)
end

local function in_visual_mode()
    local mode = vim.fn.mode()
    return mode == 'v' or mode == 'V' or mode == VISUAL_BLOCK
end

local function get_visual_range()
    local start_line
    local end_line

    if in_visual_mode() then
        start_line = vim.fn.getpos('v')[2]
        end_line = vim.fn.getcurpos()[2]
    end

    if not start_line or start_line == 0 or not end_line or end_line == 0 then
        start_line = vim.fn.line("'<")
        end_line = vim.fn.line("'>")
    end

    if start_line == 0 or end_line == 0 then
        error('no hay seleccion activa')
    end

    if start_line > end_line then
        start_line, end_line = end_line, start_line
    end

    return start_line, end_line
end

local function selection_reference(root)
    local start_line, end_line = get_visual_range()
    local ref = file_reference(root)

    if start_line == end_line then
        return string.format('%s#L%d', ref, start_line)
    end

    return string.format('%s#L%d-L%d', ref, start_line, end_line)
end

local function is_job_running(job_id)
    return type(job_id) == 'number' and vim.fn.jobwait({ job_id }, 0)[1] == -1
end

local function get_free_port()
    local server = vim.uv.new_tcp()
    if not server then
        error('no se pudo crear socket TCP para obtener un puerto libre')
    end

    local ok, bind_err = server:bind('127.0.0.1', 0)
    if not ok then
        server:close()
        error('no se pudo obtener un puerto libre: ' .. tostring(bind_err))
    end

    local sockname, name_err = server:getsockname()
    server:close()

    if not sockname or not sockname.port then
        error('no se pudo leer el puerto libre: ' .. tostring(name_err))
    end

    return sockname.port
end

local function clear_instance(root, instance_id)
    local current = instances[root]
    if not current then
        return
    end

    if instance_id and current.id ~= instance_id then
        return
    end

    instances[root] = nil
end

local function set_instance(root, instance)
    instances[root] = instance
    return instance
end

local function snapshot_instance(instance)
    return vim.tbl_extend('force', {}, instance)
end

local function is_current_snapshot(instance)
    local current = instances[instance.root]
    return current and current.id == instance.id
end

local function tmux_window_alive(window_id)
    if not window_id then
        return false
    end

    local result = vim.system({ 'tmux', 'display-message', '-p', '-t', window_id, '#{window_id}' }, { text = true }):wait()
    return result.code == 0 and vim.trim(result.stdout or '') ~= ''
end

local function instance_alive(instance)
    if not instance then
        return false
    end

    if instance.launcher == 'tmux' then
        return tmux_window_alive(instance.tmux_window_id)
    end

    return is_job_running(instance.job_id)
        and instance.bufnr
        and vim.api.nvim_buf_is_valid(instance.bufnr)
end

local function get_instance(root)
    local instance = instances[root]
    if not instance then
        return nil
    end

    if instance_alive(instance) then
        return instance
    end

    clear_instance(root, instance.id)
    return nil
end

local function focus_existing_terminal_window(bufnr)
    for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
            if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == bufnr then
                vim.api.nvim_set_current_tabpage(tabpage)
                vim.api.nvim_set_current_win(win)
                return tabpage
            end
        end
    end
end

local function ensure_terminal_window(instance)
    local tabpage = focus_existing_terminal_window(instance.bufnr)
    if tabpage then
        instance.tabpage = tabpage
        return
    end

    if instance.tabpage and vim.api.nvim_tabpage_is_valid(instance.tabpage) then
        vim.api.nvim_set_current_tabpage(instance.tabpage)
        vim.cmd('botright split')
    else
        vim.cmd('tabnew')
    end

    vim.api.nvim_win_set_buf(0, instance.bufnr)
    instance.tabpage = vim.api.nvim_get_current_tabpage()
end

local function start_opencode_nvim(opencode_bin, root, port)
    local instance_id = next_id()
    local origin_tabpage = vim.api.nvim_get_current_tabpage()

    vim.cmd('tabnew')

    local tabpage = vim.api.nvim_get_current_tabpage()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.bo[bufnr].buflisted = false
    vim.bo[bufnr].bufhidden = 'hide'

    local job_id = vim.fn.termopen({ opencode_bin, '--port', tostring(port) }, {
        cwd = root,
        env = { OPENCODE_CALLER = 'nvim' },
        on_exit = function()
            vim.schedule(function()
                clear_instance(root, instance_id)
            end)
        end,
    })

    if not job_id or job_id <= 0 then
        if vim.api.nvim_get_current_tabpage() == tabpage then
            pcall(vim.cmd, 'tabclose')
        end
        if vim.api.nvim_tabpage_is_valid(origin_tabpage) then
            vim.api.nvim_set_current_tabpage(origin_tabpage)
        end
        error('no se pudo lanzar opencode en la terminal')
    end

    local instance = set_instance(root, {
        id = instance_id,
        root = root,
        launcher = 'nvim',
        port = port,
        -- /app puede responder antes de que append-prompt quede persistido.
        ready_at = now_ms() + STARTUP_DELAY_MS,
        bufnr = bufnr,
        job_id = job_id,
        tabpage = tabpage,
    })

    if vim.api.nvim_tabpage_is_valid(origin_tabpage) then
        vim.api.nvim_set_current_tabpage(origin_tabpage)
    end

    return instance
end

local function start_opencode_tmux(opencode_bin, root, port)
    local command = string.format('OPENCODE_CALLER=nvim %s --port %d', vim.fn.shellescape(opencode_bin), port)
    local result = vim.system({
        'tmux',
        'new-window',
        '-d',
        '-P',
        '-F',
        '#{window_id}',
        '-c',
        root,
        command,
    }, { text = true }):wait()

    if result.code ~= 0 then
        error('no se pudo lanzar opencode en tmux: ' .. vim.trim(result.stderr or result.stdout or ''))
    end

    local window_id = vim.trim(result.stdout or '')
    if window_id == '' then
        error('tmux no devolvio un window id para opencode')
    end

    local instance_id = next_id()

    return set_instance(root, {
        id = instance_id,
        root = root,
        launcher = 'tmux',
        port = port,
        ready_at = now_ms() + STARTUP_DELAY_MS,
        tmux_window_id = window_id,
    })
end

local function start_opencode(root)
    local opencode_bin = ensure_executable('opencode')
    local port = get_free_port()

    if vim.env.TMUX then
        return start_opencode_tmux(opencode_bin, root, port)
    end

    return start_opencode_nvim(opencode_bin, root, port)
end

local function ensure_instance(root)
    local instance = get_instance(root)
    if instance then
        return instance, false
    end

    return start_opencode(root), true
end

local function http_request(method, port, path, body, callback)
    local args = {
        get_curl_bin(),
        '--silent',
        '--show-error',
        '--fail-with-body',
        '--connect-timeout',
        '1',
        '--max-time',
        '3',
        '--request',
        method,
        string.format('http://127.0.0.1:%d%s', port, path),
    }

    if body then
        vim.list_extend(args, {
            '--header',
            'Content-Type: application/json',
            '--data',
            vim.json.encode(body),
        })
    end

    vim.system(args, { text = true }, safe_async(function(result)
        if result.code == 0 then
            callback(true, result.stdout)
            return
        end

        local err = result.stderr ~= '' and result.stderr or result.stdout
        callback(false, err ~= '' and err or ('curl fallo con codigo ' .. result.code))
    end))
end

local function wait_until_ready(instance, callback, attempts)
    attempts = attempts or READY_RETRIES

    if not is_current_snapshot(instance) then
        callback(false, 'la instancia de opencode ya no esta disponible')
        return
    end

    http_request('GET', instance.port, '/app', nil, function(ok)
        if not is_current_snapshot(instance) then
            callback(false, 'la instancia de opencode ya no esta disponible')
            return
        end

        if ok then
            callback(true)
            return
        end

        if attempts <= 1 then
            clear_instance(instance.root, instance.id)
            callback(false, 'opencode no respondio en http://127.0.0.1:' .. instance.port .. '/app')
            return
        end

        defer(READY_DELAY_MS, function()
            wait_until_ready(instance, callback, attempts - 1)
        end)
    end)
end

local function append_prompt(instance, text, callback, attempts)
    attempts = attempts or APPEND_RETRIES

    if not is_current_snapshot(instance) then
        callback(false, 'la instancia de opencode ya no esta disponible')
        return
    end

    wait_until_ready(instance, function(ok, err)
        if not ok then
            callback(false, err)
            return
        end

        if not is_current_snapshot(instance) then
            callback(false, 'la instancia de opencode ya no esta disponible')
            return
        end

        http_request('POST', instance.port, '/tui/append-prompt', { text = text }, function(post_ok, result)
            if not is_current_snapshot(instance) then
                callback(false, 'la instancia de opencode ya no esta disponible')
                return
            end

            if post_ok then
                callback(true)
                return
            end

            if attempts <= 1 then
                clear_instance(instance.root, instance.id)
                callback(false, 'fallo el POST a /tui/append-prompt: ' .. tostring(result))
                return
            end

            defer(APPEND_DELAY_MS, function()
                append_prompt(instance, text, callback, attempts - 1)
            end)
        end)
    end)
end

local function focus_instance(instance)
    local function focus()
        local current = get_instance(instance.root)
        if not current or current.id ~= instance.id then
            return
        end

        if current.launcher == 'tmux' then
            local result = vim.system({ 'tmux', 'select-window', '-t', current.tmux_window_id }, { text = true }):wait()
            if result.code ~= 0 then
                error('no se pudo enfocar la ventana de tmux para opencode')
            end
            return
        end

        ensure_terminal_window(current)
    end

    if vim.in_fast_event() then
        vim.schedule(safe_async(focus))
        return
    end

    focus()
end

local function send_text(root, text, focus)
    local instance, started_now = ensure_instance(root)
    local snapshot = snapshot_instance(instance)
    local delay_ms = math.max(0, snapshot.ready_at - now_ms())

    if started_now then
        notify('Iniciando opencode...')
    end

    local send_prompt = function()
        append_prompt(snapshot, text, function(ok, err)
            if not ok then
                notify(err, vim.log.levels.ERROR)
                return
            end

            if focus then
                focus_instance(snapshot)
            end
        end)
    end

    if delay_ms > 0 then
        defer(delay_ms, send_prompt)
        return
    end

    send_prompt()
end

local function send_current_file()
    local root = current_project_root()
    send_text(root, file_reference(root), true)
end

local function send_current_selection()
    local root = current_project_root()
    send_text(root, selection_reference(root), true)
end

local function with_error_boundary(fn)
    return function(...)
        local args = { ... }
        safe_call(function()
            fn(unpack_args(args))
        end)
    end
end

vim.keymap.set('n', '<leader>o', with_error_boundary(send_current_file), {
    silent = true,
    desc = 'Send current file to opencode',
})

vim.keymap.set('x', '<leader>o', with_error_boundary(send_current_selection), {
    silent = true,
    desc = 'Send current selection to opencode',
})
