# Steps for Spinning Up a new Dev Integration box

# WIP

1. mount the 200GiB EBS storage device
  ```
  $ lsblk
  NAME  MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
  xvdf  202:80   0  100G  0 disk
  xvda1 202:1    0    8G  0 disk /
  $ sudo file -s /dev/xvdf
  /dev/xvdf: data
  $ sudo mkfs -t ext4 /dev/xvdf
  $ sudo mkdir /data
  $ sudo mount /dev/xvdf /data
  $ sudo cp /etc/fstab /etc/fstab.orig
  $ sudo vim /etc/fstab
  ```
2. edit the `/etc/fstab` file by adding the following:
  ```
  /dev/xvdf /data ext4 defaults,nofail 0 2
  ```
3. Mount the device:
  ```
  $ sudo mount -a
  ```
4. Before you shut mysql down backup the current DB.
  ```
  $ sudo mkdir /data/backups
  $ sudo innobackupex /data/backups
  ```
5. Once the backup is done shutdown mysql and unmount the `/var/lib/mysql` dir.
  ```
  $ sudo service mysql stop
  $ sudo umount /var/lib/mysql
  ```
6. symlink the new backup to the /var/lib/mysql dir. The new directory will follow this pattern: _YYYY-MM-DD_HH-mm-ss_
  ```
  $ sudo ln -nfs /data/backups/2015-06-04_15-34-32 /var/lib/mysql
  ```
7.

step 1-3 as taken from "[Making an Amazon EBS Volume Available for Use](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-using-volumes.html)"
