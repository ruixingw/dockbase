FROM ubuntu:16.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
WORKDIR /tmp

# UPDATE
RUN apt-get update --fix-missing 

## Essential
RUN apt-get install -y sudo build-essential pkg-config man gfortran vim git wget bzip2 unzip ca-certificates

## Oh-my-zsh and powerlevel9K theme 
RUN apt-get install -y zsh autojump
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git /usr/share/oh-my-zsh
RUN git clone https://github.com/bhilburn/powerlevel9k.git /usr/share/oh-my-zsh/custom/themes/powerlevel9k
RUN echo 'export ZSH=/usr/share/oh-my-zsh' > /usr/share/zshrc
ADD .zshrc zshrc
RUN cat zshrc >> /usr/share/zshrc
RUN chsh root -s /bin/zsh

## Miniconda 3
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


