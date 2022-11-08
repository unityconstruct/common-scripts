#!/bin/bash



src=/var/tmp/rom/
dest=/media/media1/iso/
#dest=/media/media1/000

# move files to iso1 hdd
echo "moving ${src}*.iso to ${dest}" 
mv -bf "${src}"*.iso "${dest}"
ls -la "${src}"*.iso

echo "moving ${dest}*.tar to ${dest}" 
mv -bf "${src}"*.tar "${dest}"
ls -la "${src}"*.tar


__set_srcdir () {
    local __resp=
    read -p "Enter source dir [ex: /var/tmp/rom/]" __resp
    echo "Typed: [${__resp}]"
    src="${__resp}"

}

__set_destdir () {
    local __resp=
    read -p "Enter dest dir [ex: /media/media3/cds/]" __resp
    echo "Typed: [${__resp}]"
    dest="${__resp}"

}

# scp implementation
#scp *.iso setup@silo6:/media/${dest}/cds

