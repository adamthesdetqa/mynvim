vim.api.nvim_create_autocmd("BufWipeout", {
  pattern = "*",
  callback = function(ev)
    if vim.bo[ev.buf].filetype == "NvMenu" then
      print("BufWipeout NvMenu!")
    end
  end,
})
local b = vim.api.nvim_create_buf(false, true)
vim.bo[b].filetype = "NvMenu"
vim.api.nvim_buf_delete(b, {force=true})
