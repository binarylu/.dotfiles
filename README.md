# dotfiles

My dotfiles following the [XDG Base Directory](https://specifications.freedesktop.org/basedir-spec/latest/) standard.

## Structure

```
bash/     bash_profile, bashrc.mac, bashrc.linux
git/      config, ignore
screen/   screenrc
tmux/     tmux.conf
vim/      vimrc
zsh/      zshrc
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

| Tool   | XDG since  | Fallback       |
|--------|------------|----------------|
| git    | 1.7.12     | `~/.gitconfig` |
| tmux   | 3.1        | `~/.tmux.conf` |
| vim    | 9.1.0327   | `~/.vimrc`     |
| zsh    | —          | `~/.zshrc`     |
| bash   | —          | `~/.bashrc`    |
| screen | —          | `~/.screenrc`  |

Existing files at link targets are renamed to `<name>.old` with a warning.
