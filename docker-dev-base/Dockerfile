FROM codercom/enterprise-base:ubuntu

USER root

# --- Core tools + everything Kickstart.nvim needs ---
# build-essential + cmake/gcc  -> treesitter parsers compile from source
# ripgrep, fd-find             -> telescope live_grep / find_files
# unzip, curl, git             -> lazy.nvim bootstrap + mason downloads
# xclip                        -> system clipboard support over SSH/X-forward (optional but cheap)
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    unzip \
    ripgrep \
    fd-find \
    tmux \
    xclip \
    ca-certificates \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Ubuntu ships fd as `fdfind` — Kickstart/telescope expects `fd` on PATH
RUN ln -sf $(which fdfind) /usr/local/bin/fd

# --- tree-sitter
RUN curl -LO https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz \
    && gunzip tree-sitter-linux-x64.gz \
    && install -m 755 tree-sitter-linux-x64 /usr/local/bin/tree-sitter \
    && rm -f tree-sitter-linux-x64 \
    && tree-sitter --version

# --- Neovim: grab a recent release build, apt's version is usually too old for lazy.nvim/blink.cmp ---
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
    && tar -C /opt -xzf nvim-linux-x86_64.tar.gz \
    && ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim \
    && rm nvim-linux-x86_64.tar.gz

# --- Python: mason and several LSPs (pyright's runtime, formatters) expect python3/pip ---
RUN apt-get update && apt-get install -y python3 python3-pip python3-venv \
    && rm -rf /var/lib/apt/lists/*

# --- Node/npm: mason installs a large share of LSPs (tsserver, eslint, jsonls, etc) via npm ---
# Kept in the base image (not just the node variant) since mason needs it regardless of the
# language you're working in day to day.
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

USER coder
WORKDIR /home/coder

# --- Your nvim config ---
COPY --chown=coder:coder nvim-config /home/coder/.config/nvim

# --- Minimal tmux config so sessions behave sanely by default ---
RUN echo 'set -g mouse on\nset -g history-limit 10000\nset -g default-terminal "tmux-256color"' > /home/coder/.tmux.conf

# --- Pre-fetch plugins so the first `nvim` launch in a new workspace isn't slow ---
# This runs lazy.nvim's sync headlessly at build time. It can't install LSPs via Mason here
# (no reliable network assumptions at build time in some setups), so Mason tools install on
# first real launch instead — that part will still take a minute the very first time.
RUN nvim --headless "+Lazy! sync" +qa || true

CMD ["sleep", "infinity"]
