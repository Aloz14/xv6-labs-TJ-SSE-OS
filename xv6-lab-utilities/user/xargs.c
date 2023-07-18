#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/param.h"
#include "user/user.h"

#define STIN 0
#define STOUT 1
#define MAXARGLEN 32

void alloc_args(char *args[], int arg_num, int arg_len)
{
    for (int i = 0; i < arg_num; i++) {
        args[i] = malloc(arg_len * sizeof(char));
    }
}

void free_args(char *args[], int arg_num)
{
    for (int i = 0; i < arg_num; i++) {
        free(args[i]);
    }
}

int main(int argc, char *argv[])
{
    if (argc < 2) {
        fprintf(STOUT, "Usage: xargs <command> <args>\n");
        exit(-1);
    }

    char *args[MAXARG];
    alloc_args(args, MAXARG, MAXARGLEN);
    int retval;
    char tmp;
    int arg_num = 0, arg_len = 0;
    args[arg_num] = argv[1];
    arg_num++;

    for (int i = 2; i < argc; i++) {
        strcpy(args[arg_num], argv[i]);
        arg_num++;
    }
    // 打印参数
    fprintf(STOUT, "xargs in argv: ");
    for (int i = 0; i < arg_num; i++) {
        fprintf(STOUT, "%s ", args[i]);
    }
    fprintf(STOUT, "\n");

    while ((retval = read(STIN, &tmp, sizeof(tmp))) > 0 && arg_num < MAXARG) {
        if (tmp == '\n') {
            // 读取完毕
            args[arg_num][arg_len] = '\0';
            arg_len = 0;
            arg_num++;
            break;
        }
        else if (tmp == ' ') {
            args[arg_num][arg_len] = '\0';
            arg_len = 0;
            arg_num++;
        }
        else {
            args[arg_num][arg_len] = tmp;
            arg_len++;
        }
    }

    args[arg_num] = 0;

    fprintf(STOUT, "xargs in all: ");
    for (int i = 0; i < arg_num; i++) {
        fprintf(STOUT, "%s ", args[i]);
    }
    fprintf(STOUT, "\n");

    if (fork() == 0) {
        int val = exec("/echo", args);
        if (val < 0) {
            fprintf(STOUT, "exec failed\n");
            exit(-1);
        }
        else {
            fprintf(STOUT, "exec success\n");
            fprintf(STOUT, "exec return value: %d\n", val);
        }
        free_args(args, arg_num);
    }
    else {
        wait(0);
        free_args(args, arg_num);
    }

    exit(0);
}