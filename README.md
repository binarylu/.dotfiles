# dotfiles

My dotfiles following the [XDG Base Directory](https://specifications.freedesktop.org/basedir-spec/latest/) standard.

## Structure

```
bash/
  bash_profile            sourced by .bash_profile on macOS
  bashrc.linux            Linux-specific shell config
  bashrc.mac              macOS-specific shell config
git/
  config                  main git config
  config.local.template   template for machine-local identity (name, email, signingkey)
  config.platform.linux   Linux-specific config (autocrlf = input)
  config.platform.mac     macOS-specific config (autocrlf = input)
  config.platform.win     Windows-specific config (autocrlf = true)
  ignore                  global gitignore
ghostty/
  config                  ghostty terminal config
screen/
  screenrc                GNU screen config
tmux/
  tmux.conf               tmux config (requires >= 3.2)
vim/
  skeletons/              new-file templates for vim-skeleton
    skel.c                C program template
    skel.cpp              C++ program template
    skel.py               Python script template
    skel.sbatch           SLURM batch job template
    skel.sh               shell script template
  vimrc                   vim config (XDG-aware, requires vim >= 9.1.0327)
zsh/
  zshrc                   zsh config (oh-my-zsh)
```

## Setup

Clone the repo and run `setup.sh`:

```bash
git clone https://github.com/binarylu/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./setup.sh
```

`setup.sh` detects each tool's version and symlinks configs into `$XDG_CONFIG_HOME` (`~/.config`) if supported, or falls back to `~`.

### Non-interactive mode

Pass tool names as arguments to set up specific tools without prompts:

```bash
./setup.sh vim tmux git
```

### XDG support matrix

| Tool    | XDG since  | Fallback       |
|---------|------------|----------------|
| git     | 1.7.12     | `~/.gitconfig` |
| tmux    | 3.2        | `~/.tmux.conf` |
| vim     | 9.1.0327   | `~/.vimrc`     |
| ghostty | always     | —              |
| zsh     | —          | `~/.zshrc`     |
| bash    | —          | `~/.bashrc`    |
| screen  | —          | `~/.screenrc`  |

Existing files at link targets are renamed to `<name>.YYYYMMDD_HHMMSS.old` with a warning.

### Notes

- `git/config.local.template` is copied (not linked) to `~/.config/git/config.local` on first run — fill in your name and email.
- `vim/skeletons/` is copied (not linked) to `~/.config/vim/skeletons/` so templates can be customized per machine.
