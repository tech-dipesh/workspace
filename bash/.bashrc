# ~/.bashrc – custom shell configuration for Dipesh
# Original PS1 parts: terminal title, newline, user icon, directory, git branch, arrow
PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]'
PS1+='\n\[\033[1;95m\]🤵 Dipesh\[\033[0m\]'
PS1+=' \[\033[30;106m\] 📁 \W \[\033[0m\]'
# PS1+=' \[\033[30;102m\]$(_git_ps1)\[\033[0m\]'
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
alias .1="cd ../"
alias .2="cd ../../"
alias .3="cd ../../../"
alias ~="cd ~"
alias pr="cd ~/Downloads/Project"
alias job="cd ~/Downloads/Project/Job\ Portal"
alias st="cd /d/Downloads/'Study Material'/"
alias github="cd D:/Desktop/github"
alias lua="cd ~/AppData/Local/nvim"
alias oa="cd '/d/Downloads/Study Material/Online_Assessments'"
alias rm="rm -i"
alias d="cd /d/"
alias workspace="cd ~/Documents/Future\ Learn/workspace"

# ──────────────────────────────────────────────────────────────────────────────
#  File listing
# ──────────────────────────────────────────────────────────────────────────────

alias ls='ls --color=auto'
alias ll='ls -la --color=auto'
alias l='ls -l --color=auto'
alias lt="ls -ltr"
alias lh="ls -lh"
alias ld="ls -d */"

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
# Add Only Untracked Files:
alias gaaa="git ls-files --others --exclude-standard | xargs git add"
ga() {
  git add "$@"
}
gc() {
  git commit -m "$1"
}

# ──────────────────────────────────────────────────────────────────────────────
#  Package & dev aliases
# ──────────────────────────────────────────────────────────────────────────────

alias vite="pn create vite@latest . -- --template react-ts --rolldown --immediate"
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
alias wc='warp-cli connect'
alias wd='warp-cli disconnect'
alias ws='warp-cli status'

# ──────────────────────────────────────────────────────────────────────────────
#  Various utilities
# ──────────────────────────────────────────────────────────────────────────────

alias nv='/c/Program\ Files/Neovim/bin/nvim.exe'
alias bash="vim  ~/.bashrc"
alias vimrc="vim  ~/.vimrc"
alias fast="speedtest"
alias count="find . -type f | grep -c \"^\""
alias cpen="cp .env.example .env"
alias tree='tree -F -I "node_modules|package-lock.json|pnpm-lock.yaml"'
alias catall="rg . -uu --no-messages --glob '!**/.next/**' --glob '!**/node_modules/**' --glob '!**/.git/**' --glob '!**/package-lock.json' --glob '!**/tsconfig.tsbuildinfo ' --glob '!**/pnpm-lock.yaml' --glob '!**/*.md' --glob '!**/*.pdf' --glob '!**/*.{png,jpg,jpeg,gif,webp,ico,svg}' --glob '!**/*.{mp4,mov,avi,mkv,webm,flv}'"
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
  rg -i -n \
    --glob='!node_modules/' \
    --glob='!.skip/' \
    --glob='!.next/' \
    --glob='!package-lock.json' \
    --glob='!pnpm-lock.yaml' \
    --glob='!yarn.lock' \
    "$@"
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
# Java Utilities
alias java5='cd "/c/Users/DIPESH/Downloads/Study Material/Java-5th-Sem"'
 jrun() {
   local file="${1%.java}" # remove .java if present
  javac "$file.java" && java "$file"
 }

jarun() {
  local filepath="$1"
  local dir=$(dirname "$filepath")

  # Extracts package declaration if it exists (e.g., "package com.example;")
  local pkg=$(awk '/^[[:space:]]*package[[:space:]]/ {gsub(/;|package[[:space:]]+/,""); print; exit}' "$filepath")

  # Extracts the main class name from the file
  local class_name=$(awk '/^[[:space:]]*(public[[:space:]]+)?class[[:space:]]+/ {
    for(i=1; i<=NF; i++) {
      if($i == "class") {
        print $(i+1);
        exit;
      }
    }
  }' "$filepath")

  # Compile the target file
  javac "$filepath" && {
    if [ -n "$pkg" ]; then
      # If a package exists, run from the root directory using the fully qualified name
      # Resolves package dots into a standard Java classpath format
      local root_dir=$(echo "$dir" | sed "s|/$(echo $pkg | sed 's|\.|/|g')\$||")
      java -cp "$root_dir" "${pkg}.${class_name}"
    else
      # Fallback for default package
      java -cp "$dir" "$class_name"
    fi
  }
}
crun() {
  local file="${1%.cpp}" # remove .java if present
  g++ "$file.cpp" -o a && ./a.exe
}
alias redis-cli='/c/Program\ Files/Memurai/memurai-cli.exe'
alias backend='cd ~/Downloads/Study\ Material/Backend\ Revision'
alias frontend='cd ~/Downloads/Study\ Material/Frontend\ Revision'
alias nextjs="pn create next-app@latest"
alias py='py -3.11'
alias python='py -3.11'
export PNPM_APPROVE_BUILDS=true

alias approve="pn approve-builds"
alias vercel="pnx vercel"
alias ubuntu="docker run -it -v my_secure_volume:/root ubuntu"
alias plogin="psql -U postgres -h 127.0.0.1"
alias common="cd D:/Documents/Less\ Common/"
export PNPM_APPROVE_BUILDS=true


# Function to change the terminal window name
rename-term() {
    read -p "Enter new terminal name: " new_title
    echo -ne "\e]2;$new_title\a"
}
# Bind F2 key to trigger the rename function
bind '"\eOQ": "rename-term\n"'
alias ffmpeg='cd /d/Desktop/ffmpeg'
PROMPT_COMMAND='echo -ne "\033]0;Git Bash\007"'
PROMPT_COMMAND='echo -ne "\033]0;${PWD##*/}\007"'
yt(){
	yt-dlp -f "bv*[height<=720]+ba/b[height<=720]" "$1"
}
ytc(){
	yt-dlp --cookies mycookies.txt --js-runtimes node -f "bv*[height<=720]+ba/b[height<=720]" "$1"
}
ytf(){
	yt-dlp --cookies-from-browser firefox --remote-components ejs:github -f "bv*[height<=480]+ba/b[height<=480]" "$1"
}
ytfs(){
	yt-dlp --cookies-from-browser firefox --remote-components ejs:github -f "bv*[height<=720]+ba/b[height<=720]" "$1"
}

audio(){
	yt-dlp --cookies-from-browser firefox --remote-components ejs:github -x --audio-format mp3 "$1"
}
export PGHOST="localhost"
export PGPORT="5432"
export PGDATABASE="postgres"
export PGUSER="postgres"
export PGPASSWORD="gita"
alias live-server="pnx live-server"
playlist(){
	yt-dlp -f "bestvideo[height<=720]+bestaudio/best[height<=720]" --merge-output-format mp4 -o "%(playlist_title)s/%(playlist_index)02d - %(title)s.%(ext)s" "$1"
}

export PATH="$PATH:/c/Users/DIPESH/.local/bin"
alias profile="vim ~/.bash_profile"
alias qwen="qwen.cmd"
export OPENAI_BASE_URL="https://api.groq.com/openai/v1"
export QWEN_MODEL="llama-3.1-8b-instant"
