#!/bin/bash
if [ -n "${STEAM_BETA_BRANCH}" ]
then
	echo "Loading Steam Beta Branch"
	bash "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" \
					+login anonymous \
					+app_update "${STEAM_BETA_APP}" \
					-beta "${STEAM_BETA_BRANCH}" \
					-betapassword "${STEAM_BETA_PASSWORD}" \
					+quit
else
	echo "Loading Steam Release Branch"
	bash "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" \
					+login anonymous \
					+app_update "${STEAMAPPID}" \
					+quit
fi

#ulimit -n 1000000
echo Map: "${MAPNAME}"

# Launch with mods (if defined - recommended to put mods in INI file but will support CLI)
if [ -n "{$MODS}" ]
then
	echo CLI: "${MAPNAME}"?listen?SessionName="${SESSIONNAME}"?Port="${PORT}"?QueryPort="${QUERYPORT}"?RCONPort="${RCONPORT}"?RCONEnabled=True?ServerAdminPassword="${ADMINPW}"?GameModIds="${MODS}" -NoTransferFromFiltering -clusterid="${CLUSTERKEY}" -ClusterDirOverride="${STEAMAPPDIR}/Cluster" -crossplay -gameplaylogging -UseStructureStasisGrid -lowmemory -ForceRespawnDinos -UseDynamicConfig -automanagedmods
	"${STEAMAPPDIR}"/ShooterGame/Binaries/Linux/ShooterGameServer "${MAPNAME}"?listen?SessionName="${SESSIONNAME}"?Port="${PORT}"?QueryPort="${QUERYPORT}"?RCONPort="${RCONPORT}"?RCONEnabled=True?ServerAdminPassword="${ADMINPW}"?GameModIds="${MODS}" -NoTransferFromFiltering -clusterid="${CLUSTERKEY}" -ClusterDirOverride="${STEAMAPPDIR}/Cluster" -crossplay -gameplaylogging -UseStructureStasisGrid -lowmemory -ForceRespawnDinos -UseDynamicConfig -automanagedmods
else
	echo CLI: "${MAPNAME}"?listen?SessionName="${SESSIONNAME}"?Port="${PORT}"?QueryPort="${QUERYPORT}"?RCONPort="${RCONPORT}"?RCONEnabled=True?ServerAdminPassword="${ADMINPW}" -NoTransferFromFiltering -clusterid="${CLUSTERKEY}" -ClusterDirOverride="${STEAMAPPDIR}/Cluster" -crossplay -gameplaylogging -UseStructureStasisGrid -lowmemory -ForceRespawnDinos -UseDynamicConfig
	"${STEAMAPPDIR}"/ShooterGame/Binaries/Linux/ShooterGameServer "${MAPNAME}"?listen?SessionName="${SESSIONNAME}"?Port="${PORT}"?QueryPort="${QUERYPORT}"?RCONPort="${RCONPORT}"?RCONEnabled=True?ServerAdminPassword="${ADMINPW}" -NoTransferFromFiltering -clusterid="${CLUSTERKEY}" -ClusterDirOverride="${STEAMAPPDIR}/Cluster" -crossplay -gameplaylogging -UseStructureStasisGrid -lowmemory -ForceRespawnDinos -UseDynamicConfig
fi
