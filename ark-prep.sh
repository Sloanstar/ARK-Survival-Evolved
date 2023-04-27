ARKROOT='/opt'
ARKSERVER=${ARKROOT}'/ARK-Server'
ARKCLUSTER=${ARKROOT}'/ARK-Cluster'
STEAM=${ARKROOT}'/Steam'
declare -a BASEDIRS=( "${ARKSERVER}" "${ARKCLUSTER}" "${STEAM}" )
echo Making Server Directories...
for DIR in "${BASEDIRS[@]}"; do
	echo Creating "${DIR}"
	mkdir -p "${DIR}"
	echo "Setting owner nobody:nogroup"
	chown -R nobody:nogroup "${DIR}"
	echo "Setting permissions to 777"
	chmod -R 777 "${DIR}"
done

echo Building Instance Structure...
ARKINSTANCES=('ARK100' 'ARK101' 'ARK102')
for INSTANCE in "${ARKINSTANCES[@]}"; do
	mkdir -p "${ARKROOT}/${INSTANCE}/Logs" "${ARKROOT}/${INSTANCE}/SavedArks" "${ARKROOT}/${INSTANCE}/Config" "${ARKROOT}/${INSTANCE}/MODS"
	chown -R nobody:nogroup "${ARKROOT}/${INSTANCE}"
	chmod -R 777 "${ARKROOT}/${INSTANCE}"
done
