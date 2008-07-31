/*
  Author: Zero Cho < itszero @ gmail dot com >
*/
#include<iostream>
#include<signal.h>
#include<unistd.h>
#include<sys/resource.h>
#include<sys/wait.h>
using namespace std;

static int returnSignal = -1;

void
signal_recorder (int sig)
{
  returnSignal = sig;
}

int
main (int argc, char **args)
{
    if (argc != 2)
    {
        cout << "JudgeHelper(ACIsland version) by Zero 2008" << endl;
        cout << "Usage: JudgeHelper [executable file]" << endl;
        if (argc != 1)
            cout << "Error: Invalid arguments or not enough arguments." << endl;
        return 0;
    }

    // Parse arguments
    rlimit timeLimit;
    timeLimit.rlim_max = timeLimit.rlim_cur = 10;
    
    // Set resource usage limitation
    setrlimit (RLIMIT_CPU, &timeLimit);
    rlimit outLimit;
    outLimit.rlim_max = outLimit.rlim_cur = 1024 * 1024;	// 1000 KB
    setrlimit (RLIMIT_FSIZE, &outLimit);

    // Install signal recorder
    for (int i = 1; i <= 31; i++)
    signal (i, signal_recorder);
    
    execl (args[1], NULL);
}

