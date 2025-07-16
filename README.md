# clibc-name

## 项目背景

clibc 是几年前的项目，经过仔细审视，发现其中有许多地方具备优化的空间，并且技术难度不高。因此，我决定对其进行再次优化。原项目的源网站为 https://github.com/dsyzy/free-libc 。为了表达对原作者的尊重，在本项目中我尽可能直接沿用了原作者的一些命名。

## 目录结构

本项目主要包含以下文件：

- clic：核心代码文件，包含了优化后的 clibc 相关代码。

- [install.sh](http://install.sh)：安装和使用脚本，包含了项目的安装和修改 ELF 文件的功能。

- [README.md](http://README.md)：你正在阅读的项目说明文档。

注：原本存在的 freelibs 目录在安装过程中会被移动到 /usr/lib/freelibs，可忽略原始目录。

## 安装步骤

### 前提条件

- 你需要以 root 用户身份运行安装脚本，因为安装过程涉及系统级别的操作，如文件移动和软件安装。

- 系统需要能够访问互联网，因为安装过程中会克隆 glibc-all-in-one 仓库并下载所有 glibc 版本。

### 执行安装

使用以下命令来执行安装脚本：

```
git clone https://github.com/namename333/clibc-name
cd clibc-last
chmod +x install.sh
./install.sh
```

上述命令首先为 [install.sh](http://install.sh) 脚本添加可执行权限，然后运行该脚本完成项目的安装。安装过程中会进行以下操作：

1. **检查用户权限**：确保以 root 用户运行，否则安装将终止。

1. **移动** **freelibs** **目录**：将 freelibs 目录移动到 /usr/lib/freelibs。

1. **安装** **patchelf**：根据系统的包管理器（apt 或 yum）安装 patchelf。

1. **设置** **clibc** **权限并移动**：将 clibc 文件设置为可执行权限，并移动到 /usr/local/bin。

1. **克隆** **glibc-all-in-one** **仓库**：如果 $HOME/glibc-all-in-one 目录不存在，则克隆该仓库。

1. **更新** **glibc** **列表**：运行 update_list 脚本更新 glibc 列表。

1. **下载所有** **glibc** **版本**：根据更新后的列表下载所有 glibc 版本。

1. **复制** **glibc** **目录**：将 64 位（amd64）和 32 位（i386）的 glibc 目录复制到 /usr/lib/freelibs 对应的目录中。

## 注意事项

- 安装过程中可能会因为网络问题导致 glibc 列表更新或下载失败，请确保网络连接稳定。（你也可以更换镜像源来下载，或者科学上网）

- 如果在使用过程中遇到 patchelf 命令执行失败的情况，请检查 patchelf 是否正确安装，以及目标程序是否为有效的 ELF 文件。

## 贡献

如果你对本项目感兴趣，欢迎提交问题报告或拉取请求。在贡献代码时，请确保遵循原项目的开源协议以及相关的代码风格和规范。

## 版权声明

本项目基于原项目进行优化，尊重原作者的版权。具体的版权信息请参考原项目的开源协议。
