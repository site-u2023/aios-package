# aios-package

**aios-package** is an ipk package specifically for OpenWrt. By installing this package, the "aios.sh" shell script will be installed and ready to use on your OpenWrt system. This package provides the easiest way to run aios.sh on OpenWrt.

## Install
Release Build (opkg)
```sh
opkg install https://github.com/site-u2023/aios-package/releases/download/ipk0.0/aios_all.ipk
```

<details><summary>For version 19.07</summary>

```sh
wget -O /tmp/aios_all.ipk "https://github.com/site-u2023/aios-package/releases/download/ipk0.0/aios_all.ipk"; opkg install /tmp/aios_all.ipk
```
---
</details>

“snapshot” build (apk)
```sh
wget -O /tmp/aios.apk "https://github.com/site-u2023/aios-package/releases/download/apk0.1/aios.apk"; opkg install /tmp/aios.apk
```
