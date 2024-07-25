# AUR-BUILD
用于从AUR或ARCH官方源构建软件包的Docker镜像

## 使用方法
```shell
# 切换工作目录
cd aur-build
# 构建镜像
docker build -t aur-build .
# 选择软件包输出目录，构建完成的软件包会输出到这个目录下，值应该是一个位于宿主机上的绝对路径
export $PATH_TO_PKG=
# 选择要构建的软件包名。值应该为一个字符串，包含一个或多个包名，包名之间以空格分隔
export $PACKAGE_NAME=
# 运行容器
docker run -d --rm -v ./pkgbuilds:/pkgbuilds -v $PATH_TO_PKG:/public aur-build $PACKAGE_NAME
```
可以在`$PATH_TO_PKG`目录下查看`log.txt`文件，以了解构建过程

任何情况下，优先从AUR构建软件包，如果从AUR克隆的项目没有包含`PKGBUILD`文件，则从ARCH官方源构建软件包。需要注意的是，有些AUR项目虽然没有AUR页面，但它们的`PKGBUILD`文件仍然存在于AUR仓库中，这些项目也会被从AUR构建，例如`lutris`。因此，如果你希望从ARCH官方源构建软件包，请确保AUR仓库中没有这个软件包。

该镜像添加了ArchlinuxCN源，以及使用清华源作为默认镜像源。可以在Dockerfile中修改相关设置。

## 高级用法
### 自定义makepkg.conf配置
如果需要自定义makepkg.conf配置，只需要编辑项目根目录下的`makepkg.conf`文件，然后重新构建镜像即可

### 自定义本地仓库文件
如果你希望将任何文件放入或者覆写到本地的软件包构建文件仓库中，请将这些文件放入`pkgbuilds`下以软件包名命名的子文件夹中。例如，如果你要编译`yay`软件包，并且你希望覆写`PKGBUILD`文件，你可以将`PKGBUILD`文件放入`pkgbuilds/yay`文件夹中，然后运行容器即可。

### 自定义构建脚本
默认情况下，该项目使用`makepkg -sf --noconfirm`选项构建软件包。你可以使用自己的构建脚本。请将脚本命名为`makepkg.sh`并放入`pkgbuilds`文件夹下以软件包名命名的子文件夹中。例如，如果你要编译`yay`软件包，并且你希望使用自己的构建脚本，你可以将`makepkg.sh`文件放入`pkgbuilds/yay`文件夹中，然后运行容器即可。这个脚本将会替代`makepkg -sf --noconfirm`命令。