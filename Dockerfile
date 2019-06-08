FROM ubuntu:18.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
RUN echo "root:chinaman" | chpasswd
WORKDIR /tmp

# UPDATE
RUN apt update 

## Essentials
RUN apt install -y sudo build-essential pkg-config man gfortran vim git wget bzip2 unzip ca-certificates

## Oh-my-zsh & autojump
RUN apt install -y zsh autojump
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git /root/.oh-my-zsh
ADD zshrc /root/.zshrc
RUN chsh root -s /bin/zsh

## Miniconda 3
RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh 
RUN /bin/bash miniconda.sh -b -p /opt/conda 
RUN echo 'export PATH=/opt/conda/bin:$PATH' >> /root/.zshenv 
ENV PATH /opt/conda/bin:$PATH


## SSHD
RUN apt install -y openssh-server
RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/zsh/zprofile
EXPOSE 22

# Clean
RUN apt clean
RUN rm /tmp/* -rf

# CMD sshd 
CMD ["/usr/sbin/sshd", "-D"]


