#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define FDS_WRITE 1
#define FDS_READ 0

int main()
{
    char *argv[3];
    argv[0] = "echo";
    argv[1] = "hello";
    argv[2] = 0;
    exec("echo", argv);
    exit(0);
}