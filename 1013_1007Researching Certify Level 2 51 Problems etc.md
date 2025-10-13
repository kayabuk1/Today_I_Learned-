//1013_P-45Q5
#include<stdio.h>
#include<string.h>
void print_result(int result){
  if(result > 0)
    printf("GT");
  else if(result < 0)
    printf("LT");
  else
    printf("EQ");
}
int main(void)
{
  char str1[]="AsiaAmerica";
  char str2[]="AsiaAfrica";
  printf("(Q26) = ");
  print_result(strcmp(str1,str2));
  printf("\n);
  printf("(Q27) = ");
  print_result(strncmp(str1,str2,5));
  printf("\n");
  printf("(Q28) = %4.4s\n", strchr(str1, 'i'));
  printf("(Q29) = %2.2s\n", strchr(str1, 'A'));
  return 0;
}
