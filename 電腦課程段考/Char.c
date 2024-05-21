#include <stdlib.h>
#include <stdio.h>
int add_up(int,int);
float compute_average(int,int);


//印出使用者鍵盤輸入次數
void print_search(){
int ch;
int number = 0;
printf("Enter the string to count:\n");
printf("Press Enter or Return to stop\n");
while((ch = getchar()) != '\n'&& ch != '\r'){
    number = number + 1;
}
printf("There are %d words in total",number);


}

void student_average(){
    int i;
    int a[10];
    float sum = 0;   
    float average = 0;
    for(i = 1; i<= 10; i++){
        printf("Enter the student %d score:\n",i);
        scanf("%d",&a[i-1]);
        sum = sum + a[i-1];
        printf("%f \n",sum);
    }
    
    average = sum/10;
    printf("%.2f",average);
    return 0;
}

int add_up(int x,int y){
    int sum;
    sum = x + y;
    return sum;
}

float compute_average(int x,int y){
    float average;
    int sum;
    sum = x+y;
    average = (float)(x+y)/2;
    return average;
}


int main(){
    int x;
    int sum,y;
    float average;
    student_average();
    print_search();

    x = 0;
    printf("Input 2 integers\n");
    scanf("%d %d", &x, &y);
    printf("x= %d, y = %d\n",x,y);
    sum = add_up(x,y);
    average = compute_average(x,y);
    printf("sum = %d, average = %.2f\n",sum,average);
    return 0;


}


// 