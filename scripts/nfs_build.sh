ip=$(hostname -i | tr " " "\n" | grep -oP -m1 "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
network=$(echo $ip | sed "s/[0-9]$/0/")/24

sudo apt update
sudo apt install -y  nfs-kernel-server
sudo mkdir -p /mnt/nfs_share
sudo chown -R nobody:nogroup /mnt/nfs_share/
sudo chmod 777 /mnt/nfs_share/
sudo vim /etc/exports
sudo echo "/mnt/nfs_share  $network(rw,sync,no_subtree_check)" >> /etc/exports
sudo exportfs -a
sudo systemctl restart nfs-kernel-server
sudo ufw allow from $network to any port nfs
sudo ufw enable
sudo ufw status

echo "client user"
read username
echo "client ip"
read client_ip

ssh -t $username@$client_ip "\
sudo apt update |
sudo apt install -y nfs-common |
sudo mkdir -p /mnt/nfs_clientshare |
sudo mount $ip:/mnt/nfs_share  /mnt/nfs_clientshare"
