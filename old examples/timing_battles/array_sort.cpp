#include <iostream>
#include <cstdlib>
#include <stdio.h>
#include <ctime>
#include <fstream>
using namespace std;

void printArray(int *arr, int size);

void swap(int *xp, int *yp);

void randomArray(int *arr, int size);

int partition(int *arr, int low, int high);

void quickSort(int *arr, int low, int high);

int main()
{
	int n = 1000000;

	int *array = new int [n];

	randomArray(array, n);

	quickSort(array, 0 , n - 1);

	//printArray(array, n);

	delete [] array;

	return 0;

}

void printArray(int *arr, int size)
{
	for(int i = 0; i < size; i++)
	{
		cout << arr[i] << endl;
	}
}

void randomArray(int *arr, int size)
{
	srand((unsigned)time(0));

	int temp = 0;

	for(int i = 0; i < size; i++)
	{
		temp = (rand()%size)+1;

		arr[i] = temp;
	}
}

void swap(int *xp, int *yp)
{
	int temp = *xp;
	*xp = *yp;
	*yp = temp;
}

int partition(int *arr, int low, int high)
{
	int pivot = arr[high];
	int i (low -1);

	for(int j = low; j <= high - 1; j++)
	{
		if(arr[j] <= pivot)
		{
			i++;
			swap(&arr[i], &arr[j]);
		}
	}

	swap(&arr[i+1], &arr[high]);

		return (i+1);
}

void quickSort(int *arr, int low, int high)
{
	if(low < high)
	{
		int pi = partition(arr, low, high);

		quickSort(arr, low, pi - 1);
		quickSort(arr, pi + 1, high);
	}
}


