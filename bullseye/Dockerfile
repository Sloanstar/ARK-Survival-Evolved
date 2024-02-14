############################################################
# Dockerfile that builds an ARK:SE Gameserver
############################################################
FROM cm2network/steamcmd:root

ENV STEAMAPPID 376030
ENV STEAMAPP ShooterGameServer
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}"

ENV WORKSHOPID 346110
ENV MODPATH "${STEAMAPPDIR}/ShooterGame/Content/Mods"
ENV MODS '' #Space delimited set of MOD IDs.

VOLUME ["${STEAMAPPDIR}", "${STEAMAPPDIR}/ShooterGame/Content/Mods", "${STEAMAPPDIR}/ShooterGame/Saved", "${STEAMAPPDIR}/Cluster", "${HOMEDIR}/Steam", "/etc/arkmanager" ]
# Volumes 
# /home/steam/ShooterGameServer						ARK Binaries - Only need one per physical rw, rest can be ro.
# /home/steam/ShooterGameServer/ShooterGame/Content/Mods		ARK Mods Directory
# /home/steam/ShooterGameServer/ShooterGame/Saved			ARK Persistent Saved Date
# /home/steam/ShooterGameServer/Cluster					NFS/CIFS Mounted Drive To Share Cluster Data
# /home/steam/Steam							Steam Binaries
# /etc/arkmanager							ARK Manager Tools Configuration

COPY etc/entry.sh ${HOMEDIR}
COPY etc/GameUserSettings.ini "${STEAMAPPDIR}/ShooterGame/Saved/Config/LinuxServer"
COPY etc/cron.d/ark-cron /etc/cron.d/ark-cron

RUN set -x \
	&& mkdir -p "${STEAMAPPDIR}" "${STEAMAPPDIR}/Cluster" \
	&& echo "* soft nofile 1000000" >> /etc/security/limits.conf \
	&& echo "* hard nofile 1000000" >> /etc/security/limits.conf \
	&& echo "session required pam_limits.so" >> /etc/pam.d/common-session \
	&& apt update \
	&& apt install -y perl-modules curl lsof libc6-i386 libgcc1 bzip2 sudo cron procps tar \
	&& curl -sL https://raw.githubusercontent.com/arkmanager/ark-server-tools/master/netinstall.sh | sudo bash -s steam \
        && chmod 755 "${HOMEDIR}/entry.sh" "${STEAMAPPDIR}" "${STEAMAPPDIR}/Cluster" \
	&& chmod 777 "/etc/arkmanager" \
        && chown -R "${USER}:${USER}" "${HOMEDIR}/entry.sh" "${STEAMAPPDIR}" "${STEAMAPPDIR}/Cluster" "/etc/arkmanager" \
	&& chmod 744 /etc/cron.d/ark-cron \
	&& crontab -u steam /etc/cron.d/ark-cron \
	&& mkdir -p /etc/arkmanager/instances/

COPY etc/arkmanager.cfg /etc/arkmanager/
COPY etc/main.cfg /etc/arkmanager/instances/


ENV PORT=7777 \
	QUERYPORT=27015 \
	RCONPORT=27020 \
	MAPNAME="TheIsland" \
	SESSIONNAME="ARK-UnOfficial-Docker" \
	CLUSTERKEY="OverrideThisValue" \
	ADMINPW="0v3rR!deThisV@1ue" \
	DISCORDID="ThisIsGarbage" \
	DISCORDTOKEN="UseYourOwn"

# Switch to user
USER ${USER}

WORKDIR ${HOMEDIR}

CMD ["bash", "entry.sh"]

# Expose ports
EXPOSE 7777/udp \
	7778/udp \
	27015/udp \
	27020/tcp
