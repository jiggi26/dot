#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char* argv[]){
  
  char x[100] = "1 3 4 2 1 1";
  char* saveptr;
  char* tok = strtok_r(x, " ", &saveptr);
  while(tok != NULL){
    printf("%s\n", tok);
    tok = strtok_r(NULL, " ", &saveptr);
  }

}
