vim.api.nvim_create_user_command('AskOpenCode', function()
    vim.ui.input({ prompt = 'Instrucciones: ' }, function(input)
        local opencode_bin = vim.fn.exepath('opencode')

        if not input or input == '' then
            if vim.env.TMUX then
                local cmd = 'tmux new-window ' .. vim.fn.shellescape(opencode_bin) .. ' -c'
                vim.fn.jobstart(cmd, { detach = true })
            else
                vim.api.nvim_command('terminal ' .. opencode_bin .. ' -c')
            end
            return
        end

        local archivo = vim.fn.expand('%')
        local linea = vim.fn.line('.')
        local columna = vim.fn.col('.')
        local ubicacion = string.format("@%s:%d:%d", archivo, linea, columna)
        local opencode_bin = vim.fn.exepath('opencode')

        local full = ubicacion .. " " .. input

        local escaped = vim.fn.shellescape(full)

        if vim.env.TMUX then
            local cmd = 'tmux new-window ' .. opencode_bin .. ' --agent single-file-editor -p ' .. escaped
            vim.fn.jobstart(cmd, { detach = true })
            return
        end

        vim.api.nvim_command('terminal opencode --agent single-file-editor -p ' .. escaped)
    end)
end, {})

-- Map <leader>o to the AskOpenCode command
vim.api.nvim_set_keymap('n', '<leader>o', ':AskOpenCode<CR>', { noremap = true, silent = true })

