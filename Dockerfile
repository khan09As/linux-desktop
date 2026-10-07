FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo ca-certificates curl wget git locales dbus-x11 \
    xfce4 xfce4-goodies xfce4-terminal thunar thunar-archive-plugin \
    file-roller mousepad \
    xvfb x11vnc novnc websockify \
    firefox-esr \
    fonts-dejavu fonts-liberation \
    && sed -i 's/^# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash desktop \
    && echo 'desktop ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/desktop \
    && chmod 0440 /etc/sudoers.d/desktop

COPY start-desktop.sh /usr/local/bin/start-desktop.sh

RUN chmod +x /usr/local/bin/start-desktop.sh \
    && chown desktop:desktop /usr/local/bin/start-desktop.sh

USER desktop

ENV HOME=/home/desktop

WORKDIR /home/desktop

EXPOSE 6080

CMD ["/usr/local/bin/start-desktop.sh"]
