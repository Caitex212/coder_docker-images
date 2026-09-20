# syntax=docker/dockerfile:1.7
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

# --- yazi
RUN curl -LO https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip \
    && unzip -j yazi-x86_64-unknown-linux-gnu.zip -d /usr/local/bin '*/yazi' '*/ya' \
    && chmod +x /usr/local/bin/yazi /usr/local/bin/ya \
    && rm -f yazi-x86_64-unknown-linux-gnu.zip \
    && yazi --version

# Optional preview/navigation helpers yazi uses when present (image/video/pdf previews, fuzzy
# jump, smart cd). fd/ripgrep are already installed above.
RUN apt-get update && apt-get install -y \
    ffmpeg \
    7zip \
    jq \
    poppler-utils \
    fzf \
    zoxide \
    imagemagick \
    && rm -rf /var/lib/apt/lists/*

# --- Python: mason and several LSPs (pyright's runtime, formatters) expect python3/pip ---
RUN apt-get update && apt-get install -y python3 python3-pip python3-venv \
    && rm -rf /var/lib/apt/lists/*

# --- Node/npm: mason installs a large share of LSPs (tsserver, eslint, jsonls, etc) via npm ---
# Kept in the base image (not just the node variant) since mason needs it regardless of the
# language you're working in day to day.
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# --- JDK + build tools ---
RUN apt-get update && apt-get install -y wget apt-transport-https gpg \
    && wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null \
    && echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list \
    && apt-get update \
    && apt-get install -y temurin-21-jdk maven gradle \
    && rm -rf /var/lib/apt/lists/*

RUN java -version && javac -version && mvn -version && gradle -version

USER coder
WORKDIR /home/coder

# --- Your nvim config ---
COPY --chown=coder:coder nvim-config /home/coder/.config/nvim

# --- Minimal tmux config so sessions behave sanely by default ---
RUN echo 'set -g mouse on\nset -g history-limit 10000\nset -g default-terminal "tmux-256color"' > /home/coder/.tmux.conf

USER root
RUN <<'EOF'
cat >> /etc/bash.bashrc <<'YAZI_Y_FUNC'

function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
  command yazi "$@" --cwd-file="$tmp"
  if cwd="$(<"$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

eval "$(zoxide init bash)"
YAZI_Y_FUNC
EOF
USER coder

CMD ["sleep", "infinity"]
