export PATH=$HOME/bin:/usr/local/bin:$PATH
#anaconda
export PATH="/opt/anaconda3/bin:"$PATH
export PYTHONPATH=$HOME/.PYTHONPATH
# Gaussian & gview
export g09root=/opt
export GAUSS_SCRDIR=/tmp
source $g09root/g09/bsd/g09.profile
export LIBPATH=$g09root/gv
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$g09root/gv/lib

# AmberTools16
export AMBERHOME=/opt/amber16
source $AMBERHOME/amber.sh

export TZ='Asia/Shanghai'
