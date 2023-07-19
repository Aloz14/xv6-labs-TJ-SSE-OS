struct sysinfo {
    uint64 freemem; // amount of free memory (bytes)
    uint64 nproc;   // number of process
};

uint64 countProc();
uint64 countMEM();
