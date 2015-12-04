#!/bin/bash

echo "Install Apache Ant..."
apt-get install ant -y > /dev/null 2>&1
sed -i '/^export ANT_HOME="\/usr\/share\/ant"$/d' ~/.zshrc > /dev/null 2>&1
echo 'export ANT_HOME="/usr/share/ant"' >> ~/.zshrc
sed -i '/^export PATH=${PATH}:${ANT_HOME}\/bin$/d' ~/.zshrc > /dev/null 2>&1
echo 'export PATH=${PATH}:${ANT_HOME}/bin' >> ~/.zshrc
export ANT_HOME="/usr/share/ant"
export PATH=${PATH}:${ANT_HOME}/bin

echo "Install Cordova..."
npm install -g cordova > /dev/null 2>&1

echo "Install Android SDK..."
apt-get install expect -y > /dev/null 2>&1         # For silent android install 

# Not sure for the 3 lines bellow 
dpkg --add-architecture i386
apt-get -qqy update
apt-get -qqy install libncurses5:i386 libstdc++6:i386 zlib1g:i386

apt-get install lib32stdc++6 lib32z1 lib32ncurses5 -y > /dev/null 2>&1   # Android SDK is only on 32bits (libc-i386 ?)
mkdir /usr/share/android > /dev/null 2>&1
cd /usr/share/android
echo "Download Android SDK..."
wget http://dl.google.com/android/android-sdk_r24.0.2-linux.tgz -O android-sdk.tgz #-o /dev/null
echo "unzip Android SDK..."
tar -xvzf android-sdk.tgz > /dev/null 2>&1
rm -rf android-sdk.tgz > /dev/null 2>&1
mv android-sdk-linux/* . > /dev/null 2>&1
rm -rf android-sdk-linux > /dev/null 2>&1
sed -i '/^export ANDROID_HOME="\/usr\/share\/android"$/d' ~/.zshrc > /dev/null 2>&1
echo 'export ANDROID_HOME="/usr/share/android"' >> ~/.zshrc
sed -i '/^export PATH=${PATH}:${ANDROID_HOME}\/tools:${ANDROID_HOME}\/platform-tools$/d' ~/.zshrc > /dev/null 2>&1
echo 'export PATH=${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools' >> ~/.zshrc
export ANDROID_HOME="/usr/share/android"
export PATH=${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

cat << MYEOF > accept-licenses.sh
#!/usr/bin/expect -f
# Usage example:
# ./accept-licenses "android update sdk --no-ui --all --filter build-tools" "android-sdk-license-bcbbd656|intel-android-sysimage-license-1ea702d1"
set timeout 1800
set cmd [lindex \$argv 0]
set licenses [lindex \$argv 1]
spawn {*}\$cmd
expect {
-regexp "Do you accept the license '(\$licenses)'.*" {
exp_send "y\r"
exp_continue
}
"Do you accept the license '*-license-*'*" {
exp_send "n\r"
exp_continue
}
eof
}
MYEOF

chmod u+x accept-licenses.sh

# View all SDK : android list sdk --all --extended

#COMPONENTS="tools,platform-tools,build-tools-17.0.0,android-17,sys-img-mips-android-17,sys-img-x86-android-17,sys-img-armeabi-v7a-android-17"
#COMPONENTS="-s --filter tools,platform-tools,build-tools-19.0.0,android-19,sys-img-mips-android-19,sys-img-x86-android-19,sys-img-armeabi-v7a-android-19"
COMPONENTS=""
LICENSES="android-sdk-license-5be876d5|mips-android-sysimage-license-15de68cc|intel-android-sysimage-license-1ea702d1"
# Android SDK : android-sdk-license-5be876d5
# Google TV : android-googletv-license-99eda7fb
# Google Glass : google-gdk-license-9529f459

echo "Download Android SDK add-on"
./accept-licenses.sh "tools/android update sdk --no-ui $COMPONENTS" $LICENSES 

chmod g+x,o+x -R /usr/share/android > /dev/null 2>&1
chmod g+xw,o+xw /usr/share/android/temp > /dev/null 2>&1
chmod g+xw,o+xw /usr/share/android/platforms > /dev/null 2>&1
chmod g+xw,o+xw /usr/share/android/add-ons > /dev/null 2>&1

mkdir /usr/share/android/build-tools > /dev/null 2>&1
chmod g+xw,o+xw -R /usr/share/android/build-tools > /dev/null 2>&1

mkdir /usr/share/android/platform-tools > /dev/null 2>&1
chmod g+xw,o+xw -R /usr/share/android/platform-tools > /dev/null 2>&1

mkdir /usr/share/android/samples > /dev/null 2>&1
chmod g+xw,o+xw -R /usr/share/android/samples > /dev/null 2>&1

mkdir /usr/share/android/docs > /dev/null 2>&1
chmod g+xw,o+xw -R /usr/share/android/docs > /dev/null 2>&1

mkdir /usr/share/android/extras > /dev/null 2>&1
chmod g+xw,o+xw -R /usr/share/android/extras > /dev/null 2>&1

mkdir /usr/share/android/system-images > /dev/null 2>&1
chmod g+xw,o+xw -R /usr/share/android/system-images > /dev/null 2>&1

chown root:root -R /usr/share/android > /dev/null 2>&1

echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", MODE="0666", GROUP="plugdev"' > /etc/udev/rules.d/51-android.rules
chmod a+r /etc/udev/rules.d/51-android.rules > /dev/null 2>&1
