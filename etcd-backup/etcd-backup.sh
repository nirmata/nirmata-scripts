#!/bin/bash
echo -e "--------------------------------------"
echo -e "# ETCD backup for node $HOSTNAME #"
echo -e "--------------------------------------"
etcdid=$(sudo docker ps -a | grep etcd | awk '{print $1}')
echo -e "- Container ID $etcdid "
sudo docker exec -it $etcdid sh -c 'cd /var/etcd/data/member; printf "%s\n" *; exit'
echo -e "- Backup on master node $HOSTNAME"
date=$(date '+%Y-%m-%d')
mkdir backup-etcd-$date
etcdid=$(sudo docker ps -a | grep etcd | awk '{print $1}')
sudo docker cp $etcdid:/var/etcd/data/member/ backup-etcd-$date
ls -ltr backup-etcd-$date/member | tail -2
echo -e "-----------------------------------------------"
echo -e "# ETCD backup for node $HOSTNAME completed #"
echo -e "-----------------------------------------------"
