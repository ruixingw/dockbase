export PATH=$HOME/bin:/usr/local/bin:$PATH

# Gaussian & gview
export g09root=/opt
export GAUSS_SCRDIR=/tmp
[[ -s $g09root/g09/bsd/g09.profile ]] && source $g09root/g09/bsd/g09.profile
export LIBPATH=$g09root/gv
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$g09root/gv/lib

export TZ='Asia/Shanghai'
