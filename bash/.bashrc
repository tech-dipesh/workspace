# ~/.bashrc – custom shell configuration for Dipesh
# Original PS1 parts: terminal title, newline, user icon, directory, git branch, arrow
PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]'
PS1+='\n\[\033[1;95m\]🤵 Dipesh\[\033[0m\]'
PS1+=' \[\033[30;106m\] 📁 \W \[\033[0m\]'
PS1+='\[\033[30;102m\]`_git_ps1`\[\033[0m\]'
PS1+='\n\[\033[1;32m\]➜\[\033[0m\] '

# Git branch helper for prompt
_git_ps1() {
  local b=$(git branch 2>/dev/null | grep '\*' | cut -d' ' -f2-)
  [ -n "$b" ] && echo "  $b "
}
# ──────────────────────────────────────────────────────────────────────────────
#  Local settings (locale, bracketed paste)
# ──────────────────────────────────────────────────────────────────────────────

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
bind 'set enable-bracketed-paste off'

# ──────────────────────────────────────────────────────────────────────────────
#  Aliases – navigation & shortcuts
# ──────────────────────────────────────────────────────────────────────────────

alias source="source ~/.bashrc"
alias .='code -r .'
alias .1="cd ../"
alias .2="cd ../../"
alias .3="cd ../../../"
alias ~="cd ~"
alias pr="cd ~/Downloads/Project"
alias job="cd ~/Downloads/Project/Job\ Portal"
alias st="cd ~/Downloads/'Study Material'/"
alias github="cd D:/Desktop/github"
alias lua="cd ~/AppData/Local/nvim"
alias gssoc="cd D:Desktop/github/26_gssoc"
alias oa="cd ~/'Downloads/Study Material/Online_Assessments'"

# ──────────────────────────────────────────────────────────────────────────────
#  File listing
# ──────────────────────────────────────────────────────────────────────────────

alias ls='ls --color=auto'
alias ll='ls -la --color=auto'
alias l='ls -l --color=auto'
alias lt="ls -ltr"

# ──────────────────────────────────────────────────────────────────────────────
#  Git aliases
# ──────────────────────────────────────────────────────────────────────────────

alias gs='git status'
alias gd='git diff --color'
alias gl='git log --oneline --graph --decorate --all --color'
alias status='git status'
alias gpom="git push origin main"
alias gcm="git checkout -b main"
alias push="git push"
alias add="git add ."
alias gaa="git add --all"
ga() {
  git add "$@"
}
gc() {
  git commit -m "$1"
}

# ──────────────────────────────────────────────────────────────────────────────
#  Package & dev aliases
# ──────────────────────────────────────────────────────────────────────────────

alias vite="pn create vite@latest . -- --template react --rolldown --immediate"
alias run="npm run dev"
alias start="npm start"
alias dev='npm run dev'
alias ns="npm start"
alias nrd="npm run dev"
alias ni="npm i"
alias nt="npm test"
alias test="npm test"
alias nrb="npm run backend"
alias nrf="npm run frontend"

# ──────────────────────────────────────────────────────────────────────────────
#  Docker & container aliases
# ──────────────────────────────────────────────────────────────────────────────

alias dps="docker ps -a"
dex() {
  docker exec -it $1
}
db() {
  docker build -t $1 .
}
alias dcu="docker-compose up -d"
alias dlog="docker-compose logs -f"
alias dcd="docker-compose down"
alias di="docker images -a"
alias dip="docker image prune"
alias redis="docker exec -it my-redis redis-cli"

# ──────────────────────────────────────────────────────────────────────────────
#  Network & Warp (Cloudflare)
# ──────────────────────────────────────────────────────────────────────────────

alias yt-dlp='./yt-dlp.exe'
alias warp=warp-cli
alias wc='warp-cli connect'
alias wd='warp-cli disconnect'
alias ws='warp-cli status'

# ──────────────────────────────────────────────────────────────────────────────
#  Various utilities
# ──────────────────────────────────────────────────────────────────────────────

alias nv='/c/Program\ Files/Neovim/bin/nvim.exe'
alias bash="vim  ~/.bashrc"
alias fast="speedtest"
alias count="find . -type f | grep -c \"^\""
alias cpen="cp .env.example .env"
alias tree='tree -F -I "node_modules|package-lock.json|pnpm-lock.yaml"'
alias catall="rg . -uu --no-messages --glob '!**/node_modules/**' --glob '!**/.git/**' --glob '!**/package-lock.json' --glob '!**/pnpm-lock.yaml' --glob '!**/*.md' --glob '!**/*.pdf' --glob '!**/*.{png,jpg,jpeg,gif,webp,ico,svg}' --glob '!**/*.{mp4,mov,avi,mkv,webm,flv}'"
alias catall1='find . -type f ! -path "*/.git/*" ! -path "*/node_modules/*" ! -name "*.png" ! -name "*.jpg" ! -name "*.jpeg" ! -name "*.pdf" ! -name "*package-lock*" ! -name "*pnpm-lock*" -exec cat {} + 2>/dev/null'

# ──────────────────────────────────────────────────────────────────────────────
#  Functions
# ──────────────────────────────────────────────────────────────────────────────

mkcd() {
  mkdir -p "$1" && cd "$1"
}

hg() {
  history | grep "$1"
}

finda() {
  rg -n --glob='!node_modules/' --glob='!package-lock.json' --glob='!pnpm-lock.yaml' --glob='!yarn.lock' "$1"
}
gex() {
  grep -rnw . --exclude-dir={$1}
}

watch() {
  local interval=1
  if [ "$1" = "-n" ]; then
    interval="$2"
    shift 2
  fi
  while true; do
    clear
    cmd //c tree "$@"
    sleep "$interval"
  done
}

# robust Fuzzy Matcher – uses fd if available, otherwise find
ff() {
  if command -v fd &>/dev/null; then
    fd --type f --color=always \
      --exclude "*.png" \
      --exclude "*.jpg" \
      --exclude "*.jpeg" \
      --exclude "*.gif" \
      --exclude "*.ico" \
      --exclude "*.pdf" \
      --exclude "package-lock.json" \
      --exclude "pnpm-lock.yaml" \
      --exclude "yarn.lock" \
      "$1" | fzf --ansi
  else
    find . -type f \
      ! -path "*/.*" \
      ! -path "*/node_modules/*" \
      ! -path "*/vendor/*" \
      ! -path "*/dist/*" \
      ! -path "*/build/*" \
      ! -name "*.png" \
      ! -name "*.jpg" \
      ! -name "*.jpeg" \
      ! -name "*.gif" \
      ! -name "*.ico" \
      ! -name "*.pdf" \
      ! -name "*.zip" \
      ! -name "*.tar.gz" \
      ! -name "package-lock.json" \
      ! -name "pnpm-lock.yaml" \
      ! -name "yarn.lock" \
      2>/dev/null | grep -i "$1" | fzf
  fi
}
export PATH="$PATH:/d/Documents/platform-tools"

alias nodemon="pnx nodemon"
alias render='/c/cli-tools/render.exe'
alias java5='cd "/c/Users/DIPESH/Downloads/Study Material/Java-5th-Sem"'
javarun() {
  local file="${1%.java}" # remove .java if present
  javac "$file.java" && java "$file"
}
crun() {
  local file="${1%.cpp}" # remove .java if present
  g++ "$file.cpp" -o a && ./a.exe
}
alias redis-cli='/c/Program\ Files/Memurai/memurai-cli.exe'
alias backend='cd ~/Downloads/Study\ Material/Backend\ Revision'
alias frontend='cd ~/Downloads/Study\ Material/Frontend\ Revision'
alias nextjs="pn create next-app@latest"
alias vim="nvim"
alias py='py -3.11'
alias python='py -3.11'
export PNPM_APPROVE_BUILDS=true

alias approve="pn approve-builds"
alias vercel="pnx vercel"
alias plogin="psql -U postgres -h 127.0.0.1"
