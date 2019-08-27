export HOME=/root
export DISABLE_AUTO_UPDATE="true"
export ZSH=$HOME/.oh-my-zsh
HIST_STAMPS="mm/dd/yyyy"
ZSH_THEME="ys"
plugins=(git cp common-aliases autojump)
source $ZSH/oh-my-zsh.sh
source /root/.alias
export PATH=$HOME/.bin:$PATH


