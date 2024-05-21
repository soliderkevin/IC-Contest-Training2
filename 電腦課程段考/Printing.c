


//1. Print out 3 different random string to messages.
//2. Print out 3 certain random string to messages.(Remember when trying to print out \ or ""in C, you have to add "\" before it.)
//3. Print out Uppercases when input lowercases
//4. Input 2 different student ID scores, summing them up
//5. Input 3 different student ID scores, summing them up and make average.
#include <stdio.h>
#include <stdlib.h>


void q1(){
    printf("\\n is used for jumping the whole line \n");
    printf("*str is used for the string in C, %%s is used to read string data in C \n");
    printf("%%d is used to read int value in C \n");
}


void q2(){
    
    printf("//Hi, there!\\\\ \n");
    printf("In C,\"A\" is different from 'A' \n");
    printf("Comment line use // and rather than \\\\ \n");
    printf("This is my first program HaHaHa/\\/\\/\\ \n");
    return 0;

}

void q3(char *str){
    while(*str){
        if(*str>='a' & *str<='z' ){
            *str = *str - ('a'-'A');
        }
        str++;
    }
}

void q4( int student1, int student2){

    int sum;
    sum = student1+student2;
    printf("sum = %d\n",sum);
    
}


void q5(int student1,int student2,int student3){
    int average;
    average =  (student1+student2+student3)/3;
    printf("average = %d \n",average);
    
}




int main(){
    printf("==q1== \n");
    q1();
    printf("==q2== \n");
    q2();
    printf("==q3== \n");
    char str[100];
    int student1 =4;
    int student2 = 3;
    int student3 = 5;
    printf("Enter a string: ");
    fgets(str, sizeof(str), stdin); // Read input string from user
    q3(str);
    printf("%s \n",str);
    printf("==q4== \n");
    q4(student1,student2);
    printf("==q5== \n");
    q5(student1,student2,student3);
}


//1. print 1~100
//2. print 1+2+3+...+100 =?
//3. print 1,3,5,....,99 and 2,4,6...100
//4. print 99(++) and 99 (--)
//5. print 99(each 3 with spaces.)
void q1(){
    //#include <stdio.h>
    //#include stdlib.h>
    int i;
    printf("1~100 =\t");
    for(i=0;i<=100;i++){
        printf(" %d",i);
    }
    printf("\n");
}

void q2(){
    //#include <stdio.h>
    //#include stdlib.h>
    int sum = 0;

    printf("1+2+3+...100 =\t");
    for(int i=0;i<=100;i++){
        sum = sum+ i;
        i = i+1;
    }
    printf("%d",sum);
    printf("\n");

    
}

void q3(){
    printf("1,3,5,...99 =>");
    for(int i = 0; i<=100;i++){
       if(i%2 != 0){
        printf("%d,",i);
        }
    }
    printf("\n");
    
    printf("99,97,95,....1 =>");
    for(int j = 100; j>=0;j--){
        if(j%2 != 0){
            printf("%d",j);
        }
    }
    printf("\n");
}

void q4(){
    int sum = 0;
    for(int i = 1; i<10;i++){
        for(int j = 1; j<10;j++){
            sum = i*j;
            printf("%d*%d=%d \t",i,j,sum);
        }

    }
    printf("\n");
    sum = 0;
    for(int z = 9; z>0;z--){
        for(int k = 9; k>0;k--){
            sum = z*k;
            printf("%d*%d=%d \t",z,k,sum);
        }

    }
    printf("\n");
}

void q5(){
    int sum = 0;
    
    for(int i = 1; i<10;i++){
        for(int j = 1; j<10;j++){
            sum = i*j;
            printf("%d*%d=%d \t",i,j,sum);
            if(j%3 == 0){
                printf("\n");
            }
        }
    }
    printf("\n");
    
    //Have to beware when decreasing value, the values will be different!
    for(int z = 9; z>0;z--){
        for(int k = 9; k>0;k--){
            sum = z*k;
            printf("%d*%d=%d \t",z,k,sum);
            if( (k-1)%3 == 0 ){
                printf("\n");
            }
        }

    }
}