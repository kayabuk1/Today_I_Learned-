//キューとスタック
#define STACK_SIZE 10
struct t_stack{  
  int result;
  int sp;                //spが最も重要。次に皿を置くべくｲﾝﾃﾞｯｸｽ番号かつ、現在積まれている皿の数も表している
  int buffer[STACK_SIZE]; 
};
void stack_inti(struct t_stack *p){
  p->sp=0; 
};
void push(struct t_stack *p, int value){
  if(Q35){    //ﾃﾞｰﾀをpush出来る条件は、スタックが満杯でないこと。p->sp < STACK_SIZE
    p->buffer[p->sp] = value;
    p->sp++;
    p->result = 0;
  }else{
    p->result = -1;
  }
};
int pop(struct t_stack *p){
  int value =0;
  if(p->sp > 0){    //皿が１枚以上積まれているか
    (Q36);          //p->sp--;spは次の皿を置くべき場所のｲﾝﾃﾞｯｸｽで、それを基準に‐１したら現在の一番新しいデータになる
    p->result = 0;
    value = p->buffer[p->sp];
  }else{
    p->result = -1;
  }
  return value;
};
#define QUEUE_SIZE 10
struct t_queue {
  int result;
  int count;
  int rp;
  int wp;
  int buffer[QUEUE_SIZE];
};
void queue_init(struct t_queue *p){
  p->count = 0;
  p->rp = 0;　//読み込む＝データ取り出しは列の先頭
  p->wp = 0;　//書き込む＝データ追加は列の最後の場所
};
void set(struct t_queue *p,int value){
  if(p->count < QUEUE_SIZE){　　//データの列、queueが満員でないか判断
    (Q37);    //p->buffer[p->wp] = value; 新しい値を最後尾に追加する
    p->wp++;  //指す場所をひとつ後ろにずらす
    if(p->wp == (Q38))    //QUEUE_SIZE　配列が端まで来たら0に戻すことで配列をリングのように使う
      p->wp = 0;          //0と言うことは先頭に戻ったと言うこと。リングバッファと言う。
    p->count++;           //列の総人数を１つ増やす
    p->result =0;
  }else{
    p->result = -1;
  }
};
int get(struct t_queue *p){    get=列からデータを取り出す
  int value = 0;
  if(p->count > 0){    //countはデータ数なので、データが入っていれば＝列に並んでいれば
    value = p->buffer[p->rp];   //先頭のデータを取り出す
    p->rp++;                    //先頭を一つずらす
    if(p->rp == (Q38))          //もし読み出しが端まで＝[10]の最後まで行ったらまた先頭にする
      p->rp = 0;
    (Q39);                      //取り出せれたら列からいなくなるのでcountを-1する
    p->result = 0;
  }else{
    p->result = -1;
  }
  return value;
}





































