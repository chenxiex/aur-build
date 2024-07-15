#!/bin/bash

# 检查是否提供了参数
if [ $# -eq 0 ]; then
    echo "Usage: $0 package1 [package2 ...]"
    exit 1
fi

# 工作目录
WORK_DIR=$(pwd)
sudo chmod 777 /public

exec >> /public/log.txt 2>&1
echo '##################################'
env TZ='Asia/Shanghai' date
echo '##################################'

# 添加锁文件，以作为完成提示
echo -n 'a' >> "/public/build.lock"

# 循环处理每个参数
for x in "$@"; do
    # 尝试克隆AUR仓库
    git clone "https://aur.archlinux.org/$x.git"
    # 如果PKGBUILD不存在，则尝试克隆官方仓库
    if [ ! -f "$x/PKGBUILD" ]; then
        sudo rm -r "$x"
	    git clone "https://gitlab.archlinux.org/archlinux/packaging/packages/$x.git"
	fi
    
    # 检查/pkgbuilds下是否有名为$x的目录
    if [ -d "/pkgbuilds/$x" ]; then
    	# 合并目录，如果有重复文件，则覆盖
    	cp -r "/pkgbuilds/$x/." "$WORK_DIR/$x/"
    fi

    # 进入目录
    cd "$WORK_DIR/$x"

    # 检查是否存在makepkg.sh脚本
    if [ -f "makepkg.sh" ]; then
        # 如果存在，执行makepkg.sh
        ./makepkg.sh
    else
        # 如果不存在，执行makepkg -sf
        makepkg -sf --noconfirm
    fi

    # 返回到工作目录
    cd "$WORK_DIR"
done

#释放锁
head -c -1 "/public/build.lock" > "build.lock"
mv "build.lock" "/public/build.lock"
if [ ! -s "/public/build.lock" ]; then 
    rm "/public/build.lock"
fi
