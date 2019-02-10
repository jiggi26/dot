#include <stdio.h>
#include <iostream>
#include <stdlib.h>
#include <cuda.h>
#include <math.h>
#include "dot.h"


__global__ void kernel(unsigned int mtrows, unsigned int mtcols , float *mtdata, float *wdata,float *results){
/* exception if #Mrows!= #vectorpts */
	
	unsigned int x,tid;
	float sum = 0.0f;
	float results[mtrows];
	float temp[mtcols];


	for(tid = 0; tid < mtrows; tid++) {

		for(x=0;x<mtcols;x++){
			/*Do we need to specify the memory location using size_t*/
			temp[x] = wdata[x]* mtdata[tid][x];
			sum += temp[x];
		}

		results[tid]=sum;
	}
}