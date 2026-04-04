local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

-- Carga las configuraciones por defecto (on_attach y capabilities)
nvlsp.defaults()

local servers = { "html", "cssls", "pyright", "ruff" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
        on_attach = nvlsp.on_attach,
            on_init = nvlsp.on_init,
                capabilities = nvlsp.capabilities,
                  }
                  end

    }
-- read :h vim.lsp.config for changing options of lsp servers 
