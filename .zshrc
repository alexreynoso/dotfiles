# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/krvt196/.oh-my-zsh"
# Proxy configurations
#export http_proxy=http://azpzen.astrazeneca.net:9480/
#export https_proxy=http://azpzen.astrazeneca.net:9480/
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"
#set history size
export HISTSIZE=10000
#save history after logout
export SAVEHIST=10000
#history file
export HISTFILE=~/.zhistory
#append into history file
setopt INC_APPEND_HISTORY
#save only one command if 2 common are same and consistent
setopt HIST_IGNORE_DUPS
#add timestamp for each entry
setopt EXTENDED_HISTORY
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# PYTHON
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# Aliases
alias ll='ls -lahrt'
alias ..='cd ..'

# AWS SSO configuration
sso () {
  case $1 in
    dev)
    PROFILE="azcsdcops-dev"
    ;;
  test)
    PROFILE="azcsdcops-test"
    ;;
  prod)
    PROFILE="azcsdcops-prod"
    ;;
  azcloud)
    PROFILE="azcloud"
    ;;
  *)
    echo "Intput not valid"
    return
    ;;
  esac

  echo $1
	eval "$(env|grep AWS_|sed 's/=.*//g; s/^/unset /g')" && eval "$(aws-vault exec $PROFILE --duration=12h -- env|grep AWS_|sed 's/^/export /g')" && export TF_VAR_updated_by="krvt196" && export PKR_VAR_updated_by="krvt196" && export PKR_VAR_workspace=$1 && export TF_VAR_owner="krvt196" && export TF_VAR_region="us-east-1"
}

if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
  GIT_PROMPT_ONLY_IN_REPO=1
  source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi

# FE configuration
export FIELD_EXPERIENCE_DB_USERNAME="feuser"
export FIELD_EXPERIENCE_DB_PASSWORD="fEus3r#123"
export FIELD_EXPERIENCE_DB_BASE_URL="feprod.cbmqljx60hvs.us-east-1.rds.amazonaws.com"

# AWS configuration
ssm () {
  F="Name=instance-state-name,Values=running"
  Q="Reservations[*].Instances[*].{Id:InstanceId,Name:Tags[?Key=='Name']|[0].Value,Status:State.Name}"
  I="$(aws ec2 describe-instances --query "$Q" --filters "$F" --output table)"
  #ID="$(sed '1,5d; $d; s/\|/ /g; s/^ *//g' <<< "$I" | fzf | awk '{print $1}')"
  ID="$(sed '1,5d; $d' <<< "$I" | fzf | awk '{print $2}' |  rev |cut -c 2- | rev)"
  echo $ID
  aws ssm start-session --target "$ID"
}

ZSH_THEME=powerlevel10k/powerlevel10k

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

plugins=(
    colored-man-pages
    colorize
    osx
    history-substring-search
    gitfast
    jira
    zsh-autosuggestions
    z
    web-search
    zsh-syntax-highlighting
)
source /Users/krvt196/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Terraform configuration
export TF_PLUGIN_CACHE_DIR="$HOME/terraform-plugin-dir"
export VAULT_TOKEN='s.fRfYzstWsBrwbkfrz0hedkML'

get_root_token () {
  account_id="$(aws sts get-caller-identity | jq -r '.Account')"
  token="$(aws secretsmanager get-secret-value --secret-id az-us-east-1-"$account_id"-commercialit-azcsdcopssecrets-secret-vault-requirements | jq -r '.SecretString' | jq -r '.root_token')"
  export VAULT_TOKEN=$token
  echo $VAULT_TOKEN
}

key () {
PROFILE="$( \
rg "\[" "$HOME/.aws/credentials" \
| sed 's/\[//g; s/\]//g' \
| sort -u \
| fzf \
)"
if [ -n "$PROFILE" ]; then
. awsume -s "$PROFILE"
fi
}
py_version (){
  pyenv global $1
  export PATH="$PYENV_ROOT/shims:$PATH"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"

}
export PATH="/usr/local/bin:$PATH"
