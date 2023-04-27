ARKROOT='/opt'
ARKSERVER=${ARKROOT}'/ARK-Server'
ARKCLUSTER=${ARKROOT}'/ARK-Cluster'
STEAM='/opt/Steam'
echo Making Server Directories...
mkdir -p "${ARKSERVER}" "${ARKCLUSTER}" "${STEAM}"
chown -R nobody:nogroup "${ARKSERVER}" "${ARKCLUSTER}" "${STEAM}"
chmod -R 777 "${ARKSERVER}" "${ARKCLUSTER}" "${STEAM}"

echo Building Instance Structure...
ARKINSTANCES=('ARK101' 'ARK102' 'ARK103')
for INSTANCE in "${ARKINSTANCES[@]}"; do
	mkdir -p "${ARKROOT}/${INSTANCE}/Logs" "${ARKROOT}/${INSTANCE}/SavedArks" "${ARKROOT}/${INSTANCE}/Config" "${ARKROOT}/${INSTANCE}/MODS"
	chown -R nobody:nogroup "${ARKROOT}/${INSTANCE}"
	chmod -R 777 "${ARKROOT}/${INSTANCE}"
done
