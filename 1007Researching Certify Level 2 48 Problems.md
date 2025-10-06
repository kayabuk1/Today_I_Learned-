* 問1
⑴abs()関数はabsolute valueの略で整数値を受け取り、絶対値(0からの距離)を返す関数。
標準ライブラリ関数なので<stdlib.h>で定義されている。
#include<stdio.h>
#include<stdlib.h>
int main(void){
  int num = -123;
  printf("%dの絶対値は%-5dです。\n",abs(num));の様に書く。
}
C言語にはほかに「labs()---long int」「llabs()---long long int」「fabs()---doubleなどこれだけ<math.h>」




