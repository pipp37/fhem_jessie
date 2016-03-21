## Docker Container for FHEM House-Automation-System - Full install
This Image is debian 8 (jessie) based, includes some stuff and has several perl modules installed. It should run out of the box.

Website: http://www.fhem.de

### Features
* volume /opt/fhem
* volume /opt/yowsup-config
* Imagemagic
* avrdude - firmware flash
* Python - yowsup (separate volume) for whatsapp client - volume: /opt/yowsup-config
* Open-SSH daemon
* Exposed ports: 2222/SSH, 7072 Fhem-raw, 8083-8085 Fhem Web
* supervisord for fhem
* cron daemon / at
* NFS client and autofs /net
* ssh root password: fhem!
* USB tools for CUL hardware

### Run:
    docker run -d --name fhem --cap-add SYS_ADMIN -p 7072:7072 -p 8083:8083 -p 8084:8084 -p 8085:8085 -p 2222:2222 pipp37/fhem_jessie
   
If NFS mount fails run with `--privileged` switch.

    docker run -d --name fhem --privileged -p 7072:7072 -p 8083:8083 -p 8084:8084 -p 8085:8085 -p 2222:2222  pipp37/fhem_jessie


Using  usb  needs to add the device to the run command.  Check usb devices on the host with ` lsusb `.

` lsusb -v | grep -E '\<(Bus|iProduct|bDeviceClass|bDeviceProtocol)' 2>/dev/null `

Add for example: `  --device=/dev/bus/usb/001/002 ` .


### Commands:
##### Running containers:
    docker ps
##### Attach shell to container with:
    docker exec -it ContainerID /bin/bash
##### GUI:
    http://ipaddress:8083
