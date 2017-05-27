FROM debian:latest
LABEL maintainer Douglas McCloskey <dmccloskey87@gmail.com>

ENV DEBIAN_FRONTEND noninteractive 

RUN apt-get update && apt-get install -y \
	curl \
        git \
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
	ca-certificates \
	gnupg \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENV HOME /home/user
RUN adduser --disabled-login --uid 1000 \
 --home $HOME --gecos 'user' user \
    && chmod -R u+rwx $HOME \
&& chown -R user:user $HOME

# https://code.visualstudio.com/Download
ENV CODE_VERSION 1.12.2-1494422229
ENV CODE_COMMIT f9d0c687ff2ea7aabd85fb9a43129117c0ecf519

# download the source
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - \
	&& apt-get update && apt-get install -y  nodejs --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/* \
	&& curl -sSL "https://vscode-update.azurewebsites.net/latest/linux-deb-x64/stable" -o /tmp/vs.deb \
	# && curl -sSL "https://az764295.vo.msecnd.net/stable/${CODE_COMMIT}/code_${CODE_VERSION}_amd64.deb" -o /tmp/vs.deb \
	&& dpkg -i /tmp/vs.deb \
	&& rm -rf /tmp/vs.deb \
	&& apt-get purge -y

# copy in the startup scripts
COPY start.sh /usr/local/bin/start.sh
RUN chmod u+rwx /usr/local/bin/start.sh && chown user:user /usr/local/bin/start.sh
COPY local.conf /etc/fonts/local.conf

# create nodejs and code configuration files
RUN mkdir /home/user/.config \
	&& mkdir /home/user/.vscode \
	&& chown -R user /home/user/.config \
	&& chown -R user /home/user/.vscode

WORKDIR $HOME
USER user

ENTRYPOINT [ "/usr/local/bin/start.sh" ]
# CMD ["sudo","-u","user","/usr/bin/code","--verbose"]
