# RTSS Connect

Command line tool to connect to [RTSS](https://en.wikipedia.org/wiki/R%C3%A9seau_de_t%C3%A9l%C3%A9communications_sociosanitaire) network on Linux using [OpenConnect](https://www.infradead.org/openconnect) as VPN client and the [Android Emulator](https://developer.android.com/studio/run/emulator) to run OTP app.

Links :

- [Portal](https://www.portail.rtss.qc.ca)
- [Access token](http://www.ti.msss.gouv.qc.ca/Familles-de-services/Gestion-d-outils-collaboratifs/Teleaccesjetonvirtuel.aspx)

## Install Android tools

Install [command line tools](https://developer.android.com/studio#cmdline-tools) in `~/android/cmdline-tools/latest`.

Add tools to PATH in `~/.bashrc` :

```
PATH=$PATH:~/android/cmdline-tools/latest/bin:~/android/emulator:~/android/platform-tools
```

Install emulator & platform tools :

```
sdkmanager --install emulator platform-tools
```

## Create Android virtual device

Install platform & system image :

```
sdkmanager --install 'platforms;android-31' 'system-images;android-31;google_apis;x86_64'
```

Create device :

```
avdmanager create avd --name rtss-otp --device pixel_5 --package 'system-images;android-31;google_apis;x86_64' --tag google_apis --abi x86_64
```

Add camera and keyboard support in `~/.android/avd/rtss-otp.avd/config.ini` :

```
hw.camera.back=webcam0
hw.keyboard=yes
```

Start device :

```
emulator -avd rtss-otp
```

## Install OTP app

Download [CA Mobile OTP](https://play.google.com/store/apps/details?id=com.arcot.otp1) APK file to `~/Downloads/otp.apk`.

Install app :

```
adb install ~/Downloads/otp.apk
```

## Install command

Clone the project :

```
git clone git@github.com:MattSyms/rtss-connect.git ~/code/rtss-connect
```

Create and customize `config` file :

```
cp config.sample config
```

Add alias in `~/.bashrc` :

```
alias vpn='~/code/rtss-connect/vpn.sh'
```

Run command :

```
vpn
```
