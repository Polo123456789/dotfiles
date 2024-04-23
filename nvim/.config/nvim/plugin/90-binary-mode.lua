local binaryAuGroup = vim.api.nvim_create_augroup('Binary', {clear = true});

local function binBuffReadPost()
    vim.b.bin = true
    vim.cmd('%!xxd')
    vim.b.filetype = 'xxd'
end

vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*.bin',
  group = binaryAuGroup,
  callback = binBuffReadPost
})

local function binBuffWritePre()
    if vim.b.bin then
	vim.cmd('%!xxd -r')
    end
end

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.bin',
  group = binaryAuGroup,
  callback = binBuffWritePre
})

local function binBuffWritePost()
    if vim.b.bin then
	vim.cmd('%!xxd')
	vim.b.modified = false
    end
end

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*.bin',
  group = binaryAuGroup,
  callback = binBuffWritePost
})
