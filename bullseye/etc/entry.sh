#!/bin/bash
graceful_stop() {
	echo "Intercepted Docker Stop - Attempting to gracefully stop server."
	arkmanager stop --saveworld @all
}

trap graceful_stop SIGTERM SIGHUP SIGQUIT SIGINT

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

ulimit -n 1000000
echo Map: "${MAPNAME}"

# Launch with mods (if defined - recommended to put mods in INI file but will support CLI)
echo "Clearing Mods..."
# Clear all workshop mods:
# find all folders / files in mods folder which are numeric only;
# remove the workshop mods
find "${MODPATH}"/* -maxdepth 0 -regextype posix-egrep -regex ".*/[[:digit:]]+" | xargs -0 -d"\n" rm -R 2>/dev/null

# Install mods (if defined)
if [ -n "${MODS}" ]
then
	# Set MODS as array
	declare -a MODS=("${MODS}")

	# If there are elements in the array
	if (( ${#MODS[@]} ))
	then
		echo "Installing Mods..."
		# For each MOD element in the array
		for MODID in "${MODS[@]}"; do
			echo "> Install mod '${MODID}'"
			# Download the MOD
			"${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" +login anonymous +workshop_download_item "${WORKSHOPID}" "${MODID}" +quit

			echo -e "\n> Link mod content '${MODID}'"
			# Create a symbolic link from the download to the MOD folder.
			ln -s "${STEAMAPPDIR}/steamapps/workshop/content/${WORKSHOPID}/${MODID}/" "${MODPATH}/${MODID}"
		done
		
		# Build a CSV string of MODs to use in the server start CLI
		# Integer equal to the number of elements in MODS - 1
		declare -i LEN="${#MODS[@]}"-1
        	for (( i=0; i<="${#MODS[@]}"; i++ ))
        	do
			# Concat MODID to string variable
        	        GAMEMODIDS+="${MODS[$i]}"
			# Check for last element, if not last add a comma.
        	        if [ $i -lt $LEN ]
        	        then
				# Concat comma to string variable
        	                GAMEMODIDS+=","
        	        fi
        	done
		# Echo Mods string to console for good measure.
		echo GameModIds: $GAMEMODIDS
		
		### echo CLI: "${MAPNAME}"?listen?SessionName="${SESSIONNAME}"?Port="${PORT}"?QueryPort="${QUERYPORT}"?RCONPort="${RCONPORT}"?RCONEnabled=True?ServerAdminPassword="${ADMINPW}"?GameModIds="${GAMEMODIDS}" -NoTransferFromFiltering -clusterid="${CLUSTERKEY}" -ClusterDirOverride="${STEAMAPPDIR}/Cluster" -crossplay -gameplaylogging -UseStructureStasisGrid -lowmemory -ForceRespawnDinos -UseDynamicConfig -usestore -newsaveformat -BackupTransferPlayerDatas
		### "${STEAMAPPDIR}"/ShooterGame/Binaries/Linux/ShooterGameServer "${MAPNAME}"?listen?SessionName="${SESSIONNAME}"?Port="${PORT}"?QueryPort="${QUERYPORT}"?RCONPort="${RCONPORT}"?RCONEnabled=True?ServerAdminPassword="${ADMINPW}"?GameModIds="${GAMEMODIDS}" -NoTransferFromFiltering -clusterid="${CLUSTERKEY}" -ClusterDirOverride="${STEAMAPPDIR}/Cluster" -crossplay -gameplaylogging -UseStructureStasisGrid -lowmemory -ForceRespawnDinos -UseDynamicConfig -usestore -newsaveformat -BackupTransferPlayerDatas
                echo CLI: arkmanager  --verbose run @main
                arkmanager --verbose run @main
	fi
else
	### echo CLI: "${MAPNAME}"?listen?SessionName="${SESSIONNAME}"?Port="${PORT}"?QueryPort="${QUERYPORT}"?RCONPort="${RCONPORT}"?RCONEnabled=True?ServerAdminPassword="${ADMINPW}" -NoTransferFromFiltering -clusterid="${CLUSTERKEY}" -ClusterDirOverride="${STEAMAPPDIR}/Cluster" -crossplay -gameplaylogging -UseStructureStasisGrid -lowmemory -ForceRespawnDinos -UseDynamicConfig -usestore -newsaveformat -BackupTransferPlayerDatas
	### "${STEAMAPPDIR}"/ShooterGame/Binaries/Linux/ShooterGameServer "${MAPNAME}"?listen?SessionName="${SESSIONNAME}"?Port="${PORT}"?QueryPort="${QUERYPORT}"?RCONPort="${RCONPORT}"?RCONEnabled=True?ServerAdminPassword="${ADMINPW}" -NoTransferFromFiltering -clusterid="${CLUSTERKEY}" -ClusterDirOverride="${STEAMAPPDIR}/Cluster" -crossplay -gameplaylogging -UseStructureStasisGrid -lowmemory -ForceRespawnDinos -UseDynamicConfig -usestore -newsaveformat -BackupTransferPlayerDatas
        echo CLI: arkmanager  --verbose run @main
        arkmanager --verbose run @main
fi
