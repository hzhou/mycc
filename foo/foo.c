#include <stdio.h>
#include <unistd.h>
int r=0;
void delay(int iters){for(int i=0;i<iters;i++);}
void baz() { delay(5000000); r++; }
void bar() { delay(1000000); printf("hello world!\n"); r++; baz(); }
int main(int argc,char **argv) { bar(); return r; }
