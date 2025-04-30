#!/bin/bash

# Define color codes
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}Installing dependencies for Neovim configuration...${NC}"

# Make script exit on error
set -e

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Homebrew if it doesn't exist
if ! command_exists brew; then
    echo -e "${GREEN}Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install asdf if it doesn't exist
if ! command_exists asdf; then
    echo -e "${GREEN}Installing asdf...${NC}"
    brew install asdf
    
    # Add asdf to shell configuration
    echo -e "${GREEN}Adding asdf to shell configuration...${NC}"
    echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ~/.zshrc
    source ~/.zshrc
fi

# Install asdf plugins and latest versions of Node.js and Go
echo -e "${GREEN}Installing Node.js and Go using asdf...${NC}"

# Node.js
if ! asdf plugin list | grep -q nodejs; then
    echo -e "${GREEN}Adding Node.js plugin to asdf...${NC}"
    asdf plugin add nodejs
    # Import Node.js release team's OpenPGP keys to main keyring
    bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'
fi
# Get latest Node.js version and install it
NODE_VERSION=$(asdf latest nodejs)
asdf install nodejs $NODE_VERSION

# Go
if ! asdf plugin list | grep -q golang; then
    echo -e "${GREEN}Adding Go plugin to asdf...${NC}"
    asdf plugin add golang
fi
# Get latest Go version and install it
GO_VERSION=$(asdf latest golang)
asdf install golang $GO_VERSION

# Reshim to ensure all binaries are available
asdf reshim

# Install essential tools
echo -e "${GREEN}Installing essential development tools...${NC}"
brew install ripgrep
brew install fd
brew install git
brew install lazygit
brew install python3

# Install language servers and tools
echo -e "${GREEN}Installing global NPM packages...${NC}"
npm install -g prettier
npm install -g eslint_d
npm install -g typescript
npm install -g typescript-language-server
npm install -g vscode-langservers-extracted # HTML, CSS, JSON, ESLint
npm install -g @volar/vue-language-server
npm install -g emmet-ls
npm install -g graphql-language-service-cli

# Install Python packages
echo -e "${GREEN}Installing Python packages...${NC}"
pip3 install pylint
pip3 install black
pip3 install isort
pip3 install pyright

# Install Go tools
echo -e "${GREEN}Installing Go tools...${NC}"
go install golang.org/x/tools/gopls@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# Install Tree-sitter
echo -e "${GREEN}Installing Tree-sitter...${NC}"
brew install tree-sitter

# Install formatters
echo -e "${GREEN}Installing additional formatters...${NC}"
brew install stylua

echo -e "${GREEN}Making script executable...${NC}"
chmod +x "$0"

echo -e "${GREEN}✅ All dependencies have been installed!${NC}"
echo -e "${GREEN}Note: You may need to restart your terminal for all changes to take effect.${NC}"
echo -e "${GREEN}You can now proceed with installing Neovim and launching it to complete the setup.${NC}"