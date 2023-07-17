#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define FDS_WRITE 1
#define FDS_READ 0

void create_pipe_fork()
{
    int p[2];
    if (pipe(p)) {
        printf("pipe failed\n");
        exit(0);
    }
    close(p[FDS_WRITE]);
    close(p[FDS_READ]);
    int pid = fork();

    if (pid == -1) {
        printf("error\n");
        exit(0);
    }

    if (pid == 0) {

        int pid2 = fork();

        if (pid2 == -1) {
            printf("error\n");
            exit(0);
        }

        if (pid2 == 0) {
        }
        else {

            wait(0);
        }
    }
    else {
        close(p[FDS_WRITE]);
        close(p[FDS_READ]);
        wait(0);
    }
}

int main()
{
    int k = 0;
    while (k < 30) {
        k++;
        printf("k=%d", k);
        create_pipe_fork();
    }
    exit(0);
}