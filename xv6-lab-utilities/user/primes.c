#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define FDS_WRITE 1
#define FDS_READ 0
#define INT_NUM 35

void recursive_com(int left_pipe[])
{
    int prime;
    int is_read = read(left_pipe[FDS_READ], &prime, sizeof(prime));
    if (is_read == 0) {
        close(left_pipe[FDS_READ]);
        exit(1);
    }
    else if (is_read == -1) {
        printf("read failed\n");
        exit(1);
    }
    else {
        printf("prime %d\n", prime);
    }

    int p2c[2];
    if (pipe(p2c) < 0) {
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
        close(p2c[FDS_WRITE]);
        close(left_pipe[FDS_READ]);
        recursive_com(p2c);
    }
    else {
        // 父进程
        int tmp;
        while (read(left_pipe[FDS_READ], &tmp, sizeof(tmp)) > 0) {
            if (tmp % prime != 0) {
                int flag = write(p2c[FDS_WRITE], &tmp, sizeof(tmp));
                if (flag == -1) {
                    printf("write %d failed\n", tmp);
                    exit(1);
                }
            }
        }
        close(left_pipe[FDS_READ]);
        close(p2c[FDS_WRITE]);
        wait(0);
    }

    exit(0);
}

int main(int argc, char *argv[])
{
    if (argc > 1) {
        fprintf(2, "No argument is needed!\n");
        exit(1);
    }

    int nums[INT_NUM + 2];

    for (int i = 2; i <= INT_NUM; i++) {
        nums[i] = i;
    }

    int p2c[2];
    if (pipe(p2c) < 0) {
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
        close(p2c[FDS_WRITE]);
        recursive_com(p2c);
    }
    else {
        // 父进程
        close(p2c[FDS_READ]);
        for (int i = 2; i <= INT_NUM; i++) {
            if (write(p2c[FDS_WRITE], &nums[i], sizeof(nums[i])) == -1) {
                printf("write %d failed\n", nums[i]);
                exit(1);
            }
        }
        close(p2c[FDS_WRITE]);

        wait(0);
    }
    exit(0);
}
