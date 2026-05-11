# employee-mac-bootstrap

Public Stage 0 installer for Nexara Pacific Technologies employee Macs.

Tiny, single-file. Contains no business info. Pulls the real (private) setup repo via `gh`.

## Usage (new employee)

Open Terminal, paste this, press Enter:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/nexara-pacific/employee-mac-bootstrap/main/install.sh)"
```

Walk away for 15-30 minutes.

## What it does

1. Verifies macOS
2. Installs Xcode Command Line Tools
3. Installs Homebrew
4. Installs `gh` (GitHub CLI)
5. Runs `gh auth login` — opens browser with a one-time code
6. Clones the private `nexara-pacific/employee-mac-setup` repo to `~/employee-mac-setup`
7. Runs that repo's `./install` (dotbot — symlinks configs, installs apps, applies defaults)

## What it does NOT do

- Sign you into Apple ID, iCloud, Bitwarden, Obsidian, Claude, or Slack
- Install secrets or business-specific configs (those live in the private repo)
- Configure git user/email (you do this manually after install)

The full manual checklist lives in the private repo at `docs/day-0-setup.md`.

## Why two repos?

| Stage | Repo | Visibility | Why |
|---|---|---|---|
| 0 | this repo | **public** | New employee can `curl` it without GitHub auth — chicken-and-egg solved |
| 1 | `employee-mac-setup` | **private** | Contains canned prompts, voice-guide refs, internal docs — proprietary |

## Maintenance

Updating Homebrew install URL or `gh` auth flow? Edit `install.sh` here.

For everything else (Brewfile, configs, docs), edit the private `employee-mac-setup` repo.
