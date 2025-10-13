//キューとスタック
#define BUFF_MAX 10
#define ERROR  '\0'
char buffer[BUFF_MAX];    
int sp, rp, wp;
char push(char value){
  if(Q35)            //結果がデータ書込み失敗なのだから、それは満杯=sp=10の時。sp==BUFF_MAXかな
    result ERROR;
  buffer[sp++] = value; //後置インクリメントなので、いや[]が次に演算されるから[++sp]でも[sp++]でも関係無いのかな？ 
  return value;         //今の皿の上に、新しい皿valueを追加して、その追加した値(char型)を呼び出し元に返す。
}
char pop(void){
  if(sp==0)
    return ERROR;  //sp＝０＝データが無いので取り出せない
  return (Q36);    //そうじゃなければ、buffer[rp]を返すかな？
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






