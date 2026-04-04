local nvlsp = require "nvchad.configs.lspconfig"

-- Carga las configuraciones por defecto (on_attach y capabilities)
nvlsp.defaults()

local servers = { "html", "cssls", "pyright", "ruff" }

for _, lsp in ipairs(servers) do
  -- La nueva API nativa de Neovim 0.11+
  vim.lsp.config(lsp, {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  })
  
  -- Ahora es obligatorio habilitar el servidor explícitamente
  vim.lsp.enable(lsp)
end
