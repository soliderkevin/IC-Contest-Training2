/******************************************************************************

                            Online C Compiler.
                Code, Compile, Run and Debug C program online.
Write your code in this editor and press "Run" button to compile and execute it.

*******************************************************************************/
//問題1
#include <stdlib.h>
#include <stdio.h>
int main(){
    printf("Hello there!\"Got you\"\n");
    printf("\"What's up? \"\n");
    printf("\"Do you know how to print out symbols \" and \\ ? \" \n");
    printf("\"Do you know the meaning of symbols \\n. \\a. \\t and \\\\ ? \" \n");
}

//問題2
#include <stdlib.h>
#include <stdio.h>
int main(){
    int i;
    int j;
    for (i = 1;i<=9;i++){
        for(j=9;j>=1;j--){
            printf("%d*%d = %d\n",i,j,i*j);
        }
    }
}

//問題3
#include <stdlib.h>
#include <stdio.h>
int main(){
int a[10];
int i;
int sum;
float average;
printf("Enter 10 integers:\n");
for(i=1;i<=9;i++){
    printf("Enter %dth of integer:\n",i);
    scanf("%d\n",&a[i-1]);
    sum = sum + a[i-1];
}
average = (float)(sum)/10;
printf("%f\n",average);
}

//問題4
//問題2
#include <stdlib.h>
#include <stdio.h>
int sum(int, int);
float average(int, int);


int sum(int x, int y){
    return x + y;
}
float average(int x, int y){
    return (float)(x+y)/2;
}

int main(){
    int x = 0;
    int y = 0;
    int sum_x_y = 0;
    float average_x_y = 0;
    printf("Enter two integers: \n");
    printf("Enter First integer: \n");
    scanf("%d \n", &x);
    printf("Enter Second integer: \n");
    scanf("%d \n",&y);
    
    sum_x_y = sum(x,y);
    average_x_y = average(x,y);
    printf("sum = %d \n", sum_x_y);
    printf("average = %f \n", average_x_y);

}



//問題5
#include <stdio.h>
#include <stdlib.h>

int g(int,int);
int f(int,int);

int g(int x, int y){
    return x+y;
}
int f(int x,int y){
    return x + g(x,y);
}
int main()
{   int x, y;
    int sum = 0;
    printf("Please Enter Two integers:\n");
    printf("Please Enter First integer:\n");
    scanf("%d\n",&x);
    printf("Please Enter Second integers:\n");
    scanf("%d\n",&y);
    
    sum = f(x,y);
    printf("f(%d) = %d",x,sum);
    return 0;
}


