export LC_ALL=C.UTF-8
export ZSH=$HOME/.oh-my-zsh
HIST_STAMPS="mm/dd/yyyy"

ZSH_THEME="ys"
plugins=(
  git cp common-aliases
)
source $ZSH/oh-my-zsh.sh
export PATH=$HOME/.bin/:$PATH
