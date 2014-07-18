# use the ubuntu base image provided by dotCloud
FROM ubuntu:14.04

MAINTAINER cosmo0920 <cosmo0920.wp@gmail.com>

# set env
ENV HOME /root
WORKDIR /root

# setting apt
RUN sed 's/main$/main universe/' -i /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y curl build-essential git libgmp3-dev libmpfr-dev zlib1g-dev

# ghc 7.8.3
RUN curl -O http://www.haskell.org/ghc/dist/7.8.3/ghc-7.8.3-x86_64-unknown-linux-deb7.tar.bz2
RUN tar xvfj ghc-7.8.3-x86_64-unknown-linux-deb7.tar.bz2
WORKDIR /root/ghc-7.8.3
RUN ./configure --prefix=/usr
RUN make install
RUN ghc --version
WORKDIR /root

# clean ghc
RUN rm -rf ghc-7.8.3 ghc-7.8.3-x86_64-unknown-linux-deb7.tar.bz2

# update and install cabal-install
RUN curl -O http://hackage.haskell.org/package/cabal-install-1.20.0.3/cabal-install-1.20.0.3.tar.gz
RUN tar xvfz cabal-install-1.20.0.3.tar.gz
WORKDIR cabal-install-1.20.0.3
RUN ./bootstrap.sh
ENV PATH $HOME/.cabal/bin:$PATH
ENV LANG C.UTF-8
WORKDIR /root

# clean cabal
RUN rm -rf cabal-install-1.20.0.3*

# RUN SSHD AS THIS CONTAINER'S DEFAULT PROCESS
CMD [ "/usr/sbin/sshd", "-D", "-o", "UseDNS=no", "-o", "UsePAM=no" ]
EXPOSE 22
