#if !defined (HIGHPERFORMANCECOUNTER_H)
#define HIGHPERFORMANCECOUNTER_H

class HighPerformanceCounter
{
   private:
      double micro_spt;  //micro_seconds per tick

      HighPerformanceCounter();  //the constructor is private, use a public method to get a pointer to the counter
      static HighPerformanceCounter* hpc;
      static int getTicksPerSecond();

   public:
      virtual ~HighPerformanceCounter();

      static HighPerformanceCounter* getHighPerformanceCounter();  //get a pointer to the counter
      int getCurrentTimeInTicks();
      double getTimeDifferenceInMicroSeconds(int start_time, int end_time);
};

#endif
