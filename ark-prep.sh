ARKROOT='/opt'
ARKSERVER=${ARKROOT}'/ARK-Server'
ARKCLUSTER=${ARKROOT}'/ARK-Cluster'
STEAM=${ARKROOT}'/Steam'
declare -a BASEDIRS=( "${ARKSERVER}" "${ARKCLUSTER}" "${STEAM}" )
echo "ARK Instances: $ARKINSTANCES"
#give opportunity to set ARK Instances in shell - if not build it.
if  ( test -n "${ARKINSTANCES}" )
then
	declare -a ARKINSTANCES=(${ARKINSTANCES})
else
	declare -a ARKINSTANCES=('ARK100' 'ARK101' 'ARK102')
fi

echo Making Server Directories...
for DIR in "${BASEDIRS[@]}"; do
	echo Creating "${DIR}"
	mkdir -p "${DIR}"
	echo "Setting owner 1000:1000"
	chown -R 1000:1000 "${DIR}"
	echo "Setting permissions to +rwx"
	chmod -R ugo+srwx "${DIR}"
	setfacl -d -m u::rwx "${DIR}"
	setfacl -d -m g::rwx "${DIR}"
	setfacl -d -m o::rwx "${DIR}"
done

echo Building Instance Structure...
for INSTANCE in ${ARKINSTANCES[@]}; do
	echo "   ...${INSTANCE}"
	mkdir -p "${ARKROOT}/${INSTANCE}"
        setfacl -d -m u::rwx "${DIR}"
        setfacl -d -m g::rwx "${DIR}"
        setfacl -d -m o::rwx "${DIR}"
	mkdir -p "${ARKROOT}/${INSTANCE}/Logs" "${ARKROOT}/${INSTANCE}/SavedArks" "${ARKROOT}/${INSTANCE}/Config" "${ARKROOT}/${INSTANCE}/MODS"
	chown -R 1000:1000 "${ARKROOT}/${INSTANCE}"
        chmod -R ugo+srwx "${ARKROOT}/${INSTANCE}"
	cp bullseye/etc/GameUserSettings.ini "${ARKROOT}/${INSTANCE}/Config"
done
echo "Complete"
