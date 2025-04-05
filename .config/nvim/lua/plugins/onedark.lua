return {
--  {
--   "olimorris/onedarkpro.nvim", 
 --   lazy = true,
 --   priority = 1000,
 --   config = function()
  --    vim.cmd("colorscheme onedark")
  --  end
 -- }
{
  'uZer/pywal16.nvim',
  -- for local dev replace with:
  -- dir = '~/your/path/pywal16.nvim',
  config = function()
    vim.cmd.colorscheme("pywal16")
  end,
}
}
