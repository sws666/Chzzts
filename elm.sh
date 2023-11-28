#!/bin/bash
#Author: zelang
#Time: 2022年10月3日（星期一） (GMT+8)

cur_dir=$(pwd)
check_system() {
  arch=$(arch)
  if [[ $arch == "amd64" || $arch == "x86_64" || $arch == "x64" ]]; then
    arch="amd64"
  elif [[ $arch == "aarch64" || $arch == "arm64" ]]; then
    arch="arm64"
  elif [[ $arch == "x86" || $arch == "i386" ]]; then
    arch="386"
  elif [[ $arch == "arm" || $arch == "armv7l" || $arch == "armv8l" ]]; then
    arch="arm"
  else
    echo -e "[Error] 检测架构失败，请尝试切换设备或联系作者"
    exit 2
  fi
  echo -e "[INFO] 架构: ${arch}"
}
check_install() {
  if [ ! -d "${cur_dir}/elmtool" ]; then
    echo -e "[INFO] 检测到当前未安装ElmTool，即将下载二进制文件"
    mkdir -p elmtool && cd elmtool || exit
    wget https://ghproxy.com/https://github.com/zelang/elm-release/releases/download/"${new_version:0:3}"/elm-"${new_version}"-linux-${arch}.tar.gz
    # shellcheck disable=SC2181
    if [ $? -ne 0 ]; then
      echo -e "[Error] 下载二进制文件失败，请检查网络或重新执行本脚本" && exit 2
    fi
    tar -zxvf elm-"${new_version}"-linux-${arch}.tar.gz && rm -rf elm-"${new_version}"-linux-${arch}.tar.gz
    echo -e "[SUCCESS] 下载二进制文件成功"
  fi
}
update_soft() {
  if [ -d "${cur_dir}/elmtool" ]; then
    cd "${cur_dir}" || exit
    echo -e "[INFO] 检测到当前已安装ElmTool，即将下载更新二进制文件"
    mkdir -p tmp && cd tmp || exit
    wget https://ghproxy.com/https://github.com/zelang/elm-release/releases/download/"${new_version:0:3}"/elm-"${new_version}"-linux-${arch}.tar.gz >/dev/null 2>&1
    # shellcheck disable=SC2181
    if [ $? -ne 0 ]; then
      echo -e "[Error] 下载二进制文件失败，请检查网络或重新执行本脚本" && cd .. && rm -rf tmp && exit 2
    fi
    tar -zxvf elm-"${new_version}"-linux-${arch}.tar.gz && rm -rf elm-"${new_version}"-linux-${arch}.tar.gz
    mv -f elm "${cur_dir}/elmtool" && cd .. && rm -rf tmp
    echo -e "[SUCCESS] 更新二进制文件成功"
  fi
}

version_gt() { test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" != "$1"; }
main() {
  #检测系统
  check_system
  #检测是否存在文件 && 下载更新文件
 # check_update
  #开始执行任务
  cd "${cur_dir}/elmtool" || exit
  chmod +x elm && ./elm -task -ql
  #等待任务执行完毕
}

main
