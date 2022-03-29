/*
 GridPoint.cpp
 "HullTest"
 for CSC 2400-001 Assignmebt #2, part 1
 by Philip Westrich
 Wednesday, March 26, 2014
 
 This is the struct for a point in the Grid object. It simply stores an X and Y.
 It comes with several overloaded operators
 */

#ifndef GRID_POINT_H
#define GRID_POINT_H

#include <iostream>  //for ostream

using namespace std;

struct GridPoint {
   
   double x;
   double y;
      
};

//overload operator<< for easy printing
ostream& operator<<(ostream &out, const GridPoint &point){
   
   out << "(" << point.x << ", " << point.y << ")";
   
   return out;
   
}

//overload == and != operator for easy comparison
bool operator==(const GridPoint &left, const GridPoint &right){
   
   //simply compare the values in x and y
   return ((left.x == right.x) && (left.y == right.y));
   
}

//simply not the operator==
bool operator!=(const GridPoint &left, const GridPoint &right){
   
   return !operator==(left, right);
   
}

//operators to compare by x values
bool operator<(const GridPoint &left, const GridPoint &right){
   
   return (left.x < right.x);
   
}

bool operator<=(const GridPoint &left, const GridPoint &right){
   
   return (left.x <= right.x);
   
}

bool operator>(const GridPoint &left, const GridPoint &right){
   
   return (left.x > right.x);
   
}

bool operator>=(const GridPoint &left, const GridPoint &right){
   
   return (left.x >= right.x);
   
}

bool pointSortMethod(const GridPoint *left, const GridPoint *right){
   
   return (left->x < right->x);
   
}

#endif
