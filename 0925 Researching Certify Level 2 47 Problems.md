*　問1
⑶
数字の後ろに付ける文字を「サフィックス(Suffix)（接尾辞）」と呼ぶが、それを付けることで、
その定数がどの型であるか明示的に示すことが出来る。接頭辞はprefix。これの対義語。
suf(sub)+fixで下に固定する取り付ける意味が核。それが言語変化させる部分を指す様になった。
「1」「123」の様に何も付けずに整数を書くと、デフォルトでint型として扱われる。
（intに収まらない長大な数字はlong int/long long long int）。
「1L」の様に書くと、これはｺﾝﾊﾟｲﾗにlong型の1ですよ。と伝えていることになる。
1lの様に小文字lでも可能だが、人間の判別なために大文字Lで書くことが推奨されている。
「123,123L,123LL,123U,123UL,123ULL」
⑸
「sprintf()」「printf()」どちらとも＜stdio.h＞で定義されている。
printf(print formattedの略)標準出力。通常ｺﾝｿｰﾙに出力される。
srintf(string print formatted)出力先はchar型の配列、つまり文字列。
sprintf(char *buffer,const char *format,.......);の様に書き、
一番目の引数に書き込み先の「文字配列」を指定する。書き込み先なのでポインタかアドレス情報で渡す？
  char buffer[100];
  printf("printfの出力：%d年%d月%d日",year,month,day);
  sprint(buffer,"%d年%d月%d日",year,month ,day);&buffer[0]が書き込み先として指定されている。
  printf("sprintfが書き込んだ文字列：％s\n",buffer);
上のように一度変数に文字列(buffer[])を作成しておいて、後からその文字列を使いたい、
と言う場面で役に立つ。
ただsprintfは書き込み先のサイズをチェックしない欠陥があり、バッファオーバーフローの危険があり、
現在は第二引数にバッファ最大サイズを指定できるsnprintf()を使うのが常識になっている。
⑺
「rand()」は疑似乱数というランダムに見える数値を生成するための関数。
stdlib.hをｲﾝｸﾙｰﾄﾞする必要がある。rando()を呼び出すと、０からRAND_MAX(環境によって変わる。例：32767など)までの範囲の整数がランダムに返される。
#include<stdio.h>
#include<stdlib.h>
int main(void){
  printf("%d\n",rand());
  printf("%d\n",rand());
  return 0;
}のように書ける、がこれだと何度実行しても同じ値が出てしまう。
rand()が生成する値はある計算式から作られている。その最初の計算式を「seed(種)」と呼ぶ。
種が同じだとそこから作られる数列は必ず同じになる。デフォルト値は常に同じ(１)なので毎回同じ結果になる。
では毎回違う乱数を生成するには？
プログラムを実行する度に毎回違う種をrand()に与える必要がある。
１．srand()関数：種を設定するための関数。ｓはseedのｓ。
２．time()関数：time(NULL)を呼び出すと１９７０年１月１日からの経過秒数が返される。
これは常に変化する値なのでseedに適している。<time.h>のインクルードが必要。
#include<stdio.h>
#include<stdlib.h>
#include<time.h>
int main(void){
  srand((unsigned int)time(NULL));現在時刻を種として乱数生成器を初期化
  printf("%d\n",rand());これ以降に呼び出すrand()は毎回違う値を返すようになる。
  ただrand()が返す値はそのままでは大きすぎるので、
  rand()%10 10で割った余りは必ず０～９になる。
  rand()%10+1　１～10の乱数
  rand()%6+1　 １～６のサイコロの様に余りを活用することが多い。
}
⑺　問1
⑶
数字の後ろに付ける文字を「サフィックス(Suffix)（接尾辞）」と呼ぶが、それを付けることで、
その定数がどの型であるか明示的に示すことが出来る。接頭辞はprefix。これの対義語。
suf(sub)+fixで下に固定する取り付ける意味が核。それが言語変化させる部分を指す様になった。
「1」「123」の様に何も付けずに整数を書くと、デフォルトでint型として扱われる。
（intに収まらない長大な数字はlong int/long long long int）。
「1L」の様に書くと、これはｺﾝﾊﾟｲﾗにlong型の1ですよ。と伝えていることになる。
1lの様に小文字lでも可能だが、人間の判別なために大文字Lで書くことが推奨されている。
「123,123L,123LL,123U,123UL,123ULL」
⑸
「sprintf()」「printf()」どちらとも＜stdio.h＞で定義されている。
printf(print formattedの略)標準出力。通常ｺﾝｿｰﾙに出力される。
srintf(string print formatted)出力先はchar型の配列、つまり文字列。
sprintf(char *buffer,const char *format,.......);の様に書き、
一番目の引数に書き込み先の「文字配列」を指定する。書き込み先なのでポインタかアドレス情報で渡す？
  char buffer[100];
  printf("printfの出力：%d年%d月%d日",year,month,day);
  sprint(buffer,"%d年%d月%d日",year,month ,day);&buffer[0]が書き込み先として指定されている。
  printf("sprintfが書き込んだ文字列：％s\n",buffer);
上のように一度変数に文字列(buffer[])を作成しておいて、後からその文字列を使いたい、
と言う場面で役に立つ。
ただsprintfは書き込み先のサイズをチェックしない欠陥があり、バッファオーバーフローの危険があり、
現在は第二引数にバッファ最大サイズを指定できるsnprintf()を使うのが常識になっている。
⑺
「rand()」は疑似乱数というランダムに見える数値を生成するための関数。
stdlib.hをｲﾝｸﾙｰﾄﾞする必要がある。rando()を呼び出すと、０からRAND_MAX(環境によって変わる。例：32767など)までの範囲の整数がランダムに返される。
#include<stdio.h>
#include<stdlib.h>
int main(void){
  printf("%d\n",rand());
  printf("%d\n",rand());
  return 0;
}のように書ける、がこれだと何度実行しても同じ値が出てしまう。
rand()が生成する値はある計算式から作られている。その最初の計算式を「seed(種)」と呼ぶ。
種が同じだとそこから作られる数列は必ず同じになる。デフォルト値は常に同じ(１)なので毎回同じ結果になる。
では毎回違う乱数を生成するには？
プログラムを実行する度に毎回違う種をrand()に与える必要がある。
１．srand()関数：種を設定するための関数。ｓはseedのｓ。
２．time()関数：time(NULL)を呼び出すと１９７０年１月１日からの経過秒数が返される。
これは常に変化する値なのでseedに適している。<time.h>のインクルードが必要。
#include<stdio.h>
#include<stdlib.h>
#include<time.h>
int main(void){
  srand((unsigned int)time(NULL));現在時刻を種として乱数生成器を初期化
  printf("%d\n",rand());これ以降に呼び出すrand()は毎回違う値を返すようになる。
  ただrand()が返す値はそのままでは大きすぎるので、
  rand()%10 10で割った余りは必ず０～９になる。
  rand()%10+1　１～10の乱数
  rand()%6+1　 １～６のサイコロの様に余りを活用することが多い。
}
⑺



















