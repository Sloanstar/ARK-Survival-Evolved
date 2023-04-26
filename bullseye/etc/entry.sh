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
if [ -n "$MODS" ]
then
	echo "Clearing Mods..."
	# Clear all workshop mods:
	# find all folders / files in mods folder which are numeric only;
	# remove the workshop mods
	find "${MODPATH}"/* -maxdepth 0 -regextype posix-egrep -regex ".*/[[:digit:]]+" | xargs -0 -d"\n" rm -R 2>/dev/null

# Install mods (if defined)
declare -a MODS="${MODS}"
if (( ${#MODS[@]} ))
then
	echo "Installing Mods..."
	for MODID in "${MODS[@]}"; do
		echo "> Install mod '${MODID}'"
		"${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" +login anonymous +workshop_download_item "${WORKSHOPID}" "${MODID}" +quit

		echo -e "\n> Link mod content '${MODID}'"
		ln -s "${STEAMAPPDIR}/steamapps/workshop/content/${WORKSHOPID}/${MODID}" "${MODPATH}/${MODID}"
	done
	
	declare -i LEN="${#MODS[@]}"-1
        for (( i=0; i<="${#MODS[@]}"; i++ ))
        do
                GAMEMODIDS+="${MODS[$i]}"
                if [ $i -lt $LEN ]
                then
                        GAMEMODIDS+=","
                fi
        done
	echo GameModIds: $GAMEMODIDS
fi
	echo CLI: "${MAPNAME}"?listen?SessionName="${SESSIONNAME}"?Port="${PORT}"?QueryPort="${QUERYPORT}"?RCONPort="${RCONPORT}"?RCONEnabled=True?ServerAdminPassword="${ADMINPW}"?GameModIds="${GAMEMODIDS}" -NoTransferFromFiltering -clusterid="${CLUSTERKEY}" -ClusterDirOverride="${STEAMAPPDIR}/Cluster" -crossplay -gameplaylogging -UseStructureStasisGrid -lowmemory -ForceRespawnDinos -UseDynamicConfig -automanagedmods
	"${STEAMAPPDIR}"/ShooterGame/Binaries/Linux/ShooterGameServer "${MAPNAME}"?listen?SessionName="${SESSIONNAME}"?Port="${PORT}"?QueryPort="${QUERYPORT}"?RCONPort="${RCONPORT}"?RCONEnabled=True?ServerAdminPassword="${ADMINPW}"?GameModIds="${GAMEMODIDS}" -NoTransferFromFiltering -clusterid="${CLUSTERKEY}" -ClusterDirOverride="${STEAMAPPDIR}/Cluster" -crossplay -gameplaylogging -UseStructureStasisGrid -lowmemory -ForceRespawnDinos -UseDynamicConfig -automanagedmods
else
	echo CLI: "${MAPNAME}"?listen?SessionName="${SESSIONNAME}"?Port="${PORT}"?QueryPort="${QUERYPORT}"?RCONPort="${RCONPORT}"?RCONEnabled=True?ServerAdminPassword="${ADMINPW}" -NoTransferFromFiltering -clusterid="${CLUSTERKEY}" -ClusterDirOverride="${STEAMAPPDIR}/Cluster" -crossplay -gameplaylogging -UseStructureStasisGrid -lowmemory -ForceRespawnDinos -UseDynamicConfig
	"${STEAMAPPDIR}"/ShooterGame/Binaries/Linux/ShooterGameServer "${MAPNAME}"?listen?SessionName="${SESSIONNAME}"?Port="${PORT}"?QueryPort="${QUERYPORT}"?RCONPort="${RCONPORT}"?RCONEnabled=True?ServerAdminPassword="${ADMINPW}" -NoTransferFromFiltering -clusterid="${CLUSTERKEY}" -ClusterDirOverride="${STEAMAPPDIR}/Cluster" -crossplay -gameplaylogging -UseStructureStasisGrid -lowmemory -ForceRespawnDinos -UseDynamicConfig
fi
