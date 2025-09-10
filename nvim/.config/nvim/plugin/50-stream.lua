local socket_path = "/tmp/nvim-append.sock"
local server = vim.loop.new_pipe()

local function start_server()
  server:bind(socket_path)

  server:listen(128, function(err)
    if err then return end
    local client = vim.loop.new_pipe()
    server:accept(client)

    local on_data_received = vim.schedule_wrap(function(err, data)
      if err or not data then
        client:close()
        return
      end

      local lines = vim.split(data, "\n", { trimempty = true })
      if #lines > 0 then
        vim.api.nvim_buf_set_lines(0, -1, -1, false, lines)
      end
    end)

    client:read_start(on_data_received)
  end)

  vim.api.nvim_create_autocmd('VimLeave', {
    pattern = "*",
    callback = function()
      server:close()
      vim.loop.fs_unlink(socket_path)
    end,
  })
end

local ok, err = pcall(start_server)

if not ok then
  print("INFO: No se pudo iniciar el servidor de socket. Probablemente otra instancia de nvim ya está activa. Error: " .. tostring(err))
end
