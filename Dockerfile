# Use Ubuntu 24 as the base image
FROM ubuntu:24.04

# Install necessary packages
RUN apt-get update && \
    apt-get install -y \
	xfce4 xfce4-appfinder xfce4-appmenu-plugin xfce4-battery-plugin xfce4-clipman xfce4-clipman-plugin xfce4-cpufreq-plugin xfce4-cpugraph-plugin xfce4-datetime-plugin xfce4-dev-tools xfce4-dict xfce4-diskperf-plugin xfce4-eyes-plugin xfce4-fsguard-plugin xfce4-genmon-plugin xfce4-goodies xfce4-helpers xfce4-indicator-plugin xfce4-mailwatch-plugin xfce4-mount-plugin xfce4-mpc-plugin xfce4-netload-plugin xfce4-notes xfce4-notes-plugin xfce4-notifyd xfce4-panel xfce4-panel-profiles xfce4-places-plugin xfce4-power-manager xfce4-power-manager-data xfce4-power-manager-plugins xfce4-pulseaudio-plugin xfce4-screensaver xfce4-screenshooter xfce4-sensors-plugin xfce4-session xfce4-settings xfce4-smartbookmark-plugin xfce4-sntray-plugin xfce4-sntray-plugin-common xfce4-systemload-plugin xfce4-taskmanager xfce4-terminal xfce4-time-out-plugin xfce4-timer-plugin xfce4-verve-plugin xfce4-wavelan-plugin xfce4-weather-plugin xfce4-whiskermenu-plugin xfce4-windowck-plugin xfce4-xkb-plugin \
	tightvncserver xfonts-base xfonts-75dpi xfonts-100dpi dbus-x11 \
	sudo util-linux iproute2 net-tools git curl wget nano gdebi gnupg dialog htop uuid-runtime seahorse

# Clean up unnecessary packages and cache to reduce image size
RUN apt-get autoclean && apt-get autoremove -y && apt-get autopurge -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "*customization: -color" > /root/.Xresources

# Set up TightVNC configuration
RUN mkdir -p /root/.vnc

# Create .Xauthority for root and ensure correct permissions
RUN touch /root/.Xauthority && chmod 600 /root/.Xauthority
	
RUN git clone https://github.com/novnc/noVNC /opt/noVNC
RUN git clone https://github.com/novnc/websockify /opt/noVNC/utils/websockify
RUN chmod +x /opt/noVNC/utils/novnc_proxy
RUN cp /opt/noVNC/vnc.html /opt/noVNC/index.html

# Expose the VNC port
EXPOSE 5901 6080

# Copy the entrypoint script
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the default command
CMD ["/usr/local/bin/entrypoint.sh"]
