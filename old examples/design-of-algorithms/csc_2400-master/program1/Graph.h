/*
 Graph.h
 for CSC 2400-001
 Assignment #1: "Graphs"
 by Philip Westrich
 Monday, February 24, 2014
 
 Description:
   This is the definition and implementation of the Graph object. It is 
   templated, and takes two parameters: a Vertex and an Edge.
 
 Assumptions:
   Vertex must have the following public data members:
      string         key;
      bool           isMarked;
      int            numEdges;
      int            index;
      vector<Edge *> edgeList;
 
   Edge must have the following public data members:
      double   weight;
      int      startIndex;
      int      endIndex;
 
   Not allowed in this graph:
      Edges to the same vertex
      Verticies with the same key
      Negative edge weights
*/

#ifndef GRAPH_H
#define GRAPH_H

#include <string>
#include <list>
#include <queue>

#ifndef NULL_EDGE
#define NULL_EDGE 0.0
#endif

using namespace std;

template <class Vertex, class Edge>
class Graph {
   
private:
   
   //Maximum size of the graph
   int maxSize;
   
   //The graph's current size
   int size;
   
   //The adjacency matrix
   double *weights;
   
   //The adjacency list. Doubles as list of verticies
   vector<Vertex*> *vertexList;
   
   int findVertexIndex(string name);
   
   //Recursive functions for BFS and DFS
   void DFS(Vertex *currentVertex, list<Vertex*> &dfsList);
   void BFS(Vertex *currentVertex, list<Vertex*> &bfsList);
   
   //Clears all markd from the verticies after a traversal
   void clearAllMarks();
   
public:
   
   Graph(int newMaxSize);
   ~Graph();
   
   bool isEmpty();
   bool isFull();
   
   void addVertex(Vertex *newItem);
   void addEdge(string startVertexKey, string endVertexKey, double edgeWeight);
   void printVerticies();
   
   list<Vertex*> bfs();
   list<Vertex*> dfs();
   
};

/*
   The only constructor. It sets up the object.
 
   Parameters:
      newMaxSize:    Maximum size of the graph. Must be greater than zero.
*/
template <class Vertex, class Edge>
Graph<Vertex, Edge>::Graph(int newMaxSize){
   
   //check input
   if (newMaxSize < 1){
      
      cerr << "Invalid graph size: " << newMaxSize << "." << endl;
      exit(EXIT_FAILURE);
      
   }
   
   //Initialize instance variables
   maxSize = newMaxSize;
   size = 0;
   weights = new double[(maxSize * maxSize)];
   vertexList = new vector<Vertex*>;
   
   //Initialize the matrix
   for (int col = 0; col < size; col++){
      
      for (int row = 0; row < size; row++){
         
         weights[(col * size) + row] = NULL_EDGE;
         
      }
      
   }
   
}

/*
   The destructor. Frees all memory allocated by the graph.
*/
template <class Vertex, class Edge>
Graph<Vertex, Edge>::~Graph(){
   
   //Delete the adjacency matrix
   delete [] weights;
   
   //For every item in the list
   for (int i = 0; i < size; i++){
      
      //delete the vertex
      delete (*vertexList)[i];
      
   }
   
   //Delete the adjacency list
   delete vertexList;
   
}

//Returns whether or not the graph is empty.
template <class Vertex, class Edge>
bool Graph<Vertex, Edge>::isEmpty(){
   
   return (size == 0);
   
}

//Returns whether or not the graph is full.
template <class Vertex, class Edge>
bool Graph<Vertex, Edge>::isFull(){
   
   return (size == maxSize);
   
}

//Prints all verticies in the graph in the order they were added.
template <class Vertex, class Edge>
void Graph<Vertex, Edge>::printVerticies(){
   
   for (int i = 0; i < size; i++){
      
      cout << (*vertexList)[i]->key << endl;
      
   }
   
}

/*
   Adds a vertex to the graph in the next avalible spot.
   Verticies with the same key are not allowed. They will not be added. The graph
   will ignore them.
   If the graph is full, it will simply ignore all new verticies.
 
   Parameters:
      newItem:    A pointer to the new node to be added.
 
   Returns:
      void
 
*/
template <class Vertex, class Edge>
void Graph<Vertex, Edge>::addVertex(Vertex *newItem){
   
   //First, make sure the graph isn't full
   if (isFull()){
      
      cerr << "Cannot add vertex to a full graph: " << newItem->key << endl;
      cerr << "Ignoring." << endl;
      return;
      
   }
   
   //Second, check to make sure this is not a duplicate key
   for (int i = 0; i < size; i++){
      
      if ((*vertexList)[i]->key == newItem->key){
         
         cerr << "Duplicate vertex found: " << newItem->key << "." << endl;
         cerr << "Ignoring." << endl;
         
         //delete the duplicate and return
         delete newItem;
         return;
         
      }
      
   }
   
   //Add the vertex to the list
   vertexList->push_back(newItem);
   newItem->index = size;
   
   //Increment size
   size++;
   
}

/*
   Adds an edge to the graph between the given nodes with the given weight.
 
   Parameters:
      startVertexKey:   Key of the first vertex
      endVertexKey      Key of the second vertex
      weight:           The weight of the new edge
 
   Returns:
      void
 */
template <class Vertex, class Edge>
void Graph<Vertex, Edge>::addEdge(string startVertexKey, string endVertexKey, double edgeWeight){
   
   //First, check to see if the two keys are the same
   if (startVertexKey == endVertexKey){
      
      cerr << "Edges to the same node are not allowed: " << startVertexKey << "." << endl;
      cerr << "Ignoring." << endl;
      
      return;
      
   }
   
   //Second, check the weight
   if (edgeWeight <= 0.0){
      
      cerr << "Invalid edge weight between: " << startVertexKey << ", " << endVertexKey << endl;
      cerr << "Weight must be above zero." << endl;
      cerr << "Ignoring." << endl;
      
      return;
      
   }
   
   //Third, find the index of the verticies
   int startLoc = findVertexIndex(startVertexKey);
   int endLoc = findVertexIndex(endVertexKey);
   
   //Fourth, check for a valid index
   if ((startLoc == -1) || (endLoc == -1)){
      
      cerr << "Invalid edge between: " << startVertexKey << ", " << endVertexKey << endl;
      cerr << "Ignoring." << endl;
      
      return;
      
   }
   
   //Add the edge to the matrix
   weights[(startLoc * size) + endLoc] = edgeWeight;
   
   //Make an edge object, initialize it
   Edge *newEdge = new Edge;
   newEdge->weight = edgeWeight;
   newEdge->startIndex = startLoc;
   newEdge->endIndex = endLoc;
   
   //Add the edge to the list
   (*vertexList)[startLoc]->edgeList.push_back(newEdge);
   (*vertexList)[startLoc]->numEdges++;
   
}

/*
   Performs Breadth-First Search on the graph, using the adjacency list.
 
   Returns:
      A list<Vertex*> containing references to the verticies in the order 
         they were visited in
*/
template <class Vertex, class Edge>
list<Vertex*> Graph<Vertex, Edge>::bfs(){
   
   //List the verticies will be added to
   list<Vertex*> bfsList;
   
   //loop through every vertex in the list
   for (int i = 0; i < size; i++){
      
      //Get a reference to the current item
      Vertex *curretnItem = (*vertexList)[i];
      
      //If the current item isn't marked, there is a tree rooted at this item
      if (!curretnItem->isMarked){
         
         BFS(curretnItem, bfsList);
         
      }
      
   }
   
   //Clear all marks, return the list.
   clearAllMarks();
   return bfsList;
   
}

/*
   The actual work part of BFS.
 
   Parameters:
      currentVertex: A reference to the current item er'tr working on
      bfsList:       The list to add the verticies to
 
   Returns:
      void
*/
template <class Vertex, class Edge>
void Graph<Vertex, Edge>::BFS(Vertex *currentVertex, list<Vertex*> &bfsList){
   
   //Make a queue to help with BFS
   queue<Vertex*> bfsQueue;
   
   //Push the current vertex on the queue
   bfsQueue.push(currentVertex);
   
   //add it to the list
   bfsList.push_back(currentVertex);
   
   //mark it as visited
   currentVertex->isMarked = true;
   
   //Do work while the queue is not empty
   while (!bfsQueue.empty()) {
      
      //The current vertex id the one at the front of the queue
      currentVertex = bfsQueue.front();
      
      //For every vertex adjacent to the current one
      for (int i = 0; i < currentVertex->numEdges; i++){
         
         //Get the index of the adjacent vertex
         int adjVertexIndex = currentVertex->edgeList[i]->endIndex;
         
         //If the adjacent vertex is not marked...
         if (!(*vertexList)[adjVertexIndex]->isMarked){
            
            //mark the vertex
            (*vertexList)[adjVertexIndex]->isMarked = true;
            
            //add it to the list
            bfsList.push_back((*vertexList)[adjVertexIndex]);
            
            //Add the adjacent vertex to the queue
            bfsQueue.push((*vertexList)[adjVertexIndex]);
            
         }
         
      }

      //Remove the vertex from the queue
      bfsQueue.pop();
      
   }
   
}

/*
   Performs Depth-First Search on the adjacency matrix. 
   It begins the recursive call.
   
   Returns:
      A list<Vertex*> containing references to the verticies in the 
         order they were visited in.
*/
template <class Vertex, class Edge>
list<Vertex*> Graph<Vertex, Edge>::dfs(){
   
   //make the list
   list<Vertex*> dfsList;
   
   //Loop through every vertex in the graph
   for (int i = 0; i < size; i++){
      
      //If it isn't marked, there is a tree rooted at this vertex
      if (!(*vertexList)[i]->isMarked){
         
         DFS((*vertexList)[i], dfsList);
         
      }
      
   }
   
   //clear the marks for the next search and return the list
   clearAllMarks();
   return dfsList;
   
}

/*
   The recursive part of DFS.
 
   Parameters:
      currentItem:   The current vertex to be searched
      dfsList:       List to add the vertex references to
 
   Returns:
      void
*/
template <class Vertex, class Edge>
void Graph<Vertex, Edge>::DFS(Vertex *currentItem, list<Vertex*> &dfsList){
   
   //Mark this vertex
   currentItem->isMarked = true;
   
   //Push it onto the list
   dfsList.push_back(currentItem);
   
   //For every vertex in the matrix
   for (int row = 0; row < size; row++){
      
      //If there is an edge between the current vertex and another check it
      if (weights[(currentItem->index * size) + row] != NULL_EDGE){
         
         //If the vertex isn't marked, visit it
         if (!(*vertexList)[row]->isMarked){
            
            DFS((*vertexList)[row], dfsList);
            
         }
         
      }
      
   }
   
}

//Clears all marks on the verticies.
template <class Vertex, class Edge>
void Graph<Vertex, Edge>::clearAllMarks(){
   
   for (int i = 0; i < size; i++){
      
      (*vertexList)[i]->isMarked = false;
      
   }
   
}

/*
   Finds the index of a vertex given its key
 
   Parameters:
      name:    Key of the vertex to find
 
   Returns:
      -1:   If the key wasn't found
      Index of the item in the list/array otherwise
 
*/
template <class Vertex, class Edge>
int Graph<Vertex, Edge>::findVertexIndex(string name){
   
   //Loop through the array, find the vertex
   
   for (int i = 0; i < size; i++){
      
      //Return the index if the keys match
      if ( (*vertexList)[i]->key == name) return i;
      
   }
   
   //return -1 to signal not found
   return -1;
   
}

#endif
