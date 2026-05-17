# # bash command for defalt
# # Ultimate Dipesh Bash Prompt

# # Alias . to open current directory in current VS Code window
# alias .='code -r .'

PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]'
PS1+='\n\[\033[1;95m\]🤵 Dipesh\[\033[0m\]'
PS1+=' \[\033[30;106m\] 📁 \W \[\033[0m\]'
PS1+='\[\033[30;102m\]`_git_ps1`\[\033[0m\]'
PS1+='\n\[\033[1;32m\]➜\[\033[0m\] '

_git_ps1() {
  local b=$(git branch 2>/dev/null | grep '\*' | cut -d' ' -f2-)
  [ -n "$b" ] && echo "  $b "
}

alias source="source ~/.bashrc"
alias .='code -r .'
alias vite="npm create vite@latest . -- --template react --rolldown --immediate"
alias run="npm run dev"
alias start="npm start"
alias test="npm test"
alias push="git push"
alias add="git add ."

alias ls='ls --color=auto'
alias ll='ls -la --color=auto'
alias l='ls -l --color=auto'

alias gs='git status'
alias gd='git diff --color'
alias gl='git log --oneline --graph --decorate --all --color'
alias yt-dlp='./yt-dlp.exe'
alias warp=warp-cli
alias wc='warp-cli connect'
alias wd='warp-cli disconnect'
alias ws='warp-cli status'
alias status='git status'
alias dev='npm run dev'
alias ns="npm start"
alias nrd="npm run dev"
alias ni="npm i"
alias gpom="git push origin main"
alias gcm="git checkout -b main"
alias nt="npm test"
gc() {
  git commit -m "$1"
}
ga() {
  git add $1
}
alias redis="docker exec -it my-redis redis-cli"
alias nrb="npm run backend"
alias nrf="npm run frontend"
alias gaa="git add --all"


mkcd() {
  mkdir -p "$1" && cd "$1"
}
hg() {
  history | grep "$1"
}
alias pr="cd ~/Downloads/Project"
alias st="cd ~/Downloads/'Study Material'/'Frontend Revision'/"
alias ~="cd ~"
alias lua="cd ~/AppData/Local/nvim/lua"
alias github="cd D:/Desktop/github"
alias bash="vim  ~/.bashrc"
alias dps="docker ps -a"
dex(){
docker exec -it $1
}
db(){
docker build -t $1 .
}
alias .2="cd ../../"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
bind 'set enable-bracketed-paste off'
alias  count="find . -type f | grep -c "^""
alias  .1="cd ../"
alias .3="cd ../../../"

finda(){
	rg -n "$1"
}
alias dup="docker-compose up -d"
alias dlog="docker-compose logs -f"
alias nv='/c/Program\ Files/Neovide/neovide.exe'
