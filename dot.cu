#include <sys/time.h>
#include <stdio.h>
#include <iostream>
#include <stdlib.h>
#include <string.h>
#include <cuda.h>
//#include <cuda_runtime_api.h>
#include "dot.h"
#include <stdlib.h>

int main(int argc ,char* argv[]) {

	FILE *fp;
	FILE *fp2;
	size_t size;
	
	/* Initialize rows, cols, ncases, ncontrols from the user */
	int mtrows=atoi(argv[1]);
	int mtcols=atoi(argv[2]);
	/*int ncases=atoi(argv[4]);
	int ncontrols=atoi(argv[5]);*/
	int CUDA_DEVICE = atoi(argv[4]);
	int THREADS = atoi(argv[5]);
	printf("Rows of matrix=%d Cols of matrix=%d \n",rows,cols);

	fflush(stdout);

	float* host_results = (float*) malloc(mtrows*sizeof(float));

        struct timeval starttime, endtime;
	float seconds, seconds2;

	unsigned int jobs; 
	unsigned long ulone = 1;
	unsigned long ultwo = 2; 
	unsigned long i;
	int k, tmp, cur, read;

	char *line = NULL; size_t len = 0;
	char *line2 = NULL; size_t len2 = 0;
	char *token, *saveptr;
	char *token2, *saveptr2;

	/*Kernel variable declaration */
	unsigned char *dev_dataT;

	/* Validation to check if the data file is readable */
	fp = fopen(argv[3], "r");
	if (fp == NULL) {
	    	printf("Cannot Open the matrix File");
		return 0;
	}

	fp2 = fopen(argv[4], "r");
	if (fp2 == NULL) {
	    	printf("Cannot Open the vector File");
		return 0;
	}
	
	
	size = (size_t)((size_t)mtrows * (size_t)mtcols);
	size2 = (size_t)((size_t)*1 * (size_t)mtrows);
	printf("Size of the matrix data = %lu\n",size);
	printf("Size of the vector data = %lu\n",size2);
	

	fflush(stdout);

	unsigned char *dataT = (unsigned char*)malloc((size_t)size);
	unsigned char *dataT2 = (unsigned char*)malloc((size_t)size2);
	
	if(dataT == NULL) {
        	printf("ERROR: Memory for matrix data not allocated.\n");
	}
	if(dataT2 == NULL) {
        	printf("ERROR: Memory for vector data not allocated.\n");
	}

        gettimeofday(&starttime, NULL);

	/* Transfer the SNP Data from the file to CPU Memory */
	i=0; 
	while (getline(&line, &len, fp) != -1) {
		token = strtok_r(line, " ", &saveptr);
		while(token != NULL){
	                dataT[i] = *token;
                        i++;
			token = strtok_r(NULL, " ", &saveptr);
                }

	}	
	i=0; 
	while (getline(&line2, &len2, fp2) != -1) {
		token2 = strtok_r(line2, " ", &saveptr2);
		while(token2 != NULL){
	                dataT2[i] = *token2;
                        i++;
			token2 = strtok_r(NULL, " ", &saveptr2);
                }

	}	
	
	
	
	fclose(fp);
	fclose(fp2);
	printf("read data\n");
	fflush(stdout);

        gettimeofday(&endtime, NULL); 
	seconds+=((double)endtime.tv_sec+(double)endtime.tv_usec/1000000)-((double)starttime.tv_sec+(double)starttime.tv_usec/1000000);

	printf("time to read data = %f\n", seconds);



	printf("calling kernel\n");
	fflush(stdout);

        gettimeofday(&starttime, NULL);
	/*Calling the kernel function */
	kernel(mtrows,mtcols,dataT,dataT2,host_results);
        gettimeofday(&endtime, NULL); seconds=((double)endtime.tv_sec+(double)endtime.tv_usec/1000000)-((double)starttime.tv_sec+(double)starttime.tv_usec/1000000);
        printf("time for kernel=%f\n", seconds);
		
	fflush(stdout);

	for(k = 0; k < cols; k++) {
		printf("%f ", host_results[k]);
	}
	printf("\n");

	return 0;

}
