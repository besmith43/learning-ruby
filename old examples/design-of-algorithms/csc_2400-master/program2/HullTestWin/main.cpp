/*
   main.cpp
   "HullTest"
   for CSC 2400-001 Assignmebt #2, part 1
   by Philip Westrich
   Wednesday, March 26, 2014
 
   This is the main driver for the program. It will read in points on an XY-coordinate
   plane, and find the convex hull about them in two ways: the brute force method, and 
   the quick method.
*/

#include <iostream>     //cout, cin, cerr
#include <fstream>      //reading files
#include <vector>       //for storing things
#include <cstdlib>      //for good measure

#include "Grid.h"       //the object to store the points
#include "GridPoint.h"  //a point itself
#include "GridLine.h"   //lines on the hull

using namespace std;

//function prototype for reading items
Grid *readPoints(const char *fileName);

//have to define stoi for windows, even though it's in the c standard library...
#if defined(_WIN32)

int stoi(const char *input){
   
   return static_cast<int>(atof(input));
   
}

#endif

/*
   The main method. Reads the command line arguments, makes sense of them, reads
   the input file specified, and makes a Grid object perform both brute force and
   quick hulls.
 
   It will accept any text file in the format as the one you gave us.
   It accepts a single argument: the name of the text file to read.
   If the file is bad in one way or another, the program quits.
 
   Parameters:
      argc:    Number of command line arguments
      *argv:   Pointer to the array of command line arguments
 
   Returns:
      0:    Program ran without error
      1:    Error while processing. Check stderr for logging and such
*/
int main(int argc, const char *argv[]){
   
   //check for bad arguments
   if (argc < 1){
      
      cerr << "This proggram takes one argument." << endl;
      cerr << "It should be the name of a text file with a list of points." << endl;
      
      //quit program
      return EXIT_FAILURE;
      
   }
   
   else if (argv[1] == NULL){
      
      cerr << "Null argument!" << endl;
      exit(EXIT_FAILURE);
      
   }
   
   //read the points
   Grid *grid = readPoints(argv[1]);
   
   cout << "Brute force hull..." << endl;
   
   //do brute force hull
   vector<GridPoint*> bruteList = grid->bruteForceHull(grid->getSize());
   
   //print the list
   for (int i = 0; i < bruteList.size(); i++){
      
      cout << *(bruteList[i]) << endl;
      
   }
   
   cout << "Quick hull..." << endl;
   
   //do quick hull
   vector<GridPoint*> quickList = grid->quickHull(grid->getSize());
   
   //print the list
   for (int i = 0; i < quickList.size(); i++){
      
      cout << *(quickList[i]) << endl;
      
   }
   
   //delete the grid
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
   int graphSize = stoi(buffer.c_str());
   
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
   
   //close file
   inFile.close();
   
   //return the loaded grid
   return grid;
}
