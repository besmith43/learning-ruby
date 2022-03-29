/*
 main.cpp
 "HullTest"
 for CSC 2400-001 Assignmebt #2, part 1
 by Philip Westrich
 Wednesday, March 26, 2014
 
 This is the main driver for the timer program. It will loop through each test
 a specified number of times, time each one, and print the elapsed time in 
 microseconde to the screen.
 */

#include <iostream>        //cout, cin, cerr, ostream
#include <fstream>         //fstream
#include <cstdlib>         //good measure

#include "getRealTime.c"   //timer
#include "Grid.h"          //the grid
#include "GridLine.h"      //points on the grid
#include "GridPoint.h"     //lines between them

using namespace std;

//function prototype for reading points
Grid *readPoints(const char *fileName);

/*
 The main method. Reads the command line arguments, makes sense of them, reads
 the input file specified, and makes a Grid object perform both brute force and
 quick hulls, and times each iteration of them.
 
 It will accept any text file in the format as the one you gave us.
 It accepts three arguments: starting number of points, increment, and the file to read
 If the file is bad in one way or another, the program quits.
 
 Parameters:
 argc:    Number of command line arguments
 *argv:   Pointer to the array of command line arguments
 
 Returns:
 0:    Program ran without error
 1:    Error while processing. Check stderr for logging and such
 */
int main(int argc, const char *argv[]){
   
   //check arguments
   if (argc < 3){
      
      cerr << "Not enought arguments!"                << endl;
      cerr << "1. Starting number of points to use."  << endl;
      cerr << "2. Step size."                         << endl;
      cerr << "3. File to read points from."          << endl;
      
      return 1;
      
   }
   
   //parse the numbers from the arguments
   int startNum = stoi(argv[1]);
   int stepSize = stoi(argv[2]);
   
   //check them
   if (startNum < 3){
      
      cerr << "Invalid starting number: " << startNum << "."   << endl;
      cerr << "Must be greater than 3."                        << endl;
      
      return 1;
      
   }
   
   else if (stepSize < 1){
      
      cerr << "Invalid step size: " << stepSize << "."   << endl;
      cerr << "Must be greater than zero."               << endl;
      
      return 1;
      
   }
   
   //read the points into a grid
   Grid *grid = readPoints(argv[3]);
   
   //make sure the starting number is not too large
   if (startNum > grid->getSize()){
      
      cerr << "Starting number must be greater than the grid's size." << endl;
      cerr << "Using starting number of 3 instead..." << endl;
      
      startNum = 3;
      
   }
   
   //start the testing, using brute force first
   cout << "Brute Force Hull" << endl;
   
   for (int i = startNum; i <= grid->getSize(); i = i + stepSize){
      
      cout << "Items used: " << i << ". ";
      
      double startTime = getRealTime();
      
      grid->bruteForceHull(i);
      
      double endTime = getRealTime();
      
      cout << "Elapsed time: " << ((endTime - startTime) * 1000000) << " microseconds." << endl;
      
   }
   
   //then quick hull
   
   cout << "Quick Hull:" << endl;
   
   for (int i = startNum; i <= grid->getSize(); i = i + stepSize){
      
      cout << "Items used: " << i << ". ";
      
      double startTime = getRealTime();
      
      grid->quickHull(i);
      
      double endTime = getRealTime();
      
      cout << "Elapsed time: " << ((endTime - startTime) * 1000000) << " microseconds." << endl;
      
   }
   
   delete grid;
   
   //done
   return 0;
   
}

/*
 Function to read the points from the file given.
 If the file is bad, the program will quit.
 
 Parameters:
 *fileName:  Pointer to the name of the file.
 
 Returns:
 A pointer to a Grid object, loaded with the points read from the file.
 */
Grid *readPoints(const char *fileName){
   
   fstream inFile(fileName);
   
   if (!inFile){
      
      cerr << "Invalid filename: " << fileName << endl;
      cerr << "Make sure the file exists." << endl;
      cerr << "Exiting..." << endl;
      
      exit(EXIT_FAILURE);
      
   }
   
   //make a buffer string
   string buffer;
   
   //get the first line, which is the number of points in the rest of the file
   getline(inFile, buffer, '\n');
   
   //parse the int
   int graphSize = stoi(buffer);
   
   //check it
   if (graphSize < 3){
      
      cerr << "Invalid graph size in first line of " << fileName << ": " << graphSize << endl;
      cerr << "Exiting..." << endl;
      
      exit(EXIT_FAILURE);
      
   }
   
   //make the grid
   Grid *grid = new Grid(graphSize);
   
   //get the data for the points
   
   getline(inFile, buffer, '\n');
   
   while (!inFile.eof()){
      
      //make a new point
      GridPoint *newPoint = new GridPoint;
      
      //convert it to a double, store it
      newPoint->x = atof(buffer.c_str());
      
      //get the next line, do the same
      getline(inFile, buffer, '\n');
      newPoint->y = atof(buffer.c_str());
      
      //add the point to the grid
      grid->addPoint(newPoint);
      
      //get the next line
      getline(inFile, buffer, '\n');
      
   }
   
   inFile.close();
   
   return grid;
}
