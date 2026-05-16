# --- ENTORNO Y VARIABLES ---
# Fish usa 'set -gx' (global y export) en lugar de 'export'
set -gx EDITOR nvim

# --- RUTAS (PATH) ---
# fish_add_path es la forma moderna y segura de añadir rutas en Fish. 
# Solo añade la ruta si no existe, evitando duplicados.
fish_add_path ~/.cargo/bin
fish_add_path ~/.local/bin
fish_add_path ~/.opencode/bin

# revisamos si ls shell es interactiva
status is-interactive; or return
# Sí lo es sigue leyendo la configuración

# --- COMPLETIONS (uv) ---
if type -q uv
    uv generate-shell-completion fish | source
    uvx --generate-shell-completion fish | source
end

# --- ABREVIATURAS Y ALIAS ---
# En Fish, 'abbr' es mejor que 'alias'. Expande el comando al presionar espacio,
# lo que deja el historial mucho más limpio y legible.
abbr -a bat batcat
abbr -a gc git commit
abbr -a ga git add
abbr -a gp git push
abbr -a gl git pull
# --- DESACTIVAR EL SALUDO DE FISH ---
set -g fish_greeting ""

# --- PLUGINS ---
# Inicializar Zoxide para Fish
zoxide init fish | source
