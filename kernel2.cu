#include <stdio.h>
#include <iostream>
#include <stdlib.h>
#include <cuda.h>
#include <math.h>
#include "Chi8.h"

__global__ void kernel( unsigned int rows, unsigned int cols , int cRows , int contRows ,int jobs,int ref, unsigned char *snpdata,float *results,int *dev_colid){
        unsigned char x, y;
        int m, n ;
	unsigned int p = 0 ;
        float Xmean = 0, Ymean = 0;
        float numerator=0;
	float Xvar = 0, Yvar = 0;

        int tid  = threadIdx.x + blockIdx.x * blockDim.x;
	
	if ((tid < jobs) && (tid > LD_width )) {

                for ( m = 0 ; m < cRows ; m++ ) {
                	x = snpdata[m * cols + ref];
                        y = snpdata[m * cols + (ref + tid)];

                        if ( x == '0' && y == '0') { }
                        else if (x == '0' && y == '1') { Xmean++; }
                        else if (x == '0' && y == '2') { Xmean+=2; }
                        else if (x == '1' && y == '0') { Xmean+=3; }
                        else if (x == '1' && y == '1') { Xmean+=4; }
                        else if (x == '1' && y == '2' ) { Xmean+=5; }
                        else if (x == '2' && y == '0' ) { Xmean+=6; }
                        else if (x == '2' && y == '1') { Xmean+=7; }
                        else if (x == '2' && y == '2') { Xmean+=8; }

			Ymean += 0;
                 }
               
		 for ( n = cRows ; n < cRows + contRows ; n++ ) {
                 	x = snpdata[n * cols + ref];
                        y = snpdata[n * cols + (ref + tid)];

                        if ( x == '0' && y == '0' ) { }
                        else if (x == '0' && y == '1') { Xmean++; }
                        else if (x == '0' && y == '2') { Xmean+=2; }
                        else if (x == '1' && y == '0') { Xmean+=3; }
                        else if (x == '1' && y == '1') { Xmean+=4; }
                        else if (x == '1' && y == '2' ) { Xmean+=5; }
                        else if (x == '2' && y == '0' ) { Xmean+=6; }
                        else if (x == '2' && y == '1') { Xmean+=7; }
                        else if (x == '2' && y == '2') { Xmean+=8; }

                        Ymean += 1;
                  }
		
		Xmean /= (cRows+contRows); Ymean /= (cRows+contRows);				
		
                for ( m = 0 ; m < cRows ; m++ ) {

                	x = snpdata[m * cols + ref];
                        y = snpdata[m * cols + (ref + tid)];

                        if ( x == '0' && y == '0') { numerator += (0 - Xmean)*(0 - Ymean); Xvar += (0 - Xmean)*(0 - Xmean); }
                        else if (x == '0' && y == '1') { numerator += (1 - Xmean)*(0 - Ymean); Xvar += (1 - Xmean)*(1 - Xmean); }
                        else if (x == '0' && y == '2') { numerator += (2 - Xmean)*(0 - Ymean); Xvar += (2 - Xmean)*(2 - Xmean); }
                        else if (x == '1' && y == '0') { numerator += (3 - Xmean)*(0 - Ymean); Xvar += (3 - Xmean)*(3 - Xmean); }
                        else if (x == '1' && y == '1') { numerator += (4 - Xmean)*(0 - Ymean); Xvar += (4 - Xmean)*(4 - Xmean); }
                        else if (x == '1' && y == '2' ) { numerator += (5 - Xmean)*(0 - Ymean); Xvar += (5 - Xmean)*(5 - Xmean); }
                        else if (x == '2' && y == '0' ) { numerator += (6 - Xmean)*(0 - Ymean); Xvar += (6 - Xmean)*(6 - Xmean); }
                        else if (x == '2' && y == '1') { numerator += (7 - Xmean)*(0 - Ymean); Xvar += (7 - Xmean)*(7 - Xmean); }
                        else if (x == '2' && y == '2') { numerator += (8 - Xmean)*(0 - Ymean); Xvar += (8 - Xmean)*(8 - Xmean); }
	
			Yvar += (0 - Ymean)*(0 - Ymean);
                 }
               
		 for ( n = cRows ; n < cRows + contRows ; n++ ) {
                 	x = snpdata[n * cols + ref];
                        y = snpdata[n * cols + (ref + tid)];

                        if ( x == '0' && y == '0') { numerator += (0 - Xmean)*(1 - Ymean); Xvar += (0 - Xmean)*(0 - Xmean); }
                        else if (x == '0' && y == '1') { numerator += (1 - Xmean)*(1 - Ymean); Xvar += (1 - Xmean)*(1 - Xmean); }
                        else if (x == '0' && y == '2') { numerator += (2 - Xmean)*(1 - Ymean); Xvar += (2 - Xmean)*(2 - Xmean); }
                        else if (x == '1' && y == '0') { numerator += (3 - Xmean)*(1 - Ymean); Xvar += (3 - Xmean)*(3 - Xmean); }
                        else if (x == '1' && y == '1') { numerator += (4 - Xmean)*(1 - Ymean); Xvar += (4 - Xmean)*(4 - Xmean); }
                        else if (x == '1' && y == '2' ) { numerator += (5 - Xmean)*(1 - Ymean); Xvar += (5 - Xmean)*(5 - Xmean); }
                        else if (x == '2' && y == '0' ) { numerator += (6 - Xmean)*(1 - Ymean); Xvar += (6 - Xmean)*(6 - Xmean); }
                        else if (x == '2' && y == '1') { numerator += (7 - Xmean)*(1 - Ymean); Xvar += (7 - Xmean)*(7 - Xmean); }
                        else if (x == '2' && y == '2') { numerator += (8 - Xmean)*(1 - Ymean); Xvar += (8 - Xmean)*(8 - Xmean); }

			Yvar += (1 - Ymean)*(1 - Ymean);
                  }
		Xvar = sqrt(Xvar); Yvar = sqrt(Yvar);
		dev_colid[tid] = tid;
 		results[tid] = abs(numerator/(Xvar*Yvar));
				
	}
}

