# voidrice

Kipras' fork of [Luke Smith](http://lukesmith.xyz)'s [dotfiles](https://github.com/lukesmithxyz/voidrice).

These are the dotfiles deployed by [LARBS](https://larbs.xyz), as seen on [Luke's YouTube channel](https://youtube.com/c/lukesmithxyz).

- Very useful scripts are in `~/.local/bin/`
- Settings for:
	- vim, nvim
	- vscode / vscodium / cursor -- settings, keybinds & extensions are in a [gist](https://gist.github.com/kiprasmel/de9160a0602463fb752f2d84d7aa4fd8),
	  applied by LARBS' [`vscode.sh`](https://github.com/kiprasmel/LARBS/blob/master/vscode.sh)
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

## Install these dotfiles and all dependencies

[LARBS](https://github.com/kiprasmel/larbs) (Kipras' fork of [Luke's](https://larbs.xyz)) installs everything,
incl. the programs (e.g. st, from [Kipras' fork](https://github.com/kiprasmel/st), and mutt-wizard) and the vscode settings.
It detects the OS: on Arch Linux (or similar) it runs its [`arch.sh`](https://github.com/kiprasmel/LARBS/blob/master/arch.sh) (as root),
on macOS its [`macos.sh`](https://github.com/kiprasmel/LARBS/blob/master/macos.sh) (as your user):

```sh
curl -LO https://raw.githubusercontent.com/kiprasmel/LARBS/master/larbs.sh

# inspect the script, and then

chmod +x larbs.sh
./larbs.sh -r https://github.com/kiprasmel/voidrice # or your fork
```

The dotfiles end up managed like described [below](#managing-these-dotfiles).

### Arch Linux

![](./.local/share/archrice.png)

### MacOS

![](./.local/share/macrice.png)

It's safe to re-run, and prints the remaining manual steps at the end.

#### What it changes, and why (macOS)

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

alternatively, set up the dotfiles by hand (see below) and install [the prerequisite programs](https://github.com/kiprasmel/LARBS/blob/master/progs.csv) (or equivalent, e.g. on macos at least GNU `coreutils` are needed).

## Managing these dotfiles

`$HOME` is the work tree, and the git directory is `~/.dotfiles` (not `~/.git`, so that git doesn't treat everything under `~` as one repo).
Use `config` instead of `git` for it (defined in `~/.config/aliasrc`): `config status`, `config add -f <file>`, `config commit`, etc.
`~/.gitignore` ignores everything, so only files added w/ `-f` are tracked.

LARBS sets this up. By hand, e.g. for your fork:

```sh
cd ~ # `config submodule` only works from inside the work tree

# a regular clone, not --bare: a bare one has no origin/* remote-tracking branches, nor upstreams for the branches
git clone --no-checkout https://github.com/<your-username>/voidrice /tmp/voidrice
mv /tmp/voidrice/.git ~/.dotfiles
rm -rf /tmp/voidrice

# until the dotfiles' aliasrc is in place
config() { git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$@"; }

# put the files into ~. doesn't overwrite anything: if it lists conflicting files,
# move them away (or merge them in later) and run it again
config checkout
config submodule update --init --recursive
```

similar to the "bare repository and alias method" in https://wiki.archlinux.org/title/Dotfiles#Tracking_dotfiles_directly_with_Git

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

because the git directory isn't `~/.git`, you couldn't simply use vscode to open the $HOME directory & start resolving changes.
(i [asked](https://github.com/microsoft/vscode/issues/80946), but it's not available as of yet).

but, turns out there's a work-around: https://github.com/microsoft/vscode/issues/77215#issuecomment-615834544

```sh
GIT_WORK_TREE="$HOME" GIT_DIR="$HOME/.dotfiles" code "$HOME"
```

(that's `comerge` in `~/.config/aliasrc`, w/ your `$GUI_EDITOR`)

