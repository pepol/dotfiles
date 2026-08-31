# macOS packages that mise does not manage: GUI apps, system libraries, fonts,
# and the handful of CLI tools with no entry in the mise registry.
#
# Applied by `mise run brew`, which is a no-op on Linux.

tap "nikitabobko/tap"
tap "synfinatic/aws-sso-cli"

# --- the pieces mise cannot install ---------------------------------------
brew "gnu-sed"     # scripts assume GNU sed semantics
brew "gnu-getopt"  # $GNU_GETOPT_PREFIX in .zshrc
brew "git-lfs"
brew "coreutils"

# --- terminal and window management ---------------------------------------
cask "ghostty"                 # outer terminal; herdr runs inside it
cask "nikitabobko/tap/aerospace"
cask "font-symbols-only-nerd-font"  # herdr sidebar + nvim-web-devicons glyphs

# --- language servers -----------------------------------------------------
# gopls and rust-analyzer arrive with the go/rust toolchains mise installs;
# these are the ones that do not.
brew "cue"          # ships `cue lsp`
brew "lua-language-server"

# --- cloud and kubernetes tooling referenced by .zshrc --------------------
brew "kubectl"
brew "helm"
brew "krew"
brew "awscli"
brew "synfinatic/aws-sso-cli/aws-sso-cli"
brew "aws-vault"
brew "postgresql@17"
