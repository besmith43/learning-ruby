
#include <cstdlib>
#include <iostream>
#include <fstream>
#include <string>
#include <vector>

#include "StringGraph.h"

using namespace std;

//function prototypes
StringGraph *readVerticies(const char *fileName);
void readEdges(const char *fileName, StringGraph *graph);

//use c++11 to compile

int main(int argc, const char *argv[]){

   //First off, check for valid command-line input
   if (argc < 3){
      
      cerr << "Too few arguments!" << endl;
      cerr << "Must specify 2 text files to read data from, and one to write." << endl;
      exit(EXIT_FAILURE);
      
   }
   
   //Say the names of the files we got
   cout << "Reading test files: " << argv[1] << ", " << argv[2] << endl;
   cout << "Writing to: " << argv[3] << endl;
   
   //Next, readthe verticies and edges of the graph
   StringGraph *graph = readVerticies(argv[1]);
   readEdges(argv[2], graph);
   
   cout << "Verticies and edges read:" << endl;
   graph->printVerticies(cout);
   cout << "-------------------------" << endl;
   
   //open the file
   fstream outFile(argv[3]);
   
   //do prim
   cout << "Prim's algorithm..." << endl;
   outFile << "Prim's algorithm..." << endl;
   list<string> primList = graph->prim();
   
   while (!primList.empty()) {
      
      cout << primList.front() << endl;
      outFile << primList.front() << endl;
      primList.pop_front();
      
   }
   
   outFile << endl;
   
   //do kruskal
   cout << "Kruskal's algorithm..." << endl;
   outFile << "Kruskal's algorithm..." << endl;
   
   list<string> kruskalList = graph->kruskal();
   
   while (!kruskalList.empty()){
      
      cout << kruskalList.front() << endl;
      outFile << kruskalList.front() << endl;
      kruskalList.pop_front();
      
   }
   
   //close the file, delete graph, and done
   outFile << endl;
   outFile.close();
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
StringGraph *readVerticies(const char *fileName){
   
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
   vector<string> vertexList;
   
   //Read vertex names as long as the file isn't over
   while (!inFile.eof()){
      
      //Check for a \r at the end of the string
      if (currentLine.back() == '\r'){
         
         //Get rid of it
         currentLine.erase(currentLine.length() - 1);
         
      }
      
      vertexList.push_back(currentLine);
      getline(inFile, currentLine);
      
   }
   
   //close file
   inFile.close();
   
   //make the graph, and add the verticies to it.
   StringGraph *graph = new StringGraph(static_cast<int>(vertexList.size()));
   
   for (int i = 0; i < vertexList.size(); i++){
      
      graph->addVertex(vertexList[i]);
      
   }
   
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
void readEdges(const char *fileName, StringGraph *graph){
   
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
