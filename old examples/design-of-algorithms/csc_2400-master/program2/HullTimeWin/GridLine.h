/*
 GridLine.cpp
 "HullTest"
 for CSC 2400-001 Assignmebt #2, part 1
 by Philip Westrich
 Wednesday, March 26, 2014
 
 This is the object for a line of the hull in the Grid class. It makes use of the 
 GridPoint struct.
 */

#ifndef GRID_LINE_H
#define GRID_LINE_H

#include <iostream>     //cerr, ostream

#include "GridPoint.h"  //uses these points

using namespace std;

class GridLine {
   
private:
   
   //Start and endt of the line
   GridPoint *start;
   GridPoint *end;
   
   //the coefficents of the line in standard form
   double a;
   double b;
   double c;
   
public:
   
   //public constructor, accepts two points
   GridLine(GridPoint *newStart, GridPoint *newEnd);
   
   //compare a point to the line
   double comparePoint(GridPoint *newPoint);
   
   //get the starting and ending points of the line
   GridPoint *getStart();
   GridPoint *getEnd();
   
   //overloaded line printing operator
   friend ostream &operator<<(ostream &outStream, const GridLine &line);
   
};
/*
   The only constructor. Creates a new line from start to end, and calculates the
   values for the line;s equation in standard form.
   You cannot make a line with null or two identical points. The program will
   terminate if you do so.
 
   Parameters:
      *newStart:  Pointer to the starting point of this line
      *newEnd:    Pointer to the ending point of this line
*/
GridLine::GridLine(GridPoint *newStart, GridPoint *newEnd){
   
   //check against null
   if (newStart == NULL || newEnd == NULL){
      
      cerr << "Error! Null point in line constructor!" << endl;
      exit(EXIT_FAILURE);
      
   }
   
   //check for same point
   else if (newStart == newEnd){
      
      cerr << "Error! Cannot have a line between the same point!" << endl;
      exit(EXIT_FAILURE);
      
   }
   
   //check for identical point values
   else if ( *(newStart) == *(newEnd)){
      
      cerr << "Error! Cannot make a line between same point!" << endl;
      exit(EXIT_FAILURE);
      
   }
   
   //set the points
   start = newStart;
   end = newEnd;
   
   //calculate a, b, c
   a = end->y - start->y;
   b = start->x - end->x;
   c = (start->x * end->y) - (start->y * end->x);
   
}

/*
   Compares a point to the line
 
   It uses the coefficents of the line with the x- and y-values of the incoming
   point to return an integer, telling what side of the line the point is, and
   how far away it is.
 
   Parameters:
      *newPoint:  Point ot compare
 
   Returns:
      double:  Distance and direction from the line
*/
double GridLine::comparePoint(GridPoint *newPoint){
   
   if (newPoint == NULL){
      
      cerr << "Error: Cannot compare null point!" << endl;
      exit(EXIT_FAILURE);
      
   }
   
   return ((a * newPoint->x) + (b * newPoint->y) - c);
   
}

//gets the starting point of the line
GridPoint *GridLine::getStart(){
   
   return start;
   
}

//gets the ending point of the line
GridPoint *GridLine::getEnd(){
   
   return end;
   
}

//prints the line to an ostream object
ostream &operator<<(ostream &outStream, const GridLine &line){
   
   outStream << "from " << *(line.start) << " to " << *(line.end) << ".";
   
   return outStream;
   
}

#endif
