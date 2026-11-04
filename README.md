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

- VSCode config (settings, keybinds, extensions, themes etc.): https://gist.github.com/kiprasmel/de9160a0602463fb752f2d84d7aa4fd8
  (applied to VSCodium/Cursor/VS Code by LARBS' [`vscode.sh`](https://github.com/kiprasmel/LARBS/blob/master/vscode.sh))

- st ([Kipras'](https://github.com/kiprasmel/st) or [Luke's](https://github.com/lukesmithxyz/st)) - terminal emulator
- [mutt-wizard (`mw`)](https://github.com/lukesmithxyz/mutt-wizard) - a terminal-based email system that can store your mail offline without effort
- dwm ([Luke's](https://github.com/lukesmithxyz/dwm), Kipras is staying with i3) - window manager 
- dwmblocks ([Luke's](https://github.com/lukesmithxyz/dwmblocks)) - statusbar

## Install these dotfiles and all dependencies

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

Same as Arch: [LARBS](https://github.com/kiprasmel/larbs) detects macOS and runs its
[`macos.sh`](https://github.com/kiprasmel/LARBS/blob/master/macos.sh):

```sh
curl -LO https://raw.githubusercontent.com/kiprasmel/LARBS/master/larbs.sh

# inspect the script, and then

sh larbs.sh
```

It's safe to re-run, and prints the remaining manual steps at the end.

#### What it changes, and why

- Installs homebrew w/ the [Brewfile](https://github.com/kiprasmel/LARBS/blob/master/Brewfile),
  these dotfiles (w/ submodules), and the VSCode settings (see above).
- iTerm2 loads its settings from `~/.config/iterm` (a submodule), so they're versioned.
- Creates an ssh key, if there's none.
- Dock: spaces aren't rearranged by most recent use, so a desktop keeps its number (and its ctrl+N).
- Desktop & Dock: clicking the wallpaper reveals the desktop only in Stage Manager, so a stray click doesn't hide every window.
  And no margins around tiled windows.
- Keyboard shortcuts: Mission Control & Application windows move from ctrl+up/down to opt+up/down,
  and "Move left/right a space" (ctrl+left/right) is disabled. That leaves the arrows to tmux:
  ctrl+up/down = previous/next window, ctrl/opt+left/right = move the window to an earlier/later number.
  Spaces are switched w/ ctrl/opt+N instead, see below.
- Fast key repeat, and holding a key repeats it instead of showing the accents popup (e.g. vim's hjkl). Needs a re-login.
- ctrl+cmd+drag anywhere in a window moves it.
- Optional, commented out: reduce motion, i.e. desktops crossfade instead of sliding.
- Sets up spaces (see below), and starts yabai & skhd.

#### Spaces: yabai vs native

yabai can only focus spaces w/ its scripting addition, which needs SIP (partially) disabled --
not always possible, e.g. on a managed work laptop. LARBS picks the mode from the SIP status,
and you can switch anytime w/ these scripts in the LARBS repo:

- `./macos-spaces-native.sh` -- SIP enabled: native macos shortcuts. ctrl+1..0 = desktop 1-10, opt+1..6 = desktop 11-16
- `./macos-spaces-yabai-no-sip.sh` -- SIP disabled: yabai. ctrl+1..0 = space 1-10, opt+1..0 = 11-20, ctrl+opt+1..0 = 21-30

### Other

alternatively, clone the repository directly to your home directory and install [the prerequisite programs](https://github.com/kiprasmel/LARBS/blob/master/progs.csv) (or equivalent, e.g. on macos at least GNU `coreutils` are needed).

## Managing these dotfiles

As simple as can be.

Fork the repository and clone it as a bare repo:

```sh
# fork in github

# then, clone into a bare repo:
git clone --bare http://github.com/<your-username>/voidrice ~/.dotfiles

# create an alias to manage the dotfiles
cat >> ~/.zshrc <<'EOF'
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
EOF

# ignore all files by default (to start tracking a new file, use git add -f)
printf "*" > ~/.gitignore
```

and now your `$HOME` directory acts as a git repository, just that instead of using the `git` command, you use the `config` one --
this prevents you from accidently committing files in other repositories, and in general has multiple benefits.

originally inspired by "bare repository and alias method" in https://wiki.archlinux.org/title/Dotfiles#Tracking_dotfiles_directly_with_Git

## Integrating upstream improvements

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

because of the bare repository, you couldn't simply use vscode to open the $HOME directory & start resolving changes.
(i [asked](https://github.com/microsoft/vscode/issues/80946), but it's not available as of yet).

but, turns out there's a work-around: https://github.com/microsoft/vscode/issues/77215#issuecomment-615834544

```sh
GIT_WORK_TREE="$HOME" GIT_DIR="$HOME/.dotfiles" code "$HOME"
```

