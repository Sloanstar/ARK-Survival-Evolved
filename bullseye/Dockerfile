############################################################
# Dockerfile that builds an ARK:SE Gameserver
############################################################
FROM cm2network/steamcmd:root

ENV STEAMAPPID 376030
ENV STEAMAPP ShooterGameServer
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}"

VOLUME ["${STEAMAPPDIR}", "${STEAMAPPDIR}/ShooterGame/Saved/Config/LinuxServer", "${STEAMAPPDIR}/ShooterGame/Saved/SavedArks", "${STEAMAPPDIR}/ShooterGame/Saved/Logs", "${STEAMAPPDIR}/Cluster"]
# Volumes 
# /home/steam/ShooterGameServer						ARK Binaries - Only need one per physical rw, rest can be ro.
# /home/steam/ShooterGameServer/ShooterGame/Saved/Config/LinuxServer	Linux Server Config
# /home/steam/ShooterGameServer/ShooterGame/Saved/SavedArks		ARK Saves
# /home/steam/ShooterGameServer/ShooterGame/Saved/Logs			Log Directory
# /home/steam/ShooterGameServer/Cluster					NFS/CIFS Mounted Drive To Share Cluster Data

COPY etc/entry.sh ${HOMEDIR}
COPY etc/GameUserSettings.ini "${STEAMAPPDIR}/ShooterGame/Saved/Config/LinuxServer"

RUN set -x \
	&& mkdir -p "${STEAMAPPDIR}" "${STEAMAPPDIR}/Cluster" \
	&& chmod 755 "${HOMEDIR}/entry.sh" "${STEAMAPPDIR}" "${STEAMAPPDIR}/Cluster" \
	&& chown "${USER}:${USER}" "${HOMEDIR}/entry.sh" "${STEAMAPPDIR}" "${STEAMAPPDIR}/Cluster" \
	&& echo "* soft nofile 1000000" >> /etc/security/limits.conf \
	&& echo "* hard nofile 1000000" >> /etc/security/limits.conf \
	&& echo "session required pam_limits.so" >> /etc/pam.d/common-session

ENV PORT=7777 \
	QUERYPORT=27015 \
	RCONPORT=27020 \
	MAPNAME="TheIsland" \
	SESSIONNAME="ARK-UnOfficial-Docker" \
	CLUSTERKEY="OverrideThisValue" \
	ADMINPW="0v3rR!deThisV@1ue"

#ENV MODS=#Comma delimited set of MOD IDs - no spaces.

# Switch to user
USER ${USER}

WORKDIR ${HOMEDIR}

CMD ["bash", "entry.sh"]

# Expose ports
EXPOSE 7777/udp \
	7778/udp \
	27015/udp \
	27020/tcp
