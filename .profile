#!/bin/sh
# ~/.profile
# Profile file. Runs on login. Environmental variables are set here.

export SOURCED_DOT_PROFILE=1

# Get default LARBS WM from ~/.local/share/larbs/wm
export LARBSWM="$(cat ~/.local/share/larbs/wm 2>/dev/null)" &&
	[ "$LARBSWM" = "dwm" ] || export LARBSWM="i3"

# Adds `~/.local/bin/` and all subdirectories to $PATH
export PATH="$PATH:$(du "$HOME/.local/bin/" | cut -f2 | tr '\n' ':' | sed 's/:*$//')"
# export PATH="$PATH:${$(find ~/.local/bin -type d -printf %p:)%%:}" # TODO merge investigate

# unsetopt PROMPT_SP # TODO merge intestigate

export PATH="$PATH:${XDG_DATA_HOME:-$HOME/.local/share}/cargo/bin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.gem/ruby/2.6.0/bin"
export PATH="$PATH:$HOME/.dotnet/tools"
export PATH="$PATH:/home/kipras/.gem/ruby/2.7.0/bin" # WE'VE REVERSELY FALLEN FOR THE MEME BOYZ
export PATH="$PATH:/home/kipras/builds/DataGrip-2019.3.2/bin" # WE'VE REVERSELY FALLEN FOR THE MEME BOYZ
export PATH="$PATH:/opt/resolve/bin"
export PATH="$PATH:$HOME/.cabal/bin:$HOME/.ghcup/bin"
export PATH="$PATH:/opt/depot_tools"
export PATH="$PATH:$HOME/.emacs.d/bin"
export PATH="$PATH:$HOME/.mozbuild/git-cinnabar"
export PATH="$PATH:$HOME/forkprojects/boomer"

# Default programs:
export EDITOR="nvim"
export REACT_EDITOR="vscodium"
export SUDO_EDITOR="vi"
export TERMINAL="st"
# export TERMINAL="alacritty"
export BROWSER="firefox-developer-edition"
export READER="zathura"
export FILE="lf"
export STATUSBAR="${LARBSWM}blocks"

# ~/ Clean-up:
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
#export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority" # This line will break some DMs.
export WAKATIME_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/wakatime"
export PLATFORMIO_CORE_DIR="$HOME/.config/platformio"
export BIB="$HOME/Documents/LaTeX/uni.bib"
export REFER="$HOME/Documents/referbib"
export NOTMUCH_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/notmuch-config"
export GTK2_RC_FILES="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-2.0/gtkrc-2.0"
export LESSHISTFILE="-"
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/wget/wgetrc"
export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}/inputrc"
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
export ALSA_CONFIG_PATH="$XDG_CONFIG_HOME/alsa/asoundrc"
#export GNUPGHOME="${XDG_DATA_HOME:-$HOME/.local/share}/gnupg"
export WINEPREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/wineprefixes/default"
export KODI_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/kodi"
export PASSWORD_STORE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/password-store"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export ANDROID_SDK_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/android"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
export ANSIBLE_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/ansible/ansible.cfg"
export UNISON="${XDG_DATA_HOME:-$HOME/.local/share}/unison"
export WEECHAT_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/weechat"
export MBSYNCRC="${XDG_CONFIG_HOME:-$HOME/.config}/mbsync/config"
export ELECTRUMDIR="${XDG_DATA_HOME:-$HOME/.local/share}/electrum"

export DOTNET_CLI_TELEMETRY_OPTOUT=1 # https://wiki.archlinux.org/index.php/.NET_Core#Telemetry
export DOTNET_ROOT="/opt/dotnet" # https://wiki.archlinux.org/index.php/.NET_Core#Troubleshooting
export MSBuildSDKsPath="/opt/dotnet/sdk/3.0.100/Sdks";
#export MSBuildSDKsPath="/opt/dotnet/sdk/2.2.108/Sdks";
##export N_PREFIX="$HOME/.local/share/n"

# Other program settings:
export DICS="/usr/share/stardict/dic/"
export FZF_DEFAULT_OPTS="--layout=reverse --height 40%"
export LESS=-R
#export LESSHISTFILE="$HOME/.cache/less/history"
export LESSHISTFILE="-"
export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"
export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"
export LESS_TERMCAP_me="$(printf '%b' '[0m')"
export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"
export LESS_TERMCAP_se="$(printf '%b' '[0m')"
export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"
export LESS_TERMCAP_ue="$(printf '%b' '[0m')"
export LESSOPEN="| /usr/bin/highlight -O ansi %s 2>/dev/null"
export QT_QPA_PLATFORMTHEME="gtk2"	# Have QT use gtk2 theme.
export MOZ_USE_XINPUT2="1"		# Mozilla smooth scrolling/touchpads.
export AWT_TOOLKIT="MToolkit wmname LG3D"	#May have to install wmname
export _JAVA_AWT_WM_NONREPARENTING=1	# Fix for Java applications in dwm

# This is the list for lf icons:
export LF_ICONS="di=📁:\
fi=📃:\
tw=🤝:\
ow=📂:\
ln=⛓:\
or=❌:\
ex=🎯:\
*.txt=✍:\
*.mom=✍:\
*.me=✍:\
*.ms=✍:\
*.png=🖼:\
*.webp=🖼:\
*.ico=🖼:\
*.jpg=📸:\
*.jpe=📸:\
*.jpeg=📸:\
*.gif=🖼:\
*.svg=🗺:\
*.tif=🖼:\
*.tiff=🖼:\
*.xcf=🖌:\
*.html=🌎:\
*.xml=📰:\
*.gpg=🔒:\
*.css=🎨:\
*.pdf=📚:\
*.djvu=📚:\
*.epub=📚:\
*.csv=📓:\
*.xlsx=📓:\
*.tex=📜:\
*.md=📘:\
*.r=📊:\
*.R=📊:\
*.rmd=📊:\
*.Rmd=📊:\
*.m=📊:\
*.mp3=🎵:\
*.opus=🎵:\
*.ogg=🎵:\
*.m4a=🎵:\
*.flac=🎼:\
*.wav=🎼:\
*.mkv=🎥:\
*.mp4=🎥:\
*.webm=🎥:\
*.mpeg=🎥:\
*.avi=🎥:\
*.mov=🎥:\
*.mpg=🎥:\
*.wmv=🎥:\
*.m4b=🎥:\
*.flv=🎥:\
*.zip=📦:\
*.rar=📦:\
*.7z=📦:\
*.tar.gz=📦:\
*.z64=🎮:\
*.v64=🎮:\
*.n64=🎮:\
*.gba=🎮:\
*.nes=🎮:\
*.gdi=🎮:\
*.1=ℹ:\
*.nfo=ℹ:\
*.info=ℹ:\
*.log=📙:\
*.iso=📀:\
*.img=📀:\
*.bib=🎓:\
*.ged=👪:\
*.part=💔:\
*.torrent=🔽:\
*.jar=♨:\
*.java=♨:\
"

[ ! -f ${XDG_CONFIG_HOME:-$HOME/.config}/shortcutrc ] && "$HOME/.local/bin/"shortcuts >/dev/null 2>&1 &

# Various bs

# react-native
# https://facebook.github.io/react-native/docs/getting-started#3-configure-the-android_home-environment-variable
export ANDROID_HOME="$HOME"/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# xampp
export PATH="$PATH:/opt/lampp"
export PATH="$PATH:$HOME/.local/bin"

# source some secrets
[ -f "$HOME/.secret" ] && . "$HOME/.secret"

# sourcemod / sourcepawn
export PATH="$PATH:$HOME/.local/share/sourcemod/addons/sourcemod/scripting"

# nosqlclient (for mongo)
export MONGO_URL="/usr/bin/mongo"

# deno
export DENO_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/deno"
export DENO_INSTALL_ROOT="$DENO_DIR/bin"

# snap
export PATH="$PATH:/var/lib/snapd/snap/bin"

# emacs
export DOOMDIR="${XDG_CONFIG_HOME:-$HOME/.config}/doom"

# mozilla (firefox etc)
export MOZCONFIG="$HOME/.config/mozilla/mozconfig"

# man, man-db, cppman
# https://github.com/aitjcize/cppman/issues/84#issuecomment-763265258
## export MANPATH="${XDG_DATA_HOME}/man"

# disable emoji in minikube
export MINIKUBE_IN_STYLE=false

#k8s
# kubectl plugins (originally wanted https://github.com/kubernetes-sigs/krew):
export PATH="${PATH}:${HOME}/.krew/bin"
# for kubectl, don't forget exporting the config filepath:
# export KUBECONFIG=~/.kube/k8s-2-fra-2-live.config
# before running the command, such as 'kubectl get pods'
# 

# firefox
[ -f  "$HOME/.local/share/cargo/env" ] && . "$HOME/.local/share/cargo/env"

# DBs
export KEEPASS_DB="$HOME/private/keepassxc-passwords.kdbx"

# work
export PIPEDRIVE_GIT_DIR="$HOME/wagie"

export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD="true"
export PUPPETEER_EXECUTABLE_PATH="$(which chromium)"

# https://stackoverflow.com/a/18434831
case "$OSTYPE" in
  solaris*) echo "SOLARIS" ;;
  darwin*)
	  	# echo "OSX"

		# homebrew env
		# update via: "/opt/homebrew/bin/brew shellenv"
		export HOMEBREW_PREFIX="/opt/homebrew"
		export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
		export HOMEBREW_REPOSITORY="/opt/homebrew"
		export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"
		export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
		export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

		# begin load nvm
		export NVM_DIR="$HOME/.config/nvm"
		[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
		[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
		# end load nvm
		# (see also ~/.zshrc)

		if command -v "/usr/local/bin/ssh-askpass" &>/dev/null; then
			export SUDO_ASKPASS="/usr/local/bin/ssh-askpass"
		else
			# irrelevant
			#echo "please install https://github.com/theseal/ssh-askpass"
		fi

		# BEGIN PYTHON

		# do manually:
		# brew install pyenv
		# pyenv install 3.9.7 (atm)
		# pyenv global 3.9.7
		# restart

		#export PATH="/usr/local/opt/python/libexec/bin:$PATH"
		#export PATH="$PATH:$HOME/Library/Python/3.8/bin"
		#export PATH="$PATH:/usr/local/opt/python@3.9/libexec/bin"

		# https://opensource.com/article/19/5/python-3-default-mac
		if command -v pyenv 1>/dev/null 2>&1; then
		  #eval "$(pyenv init -)"
		  eval "$(pyenv init --path)"
		fi
		# export PATH="$PATH:$HOME/Library/Python/3.8/bin"

		# END PYTHON
	  
		# see https://stackoverflow.com/a/57973942/9285308
		# make GNU commands available
		export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
		export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

		export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

		# brew install gnu-time
		# gtime -> just "time"
		#
		# needed for expected time calculation in .zshrc,
		# just better compat w/ linux in general
		#
 		# export PATH="/usr/local/opt/gnu-time/libexec/gnubin:$PATH"
		
		export PATH="/Applications/Firefox Developer Edition.app/Contents/MacOS/:$PATH"
		export BROWSER="/Applications/Firefox\ Developer\ Edition.app/Contents/MacOS/firefox" # additional escape characters apparently still needed because of later evaluation

		#export PATH="/Applications/Google Chrome.app/Contents/MacOS:$PATH"
		#BROWSER="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome" # additional escape characters apparently still needed because of later evaluation

		# add yabai (wm) scripts
		export PATH="${XDG_CONFIG_HOME:-$HOME/.config}/yabai/scripts:$PATH"

		# java kek
		export PATH="/usr/local/opt/openjdk/bin:$PATH"

		;;
  linux*) 
	  	#echo "LINUX" ;;

		export SUDO_ASKPASS="$HOME/.local/bin/dmenupass"

  		;;
  bsd*)     #echo "BSD" ;;
  		;;
  msys*)    #echo "WINDOWS" ;;
  		;;
  *)        #echo "unknown: $OSTYPE" ;;
  		;;
esac

# gpg stuff
# https://bbs.archlinux.org/viewtopic.php?pid=1490821#p1490821
###export GPG="gpg2" # NO NEED, KEEP DISABLED UNLES U KNOW WHAT UR DOING
export GPG_TTY=$(tty)
export GPG_AGENT_INFO="_" # set to non-empty to avoid the check in /usr/bin/pass
#eval $(keychain --eval -Q --quiet id_rsa)

# see https://wiki.archlinux.org/index.php/GnuPG#Configure_pinentry_to_use_the_correct_TTY
# questionable if I need this
gpg-connect-agent updatestartuptty /bye >/dev/null

command -v yarn &>/dev/null && {
	# needs to be below because nvm
	# see https://stackoverflow.com/a/15646750/9285308
	# and https://github.com/yarnpkg/yarn/issues/2049#issuecomment-397629921
	export NODE_PATH="$(yarn global dir)"
	export PATH="$NODE_PATH/node_modules/bin:$PATH"
}

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

[ -f ~/yarn-completion.bash ] && . ~/yarn-completion.bash

case "$OSTYPE" in
  solaris*) ;;
  darwin*) ;;
  linux*) 
		# Switch escape and caps if tty and no passwd required:
		sudo -n loadkeys ~/.local/share/larbs/ttymaps.kmap 2>/dev/null

		# MUST BE LAST:
		# Start graphical server on tty1 if not already running.
		[ "$(tty)" = "/dev/tty1" ] && ! ps -e | grep -qw Xorg && exec startx
		# [ "$(tty)" = "/dev/tty1" ] && ! pidof -s Xorg >/dev/null 2>&1 && exec startx "$XINITRC" # TODO merge investigate

  		;;
  bsd*) ;;
  msys*) ;;
  *) ;;
esac
##                              ##
## DO NOT ADD STUFF BELOW THIS  ##
##                              ##

