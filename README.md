# voidrice

Kipras' fork of [Luke Smith](http://lukesmith.xyz)'s [dotfiles](https://github.com/lukesmithxyz/voidrice).

These are the dotfiles deployed by [LARBS](https://larbs.xyz), as seen on [Luke's YouTube channel](https://youtube.com/c/lukesmithxyz).

- Very useful scripts are in `~/.local/bin/`
- Settings for:
	- vim, nvim, vscode
	- git w/ many comfy aliases & extra utils
	- zsh, incl. fish-like autocompletions
	- tmux (terminal multiplexer)
	- i3wm/i3-gaps (window manager)
	- i3blocks (status bar)
	- sxhkd (general key binder)
	- ranger / lf / vifm (file managers)
	- mpd/ncmpcpp (music)
	- sxiv (image/gif viewer)
	- mpv (video player)
	- calc (python calculator w/ prefilled utils)
	- other stuff like xdg default programs, inputrc and more, etc.
- Additionally for Mac:
	- yabai, with a very similar feel to i3
	- iTerm2, integrated w/ tmux!
	- Alfred, incl. emoji picker keybind
- We try to minimize what's directly in `$HOME` so:
	- Most configs that can be in `~/.config/` are.
	- Some environmental variables have been set in `~/.profile` to move configs into `~/.config/`
- Bookmarks in text files used by various scripts (like `~/.local/bin/shortcuts`)
	- File bookmarks in `~/.config/files`
	- Directory bookmarks in `~/.config/directories`

## Not included here

- VSCode/[VSCodium](https://github.com/VSCodium/vscodium) config (settings, keybinds, extensions, themes etc.): https://gist.github.com/kiprasmel/de9160a0602463fb752f2d84d7aa4fd8
- [st](https://github.com/kiprasmel/st) - terminal emulator on linux
- [mutt-wizard](https://github.com/lukesmithxyz/mutt-wizard) - a terminal-based email client for any email provider
- some git utils (see aliases in [.gitconfig](./.gitconfig) and my [git-* repos](https://github.com/kiprasmel?tab=repositories&q=%23git&sort=stargazers))
- [infra](https://github.com/kiprasmel/infra) scripts for automating deployment of these dotfiles & much more

## Install these dotfiles and all dependencies

If you want to try out these dotfiles, I'd recommend creating a new user with a
home directory first, e.g. on linux:

```sh
sudo useradd --shell /bin/zsh --create-home tester
passwd tester
su tester
cd ~
```

### Arch Linux

![](./.local/share/archrice.png)

On an Arch Linux (or similar) system, use [LARBS](https://larbs.xyz) ([Kipras' fork](https://github.com/kiprasmel/larbs)) to autoinstall everything:

```sh
curl -LO http://raw.githubusercontent.com/kiprasmel/LARBS/master/larbs.sh

# inspect the script, and then

./larbs.sh -r https://github.com/kiprasmel/voidrice
```

### MacOS

![](./.local/share/macrice.png)

<!--
Some is automated, some is not (yet).
See the next section "Installing and Managing these dotfiles
See my recent notes for the steps to take to fully setup:

https://notes.kipras.org/macos.html#xe5IP3iU-
-->


## Installing and Managing these dotfiles

As simple as can be -- using git.

### Installing

Fork the repository and clone it as a bare repo:
TODO: no "bare", instead normal clone, `cp * .*`, `mv .git .dotfiles`

```sh
# fork in github

# then, clone into a bare repo:
GH_USERNAME="your-username" git clone --bare "http://github.com/$GH_USERNAME/voidrice" ~/.dotfiles

# create an alias to manage the dotfiles
cat >> ~/.zshrc <<'EOF'
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
EOF

# ignore all files by default (to start tracking a new file, use git add -f)
echo "*" > ~/.gitignore
```

and now your `$HOME` directory acts as a git repository, just that instead of
using the `git` command, you use the `config` one -- this prevents you from
accidently interfering with other git repositories.

now, to apply all of my dotfiles to your (test user's) home directory, first
run `config status`, which should print that all files have been deleted (i.e.
you cloned the bare repo but haven't created the files yet).

if there are any modified files, it means you have your own files which are at
the same locations as mine, and you'd overwrite them if you took the next step,
so back them up first.

finally, you'd now do `config reset --hard HEAD`, which will apply all files
from the dotfiles repo into your home directory.

and now you can start using them.

### Managing

The regular git biz applies: `config status`, `config add` (with `-f` if new
file), `config commit`, `config push`.

originally inspired by "bare repository and alias method" in https://wiki.archlinux.org/title/Dotfiles#Tracking_dotfiles_directly_with_Git

## Integrating upstream improvements

To keep your dotfiles up-to-date with mine:

```sh
# see above for the "config" alias
config remote add upstream https://github.com/kiprasmel/voidrice
```

and occationally perform

```sh
config fetch --all
config merge upstream/master
```

though, when merging, i recommend reviewing each change, because even if it auto-merged, the results are not always what you want.

e.g. i myself merge from Luke, and there are sometimes deleted files, or renamed directories, or just scripts/configs changed
in a way that i don't necessarily like, and so i pick what i want & how i want.

e.g. Luke has moved on from i3 to dwm, meanwhile i myself am staying with i3.

### Performing merges comfortably

```sh
merge_editor=code

GIT_WORK_TREE="$HOME" GIT_DIR="$HOME/.dotfiles" $merge_editor "$HOME"
```

