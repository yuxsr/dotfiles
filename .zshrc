# lessの日本語対応
export LESSCHARSET=utf-8

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
setopt share_history

HISTCONTROL=ignoreboth

# Ctrl+Dでログアウトしてしまうことを防ぐ
setopt IGNOREEOF

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Ctrl+sのロック, Ctrl+qのロック解除を無効にする
setopt no_flow_control

# auto compile .zshrc
if [ ~/.zshrc -nt ~/.zshrc.zwc ]; then
  zcompile ~/.zshrc
fi

# 補完
autoload -Uz compinit
compinit

# starship
eval "$(starship init zsh)"

# mise
eval "$(~/.local/bin/mise activate zsh)"

##########
# fzf
##########
# fzfのデフォルト設定
export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --border \
--preview 'bat -n --color=always {}' --preview-window=right:50% \
--bind 'ctrl-/:change-preview-window(80%|hidden|)' \
--bind 'ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down'"

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# CTRL-/ to toggle small preview window to see the full command
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

# Print tree structure in the preview window
export FZF_ALT_C_OPTS="--preview 'tree -C {}'"

#ローカルにあるbranchを選択して切り替えられる
fbr() {
  local branches branch
  branches=$(git --no-pager branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

# cd with fzf
fcd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m --preview 'tree -C {}') &&
  cd "$dir"
}

# open vim with fzf
fvim() {
  local dir
  dir=$(find ${1:-.} -type f | fzf) &&
  vim "$dir"
}

#####
# ghq
#####

# cd ghq repo with fzf
gcd() {
	local groot=$(ghq root)
	local src=$(ghq list | fzf --preview "bat --color=always --style=header,grid --line-range :80 $groot/{}/README.*")
	if [ -n "$src" ]; then
		cd "$groot/$src"
	fi
}

# open vscode ghq repo with fzf
gcode() {
	local groot=$(ghq root)
	local src=$(ghq list | fzf --preview "bat --color=always --style=header,grid --line-range :80 $groot/{}/README.*")
	if [ -n "$src" ]; then
		code "$groot/$src"
	fi
}

# gadd() add existing repository to ghq
# 移行した後ものと場所にシンボリックリンクを作成する（GHQ_MIGRATOR_LINK=1）
function gadd() {
	if [ -z "$1" ]; then
		echo "Usage: gadd <targetpath>"
		return 1
	fi

	local groot=$(ghq root)
	local targetpath=$1

	$groot/github.com/astj/ghq-migrator/ghq-migrator.bash "$targetpath"

	while true; do
		echo "Do you want to add? (y/n)"
		read -r answer
		case $answer in
			[Yy]* )
				GHQ_MIGRATOR_ACTUALLY_RUN=1 GHQ_MIGRATOR_LINK=1 $groot/github.com/astj/ghq-migrator/ghq-migrator.bash "$targetpath"
				break
				;;
			[Nn]* )
				echo "Process terminated."
				return 0
				;;
			* )
				echo "Please answer yes (y) or no (n)."
				;;
		esac
	done
}

# golang
export GOPATH="$HOME/go"
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin

# kubectl
source <(kubectl completion zsh)
alias k=kubectl

# krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# sops age key file
export SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt"

# shell統合（terminalの拡大、縮小をするために導入）
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# init tmux
# すでにattachされているセッションがある場合は何もしない（tmux sessionに入った時にnestでエラーになるのを防ぐため）
# それ以外でセッションがあればatach、なければ新規にセッション作成
if [ -n "$(tmux ls 2>/dev/null | grep attached)" ]; then
        # do nothing
elif [ -n "$(tmux ls 2>/dev/null)" ]; then
        tmux a
else
        tmux
fi


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/yushi-abe/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/yushi-abe/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/yushi-abe/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/yushi-abe/google-cloud-sdk/completion.zsh.inc'; fi
