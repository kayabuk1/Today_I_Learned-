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
st
