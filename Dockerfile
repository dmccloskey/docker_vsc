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
	--no-install-recommends

ENV HOME /home/user
RUN adduser --disabled-login --uid 1000 \
 --home $HOME --gecos 'user' user \
    && chmod -R u+rwx $HOME \
&& chown -R user:user $HOME

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

# create nodejs and code configuration files
RUN mkdir /home/user/.config \
	&& mkdir /home/user/.vscode \
	&& chown -R user /home/user/.config \
	&& chown -R user /home/user/.vscode

WORKDIR $HOME
USER user

CMD ["sudo","-u","user","/usr/bin/code","--verbose"]

##Run:
#docker run -ti -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --net=host     -v $HOME/.Xauthority:/home/user/.Xauthority     -v $HOME/dev:/home/user/dev     --name vsc dmccloskey/docker-vsc

