#!/bin/sh

set -e

ICON=ic_launcher.icns
if [ "$RUNNER_OS" = "Windows" ]; then
    ICON=ic_launcher.ico

    # Create debug version for Windows
    pyinstaller \
        --hidden-import etesync_dav.radicale \
        --hidden-import radicale.auth.htpasswd \
        --additional-hooks-dir ./hooks \
        --onefile \
        --icon $ICON \
        --name etesync-dav-debug
        ../scripts/etesync-dav
fi

# Icon is used on Mac & Windows and ignored on Linux
pyinstaller \
    --hidden-import etesync_dav.radicale \
    --hidden-import radicale.auth.htpasswd \
    --additional-hooks-dir ./hooks \
    --onefile \
    --windowed \
    --icon $ICON \
    ../scripts/etesync-dav

# Travis stuff
mkdir -p deploy
if [ "$RUNNER_OS" = "Linux" ]; then
    ./dist/etesync-dav --version  # Sanity test on Linux and mac, can't do on windows
    mv dist/etesync-dav "deploy/linux-amd64-etesync-dav"
fi
if [ "$RUNNER_OS" = "macOS" ]; then
    ./dist/etesync-dav --version  # Sanity test on Linux and mac, can't do on windows
    cd dist
    zip -r mac-etesync-dav.zip *
    mv mac-etesync-dav.zip ../deploy/
    cd ../
fi
if [ "$RUNNER_OS" = "Windows" ]; then
    mv dist/etesync-dav.exe deploy/
    mv dist/etesync-dav-debug.exe deploy/
fi
