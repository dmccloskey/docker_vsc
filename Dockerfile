FROM debian:latest
LABEL maintainer Douglas McCloskey <dmccloskey87@gmail.com>

RUN apt-get update && apt-get install -y \
	gnupg \
	libasound2 \
	libatk1.0-0 \
	libcairo2 \
	libcups2 \
	libdatrie1 \
	libdbus-1-3 \
	libfontconfig1 \
	libfreetype6 \
	libgconf-2-4 \
	libgcrypt20 \
	libgl1-mesa-dri \
	libgl1-mesa-glx \
	libgdk-pixbuf2.0-0 \
	libglib2.0-0 \
	libgtk2.0-0 \
	libgpg-error0 \
	libgraphite2-3 \
	libnotify-bin \
	libnss3 \
	libnspr4 \
	libpango-1.0-0 \
	libpangocairo-1.0-0 \
	libxcomposite1 \
	libxcursor1 \
	libxdmcp6 \
	libxi6 \
	libxrandr2 \
	libxrender1 \
	libxss1 \
	libxtst6 \
	liblzma5 \
	libxkbfile1 \
	sudo \
	--no-install-recommends

# https://code.visualstudio.com/Download
ENV CODE_VERSION 1.12.1-1493934083
ENV CODE_COMMIT f6868fce3eeb16663840eb82123369dec6077a9b

# download the source
RUN buildDeps=' \
		ca-certificates \
		curl \
	' \
	&& set -x \
	&& apt-get update && apt-get install -y $buildDeps --no-install-recommends \
	&& curl -sL https://deb.nodesource.com/setup_6.x | bash - \
	&& apt-get update && apt-get install -y nodejs --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/* \
	&& curl -sSL "https://az764295.vo.msecnd.net/stable/${CODE_COMMIT}/code_${CODE_VERSION}_amd64.deb" -o /tmp/vs.deb \
	&& apt-get purge -y --auto-remove $buildDeps \
	&& dpkg -i /tmp/vs.deb \
	&& rm -rf /tmp/vs.deb

# ENV HOME /home/developeruser
# RUN useradd --create-home --home-dir $HOME developer \
# 	&& chown -R developer:developer $HOME

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer && \
	#xrdp fix on ubuntu/debian
	#https://stackoverflow.com/questions/36694941/visual-studio-code-1-fails-to-launch-on-ubuntu-using-xrdp
	sed -i 's/BIG-REQUESTS/_IG-REQUESTS/' /usr/lib/x86_64-linux-gnu/libxcb.so.1
	
# #GLIB_2.18 workaround for vscode (testing)
# #https://github.com/Microsoft/vscode-cpptools/issues/19
# # COPY Microsoft.VSCode.CPP.Extension.linux.sh ~/.vscode/extension/ms-vscode.cpptools-0.9.3/bin
# RUN unset LD_LIBRARY_PATH && \
# 	mkdir /home/user/tmp && \
# 	cd /home/user/tmp && \
# 	wget http://ftp.gnu.org/gnu/glibc/glibc-2.18.tar.xz && \
# 	tar xvf glibc-2.18.tar.xz && \
# 	cd glibc-2.18 && \
# 	mkdir build && \
# 	cd build && \
# 	../configure --prefix=/opt/glibc-2.18 && \
# 	sudo make install && \ 
# 	rm -rf glibc-2.18.tar.xz
# 	# && \
# 	# chmod a+x Microsoft.VSCode.CPP.Extension.linux.sh && \
# 	# Modify "~/.vscode/extensions/ms-vscode.cpptools-0.9.3/out/src/LanguageServer/C_Cpp.js"
# 	# Change the following line from " extensionsProcessName += '.linux'; " to " extensionProcessName += '.linux.sh'; "
# ENV LD_LIBRARY_PATH /usr/local/openms-build/lib/:$LD_LIBRARY_PATH

ENV HOME /home/developer

# create nodejs and code configuration files
RUN mkdir /home/developer/.config \
	&& mkdir /home/developer/.vscode \
	&& chown -R developer /home/developer/.config \
	&& chown -R developer /home/developer/.vscode

WORKDIR $HOME
USER developer

CMD ["/usr/bin/code"]
# CMD ["sudo","-u","developer","/usr/bin/code","--verbose"]
# CMD [ "start.sh" ]

##Run:
#e.g., https://github.com/jessfraz/dockerfiles/blob/master/vscode/Dockerfile
#e.g., http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/
#xhost +local:docker
#docker run -ti -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --net=host     -v $HOME/.Xauthority:/home/developer/.Xauthority     -v $HOME/dev:/home/developer/dev     --name vsc dmccloskey/docker-vsc

