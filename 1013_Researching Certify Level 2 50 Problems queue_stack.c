//キューとスタック、問題のコードなので、君のほうで簡単なコードに修正したりせず、このまま解説してほしい。
#define BUFF_MAX 10
#define ERROR  '\0'
char buffer[BUFF_MAX];    
int sp, rp, wp;
char push(char value){
  if(Q35){            //結果がデータ書込み失敗なのだから、それは満杯=sp=10の時。sp==BUFF_MAXかな
                      //Q35はresult ERRORなのだから、sp==BUFF_MAXの条件でよいのでは？｛｝無いから君も見間違えたね
    result ERROR;
  }
  buffer[sp++] = value; //後置インクリメントなので、いや[]が次に演算されるから[++sp]でも[sp++]でも関係無いのかな？ 
  return value;         //今の皿の上に、新しい皿valueを追加して、その追加した値(char型)を呼び出し元に返す。⇒✖
}　                     //普通に書かれている1行の処理を実行した後に加算するのが後置インクリメント誤解していた
char pop(void){
  if(sp==0){
    return ERROR;
  }                //sp＝０＝データが無いので取り出せない。前回の問題は置く場所をﾎﾟｲﾝﾀで扱っていたけれど、
                  //今回の問題は直接配列buffer[]に入れるて、入れる変数によって配列のどの要素を指させるか動かす感じだね。
                  //ﾎﾟｲﾝﾀとして扱うのと、整数型として扱うのメリットデメリットはどう違うのだろうか？
  return (Q36);    //そうじゃなければ、buffer[rp]を返すかな？⇒✖。buffer[--sp]が正解。
                    //spは次に置く皿の位置。sp-1 は一番最後（上）に入れたデータ。それがデータを取る位置。
                    //しかし、pop動作だからrpを使うのかと思ったらspを使ったほうが簡単というのは何だか、狐につままれた
                    //感覚になってしまう。
};
char Queue(char value){
  if(wp==-1){    //書き込みポイントが-1?満杯ということ？でもこれﾎﾟｲﾝﾀではないからEOFかな端っこに来て満杯ならということか
    wp = rp;      //満杯なら書き込み位置を読み込み位置にする？違う書き込み位置と読込み位置が同じということはデータが空だ。
  }else if(Q37){    //なのでデータが空ならでwp==rp?
    return ERROR;
  }
  buffer[wp] = value;
  (Q38);              //書き込みは配列の後ろからなのでwp--;かな
  return value;
};
char Dequeue(void){
  char value;
  if(wp==-1)
    return ERROR;
  value = buffer[rp];
  rp =(rp +1)%BUFF_MAX      //10の剰余は０～９になるので、データが空でなかったら、valueに入れたのがbuffer[5]なら
                            //先入れ先出しなので読込は配列の最初の方の要素から増やしていくのか。
  if(rp==wp){
    (Q39);                  //キューはrpとwpが等しいと言うことは、スタックと違いデータが満杯
  }                        //return ?分からない
  return 0;
};






