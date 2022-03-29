#include "HighPerformanceCounter.h"

#include <cstdlib>
#include <windows.h>
#include <iostream>
using namespace std;

HighPerformanceCounter* HighPerformanceCounter::hpc = new HighPerformanceCounter();

HighPerformanceCounter::HighPerformanceCounter()
{
   LARGE_INTEGER ticksPerSecond;
   QueryPerformanceFrequency(&ticksPerSecond);
   int tps = ticksPerSecond.QuadPart;
   double spt = 1.0/tps;    //seconds per tick
   micro_spt = spt/1.0E-6;  //microseconds per tick
}

HighPerformanceCounter::~HighPerformanceCounter()
{}

HighPerformanceCounter* HighPerformanceCounter::getHighPerformanceCounter()
{
   return hpc;
}

int HighPerformanceCounter::getCurrentTimeInTicks()
{
   LARGE_INTEGER tick;   
   LARGE_INTEGER ticksPerSecond;

   QueryPerformanceCounter(&tick);
   return tick.QuadPart;
}

double HighPerformanceCounter::getTimeDifferenceInMicroSeconds(int start_time, int end_time)
{
   int diff = end_time - start_time; //total number of ticks
   double micro = diff * micro_spt;  //corresponding time in microseconds
   return micro;
}
