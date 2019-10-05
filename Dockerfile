# We're using Alpine stable
FROM alpine:edge

#
# We have to uncomment Community repo for some packages
#
RUN sed -e 's;^#http\(.*\)/v3.9/community;http\1/v3.9/community;g' -i /etc/apk/repositories

# Installing Python
RUN apk add --no-cache --update \
    bash \
    build-base \
    bzip2-dev \
    curl \
    figlet \
    gcc \
    git \
    sudo \
    util-linux \
    chromium \
    chromium-chromedriver \
    jpeg-dev \
    libffi-dev \
    libpq \
    libwebp-dev \
    libxml2 \
    libxml2-dev \
    libxslt-dev \
    linux-headers \
    musl \
    neofetch \
    openssl-dev \
    php-pgsql \
    postgresql \
    postgresql-client \
    postgresql-dev \
    py3-lxml \
    py3-pillow \
    py3-pip \
    py3-setuptools \
    py3-psycopg2 \
    py3-requests \
    py3-sqlalchemy \
    py3-tz \
    py3-aiohttp \
    python-dev \
    openssl \
    pv \
    jq \
    wget \
    python3 \
    python3-dev \
    readline-dev \
    sqlite \
    sqlite-dev \
    zlib-dev \
    redis \   
    py-pillow \
    py-requests \
    libpq \
    curl \
    sudo \
    neofetch \
    musl \
    py-tz \
    py3-aiohttp \
    py-six \
    py-click
# Copy Python Requirements to /app

RUN  sed -e 's;^# \(%wheel.*NOPASSWD.*\);\1;g' -i /etc/sudoers
RUN adduser marinette --disabled-password --home /home/marinette
RUN adduser marinette wheel
USER marinette
RUN mkdir /home/marinette/marinette
RUN mkdir /home/userbot/bin
RUN git clone https://github.com/orgess2/tgbot /home/marinette/marinette
WORKDIR /home/marinette/marinette
ADD ./requirements.txt /home/marinette/marinette/requirements.txt

#
# Copies session and config(if it exists)
#
#COPY ./sample_config.env ./userbot.session* ./config.env* /home/userbot/userbot/

#
# Clone helper scripts
#
#RUN curl -s https://raw.githubusercontent.com/yshalsager/megadown/master/megadown -o /home/userbot/bin/megadown && sudo chmod a+x /home/userbot/bin/megadown
#RUN curl -s https://raw.githubusercontent.com/yshalsager/cmrudl.py/master/cmrudl.py -o /home/userbot/bin/cmrudl && sudo chmod a+x /home/userbot/bin/cmrudl
ENV PATH="/home/marinette/bin:$PATH"

#
# Install requirements
#
RUN sudo pip3 install -r requirements.txt
ADD . /home/marinette/marinette
RUN sudo chown -R $(whoami) /usr/lib/python3.7/site-packages
RUN sudo chown -R marinette /home/marinette/marinette
RUN sudo chmod -R 777 /home/marinette/marinette
CMD ["python3","-m tg_bot"]
