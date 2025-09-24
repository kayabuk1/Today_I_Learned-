*　問1
⑴数字の後ろに付ける文字を「サフィックス(Suffix)（接尾辞）」と呼ぶが、それを付けることで、
その定数がどの型であるか明示的に示すことが出来る。接頭辞はprefix。これの対義語。
suf(sub)+fixで下に固定する取り付ける意味が核。それが言語変化させる部分を指す様になった。
「1」「123」の様に何も付けずに整数を書くと、デフォルトでint型として扱われる。
（intに収まらない長大な数字はlong int/long long long int）。
「1L」の様に書くと、これはｺﾝﾊﾟｲﾗにlong型の1ですよ。と伝えていることになる。
1lの様に小文字lでも可能だが、人間の判別なために大文字Lで書くことが推奨されている。
「123,123L,123LL,123U,123UL,123ULL」
⑵「sprintf()」「printf()」どちらとも＜stdio.h＞で定義されている。
printf(print formattedの略)標準出力。通常ｺﾝｿｰﾙに出力される。
sprintf(string print formatted)出力先はchar型の配列、つまり文字列。
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
  
