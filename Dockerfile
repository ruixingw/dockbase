FROM ubuntu:16.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ARG user=ruixingw
ARG pswd=chinaman
ARG ubuntuversion=xenial

# Add source 
## emacs25 from https://launchpad.net/~kelleyk/+archive/ubuntu/emacs
RUN echo "deb http://ppa.launchpad.net/kelleyk/emacs/ubuntu $ubuntuversion main" >> /etc/apt/sources.list
RUN echo "deb-src http://ppa.launchpad.net/kelleyk/emacs/ubuntu $ubuntuversion main" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EAAFC9CD
## UPDATE
RUN apt-get update --fix-missing 

# Add user
RUN apt-get install -y sudo
RUN useradd -m $user
RUN echo "$user:$pswd" | chpasswd 
RUN adduser $user sudo

# Install apps
## Build-essential
RUN apt-get install -y build-essential gfortran vim 

## Oh-my-zsh and powerlevel9K theme 
RUN apt-get install -y zsh git-core wget autojump
USER $user
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
RUN wget "https://raw.githubusercontent.com/ruixingw/myconf/master/.zshrc" -O ~/.zshrc
RUN wget "https://raw.githubusercontent.com/ruixingw/myconf/master/.zshenv" -O ~/.zshenv
RUN git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
USER root
RUN chsh $user -s /bin/zsh

## Miniconda 3
RUN apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/zsh/zprofile && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.3.11-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh
RUN apt-get clean
ENV PATH /opt/conda/bin:$PATH

## ambertools conda-build
ADD .amberrc /root
WORKDIR /root
RUN conda install -v -y -c ambermd ambertools=16.21.1
RUN rm /root/.amberrc -f

## spacemacs
RUN apt-get install -y emacs25
USER $user
RUN git clone https://github.com/syl20bnr/spacemacs $HOME/.emacs.d
RUN wget "https://raw.githubusercontent.com/ruixingw/myconf/master/.spacemacs" -O ~/.spacemacs
USER root

# SSHD
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:$pswd' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]


