//1013_P-45Q5
#include<stdio.h>
#include<string.h>
void print_result(int result){
  if(result > 0)
    printf("GT");　//Greater Thanの略
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
  print_result(strcmp(str1,str2));    //GT
  printf("\n");
/*
↑のタイプの書き方は￥ｎを挟まずに複数の表示命令を連続して呼び出すことで結果的に1行に出力しているだけ。
strcmp()は先頭から１文字ずつ、**文字コードの大きさで**比較する。違いが存在しないなら\0を返す。
*/
  printf("(Q27) = ");
  print_result(strncmp(str1,str2,5));    //EQ
  printf("\n");
  printf("(Q28) = %4.4s\n", strchr(str1, 'i'));  //iaAm
  printf("(Q29) = %2.2s\n", strrchr(str1, 'A'));  //Am
  return 0;
}
