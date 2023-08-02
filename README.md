# 总述（Overview）

同济大学软件学院操作系统课程的课程设计，完成了MIT2022年秋季6.1810课程的配套实验，使用了xv6内核并利用qemu进行模拟。实验内容如下：

- Utilities
- System Calls
- Page Tables
- Traps
- Copy on Write
- Multithreading
- Network Driver
- Lock
- File System
- mmap

实验报告放在report文件夹下。

This is the course design of Tongji University SSE OS course. It completes the supporting experiments of MIT 6.1810 course in autumn 2022, uses the xv6 kernel and simulates it using qemu. The experimental content is as follows:

- Utilities
- System Calls
- Page Tables
- Traps
- Copy on Write
- Multithreading
- Network Driver
- Lock
- File System
- mmap

The experimental report is placed in './report'.

# 实验环境（Experimental Environment）

对于本次实验，笔者采用了如下配置：

- 使用的服务器搭载Intel的4核CPU，采用Haswell微架构，使用x86-64指令集架构
- 使用Ubuntu20.04发行版作为操作系统
- 通过LAN与开发机器连接
- 使用XShell、XFTP等工具进行交互
- 使用VS Code远程连接到服务器端（Remote-SSH）进行开发
- 使用Git进行版本控制
- 使用GitHub托管远程仓库

For this experiment, the author used the following configuration:

- The server used is equipped with Intel's 4-core CPU, using the Haswell microarchitecture, and using the x86-64 instruction set architecture
- Use the Ubuntu 20.04 distribution as the operating system
- Connect to the development machine via LAN
- Use tools such as XShell and XFTP for interaction
- Use VS Code to remotely connect to the server side (Remote-SSH) for development
- Use Git for version control
- Use GitHub to host remote repositories

# 源码（Source Code）

访问[Aloz14/xv6-labs-TJ-SSE-OS: several xv6 labs of Tongji University SSE OS course design (github.com)](https://github.com/Aloz14/xv6-labs-TJ-SSE-OS)以获取。

Visit [Aloz14/xv6-labs-TJ-SSE-OS: several xv6 labs of Tongji University SSE OS course design (github.com)](https://github.com/Aloz14/xv6-labs-TJ-SSE-OS).

