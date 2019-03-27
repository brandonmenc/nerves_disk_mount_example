# NervesDiskMountExample

Example application that uses
[NervesMountManager](https://github.com/brandonmenc/nerves_mount_manager) and
[NervesDiskManager](https://github.com/brandonmenc/nerves_disk_manager).

All this app does is watch for a USB drive with at least one partition to be
plugged in. When the drive is plugged in it will mount the partition and
create a special file on it.
