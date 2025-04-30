#!/usr/bin/lua

-- 設定
local BASE_DIR = "/tmp/aios"
local BASE_FILE = "aios.sh"
local BASE_PATH = BASE_DIR .. "/" .. BASE_FILE
local BASE_URL = "https://raw.githubusercontent.com/site-u2023/aios/main/" .. BASE_FILE

-- ユーティリティ：コマンド実行 & 成功判定
local function run_cmd(cmd)
    local ok = os.execute(cmd)
    return ok == true or ok == 0
end

-- ディレクトリ作成
local function ensure_dir(path)
    local f = io.open(path, "r")
    if f then
        f:close()
        return true
    end
    return run_cmd("mkdir -p " .. path)
end

-- ダウンロード
local function download(url, outpath)
    local cmd = string.format('wget -q -O %s "%s"', outpath, url)
    return run_cmd(cmd)
end

-- 実行権限付与
local function chmodx(path)
    return run_cmd("chmod +x " .. path)
end

-- aios.sh 実行
local function exec_aios(args)
    local argstr = ""
    for i = 1, #args do
        argstr = argstr .. " " .. string.format("'%s'", args[i])
    end
    local exec_cmd = BASE_PATH .. argstr
    os.exit(os.execute(exec_cmd))
end

-- メイン処理
local function main()
    if not ensure_dir(BASE_DIR) then
        io.stderr:write("ディレクトリ作成失敗: " .. BASE_DIR .. "\n")
        os.exit(1)
    end
    if not download(BASE_URL, BASE_PATH) then
        io.stderr:write("ダウンロード失敗: " .. BASE_URL .. "\n")
        os.exit(1)
    end
    if not chmodx(BASE_PATH) then
        io.stderr:write("実行権限の付与に失敗: " .. BASE_PATH .. "\n")
        os.exit(1)
    end
    -- 引数を渡して実行
    exec_aios(arg)
end

main()