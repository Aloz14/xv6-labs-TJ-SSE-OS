#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{

    if (argc > 1) {
        fprintf(2, "No 1 argument is needed!\n");
        exit(1);
    }

    int p_to_c[2], c_to_p[2];
    char buf[10];

    if (pipe(p_to_c) < 0) {
        printf("pipe create failed\n");
        exit(1);
    }

    if (pipe(c_to_p) < 0) {
        printf("pipe create failed\n");
        exit(1);
    }

    int pid;
    pid = fork();

    if (pid < 0) {
        printf("fork failed\n");
        exit(1);
    }

    if (pid == 0) {
        // 子进程
        close(c_to_p[0]);
        close(p_to_c[1]);
        // 从管道读取字节
        if (read(p_to_c[0], buf, 4) == -1) {
            printf("child process read failed\n");
            exit(1);
        }
        close(p_to_c[0]);

        printf("%d: received %s\n", getpid(), buf);

        strcpy(buf, "pong");
        // 向管道发送字节
        if (write(c_to_p[1], buf, 4) == -1) {
            printf("child process write failed\n");
            exit(1);
        }
        close(c_to_p[1]);
        exit(0);
    }
    else {
        strcpy(buf, "ping");
        // 父进程
        close(c_to_p[1]);
        close(p_to_c[0]);
        // 向管道发送字节
        if (write(p_to_c[1], buf, 4) == -1) {
            printf("parent process write failed\n");
            exit(1);
        }

        // 等待子进程结束
        wait(0);

        close(p_to_c[1]);
        // 从管道读取字节
        if (read(c_to_p[0], buf, 4) == -1) {
            printf("parent process read failed\n");
            exit(1);
        }

        close(c_to_p[0]);
        printf("%d: received %s\n", getpid(), buf);

        exit(0);
    }
}
