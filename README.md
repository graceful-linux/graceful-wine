# wine

> 支持windows应用程序运行的环境

## 主要命令介绍

|命令|功能|
|----|----|
|winetricks|用于下载wine环境下的动态库、字体等资源|
|wine|wine环境主要程序|

> wine32是window 32位程序运行环境，动态库都是32位的;
> wine64是window 64位程序运行环境，动态库都是64位的。
> 使用wine64即可

## 安装前准备

当前wine版本是`wine 9.0.0-4`，使用过程中发现wine有提示，wine的64位环境属于**体验阶段**，尽量使用wine的32位环境。

在编译wine32的时候依赖一些32位动态库，我们可以通过修改包管理器配置文件，添加32位程序的源来解决此问题，具体做法如下：
1. 打开 `/etc/pacman.conf`
    ```shell
    sudo vim /etc/pacman.conf
    ```
2. 在文件末尾添加如下配置
    ```
    [multilib]
    Include = /etc/pacman.d/mirrorlist
    ```
3. 更新源
    ```shell
    sudo pacman -Sy
    ```

> 这里需要注意的是，上述配置中，源地址默认放在`/etc/pacman.d/mirrorlist`中，如果系统中没有此文件，就需要用实际的源地址替代。
> 不过此文件默认是有的！

## wine32编译

在做了上步`安装前准备`之后，在此源码根目录下执行：

1. 编译前环境检查
    ```shell
    ./configure
    ```
    如果有任何缺少32位库的报错，直接用包管理器安装即可，直到此命令执行无报错为止。
2. 开始编译
    ```shell
    make -j8
    ```
编译完成后即可在当前根目录看到wine的32位二进制程序。

> 我并没有编译 wine32 位环境

## wine64编译

在此源码根目录直接执行 `./build.sh` 即可，执行成功后在当前目录的 `out/` 下看到生成的 `graceful-wine-9.0.0-4-x86_64.pkg.tar.zst` 安装包，执行 `pacman -U out/graceful-wine-*-x86_64.pkg.tar.zst` 安装即可。

