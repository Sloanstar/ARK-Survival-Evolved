#!/bin/bash
graceful_stop() {
	echo "Intercepted Docker Stop - Attempting to gracefully stop server."
	arkmanager stop --saveworld @all
}

trap graceful_stop SIGTERM SIGHUP SIGQUIT SIGINT

if [ -n "${STEAM_BETA_BRANCH}" ]
then
	echo "Loading Steam Beta Branch"
	/bin/bash "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" \
					+login anonymous \
					+app_update "${STEAM_BETA_APP}" validate \
					-beta "${STEAM_BETA_BRANCH}" \
					-betapassword "${STEAM_BETA_PASSWORD}" \
					+quit
else
	echo "Loading Steam Release Branch"
	/bin/bash "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" \
					+login anonymous \
					+app_update "${STEAMAPPID}" validate \
					+quit
fi

#Set ulimit
ulimit -n 1000000

#Echo Map
echo Map: "${MAPNAME}"

#MOD Support moved to arkmanger - Please manage MOD IDs thorugh arkmanager.cfg
#Depending on volume mapping you can make MODs global or instance specific.

#Add Environment Variable to CRON environment.
echo Persisting 'env' to /etc/environment
#Suppressing STDOUT of tee due to potential sensitive nature of environment variables.
env | sudo tee -a /etc/environment 1> /dev/null

#Start cron
echo Starting cron service
sudo service cron start

### echo CLI: "${MAPNAME}"?listen?SessionName="${SESSIONNAME}"?Port="${PORT}"?QueryPort="${QUERYPORT}"?RCONPort="${RCONPORT}"?RCONEnabled=True?ServerAdminPassword="${ADMINPW}" -NoTransferFromFiltering -clusterid="${CLUSTERKEY}" -ClusterDirOverride="${STEAMAPPDIR}/Cluster" -crossplay -gameplaylogging -UseStructureStasisGrid -lowmemory -ForceRespawnDinos -UseDynamicConfig -usestore -newsaveformat -BackupTransferPlayerDatas
### "${STEAMAPPDIR}"/ShooterGame/Binaries/Linux/ShooterGameServer "${MAPNAME}"?listen?SessionName="${SESSIONNAME}"?Port="${PORT}"?QueryPort="${QUERYPORT}"?RCONPort="${RCONPORT}"?RCONEnabled=True?ServerAdminPassword="${ADMINPW}" -NoTransferFromFiltering -clusterid="${CLUSTERKEY}" -ClusterDirOverride="${STEAMAPPDIR}/Cluster" -crossplay -gameplaylogging -UseStructureStasisGrid -lowmemory -ForceRespawnDinos -UseDynamicConfig -usestore -newsaveformat -BackupTransferPlayerDatas
echo CLI: arkmanager  --verbose run @main
arkmanager --verbose run @main
