
#ifndef StringGraph_h
#define StringGraph_h

#include <string>
#include <vector>
#include <list>
#include <queue>

using namespace std;

class StringGraph {
   
private:
   
   //internal edge item
   struct Edge {
      
      double weight;
      int startIndex;
      int endIndex;
      
   };
   
   //internal vertex item
   struct Vertex {
      
      string key;
      bool isMarked;
      int numEdges;
      int index;
      vector<Edge*> edgeList;
      
      //parent vertex for kruskal's
      int parent;
      
   };
   
   //used for priority queue comparison
   struct compareEdgesByWeight {
      
      bool operator()(const Edge &left, const Edge &right) const {
         
         return (left.weight > right.weight);
         
      }
      
   };
   
   //Maximum size of the graph
   int maxSize;
   
   //The graph's current size
   int size;
   
   //The adjacency list. Doubles as list of verticies
   vector<Vertex*> vertexList;
   
   //finds the index of a vertex by name
   int findVertexIndex(const string &name);
   
   //Clears all markd from the verticies after a traversal
   void clearAllMarks();
   
   //turn an edge into a string
   string printEdge(Edge edge);
   
   //find the parent node in kruskal's tree
   int findParent(const int &leafIndex);
   
   //count the size of the tree
   int findSize(const int &parentIndex);
   
   //reset the parent of every vertex after kruskal's
   void resetParents();
   
public:
   
   StringGraph(const int &newMaxSize);
   ~StringGraph();
   
   bool isEmpty();
   bool isFull();
   
   void printVerticies(ostream &out);
   
   void addVertex(const string &newItem);
   void addEdge(const string &startVertexKey, const string &endVertexKey, const double &edgeWeight);
   
   list<string> prim();
   list<string> kruskal();
   
};

/*
 The only constructor. It sets up the object.
 
 Parameters:
 newMaxSize:    Maximum size of the graph. Must be greater than zero.
 */

StringGraph::StringGraph(const int &newMaxSize){
   
   //check input
   if (newMaxSize < 1){
      
      cerr << "Invalid graph size: " << newMaxSize << "." << endl;
      exit(EXIT_FAILURE);
      
   }
   
   //Initialize instance variables
   maxSize = newMaxSize;
   size = 0;
   
}

/*
 The destructor. Frees all memory allocated by the graph.
 */
StringGraph::~StringGraph(){
   
   //For every item in the list
   for (int i = 0; i < size; i++){
      
      //for each edge in said item, delete it
      for (int j = 0; j < vertexList[i]->numEdges; j++){
         
         delete vertexList[i]->edgeList[j];
         
      }
      
      //delete the vertex
      delete vertexList[i];
      
   }
   
}

//Returns whether or not the graph is empty.
bool StringGraph::isEmpty(){
   
   return (size == 0);
   
}

//Returns whether or not the graph is full.
bool StringGraph::isFull(){
   
   return (size == maxSize);
   
}

//writes all verticies to the given ostream object
void StringGraph::printVerticies(ostream &out){
   
   //for each vertex
   for (int i = 0; i < size; i++){
      
      //print its name
      out << vertexList[i]->key << endl;
      out << "Edges:" << endl;
      
      //for each edge in said vertex
      for (int j = 0; j < vertexList[i]->numEdges; j++){
         
         //print the edge
         out << printEdge(*(vertexList[i]->edgeList[j])) << endl;
         
      }
      
   }
   
}

/*
 Adds a vertex to the graph in the next avalible spot.
 Verticies with the same key are not allowed. They will not be added. The graph
 will ignore them.
 If the graph is full, it will simply ignore all new verticies.
 
 Parameters:
 newItem:    The string to be added.
 
 Returns:
 void
 */
void StringGraph::addVertex(const string &newItem){
   
   //First, make sure the graph isn't full
   if (isFull()){
      
      cerr << "Cannot add vertex to a full graph: " << newItem << endl;
      cerr << "Ignoring." << endl;
      return;
      
   }
   
   //Second, check to make sure this is not a duplicate key
   for (int i = 0; i < size; i++){
      
      if (vertexList[i]->key == newItem){
         
         cerr << "Duplicate vertex found: " << newItem << "." << endl;
         cerr << "Ignoring." << endl;
         
         //delete the duplicate and return
         return;
         
      }
      
   }
   
   //make a vertex to add
   Vertex *item = new Vertex;
   
   //initialize it
   item->key = newItem;
   item->isMarked = false;
   item->numEdges = 0;
   item->index = size;
   item->parent = -1;
   
   //Add the vertex to the list
   vertexList.push_back(item);
   
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
void StringGraph::addEdge(const string &startVertexKey, const string &endVertexKey, const double &edgeWeight){
   
   //First, check to see if the two keys are the same
   if (startVertexKey == endVertexKey){
      
      cerr << "Edges to the same node are not allowed: " << startVertexKey << "." << endl;
      cerr << "Ignoring." << endl;
      
      return;
      
   }
   
   //Second, check the weight
   else if (edgeWeight <= 0.0){
      
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
   
   //Make an edge object, initialize it
   Edge *newEdge = new Edge;
   newEdge->weight = edgeWeight;
   newEdge->startIndex = startLoc;
   newEdge->endIndex = endLoc;
   
   //Add the edge to the list
   vertexList[startLoc]->edgeList.push_back(newEdge);
   vertexList[startLoc]->numEdges++;
   
}

list<string> StringGraph::prim(){
   
   //proirity queue for edges
   priority_queue<Edge, vector<Edge>, compareEdgesByWeight> edgePQ;
   
   //list of edges found
   list<string> edgeList;
   
   Vertex *currentItem = vertexList[0];
   
   do {
      
      //check every edge this vertex has
      for (int i = 0; i < currentItem->numEdges; i++){
         
         //if the vertex this edge points to isn't marked, add this edge to the PQ
         if (!vertexList[currentItem->edgeList[i]->startIndex]->isMarked){
            
            edgePQ.push(*(currentItem->edgeList[i]));
            
         }
         
      }
      
      //mark this item now
      currentItem->isMarked = true;
      
      //get the top item on the PQ
      Edge currentEdge = edgePQ.top();
      edgePQ.pop();
      
      //if we haven't visited this item yet, do so, and add this edge
      if (!vertexList[currentEdge.endIndex]->isMarked){
         
         currentItem = vertexList[currentEdge.endIndex];
         edgeList.push_back(printEdge(currentEdge));
         
      }
      
   } while (!edgePQ.empty());
   
   //unmark all verticies
   clearAllMarks();
   
   return edgeList;
   
}

list<string> StringGraph::kruskal(){
   
   //minimum spanning tree list
   list<string> edgeList;
   
   //PQ of edges
   priority_queue<Edge, vector<Edge>, compareEdgesByWeight> edgePQ;
   
   //for each vertex
   for (int i = 0; i < size; i++){
      
      Vertex *currentVertex = vertexList[i];
      
      //for each edge in current vertex
      for (int j = 0; j < currentVertex->numEdges; j++){
         
         //push it onto the PQ
         edgePQ.push(*(currentVertex->edgeList[j]));
         
      }
      
   }
   
   //continue working until we're out of edges
   while(!edgePQ.empty()){
      
      //get the topmost edge, the one with the least weight
      Edge currentEdge = edgePQ.top();
      edgePQ.pop();
      
      //calculate the parents of this edge's start and end indicies
      int firstParent = findParent(currentEdge.startIndex);
      int endParent = findParent(currentEdge.endIndex);
      
      //start comparing
      if (firstParent != endParent){
         
         edgeList.push_back(printEdge(currentEdge));
         
         int firstParentSize = findSize(firstParent);
         int endParentSize = findSize(endParent);
         
         if (firstParentSize > endParentSize){
            
            vertexList[currentEdge.endIndex]->parent = firstParent;
            
         }
         
         else {
            
            vertexList[currentEdge.startIndex]->parent = endParent;
            
         }
         
      }
      
   }
   
   //reset the parents
   resetParents();
   
   return edgeList;
   
}

//find the parent node in kruskal's tree
int StringGraph::findParent(const int &leafIndex){
   
   int current = leafIndex;
   int previous = -1;
   
   do {
      
      previous = current;
      current = vertexList[current]->parent;
      
   } while (current != -1);
   
   return previous;
   
}

//count the size of the tree
int StringGraph::findSize(const int &parentIndex){
   
   int count = 0;
   
   for (int item = 0; item < size; item++){
      
      if (vertexList[item]->parent == parentIndex) count++;
      
   }
   
   return count;
   
}

//reset each vertex's parent to -1
void StringGraph::resetParents(){
   
   for (int i = 0; i < size; i++){
      
      vertexList[i]->parent = -1;
      
   }
   
}

//Clears all marks on the verticies.
void StringGraph::clearAllMarks(){
   
   for (int i = 0; i < size; i++){
      
      vertexList[i]->isMarked = false;
      
   }
   
}

//Returns the string reprisentation of an edge, in Boshart form
string StringGraph::printEdge(Edge edge){
   
   //c++11 way
   //for some reason, g++ in windows does not like this
   //return ("(" + vertexList[edge.startIndex]->key + ", " + vertexList[edge.endIndex]->key + ", " + to_string(edge.weight) + ")");
   
   //old way
   char temp[16];
   snprintf(temp, sizeof(temp), "%g", edge.weight);
   return ("(" + vertexList[edge.startIndex]->key + ", " + vertexList[edge.endIndex]->key + ", " + temp + ")");
   
}

/*
 Finds the index of a vertex given its key
 
 Parameters:
 name:    Key of the vertex to find
 
 Returns:
 -1:   If the key wasn't found
 Index of the item in the list/array otherwise
 */
int StringGraph::findVertexIndex(const string &name){
   
   //Loop through the array, find the vertex
   for (int i = 0; i < size; i++){
      
      //Return the index if the keys match
      if (vertexList[i]->key == name) return i;
      
   }
   
   //return -1 to signal not found
   return -1;
   
}

#endif
