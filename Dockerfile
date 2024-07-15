FROM archlinux

RUN echo 'Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist

RUN pacman -Syyu --noconfirm git base-devel

RUN mkdir -p /public
RUN mkdir -p /pkgbuilds

RUN useradd -m aurbuild
RUN echo 'aurbuild ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/00_aurbuild

COPY ./makepkg.conf /etc/makepkg.conf

WORKDIR /home/aurbuild

COPY --chown=aurbuild:aurbuild ./aur-build.sh aur-build.sh
RUN chmod +x aur-build.sh

ENTRYPOINT ["sudo", "-u", "aurbuild", "./aur-build.sh"]
