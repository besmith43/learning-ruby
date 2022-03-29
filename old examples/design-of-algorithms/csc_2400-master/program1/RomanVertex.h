/*
 RomanVertex.h
 for CSC 2400-001
 Assignment #1: "Graphs"
 by Philip Westrich
 Monday, February 24, 2014
 
 Description:
   This is a simple class to hold the information for our verticies.
 
 Fields:
   key:        a string with the vertex's key. It will be used to compre them.
   isMarked:   Has the vertex been visited by the Graph's BFS or DFS?
   numEdges:   Size of edgeList
   index:      Index of the vertex on the graph's list and matrix
   edgeList:   Pointer to a vector of RomanEdges. Used for BFS.
 
*/

#ifndef ROMAN_VERTEX_H
#define ROMAN_VERTEX_H

#include <string>
#include <vector>
#include "RomanEdge.h"

using namespace std;

struct RomanVertex {
   
   string key;
   bool isMarked;
   int numEdges;
   int index;
   vector<RomanEdge *> edgeList;
   
};

#endif
