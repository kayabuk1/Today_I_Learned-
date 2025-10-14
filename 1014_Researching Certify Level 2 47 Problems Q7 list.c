//1014_P-47Q7_list
#include<string.h>
#define MAX_USER  10
#define EMPTY     (-1)
#define EOD       ((void *) 0)  //EndOfDataの略void型ﾎﾟｲﾝﾀにきちんとキャストされている。ﾎﾟｲﾝﾀは本来void型だっけ？
struct USER{        構造体USER型の定義
  char id[10];
  char name[80];
  int age;
  struct USER *next  //構造体USER型ﾎﾟｲﾝﾀ *next　の宣言。リスト構造的に次のデータの場所(ｱﾄﾞﾚｽ)が入る。
};
struct USER buffer[MAX_USER];  //構造体
struct USER *top;
void Initialize(void){
  int i;
  for(i=0;i<MAX_USER;i++){
    buffer[i].age = EMPTY;
  }
  top = EOD;
};
struct USER *FindEmpty(void){
  int i;
  for(i=0;i<MAX_USER;i++){
    if(Q35){
      return &buffer[i];
    }
  }
  return EOD;
};
struct USER *Append(char id[], char name[], int age){
  struct USER *new, *p;
  new = FindEmpty();
  if(new==EOD){
    return EOD;
  }
  strcpy(new->id, id);
  strcpy(new-name, name);
  new->age =age;
  (Q36);
  if(top==EOD){
    (Q37);
  }else{
    p=top;
    while(Q38){
      p=p->next;
    }
    p->next=new;
  }
  return new;
};
struct USER *Remove(void){
  struct USER *p;
  if(top==EOD)
    return EOD;
  p=top;
  (Q39);
  p->age=EMPTY;
  return p;
}


























