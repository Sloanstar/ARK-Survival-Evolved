[![](https://img.shields.io/codacy/grade/ac35171da5ca4fc29cfcdd2f7c1f7833)](https://hub.docker.com/r/cm2network/squad/) [![Docker Build Status](https://img.shields.io/docker/cloud/build/cm2network/squad.svg)](https://hub.docker.com/r/cm2network/squad/) [![Docker Stars](https://img.shields.io/docker/stars/cm2network/squad.svg)](https://hub.docker.com/r/cm2network/squad/) [![Docker Pulls](https://img.shields.io/docker/pulls/cm2network/squad.svg)](https://hub.docker.com/r/cm2network/squad/) [![](https://img.shields.io/docker/image-size/cm2network/squad)](https://microbadger.com/images/cm2network/squad) [![Discord](https://img.shields.io/discord/747067734029893653)](https://discord.gg/7ntmAwM)
# Supported tags and respective `Dockerfile` links
-	[`latest` (*bullseye/Dockerfile*)](https://github.com/Sloanstar/ARK-Survival-Evolved/blob/master/bullseye/Dockerfile)

# What is ARK: Survival Evolved?
As a man or woman stranded, naked, freezing, and starving on the unforgiving shores of a mysterious island called ARK, use your skill and cunning to kill or tame and ride the plethora of leviathan dinosaurs and other primeval creatures roaming the land. Hunt, harvest resources, craft items, grow crops, research technologies, and build shelters to withstand the elements and store valuables, all while teaming up with (or preying upon) hundreds of other players to survive, dominate... and escape! <br/>

> [ARK: Survival Evolved](http://store.steampowered.com/app/346110/ARK_Survival_Evolved/)

<img src="https://vignette.wikia.nocookie.net/arksurvivalevolved_gamepedia/images/e/e6/Site-logo.png/revision/latest?cb=20220909010429" alt="logo" width="300"/></img>

# How to use this image

## Hosting a simple game server
Running on the *host* interface:<br/>
```console
$ docker run -d --net=host -v /home/steam/ark-dedicated/ --name=ark-dedicated sloanstar/ark-se:latest
```

Running using a bind mount for data persistence on container recreation RECOMMENDED:
```console
$ mkdir -p /opt/ARK-Server
$ mkdir -p /opt/ARK-Cluster
$ mkdir -p /opt/ARK100/Logs
$ mkdir -p /opt/ARK100/SavedArks
$ mkdir -p /opt/ARK100/Config
$ chmod -R 777 /opt/ARK-Server /opt/ARK-Cluster /opt/ARK100 # Makes sure the directory is writeable by the unprivileged container user
$ docker run -it --name ARK100 --network host \
	-v /opt/ARK-Server:/home/steam/ShooterGameServer \
	-v /opt/ARK100/Config:/home/steam/ShooterGameServer/ShooterGame/Saved/Config/LinuxServer \
	-v /opt/ARK100/SavedArks:/home/steam/ShooterGameServer/ShooterGame/Saved/SavedArks \
	-v /opt/ARK100/Logs:/home/steam/ShooterGameServer/ShooterGame/Saved/Logs \
	sloanstar/ark-se:latest

```

Running multiple instances (iterate PORT, QUERYPORT and RCONPORT and change Server Specific Folder):<br/>
```console
$ docker run -d --net=host -e PORT=7788 -e QUERYPORT=27166 -e RCONPORT=21115 --name=ARK101 \
	-v /opt/ARK-Server:/home/steam/ShooterGameServer \
	-v /opt/ARK101/Config:/home/steam/ShooterGameServer/ShooterGame/Saved/Config/LinuxServer \
	-v /opt/ARK101/SavedArks:/home/steam/ShooterGameServer/ShooterGame/Saved/SavedArks \
	-v /opt/ARK101/Logs:/home/steam/ShooterGameServer/ShooterGame/Saved/Logs \
	sloanstar/ark-se:latest
```

**It's also recommended using "--cpuset-cpus=" to limit the game server to a specific core & thread.**<br/>
**The container will automatically update the game on startup, so if there is a game update just restart the container.**

### docker-compose.yml example
```dockerfile
version: '3.9'

services:
  ark-se:
    image: sloanstar/ark-se
    container_name: ark-dedicated
    restart: unless-stopped
    network_mode: "host"
    volumes:
      - /opt/ARK-Server:/home/steam/ShooterGameServer
      - /opt/ARK100/Config:/home/steam/ShooterGameServer/ShooterGame/Saved/Config/LinuxServer
      - /opt/ARK100/SavedArks:/home/steam/ShooterGameServer/ShooterGame/Saved/SavedArks
      - /opt/ARK100/Logs:/home/steam/ShooterGameServer/ShooterGame/Saved/Logs
      - /opt/ARK-Cluster:/home/steam/ShooterGameServer/Cluster
    environment:
      - SESSIONNAME=ARK 100
      - PORT=7777
      - QUERYPORT=27015
      - RCONPORT=27020
      - MAPNAME=TheIsland
      - CLUSTERKEY=ChangeMe
      - ADMINPW=ChangeMe
```

# Configuration
## Environment Variables
Feel free to overwrite these environment variables, using -e (--env):
```dockerfile
PORT=7777
QUERYPORT=27015
RCONPORT=27020
```

## Config
The config files can be edited using this command:

```console
docker exec -it {Container Name} nano /home/steam/ShooterGameServer/ShooterGame/Saved/Config/LinuxServer/GameUserSettings.ini
docker exec -it {Container Name} nano /home/steam/ShooterGameServer/ShooterGame/Saved/Config/LinuxServer/Game.ini
```

If you want to learn more about configuring an ARK server check this [documentation](https://ark.gamepedia.com/Server_Configuration).

## Mods - TODO: Update for ARK

Add each id to the MODS environment variable, for example `MODS="(13371337 12341234 1111111)"`

> MODS must be a bash array `(mod1id mod2id mod3id)` where each mod id is separated by a space and inclosed in brackets

You can get the mod id from the workshop url or by installing it locally and lookup the numeric folder name at `<root_steam_folder>/steamapps/workshop/content/393380`.

# Contributors
[![Contributors Display](https://badges.pufler.dev/contributors/CM2Walki/Squad?size=50&padding=5&bots=false)](https://github.com/CM2Walki/Squad/graphs/contributors)
