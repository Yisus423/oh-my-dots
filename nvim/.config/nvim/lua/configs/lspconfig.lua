local nvlsp = require "nvchad.configs.lspconfig"
nvlsp.defaults()

local servers = { "html", "cssls", "ruff" }

-- Configuración para los servidores estándar
for _, lsp in ipairs(servers) do
  vim.lsp.config(lsp, {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  })
  vim.lsp.enable(lsp)
end

-- Configuración específica para TY (Astral)
-- La API 0.11 necesita saber los filetypes y el root_markers
vim.lsp.config("ty", {
  cmd = { "ty", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", ".git", "requirements.txt" },
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    python = {
      -- Esto busca automáticamente si hay un venv o usa el python3 del sistema
      pythonPath = vim.fn.glob("./.venv/bin/python") ~= "" and "./.venv/bin/python" or "python3"
    }
  }
})

vim.lsp.enable("ty")
