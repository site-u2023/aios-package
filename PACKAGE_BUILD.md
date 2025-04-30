# OpenWrt用ipkパッケージ作成・インストール手順書 / Guide for Building & Installing OpenWrt ipk Packages

---

## 日本語

### 概要
この手順書は、OpenWrt向けipkパッケージの作成、ターゲットデバイスへのアップロード、インストール、及び作業後の不要ファイル削除までの流れを具体的なコマンド例を交えて記載しています。  
各項目の固有情報（パッケージ名、IPアドレス、ファイルパス等）は、必ず各自の環境に合わせて読み替えてください。

---

### 1. ipkg-buildの導入

```sh
wget https://raw.githubusercontent.com/openwrt/openwrt/master/scripts/ipkg-build
chmod +x ipkg-build
sudo mv ipkg-build /usr/local/bin/
```
> `ipkg-build` コマンドが使えることを確認してください。

---

### 2. パッケージディレクトリの構築

```sh
mkdir -p ~/your_project/ipk/CONTROL
mkdir -p ~/your_project/ipk/usr/bin
```
#### ディレクトリ構成図（例）

```
your_project/
└─ ipk/
   ├─ CONTROL/
   │   └─ control         ... パッケージ情報（必須）
   └─ usr/
       └─ bin/
           └─ your_executable ... 実行ファイル（スクリプトやバイナリ）
```

> - `CONTROL/control`：パッケージのメタデータ（必須）
> - `usr/bin/your_executable`：インストールされる実行ファイル

- `CONTROL/control` ファイルの作成（内容は自分のパッケージ仕様に合わせて編集）:

```sh
cat <<EOF > ~/your_project/ipk/CONTROL/control
Package: your-package
Version: 0.1
Architecture: all
Maintainer: your-name
Description: Your package description here.
EOF
```

- 実行ファイル（例: your_executable）の配置と権限付与、および**改行コードの変換**:

```sh
cp /path/to/your_executable ~/your_project/ipk/usr/bin/
# --- ここから追記 ---
# 改行コードをLF（UNIX形式）に統一（Windowsで編集した場合は必須）
dos2unix ~/your_project/ipk/usr/bin/your_executable
# 実行権限を必ず付与
chmod +x ~/your_project/ipk/usr/bin/your_executable
# --- ここまで追記 ---
```
> **重要:**  
> - 実行ファイル（シェルスクリプト・Luaスクリプト等）は、必ずUNIX(LF)改行にしてください。  
> - Windowsで作成・編集した場合は、`dos2unix`コマンドでLF変換を行ってください。  
> - 改行コード不一致（CRLFのまま）だと、「No such file or directory」エラーの原因になります。
> - 実行権限（`chmod +x`）がないと、`Permission denied`等で実行できません。

---

### 3. ipkパッケージの作成

```sh
cd ~/your_project
ipkg-build ipk
```
- 成功すると、カレントディレクトリに `your-package_0.1_all.ipk` などが生成されます。

---

### 4. パッケージのアップロード

- **IPアドレスは必ず自分のOpenWrt機器のものに置き換えてください。**

```sh
scp your-package_0.1_all.ipk root@<OpenWrtのIPアドレス>:/tmp/
```

---

### 5. OpenWrt側でのインストール

```sh
ssh root@<OpenWrtのIPアドレス>
opkg install /tmp/your-package_0.1_all.ipk
```

---

### 6. 動作確認

```sh
which your_executable
your_executable --help
```

---

### 7. 作業後のクリーンアップ

```sh
rm /tmp/your-package_0.1_all.ipk
exit
```
> 不要なipkファイルは必ず削除してください。

---

## 注意点
- IPアドレス・パス・ファイル名は必ず各自の環境に合わせて変更してください。
- OpenWrtの空き容量が十分かどうか、インストール前に確認してください。
- `opkg install`が失敗する場合は、依存パッケージの有無やcontrolファイルの内容を再確認してください。
- **実行ファイルの改行コードと権限は特に重要です。CRLF→LF変換・chmod +xを必ず行ってください。**

---

## English

### Overview
This guide provides step-by-step instructions for building an OpenWrt ipk package, uploading it to your target device, installing it, and cleaning up temporary files.  
**Be sure to replace placeholders (package name, IP address, file paths, etc.) with your own settings.**

---

### 1. Install ipkg-build

```sh
wget https://raw.githubusercontent.com/openwrt/openwrt/master/scripts/ipkg-build
chmod +x ipkg-build
sudo mv ipkg-build /usr/local/bin/
```
> Ensure that the `ipkg-build` command is available.

---

### 2. Prepare the Package Directory

```sh
mkdir -p ~/your_project/ipk/CONTROL
mkdir -p ~/your_project/ipk/usr/bin
```

#### Directory Structure Example

```
your_project/
└─ ipk/
   ├─ CONTROL/
   │   └─ control         ... Package metadata (required)
   └─ usr/
       └─ bin/
           └─ your_executable ... Executable file (script or binary)
```

> - `CONTROL/control`: Package metadata (required)
> - `usr/bin/your_executable`: The file installed as executable

- Create the `CONTROL/control` file (edit contents to match your package):

```sh
cat <<EOF > ~/your_project/ipk/CONTROL/control
Package: your-package
Version: 0.1
Architecture: all
Maintainer: your-name
Description: Your package description here.
EOF
```

- Place your executable (example: your_executable), **convert line endings**, and set permissions:

```sh
cp /path/to/your_executable ~/your_project/ipk/usr/bin/
# --- Added section ---
# Convert line endings to UNIX LF (required if edited on Windows)
dos2unix ~/your_project/ipk/usr/bin/your_executable
# Ensure executable permission is set
chmod +x ~/your_project/ipk/usr/bin/your_executable
# --- End of added section ---
```
> **Important:**  
> - Always ensure scripts/binaries use UNIX (LF) line endings.  
> - If edited on Windows, run `dos2unix` to convert line endings.  
> - Wrong line endings (CRLF) can cause "No such file or directory" errors on OpenWrt.  
> - Executable permission (`chmod +x`) is mandatory; without it, you may get "Permission denied".

---

### 3. Build the ipk Package

```sh
cd ~/your_project
ipkg-build ipk
```
- If successful, `your-package_0.1_all.ipk` will be generated in your current directory.

---

### 4. Upload the Package

- **Replace `<OpenWrt IP address>` with your device's actual IP.**

```sh
scp your-package_0.1_all.ipk root@<OpenWrt IP address>:/tmp/
```

---

### 5. Install on OpenWrt

```sh
ssh root@<OpenWrt IP address>
opkg install /tmp/your-package_0.1_all.ipk
```

---

### 6. Verify Installation

```sh
which your_executable
your_executable --help
```

---

### 7. Clean up Temporary Files

```sh
rm /tmp/your-package_0.1_all.ipk
exit
```
> Always delete unnecessary ipk files after installation.

---

## Notes
- Always adjust IP address, paths, and filenames to match your environment.
- Ensure your OpenWrt device has enough free space before installation.
- If `opkg install` fails, check for missing dependencies or issues in the control file.
- **Line endings and permissions are critical! Always use LF (not CRLF) and set executable bit.**