# Jetson Nano setup

Setup scripts for the NVidia Jetson Nano (may or may not work with other jetson boards ¯\\_(ツ)_/¯)

## TLDR;

- To update jetson nano, run `sudo ./update.sh`
- To correct IMX219 camera color, run `sudo ./camera-override.sh`

## Update the Jetson Nano

After the initial [Setup of Jetson Nano](https://developer.nvidia.com/embedded/learn/get-started-jetson-nano-devkit#setup) the OS contains some Software that is not really usefull for robots (like the great libreoffice package). Also it has some outdated software packages, so it requires some updates.

The `update.sh` script will remove unused software and update other packages like Docker.

Run it with sudo privileges:

```
$ sudo ./update.sh
```

#### Test Docker

The script will also create a `docker` group for the jetbot user as it's [good advise](https://docs.docker.com/engine/install/linux-postinstall/) to run docker without `sudo docker ...` all the time.

After the update, test docker with user (without sudo!) :

`$ docker run hello-world`

If it doesnt work, restart jetson nano and try again.

#### WiFi Setup

Jetson Nano OS has a known and unsolved bug that WiFi Power Manager cannot be disabled permanently.

The problem is that Jetson Nano runs automatically in `power save mode` which leads to decreased wifi performance and sometimes even to problems with running robotic applications, because the connection is not stable or sometimes even disconnected.

For example, the command `sudo iw dev wlan0 set power_save off` will shut down the power manager for the running system, but after reboot, it will be enabled again.

The update script will also manage this with a service, which will run the above command on every boot.

To test this, run `iwconfig` which will show if wifi power manager is _on_ .

Also, run `nmcli device wifi list` to see a complete list of available WiFi Access Points. If it shows the current connection, the module is in power save mode and does not scan for available WiFi APs.

## Disable docker logs

Change docker log to `none` to save massive write operations on sd-card!

You can enable it again if there are docker issues to debug them ...

`$ docker info --format '{{.LoggingDriver}}'`

Should output `json-file` (default log option), to change the configuration, open the config file:

`$ sudo vim /etc/docker/daemon.json`

and add (or change) this line in the configuration:

`"log-driver": "none",`

then restart the docker service and check log format again:

$ sudo service docker restart
$ docker info --format '{{.LoggingDriver}}'

Should output `none` now.

## Camera Setup

I use the Waveshare IMX219 Camera modules, which require a color correction.

The script `camera-override.sh` will install the required ISP file for that.

Run it with sudo privileges:

```
$ sudo ./camera-override.sh
```


