/*
   main.cpp
   for CSC 2400-001
   Assignment #1: "Graphs"
   by Philip Westrich
   Monday, February 24, 2014
 
   Description:
      This is the driver for the programming assignment. It reads the data from
      the files, puts it into a Graph, has it perform the two seraches, and
      prints the results.
 */

#include <cstdlib>
#include <iostream>
#include <fstream>
#include <string>
#include "Graph.h"
#include "RomanVertex.h"

using namespace std;

//Function prototypes
Graph<RomanVertex, RomanEdge> *readVerticies(const char *fileName);
void readEdges(const char *fileName, Graph<RomanVertex, RomanEdge> *graph);

/*
   The main mehtod.
 
   It takes two arguments from the command line: a text file with the names of 
   the verticies on each line, and another text file with the edges in the 
   following format, on each line:
 
         <startVertexName> <endVertexName> <double Weight>
 
   If the files are nonexistent, the program will quit. If an invalid edge is
   in the file, the program will ignore them.
 
   Negative edge weights are not allowed. Neither are duplicate edges. They will 
   be ignored.
 
   Notes:
      Getting the program to read files with Windows-style newlines wasn't all 
   that difficult; there was actually a really easy check for that.
 
      However, I noticed that if the vertex file does not end with a newline, the
   getline function triggers the eof flag on the input file early, causing the 
   program not to add the last vertex. The easiest fix for this is to make sure
   the file ends in a newline. I haven't been able to find a solution to this,
   and the Internet is of no help either; they pretty much said that it's an 
   issue with getline, and just terminate the file with a newline.
 
      To compile, enter the following command:
 
         g++ -std=c++11 -o program1 main.cpp
 
   Parameters:
      argc:    Number of arguments passed from the command line.
      argv[]   Array of arguments passed in, only argv[1] and argv[2] will be used.
 
   Returns:
      0:       Program was successful.
      1:       Program encountered a problem, and was terminated early.
*/

int main(int argc, const char *argv[]){
   
   //First off, check for valid command-line input
   if (argc < 2){
      
      cerr << "Too few arguments!" << endl;
      cerr << "Must specify 2 text files to read data from." << endl;
      exit(EXIT_FAILURE);
      
   }
   
   //Say the names of the files we got
   cout << "Reading test files: " << argv[1] << ", " << argv[2] << endl;
   
   //Next, readthe verticies and edges of the graph
   Graph<RomanVertex, RomanEdge> *graph = readVerticies(argv[1]);
   readEdges(argv[2], graph);
   
   //Print all verticies as they are
   cout << "\n\nVerticies read: " << endl;
   graph->printVerticies();
   
   //Do the BFS
   cout << "\n\nPerforming BFS...\n" << endl;
   list<RomanVertex*> bfsList = graph->bfs();
   
   //Print its list
   while (!bfsList.empty()) {
      
      cout << bfsList.front()->key << endl;
      bfsList.pop_front();
      
   }
   
   //Do the DFS
   cout << "\n\nPerforming DFS...\n" << endl;
   list<RomanVertex*> dfsList = graph->dfs();
   
   //Print its list
   while (!dfsList.empty()){
      
      cout << dfsList.front()->key << endl;
      dfsList.pop_front();
      
   }
   
   //Done! Delete the graph, return 0
   delete graph;
   return 0;
   
}

/*
   This function is responsible for reading the verticies from the text file, 
   creating the graph, and returning it.
 
   Parameters:
      fileName:      Pointer to the name of the file.
 
   Returns:
      StringGraph:   Pointer to the graph, filled with verticies.
 
 */

Graph<RomanVertex, RomanEdge> *readVerticies(const char *fileName){
   
   //Make and open file
   ifstream inFile(fileName);
   
   //Check for read error
   if (!inFile){
      
      cerr << "Error! Could not open file: " << fileName << endl;
      exit(EXIT_FAILURE);
      
   }
   
   //Buffer for the current line we're reading
   string currentLine;
   
   //Get the first line
   getline(inFile, currentLine);
   
   //Make a list of all the vertex names, and keep its length
   list<string> vertexList;
   int listLength = 0;
   
   //Read vertex names as long as the file isn't over
   while (!inFile.eof()){
      
      //Check for a \r at the end of the string
      if (currentLine.back() == '\r'){
         
         //Get rid of it
         currentLine.erase(currentLine.length() - 1);
         
      }
      
      listLength++;
      vertexList.push_back(currentLine);
      getline(inFile, currentLine);
      
   }
   
   //close file
   inFile.close();
   
   //Make the graph
   Graph<RomanVertex, RomanEdge> *graph = new Graph<RomanVertex, RomanEdge>(listLength);
   
   //Make a vertex for each item, and add it to the graph
   for (int i = 0; i < listLength; i++){
      
      //Make a new vertex
      RomanVertex *currentVertex = new RomanVertex;
      
      //add info to the fields
      currentVertex->key = vertexList.front();
      currentVertex->numEdges = 0;
      currentVertex->isMarked = false;
      
      //pop the first element
      vertexList.pop_front();
      
      //add the vertex to the graph
      graph->addVertex(currentVertex);
      
   }
   
   //Return the graph
   return graph;
   
}
/*
   This function is responsible for reading the edges from the text file, and 
   adding them to the graph given to it.
 
   Parameters:
      fileName:   Pointer to the name of the file
      graph:      Pointer to the graph to add the edges to
 
   Returns:
      void
*/

void readEdges(const char *fileName, Graph<RomanVertex, RomanEdge> *graph){
   
   //Make and open file
   ifstream inFile(fileName);
   
   //Check for read error
   if (!inFile){
      
      cerr << "Error! Could not open file: " << fileName << "." << endl;
      exit(EXIT_FAILURE);
      
   }
   
   //Current line we're reading. It will be split into three parts.
   string currentStart, currentEnd, currentWeight;
   
   //Get the first line, in its three parts
   getline(inFile, currentStart, ' ');
   getline(inFile, currentEnd, ' ');
   getline(inFile, currentWeight, '\n');
   
   //Read data while the file has more lines
   while (!inFile.eof()){
      
      //Convert the string to a double
      double weight = atof(currentWeight.c_str());
      
      //Check the weight
      if (weight <= 0.0){
         
         cerr << "edge between " << currentStart << " and " << currentEnd
              << " has invalid weight: " << currentWeight << "." << endl;
         cerr << "Weight cannot be zero or less." << endl;
         cerr << "Ignoring edge." << endl;
         
         //get the next line
         getline(inFile, currentStart, ' ');
         getline(inFile, currentEnd, ' ');
         getline(inFile, currentWeight, '\n');
         
         continue; //ignore the edge
         
      }
      
      //Check the verticies
      if (currentStart == currentEnd){
         
         cerr << "Edges between the same vertex are not allowed in this assignment." << endl;
         cerr << "Ignoring edge." << endl;
         
         continue;
         
      }
      
      //Add the edge to the graph
      graph->addEdge(currentStart, currentEnd, weight);
      
      //get the next line
      getline(inFile, currentStart, ' ');
      getline(inFile, currentEnd, ' ');
      getline(inFile, currentWeight, '\n');
      
   }
   
   //Close the file.
   inFile.close();
   
}
