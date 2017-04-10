FROM ubuntu:16.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ARG user=ruixingw
ARG pswd=chinaman
ARG ubuntuversion=xenial
WORKDIR /tmp

# UPDATE
RUN apt-get update --fix-missing 

## Essential
RUN apt-get install -y sudo build-essential pkg-config man gfortran vim git wget bzip2 unzip ca-certificates

# Add user
RUN useradd -m $user
RUN echo "$user:$pswd" | chpasswd 
RUN echo "root:$pswd" | chpasswd
RUN adduser $user sudo

# Install apps
## Oh-my-zsh and powerlevel9K theme 
RUN apt-get install -y zsh autojump
USER $user
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
RUN echo "export ZSH=/home/$user/.oh-my-zsh" > ~/.zshrc
ADD .zshrc zshrc
RUN cat zshrc >> ~/.zshrc
ADD .zshenv ~/.zshenv
RUN git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
USER root
RUN cp /home/$user/.zshrc /root
RUN chsh $user -s /bin/zsh
RUN chsh root -s /bin/zsh

## Miniconda 3
RUN apt-get install -y mercurial subversion \
    libglib2.0-0 libxext6 libsm6 libxrender1
RUN echo 'export PATH=/opt/conda/bin:$PATH' >> /etc/zsh/zshenv && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh
ENV PATH /opt/conda/bin:$PATH

## SSHD
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/zsh/zprofile
EXPOSE 22

# Clean
RUN apt-get clean
RUN rm /tmp/* -rf

# CMD sshd 
CMD ["/usr/sbin/sshd", "-D"]


