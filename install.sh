#!/bin/bash
set -e
echo -e "start!"

# 定义颜色代码，用于输出信息的美化
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# 检查是否以 root 用户运行
if [ "$(whoami)" != "root" ]; then
    echo -e "${RED}非root用户运行，无法执行安装！${NC}"
    exit 1
fi

echo -e "${GREEN}root用户！开始安装...${NC}"

# 定义必要的目录变量
FREELIBS_DIR="/usr/lib/freelibs"
GLIBC_DIR="$HOME/glibc-all-in-one"
GLIBC_LIBS_DIR="$GLIBC_DIR/libs"
mkdir -p "./freelibs"

# 移动 freelibs 目录
if [ -d "freelibs" ]; then
    echo -e "${YELLOW}移动 freelibs 目录到 $FREELIBS_DIR...${NC}"
    mv freelibs/ "$FREELIBS_DIR"
else
    echo -e "${RED}freelibs 目录不存在，请检查！${NC}"
    exit 1
fi

# 安装 patchelf
echo -e "${YELLOW}检查并安装 patchelf...${NC}"
if command -v apt >/dev/null 2>&1; then
    apt update
    apt install -y patchelf
elif command -v yum >/dev/null 2>&1; then
    yum install -y patchelf
else
    echo -e "${RED}当前系统不支持该包管理器，无法安装 patchelf！${NC}"
    exit 1
fi

# 设置 clibc 权限并移动到 /usr/local/bin
if [ -f "clibc" ]; then
    echo -e "${YELLOW}设置 clibc 权限并移动到 /usr/local/bin...${NC}"
    chmod 777 clibc
    mv clibc /usr/local/bin/
else
    echo -e "${RED}clibc 文件不存在，请检查！${NC}"
    exit 1
fi

# 克隆 glibc-all-in-one 仓库
if [ ! -d "$GLIBC_DIR" ]; then
    echo -e "${YELLOW}克隆 glibc-all-in-one 仓库...${NC}"
    git clone https://github.com/matrix1001/glibc-all-in-one.git "$GLIBC_DIR"
else
    echo -e "${YELLOW}$GLIBC_DIR 已存在，跳过克隆步骤。${NC}"
fi

# 更新 glibc 列表
echo -e "${YELLOW}更新 glibc 列表...${NC}"
python3 "$GLIBC_DIR/update_list"

# 下载所有 glibc 版本
echo -e "${YELLOW}下载所有 glibc 版本...${NC}"
cat "$GLIBC_DIR/list" | xargs -I {} "$GLIBC_DIR/download" {}

# 创建目标目录
mkdir -p "$FREELIBS_DIR/amd64"
mkdir -p "$FREELIBS_DIR/i386"

# 复制 64 位(amd64)目录到 /usr/lib/freelibs/amd64
echo -e "${YELLOW}复制所有 64 位(amd64)目录到 $FREELIBS_DIR/amd64...${NC}"
for dir in "$GLIBC_LIBS_DIR"/*amd64; do
    if [ -d "$dir" ]; then
        cp -r "$dir" "$FREELIBS_DIR/amd64/"
    fi
done

# 复制 32 位(i386)目录到 /usr/lib/freelibs/i386
echo -e "${YELLOW}复制所有 32 位(i386)目录到 $FREELIBS_DIR/i386...${NC}"
for dir in "$GLIBC_LIBS_DIR"/*i386; do
    if [ -d "$dir" ]; then
        cp -r "$dir" "$FREELIBS_DIR/i386/"
    fi
done

echo -e "${GREEN}安装完成！${NC}"
