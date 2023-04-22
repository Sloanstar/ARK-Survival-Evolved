############################################################
# Dockerfile that builds an ARK:SE Gameserver
############################################################
FROM cm2network/steamcmd:root

ENV STEAMAPPID 376030
ENV STEAMAPP ShooterGameServer
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}"

#ENV STEAM_BETA_APP 774961
#ENV STEAM_BETA_PASSWORD ""
#ENV STEAM_BETA_BRANCH ""

#ENV WORKSHOPID 393380
#ENV MODPATH "${STEAMAPPDIR}/SquadGame/Plugins/Mods"
#ENV MODS "()"

COPY etc/entry.sh ${HOMEDIR}

RUN set -x \
	&& mkdir -p "${STEAMAPPDIR}" \
	&& chmod 755 "${HOMEDIR}/entry.sh" "${STEAMAPPDIR}" \
	&& chown "${USER}:${USER}" "${HOMEDIR}/entry.sh" "${STEAMAPPDIR}" \
	&& echo "* soft nofile 1000000" >> /etc/security/limits.conf \
	&& echo "* hard nofile 1000000" >> /etc/security/limits.conf \
	&& echo "session required pam_limits.so" >> /etc/pam.d/common-session

ENV PORT=7777 \
	QUERYPORT=27015 \
	RCONPORT=27020 \
	MAPNAME="TheIsland" \
	SESSIONNAME="NA-PVE-UnOfficial-Docker"

# Switch to user
USER ${USER}

WORKDIR ${HOMEDIR}

CMD ["bash", "entry.sh"]

# Expose ports
EXPOSE 7777/udp \
	27015/tcp \
	27015/udp \
	27020/tcp \
	27020/udp
