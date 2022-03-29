/*
 Grid.h
 "HullTest"
 for CSC 2400-001 Assignmebt #2, part 1
 by Philip Westrich
 Wednesday, March 26, 2014
 
 This is the Grid class. It stores a set of GridPoints, with operations
 that can be performed on them.
 
 It uses two other objects: a struct called GridPoint, and a class called
 GridLine. This is what it uses to store the data for points, and lines that
 connect them.
 */

#ifndef GRID_H
#define GRID_H

#include <iostream>     //for cerr, osteream
#include <vector>       //storing things
#include <algorithm>    //standard library mergesort
#include <cstdlib>      //good measure

#include "GridPoint.h"  //the points we store here
#include "GridLine.h"   //and the lines between them

using namespace std;

class Grid {
   
private:
   
   //Current size of the grid
   int size;
   
   //Maximum size
   int maxSize;
   
   //Array of point pointers
   GridPoint **points;
   
   //static constants
   static const int MIN_GRID_SIZE = 3;
   static const int DEFAULT_GRID_SIZE = 100;
   
   //function to make the point list after getting all lines
   vector<GridPoint*> makePointList(vector<GridLine*> &hullList);
   
   //recursive part of quick hull
   void quickHullRec(const vector<GridPoint*> &hullPoints, vector<GridLine*> &lineList, GridLine *line);
   
public:
   
   //Constructors.
   Grid();
   Grid(const int &newSize);
   
   //Destructor
   ~Grid();
   
   //Is it full or empty?
   bool isFull();
   bool isEmpty();
   
   //What is its size? How much can it hold?
   int getSize();
   int getMaxSize();
   
   //Add a point to the grid
   void addPoint(GridPoint *newPoint);
   
   //Convex Hull mehtods
   vector<GridPoint*> bruteForceHull(const int &numToUse);
   vector<GridPoint*> quickHull(const int &numToUse);
   
};

//The default constructor. Calls the other one with the defult size.
Grid::Grid(){
   
   Grid(DEFAULT_GRID_SIZE);
   
}

/*
 General-Purpose construtor.
 
 It accepts an integer number of points to store. If the number is below the
 default number, it will quit.
 
 If a valid parameter is passed, it will allocate the data for the points.
 
 Parameters:
      newSize:    Size of the graph. This is not changeable.
*/
Grid::Grid(const int &newSize){
   
   //check incoming size
   if (newSize < MIN_GRID_SIZE){
      
      cerr << "Error! Invalid grid size: " << newSize << "." << endl;
      exit(EXIT_FAILURE);
      
   }
   
   //set sizes, allocate array
   points = new GridPoint*[newSize];
   size = 0;
   maxSize = newSize;
   
}

//The destructor. Deletes the array of points, as well as the points
Grid::~Grid(){
   
   //delete every point
   for (int i = 0; i < size; i++){
      
      delete points[i];
      
   }
   
   //delete the point array
   delete [] points;
   
}

//Is the grid full?
bool Grid::isFull(){
   
   return (size == maxSize);
   
}

//Is it empty?
bool Grid::isEmpty(){
   
   return (size != maxSize);
   
}

//What is its current size?
int Grid::getSize(){
   
   return size;
   
}

//What is its maximum size?
int Grid::getMaxSize(){
   
   return maxSize;
   
}
/*
 Adds a point to the grid.
 
 If the grid is full, it will ignore the point.
 
 Parameters:
   *newPoint:  A reference to the point to be added.
*/
void Grid::addPoint(GridPoint *newPoint){
   
   //don't add to a full grid
   if (isFull()){
      
      cerr << "Grid is full! Cannot add element: " << newPoint << "." << endl;
      cerr << "Ignoring." << endl;
      return;
      
   }
   
   //add the point
   points[size] = newPoint;
   size++;
   
}

/*
 Find the convex hull of the points, using the brute force method.
 
 If the grid is too small, it will exit.
 If numToUse is too small or large, it will also exit.
 
 Parameters:
   &numToUse:  Number of points to perform the convex hull on
*/
vector<GridPoint*> Grid::bruteForceHull(const int &numToUse){
   
   //don't do anything on a grid too small
   if (size < MIN_GRID_SIZE){
      
      cerr << "Cannot perform algorithm on grid of size less than 3." << endl;
      exit(EXIT_FAILURE);
      
   }
   
   //or if the number to use is too small or large
   else if (numToUse < MIN_GRID_SIZE || numToUse > size){
      
      cerr << "Cannot perform brute force hull with " << numToUse << " items." << endl;
      exit(EXIT_FAILURE);
      
   }
   
   //vector of lines
   vector<GridLine*> hull;
   
   //loop through each pair of points
   for (int startPoint = 0; startPoint < numToUse; startPoint++){
      
      for (int endPoint = startPoint + 1; endPoint < numToUse; endPoint++){
         
         //Make the line to compare
         GridLine *currentLine = new GridLine(points[startPoint], points[endPoint]);
         
         //flags for determining what side of the line the points are
         bool onLeft = false;
         bool onRight = false;
         
         //compare every point against the line
         for (int comparePoint = 0; comparePoint < numToUse; comparePoint++){
            
            //skip the ends of the line
            if (comparePoint == startPoint || comparePoint == endPoint){
               
               continue;
               
            }
            
            //compare the point to the line
            if (0.0 > currentLine->comparePoint(points[comparePoint])){
               
               //on the left
               onLeft = true;
               
            }
            
            else {
               
               //on right
               onRight = true;
               
            }
            
            if (onLeft && onRight){
               
               //stop comparing if a point is on both sides
               break;
               
            }
            
         }
         
         //if all points are on one side, we have a line of the hull
         if (onLeft != onRight){
            
            hull.push_back(currentLine);
            
         }
         
         else {
            
            //otherwose, delete it
            delete currentLine;
         
         }
            
      }
      
   }
   
   //make the point list, and return it
   vector<GridPoint*> pointList = makePointList(hull);
   
   //delete the duplicate point
   if (pointList[0] == pointList[pointList.size() - 1]){
      
      pointList.pop_back();
      
   }
   
   return pointList;
   
}

/*
   The starting part of QuickHull.
 
   It will sort the points in order by their X-values, draw a line from the lowest
   X to the highest, divide the set of points into the upper and lower hulls, and
   begin the recursion.
 
   Parameters:
      &numToUse:  Number of points to tue in the calculation
 
   Returns:
      Vector of GridPoint*s: the list of points on the hull, in Boshart form
*/

vector<GridPoint*> Grid::quickHull(const int &numToUse){
   
   //don't do anything on a grid too small
   if (size < MIN_GRID_SIZE){
      
      cerr << "Cannot perform algorithm on grid of size less than 3." << endl;
      exit(EXIT_FAILURE);
      
   }
   
   //or if the number to use is too small or large
   else if (numToUse < MIN_GRID_SIZE || numToUse > size){
      
      cerr << "Cannot perform quick hull with " << numToUse << " items." << endl;
      exit(EXIT_FAILURE);
      
   }
   
   //First off, sort the points
   sort(points, points + numToUse, pointSortMethod);
   
   //upper and lower hulls
   vector<GridPoint*> upperHull;
   vector<GridPoint*> lowerHull;
   
   //farthest left and right points
   GridPoint *leftPoint = NULL;
   GridPoint *rightPoint = NULL;
   
   //their magnitude from the line
   double leftMagnitude = 0.0;
   double rightMagnitude = 0.0;
   
   //make the starting line
   GridLine *startLine = new GridLine(points[0], points[numToUse - 1]);
   
   //split the points into the upper and lower hulls, excluding the ends of the start line
   for (int item = 1; item < numToUse - 1; item++){
      
      //compare the point to the line
      double currentMagnitude = startLine->comparePoint(points[item]);
      
      //if on left, put it in upper hull
      if (currentMagnitude < 0.0){
         
         upperHull.push_back(points[item]);
         
         //if it's the farthest left, keep track of it
         if (currentMagnitude < leftMagnitude){
            
            leftMagnitude = currentMagnitude;
            leftPoint = points[item];
            
         }
         
      }
      
      //else, it's in the lower hull
      else {
         
         lowerHull.push_back(points[item]);
         
         //if it's the farthest right, keep track of it
         if (currentMagnitude > rightMagnitude){
            
            rightMagnitude = currentMagnitude;
            rightPoint = points[item];
            
         }
         
      }
      
   }
   
   //place to store the lines of the hull
   vector<GridLine*> hull;

   //do the recursive method on the upper hull
   quickHullRec(upperHull, hull, startLine);
   
   //do it on the lower hull
   quickHullRec(lowerHull, hull, new GridLine(points[numToUse - 1], points[0]));
   
   //make the point list, and return it
   vector<GridPoint*> pointList = makePointList(hull);
   
   //delete the duplicate point
   if (pointList[0] == pointList[pointList.size() - 1]){
      
      pointList.pop_back();
      
   }
   
   return pointList;
   
}

/*
   The recursive part of QuickHull. It takes a set of points, a place to put lines
   on the hull, and a line to compare the set of points against.
 
   It will determine whetner or not the given line is on the hull, and if not, 
   call the next step of recustion using that it's found.
 
   Parameters:
      &hullPoints:   The set of points to use
      &lineList:     Where to put the correct lines on the hull
      *line:         The current line to test
*/

void Grid::quickHullRec(const vector<GridPoint*> &hullPoints, vector<GridLine*> &lineList, GridLine *line){
   
   //set of points on the left of the line
   vector<GridPoint*> leftPoints;
   
   //keep track of the farthest left item
   GridPoint *leftPoint = NULL;
   double leftMagnitude = 0.0;
   
   //loop through every point in the vector passed in, compare it to the line
   for (int item = 0; item < hullPoints.size(); item++){
      
      //if the item happens to be on the line, ignore it
      if ((hullPoints[item] == line->getStart()) || (hullPoints[item] == line->getEnd())){
         
         continue;
         
      }
      
      //compare the point
      double currentMagnitude = line->comparePoint(hullPoints[item]);
      
      //if on the left, add it to the list
      if (currentMagnitude < 0.0){
         
         leftPoints.push_back(hullPoints[item]);
         
         //if it's the farthest left, keep track of it
         if (currentMagnitude < leftMagnitude){
            
            leftPoint = hullPoints[item];
            leftMagnitude = currentMagnitude;
            
         }
         
      }
      
   }
   
   //if there are no items to the left of the line, it's part of the hull, recursion over
   if (leftPoints.empty()){

      lineList.push_back(line);
      
   }
   
   //otherwise, we have more work to do
   else {
      
      //make a line from the start of the old one to the left point, and check it
      quickHullRec(leftPoints, lineList, new GridLine(line->getStart(), leftPoint));
      
      //then make a line from the left point to the end of the old line, and check it
      quickHullRec(leftPoints, lineList, new GridLine(leftPoint, line->getEnd()));
      
      //delete the line not on the hull
      delete line;
            
   }

}

/*
   This function takes in a vector of hull edges, and puts it into Boshart form.
 
   One issue with this function is that if the hull coming in is not complete, it
   will be stuck in an infinite loop.
 
   Parameters:
      &hullList:  A vector of GridLine*'s, the convex hull of the grid
 
   Returns:
      vector<GridPoint*>:  the list of points, in Dr. Boshart's order
*/
vector<GridPoint*> Grid::makePointList(vector<GridLine*> &hullList){
   
   //point list
   vector<GridPoint*> pointList;
   
   //pick a line to start off with
   pointList.push_back(hullList[0]->getStart());
   pointList.push_back(hullList[0]->getEnd());
   
   //remove the line
   hullList.erase(hullList.cbegin());
   
   //keep working until all lines are gone
   while (hullList.size() > 0){
      
      for (int i = 0; i < hullList.size(); i++){
         
         if (hullList[i]->getStart() == pointList.back()){
            
            //add it to the list
            pointList.push_back(hullList[i]->getEnd());
            
            //delete the line
            hullList.erase(hullList.cbegin() + i);
            
            //break from this loop
            break;
            
         }
         
         else if (hullList[i]->getEnd() == pointList.back()){
            
            //add it to the list
            pointList.push_back(hullList[i]->getStart());
            
            //delete the line
            hullList.erase(hullList.cbegin() + i);
            
            //break from this loop
            break;
            
         }
         
      }
      
   }
   
   //return the list
   return pointList;
   
}

#endif
