FROM ubuntu:18.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
RUN echo "root:chinaman" | chpasswd
WORKDIR /tmp

# UPDATE
RUN apt-get update 
RUN apt-get upgrade -y

## Essentials
RUN apt-get install -y sudo build-essential pkg-config man gfortran vim git wget bzip2 unzip ca-certificates apt-utils cmake

## Oh-my-zsh & autojump
RUN apt-get install -y zsh autojump
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git /root/.oh-my-zsh
ADD zshrc /root/.zshrc
ADD alias /root/.alias
RUN chsh root -s /bin/zsh

## Miniconda 3
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
RUN /bin/bash miniconda.sh -b -p /opt/conda 
RUN eval "$(/opt/conda/bin/conda shell.zsh hook)"
RUN conda init zsh

## SSHD
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN mkdir /root/.ssh
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN echo "export LANG=C.UTF-8 LC_ALL=C.UTF-8" >> /etc/zsh/zprofile
EXPOSE 22


RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# CMD sshd 
CMD ["/usr/sbin/sshd", "-D"]


