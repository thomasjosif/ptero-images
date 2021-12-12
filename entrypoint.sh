#!/bin/bash
echo "Hello!"
cd /home/container || exit
MODIFIED_STARTUP=$(eval echo "$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g')")
echo "/home/container/scp_server$: ${MODIFIED_STARTUP}"

if [ $REINSTALL == 1 ]; then
        if [ ! -f "steamcmd.sh" ]; then
            curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
        fi
        if [ ! -d "steamcmd" ]; then
            curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
        fi
        EX=""
        if [ ! -z $SPECIAL_BRANCH ]; then
                EX="-beta $SPECIAL_BRANCH"
                if  [ ! -z $BRANCH_PASSWORD ]; then
                        EX="-beta $SPECIAL_BRANCH -betapassword $BRANCH_PASSWORD"
                fi
        fi
        echo $EX
        ./steamcmd.sh +login anonymous +force_install_dir ./scp_server +app_update 996560 validate $EX +quit
#        cp -r ~/Steam/steamapps/common/SCP*/* ~/scp_server
fi

if [ "$UPDATE_INSTALLER" == 1 ]; then
        echo "Updating Installer.."
        rm -rf Exiled.Installer-Linux
        wget https://github.com/Exiled-Team/EXILED/releases/download/2.2.5/Exiled.Installer-Linux
        chmod +x Exiled.Installer-Linux
        echo "Installer updated. Running.."
        EXTRA=""
        if [ "$PRE_RELEASE" == 1 ]; then
                EXTRA="--pre-releases"
        fi
        if [ ! -z "$EXILED_VER" ]; then
                EXTRA="--target-version $EXILED_VER"
        fi

        rm -rf "temp" &&
        mkdir "temp" &&
        export DOTNET_BUNDLE_EXTRACT_BASE_DIR="temp"

        if [ ! -d "/home/container/.config" ]; then
        mkdir .config
        fi

        ./Exiled.Installer-Linux --appdata /home/container/.config -p /home/container/scp_server $EXTRA --exit
fi
if [ -f "/home/container/.config/EXILED/Plugins/DiscordIntegration.dll" ]; then
        cd DiscordIntegration &&
        if [ ! -d "/home/container/DiscordIntegration/node_modules" ]; then
                npm install package.json
        fi

        node discordIntegration.js > /home/container/DiscordIntegration/logs/latest.log &
        cd /home/container || exit
fi

cd /home/container/scp_server &&
${MODIFIED_STARTUP};
