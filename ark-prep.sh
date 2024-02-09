ARKROOT='/opt'
ARKSERVER=${ARKROOT}'/ARK-Server'
ARKCLUSTER=${ARKROOT}'/ARK-Cluster'
STEAM=${ARKROOT}'/Steam'
ARKMANAGER=${ARKROOT}'/arkmanager'
declare -a BASEDIRS=( "${ARKSERVER}" "${ARKCLUSTER}" "${STEAM}" "${ARKMANAGER}" )
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
cp bullseye/etc/arkmanager.cfg "${ARKMANAGER}"

echo Building Instance Structure...
for INSTANCE in ${ARKINSTANCES[@]}; do
	echo "   ...${INSTANCE}"
	mkdir -p "${ARKROOT}/${INSTANCE}"
        setfacl -d -m u::rwx "${DIR}"
        setfacl -d -m g::rwx "${DIR}"
        setfacl -d -m o::rwx "${DIR}"
	mkdir -p "${ARKROOT}/${INSTANCE}/Saved/Logs" "${ARKROOT}/${INSTANCE}/Saved/SavedArks" "${ARKROOT}/${INSTANCE}/Saved/Config" "${ARKROOT}/${INSTANCE}/MODS" "${ARKROOT}/${INSTANCE}/etc/arkmanager/instances"
	chown -R 1000:1000 "${ARKROOT}/${INSTANCE}"
        chmod -R ugo+srwx "${ARKROOT}/${INSTANCE}"
	cp bullseye/etc/GameUserSettings.ini "${ARKROOT}/${INSTANCE}/Config"
        ln "${ARKMANAGER}"/arkmanager.cfg -t "${ARKROOT}/${INSTANCE}/etc/arkmanager/"
        cp bullseye/etc/main.cfg "${ARKROOT}/${INSTANCE}/etc/arkmanager/instances"
done
echo "Complete"
