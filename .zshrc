# https://wiki.archlinux.org/title/zsh

test -n "$RUN_PROFILER" && zmodload zsh/zprof

case "$OSTYPE" in
	darwin*)
		if command -v gdate >/dev/null; then
			get_date() { printf "%s" $(gdate +%s%N) }
			bootTimeStart=$(get_date)
		else
			get_date() { printf "0" }
			bootTimeStart=0
			noStartTime=1
		fi
		;;
	*)
		# measure boot time (see also the last line)
		# note: uses gnu-date
		get_date() { printf "%s" $(date +%s%N) }
		bootTimeStart=$(get_date)
		;;
esac

rel() {
	source "$HOME/.zshrc"
	source "$HOME/.profile"
}

source ~/zsh-defer/zsh-defer.plugin.zsh

# handle mac-os specifics
case "$OSTYPE" in
	darwin*)
		# make gnu date (gdate) take over osx date, & other utils.
		# see
		# https://apple.stackexchange.com/a/371984/429613
		HOMEBREW_PREFIX=$(brew --prefix)

		for d in ${HOMEBREW_PREFIX}/opt/*/libexec/gnubin; do
			export PATH="$d:$PATH"
		done

		for d in ${HOMEBREW_PREFIX}/opt/*/libexec/gnuman; do
			export MANPATH="$d:$MANPATH"
		done

		# higher precedence
		export PATH="$HOMEBREW_PREFIX/bin:$PATH"

		# disabled because no longer needed apparently -
		# works just fine w/o it, even the 'date' stuff - 
		# for it, just extending the $PATH is enough
		# since we have the gnu-date installed
		#
		## source .profile if haven't already
		#[ -z "$SOURCED_DOT_PROFILE" ] && source "$HOME/.profile"


		# will load nvm if it wasn't loaded already,
		# but only when it's called
		[ -n "nvm" ] && {
			nvm() {
				# here, put everything that you'd
				# normally put directly in your zshrc/bashrc/.profile
				# (i.e., the official steps to load nvm):
				export NVM_DIR="$HOME/.config/nvm"
				[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
				[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


				# by now, "nvm" will be replaced with the a new "nvm" function
				# (the one that we actually want),
				# and thus infinite loops will not occur.
				# 
				# also, since "nvm" will no longer point to _lazy_init_nvm_once,
				# subsequent calls to "nvm" will not call _lazy_init_nvm_once,
				# and thus nvm won't be loaded again, because it's already loaded.
				#
				nvm $*
			}
		}

		# TODO fix on vscode
		#eval "$(pyenv init -)"

		# overwrite code to the FOSS vscodium
		command -v codium >/dev/null && {
			alias code="codium"
		}

		;;
	*) 
		;;
esac

# have time work just like in bash/POSIX
#disable -r time
#alias time="time -p"

# bash bash compatibility mode - see https://github.com/eddiezane/lunchy/issues/57#issuecomment-448588918
#autoload -U +X bashcompinit && bashcompinit
#
zstyle ':completion:*' matcher-list      'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*' # prefers not case sensitive
# zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*' # prefers case sensitive
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate rehash true
zstyle ':completion:*' menu select completer _expand _complete _ignored _correct _approximate rehash true
#
#bindkey -M menuselect '^?' undo
#bindkey -M 'menuselect' '^M' .accept-line
#
#
zstyle :compinstall filename '$ZDOTDIT/.zshrc'
#
setopt autolist

autoload -Uz compinit
zmodload -i zsh/complist # https://gist.github.com/LukeSmithxyz/e62f26e55ea8b0ed41a65912fbebbe52#gistcomment-3079386

compinit
_comp_options+=(globdots)		# Include hidden files.

zstyle ':completion:*' menu select

autoload -Uz promptinit
promptinit

# select the redhat prompt
prompt redhat

# hub.zsh_completion
# https://github.com/github/hub/tree/master/etc
fpath=($HOME/.config/zsh/completions $fpath)
##autoload -U compinit && compinit

stty stop undef		# Disable ctrl-s to freeze terminal.

# make backspace work in vim + tmux environment
# see https://superuser.com/a/793283/1012390
stty erase "^?"
# see also 'stty ek'

# source 'git-extras' completions
# (https://github.com/tj/git-extras)
[ -f "$HOME/.config/zsh/completions/git-extras-completion.zsh" ] && zsh-defer source "$HOME/.config/zsh/completions/git-extras-completion.zsh"

# Load aliases and shortcuts if existent.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shortcutrc" ] && zsh-defer source "${XDG_CONFIG_HOME:-$HOME/.config}/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shortcutenvrc" ] && zsh-defer source "${XDG_CONFIG_HOME:-$HOME/.config}/shortcutenvrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/aliasrc" ] && zsh-defer source "${XDG_CONFIG_HOME:-$HOME/.config}/aliasrc"
#[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/zshnameddirrc"

# ghcup-env (haskell poggers)
[ -f "$HOME/.ghcup/env" ] && zsh-defer source "$HOME/.ghcup/env"

# ocaml
[ -f "$HOME/.opam/opam-init/init.zsh" ] && zsh-defer source "$HOME/.opam/opam-init/init.zsh"

###
# history #
# see https://unix.stackexchange.com/a/273863

HISTDIR="$HOME/.cache/zsh"
HISTFILE="$HISTDIR/history"
mkdir -p "$HISTDIR"
HISTSIZE=999999999
SAVEHIST=$HISTSIZE
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
#setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt append_history            # Don't _overwrite_ history
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
#setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
#setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
#setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
#setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
#setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
#setopt HIST_BEEP                 # Beep when accessing nonexistent history.
setopt share_history             # share history between shells
setopt hist_no_store             # don't save 'history' cmd in history

function zshaddhistory() {
	local HID_RE="(^$|^ |password|token|^hid|^h$|^h |^q$|^q )"

	emulate -L zsh
	if test -n "$__ZSH_HID" || [[ "${1%%$'\n'}" =~ "$HID_RE" ]]; then
		return 1
	fi

	return 0
}

# Directory changing
# adopted from https://github.com/moprak/zshrc
setopt autocd           # Automatically change directory
setopt autopushd        # Use "pushd" instead of "cd", enabling use of "popd"
setopt pushdsilent      # Make "popd" be less verbose (like cd)
##setopt pushdignoredups  # Don't record the same directory as multiple entries
setopt pushdtohome
setopt cdable_vars
DIRSTACKSIZE=10         # Limit the number of directories to keep in history

# Completion, expansion and globbing
setopt automenu
setopt autolist
#setopt complete_in_word
setopt always_to_end
setopt menucomplete
setopt listpacked
setopt globdots
setopt extendedglob
setopt markdirs
setopt nomatch
setopt numeric_glob_sort
setopt rc_quotes
##setopt rec_exact
unsetopt autoparamslash

###

# Do not insert a space after a completion / stop eating spaces where it shouldn't.
# See https://superuser.com/a/613817/1012390
ZLE_REMOVE_SUFFIX_CHARS=""

setopt appendhistory autocd extendedglob nomatch notify
### do NOT set COMPLETE_ALIASES! See https://stackoverflow.com/a/20643204
#setopt complete_aliases
unsetopt beep



### BEGIN CURSOR (zsh + nvim + tmux) ###

### https://superuser.com/a/1501674/1012390

bindkey -v
export KEYTIMEOUT=1

# Change cursor with support for inside/outside tmux
function _set_cursor() {
    if [[ $TMUX = '' ]]; then
      echo -ne $1
    else
      echo -ne "\ePtmux;\e\e$1\e\\"
    fi
}

function _set_block_cursor() { _set_cursor '\e[2 q' }
function _set_beam_cursor() { _set_cursor '\e[6 q' }

function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
      _set_block_cursor
  else
      _set_beam_cursor
  fi
}
zle -N zle-keymap-select
# ensure beam cursor when starting new terminal
precmd_functions+=(_set_beam_cursor) #
# ensure insert mode and beam cursor when exiting vim
zle-line-init() { zle -K viins; _set_beam_cursor }

### END CURSOR (zsh + nvim + tmux) ###

###

### Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -M viins '^e' edit-command-line
bindkey -M vicmd '^e' edit-command-line

###

# set -o physical (cd into symlinks like into the real values (see https://unix.stackexchange.com/a/371147/332452))
setopt CHASE_LINKS

# Case INsensitive autocompletions
setopt MENU_COMPLETE

# allow comments in command-line commands
# see https://stackoverflow.com/a/11873793
setopt interactivecomments

#
#setopt nomenucomplete noautomenu
setopt nomenucomplete

# "shopt -s expand_aliases" in bash equivalent.
# see https://stackoverflow.com/a/23259088/9285308
setopt aliases

# Enable colors and change prompt:
autoload -U colors && colors

if [ -f "$HOME/.config/git/git-prompt.sh" ]; then
	# add the git prompt to precmd, as recommended in
	# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh

	GIT_PS1_COMPRESSSPARSESTATE=1

	source "$HOME/.config/git/git-prompt.sh"

	precmd () {
		# the __git_ps1
		# pre
		# git's status
		# post
		# wrap git's status

		_HID_PREFIX=
		test -n "$__ZSH_HID" && _HID_PREFIX="H "
	
		__git_ps1 \
		"${_HID_PREFIX}%b%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%m %{$fg[magenta]%}%~%{$reset_color%}" \
		"%{$fg[red]%}]%{$reset_color%}$%b " \
		" (%s)"
		
		# alternative, with exit code prefix:

		# __git_ps1 \
		# "%b%{$fg[red]%}[%{$fg[red]%}$?%{$reset_color%} %{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%m %{$fg[magenta]%}%1~%{$reset_color%}" \
		# "%{$fg[red]%}]%{$reset_color%}$%b " \
		# " (%s)"

		#"%{$fg[red]%}$?%{$reset_color%} %b%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%m %{$fg[magenta]%}%1~%{$reset_color%}" \
	}
else
	# without __git_prompt
	export PS1="${_HID_PREFIX}%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%m %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
fi

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'
#bindkey -s '^g' 'lfcd\n'

bindkey -s -M viins '^w' 'exit\n'
bindkey -s -M vicmd '^w' 'exit\n'

bindkey -s -M viins '^[w' 'exit\n'
bindkey -s -M vicmd '^[w' 'exit\n'

## bindkey -s '^a' 'bc -l\n'

bindkey -s '^f' 'cd "$(dirname "$(fzf)")"\n'

bindkey '^[[P' delete-char

### tmux. prefix with space to not go into history
bindkey -s '^s' ' tmux a -t 0 2>/dev/null || tmux new -s 0\n'
bindkey -s -M viins '^s'  ' tmux a -t 0 2>/dev/null || tmux new -s 0\n'
bindkey -s -M vicmd '^s' ' tmux a -t 0 2>/dev/null || tmux new -s 0\n'

# unbind -- https://unix.stackexchange.com/a/285210/332452
bindkey -r "^[/"
bindkey -r "^_"
##bindkey -r "^\\"
bindkey -r "\^\\\^"
###

# git-prompt.sh configs
# More info @ ~/.config/git-prompt.sh & ~/.config/git-completion.bash
GIT_PS1_SHOWCOLORHINTS=1
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
#export GIT_PS1_SHOWUPSTREAM="auto verbose name"
#GIT_PS1_SHOWUPSTREAM="auto verbose"
GIT_PS1_SHOWUPSTREAM="verbose"
GIT_PS1_DESCRIBE_STYLE="default"

### ARCH ###

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[ShiftTab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"      beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"       end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"    overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}" backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"    delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"        up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"      down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"      backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"     forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"    beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"  end-of-buffer-or-history
[[ -n "${key[ShiftTab]}"  ]] && bindkey -- "${key[ShiftTab]}"  reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start {
		echoti smkx
	}
	function zle_application_mode_stop {
		echoti rmkx
	}
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

###

# C-a for end of line, C-i for beginning of line (just like vi)

# used for file manager
#bindkey -- '^o' beginning-of-line
#bindkey -M viins -- '^o' beginning-of-line
#bindkey -M vicmd -- '^o' beginning-of-line

# used in tmux
#bindkey -- '^a' end-of-line
#bindkey -M vicmd -- '^a' end-of-line
#bindkey -M viins -- '^a' end-of-line

###

# history search - see https://wiki.archlinux.org/index.php/Zsh#History_search

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

###

# print how long a command took if it took longer than `3` seconds
# http://zsh.sourceforge.net/Doc/Release/Parameters.html
export REPORTTIME=3

# ported from .bashrc #

# useless & didn't do anything afaik, see instead ~/.profile
#export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export GPG_TTY="$(tty)"
#export PASSWORD_STORE_DIR="$HOME/.password-store"

### vi mode improved!

autoload -U select-quoted; zle -N select-quoted
for m in visual viopp; do
    for c in {a,i}{\',\",\`}; do
        bindkey -M $m $c select-quoted
    done
done


autoload -U select-bracketed; zle -N select-bracketed
for m in visual viopp; do
    for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
        bindkey -M $m $c select-bracketed
    done
done


autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -a cs change-surround
bindkey -a ds delete-surround
bindkey -a ys add-surround
bindkey -M visual S add-surround

###

### block cursor



###

### add missing vim hotkeys
# http://zshwiki.org/home/zle/vi-mode
bindkey -a u undo
bindkey -a '^R' redo
bindkey '^?' backward-delete-char  #backspace

### history search in vim mode
# http://zshwiki.org./home/zle/bindkeys#why_isn_t_control-r_working_anymore
# ctrl+r to search history
bindkey -M viins '^r' history-incremental-search-backward
bindkey -M vicmd '^r' history-incremental-search-backward

bindkey -M menuselect '^M' .accept-line

### --- ###

#source ~/.config/zsh/completions/_deno

# https://github.com/okapia/zsh-viexchange
#[ -f "${ZDOTDIR}/zsh-viexchange/zsh-viexchange.plugin.zsh" ] && zsh-defer source "${ZDOTDIR}/zsh-viexchange/zsh-viexchange.plugin.zsh"
# zstyle 'zle:exchange' highlight 'fg=26,bg=195'
zstyle 'zle:exchange' highlight 'fg=195,bg=26'

# note: sucks - do not use!
#source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh"

case "$OSTYPE" in
	# https://unix.stackexchange.com/a/446380/332452
	darwin*)
		# iterm2
		test -e "${ZDOTDIR}/.iterm2_shell_integration.zsh" && zsh-defer source "${ZDOTDIR}/.iterm2_shell_integration.zsh"
		
		# export PATH="/usr/local/opt/gnu-time/libexec/gnubin:$PATH"

		# sourcing in the beginning already for the proper gnu-date

		# [ -n "$TMUX" ] && {
			# source "$HOME/.profile"

			### # copied from .profile because tmux is not a login shell and needs it sourced anyway

			### # see https://stackoverflow.com/a/57973942/9285308
			### # make GNU commands available
			### export PATH="/usr/local/opt/coreutils/libexec/gnubin:${PATH}"
			### export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:${MANPATH}"
		# }

		# diff apparently doesn't have --color=always
		#unalias diff

		_load_zsh_stuff_by_platform() {
			# zsh-autosuggestions
			_ZSH_AUTOSUG="$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
			[ -f "$_ZSH_AUTOSUG" ] && source "$_ZSH_AUTOSUG"

			# zsh-syntax-highlighting.
			_ZSH_AUTOHL="$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
			[ -f "$_ZSH_AUTOHL" ] && source "$_ZSH_AUTOHL"
		}
		;;
	*)
		_load_zsh_stuff_by_platform() {
			_ZSH_AUTOSUG="/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
			[ -f "$_ZSH_AUTOSUG" ] && source "$_ZSH_AUTOSUG"

			# https://wiki.archlinux.org/title/Zsh#Fish-like_syntax_highlighting_and_autosuggestions
			_ZSH_AUTOHL="/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
			[ -f "$_ZSH_AUTOHL" ] && source "$_ZSH_AUTOHL"
		}
	;;
esac

# see above
_load_zsh_stuff_by_platform

if [ -z "$TMUX" ] && [ "x$noStartTime" = "x" ]; then
	bootTimeDuration=$((($(get_date) - $bootTimeStart)/1000000))
	printf "$bootTimeDuration ms\n"
fi

test -n "$RUN_PROFILER" && zprof

