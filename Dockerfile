# Dockerfile to build VScode container images 

# Set the base image to debian
FROM debian:8

# File Author / Maintainer
LABEL maintainer Douglas McCloskey <dmccloskey87@gmail.com>

# Set the environmental variable
ENV DEBIAN_FRONTEND noninteractive  

RUN apt-get update && apt-get install -y unzip sudo libgtk2.0-0 libgconf2-4 libnss3 \  
            libasound2 libxtst6 libcanberra-gtk-module libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*


## Install wget
#RUN apt-get update && apt-get install -y wget

# Install VSCode
WORKDIR /usr/local/ 
#RUN wget http://download.microsoft.com/download/...
ADD ./source/code-stable-code_1.9.1-1486597190_amd64.tar.gz /usr/local/
#RUN tar -zxvf VSCode-linux-x64.tar.gz 
RUN adduser --disabled-login --uid 1000 \--gecos 'dummy' dummy

## add VSCode to path
#ENV PATH /usr/local/VSCode-linux-x64/bin:$PATH

## Cleanup
#RUN rm -rf breseq-0.26.0-Linux-x86_64.tar.gz
RUN apt-get clean

## Create an app user
#ENV HOME /home/user
#RUN useradd --create-home --home-dir $HOME user \
#    && chmod -R u+rwx $HOME \
#    && chown -R user:user $HOME

#WORKDIR $HOME
#USER user

CMD ["sudo","-u","dummy","/usr/local/VSCode-linux-x64/code"]

##Test:
#Run
#docker build -t dmccloskey/docker-vsc .

#Use:
#docker run -ti -e DISPLAY -v $HOME/.Xauthority:/home/dummy/.Xauthority -v $PWD:/shared --net=host dmccloskey/docker-vsc