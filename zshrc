#display branch name
autoload -Uz vcs_info colors && colors
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b'
setopt PROMPT_SUBST
PROMPT='${PWD/#$HOME/~} %{$fg[blue]%}${vcs_info_msg_0_}%{$reset_color%} %% '

function gb() {
if [ -n "$1" ]; then 
  git checkout -b $1
else
  git branch
fi
}

function gt() {
git fetch --all; git remote prune origin; git checkout --track "origin/$1"
}

alias gr="git pull --rebase"
alias gro="git fetch; git rebase origin/main"
alias ga="git add ."
alias gc="git commit -m"
alias gca="git commit --amend -m"
alias gcan="git commit --amend --no-edit"
alias gl="git log"
alias gp="git push origin \$(git branch --show-current)"
alias gpf="git push origin \$(git branch --show-current) --force"
alias gd="b=\$(git branch --show-current);git switch main; git branch -D \$b; git pull --rebase"
alias gs="git status"
