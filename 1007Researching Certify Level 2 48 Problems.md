* 問1
⑴abs()関数はabsolute valueの略で整数値を受け取り、絶対値(0からの距離)を返す関数。
標準ライブラリ関数なので<stdlib.h>で定義されている。
#include<stdio.h>
#include<stdlib.h>
int main(void){
  int num = -123;
  printf("%dの絶対値は%-5dです。\n",abs(num));の様に書く。
}
C言語にはほかに「labs()---long int」「llabs()---long long int」「fabs()---doubleを変換。これだけ<math.h>」
⑵　　
記憶域クラス指定子autoを指定して、外部変数を宣言することが出来るか？
そもそも記憶クラス指定子とは？
変数の「寿命」と「可視性(どこから見えるか)」という2つの性質を決定するためのキーワード。
「寿命(storage duration)---その変数が」
⑶
標準ライブラリ関数strrch(),


