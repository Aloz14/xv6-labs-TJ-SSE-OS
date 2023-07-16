#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
    if (argc != 1) {
        printf("No parameters are accepted!\nUsage: pingpong\n");
        exit(-1);
    }
}
