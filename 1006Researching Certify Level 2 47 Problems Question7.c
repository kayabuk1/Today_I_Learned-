/*このプログラムはmalloc()を使わずに、最初に用意した10個の部屋(struct USER buffer[10])を
やりくりして、ユーザのリストを作ったり削除したりする仕組みとのこと。連結リストというデータ構造。
age = EMPTY(-1)でその部屋が空室であることを示す。
top:実際に使われている部屋(ユーザリスト)の先頭を指すﾎﾟｲﾝﾀ
next:次の部屋を示すﾎﾟｲﾝﾀ。デイジーチェーンのように繋がっている。*/

#include<stdio>
#define MAX_USER 10  //最大ユーザ数を10人に定義してマクロで置き換える
#define EMPTY (-1)  //EMPTYを(-1)で置き換える。-1と言うことはEOFみたいに被ってはいけない値？
#define EDO ((void*)0)  //EODをvoid*型にキャストした0で置き換える。なんの略だろうEND OF Data
struct USER{  //構造体USERの記述
  char id[10];
  char name[80];
  int age;
  struct USER *next;  //構造体USER型のﾎﾟｲﾝﾀ(次のユーザへのﾎﾟｲﾝﾀ)
};
struct USER buffer[MAX_USER];  //構造体USER型配列buffer[10]の宣言
struct USER *top;  //構造体USER型ﾎﾟｲﾝﾀ*topを宣言。
void Intialize(void){　  //初期化関数？
    int i;
    for(i=0;i<MAX_USER;i++){   //カウンタ変数iが0～10になるまでつまり10回繰り返す。
      buffer[i].age = EMPTY;//構造体USER型配列buffer[0～9].ageに(-1)を代入。
    }
    top = EDO;　//全ての初期化が終わったら構造体USER型ﾎﾟｲﾝﾀ*topの指すｱﾄﾞﾚｽを((void*)0)に。
}
struct USER *FindEmpty(void){　//構造体USER型ﾎﾟｲﾝﾀを戻り値として返すFindEmpty関数
  int i;
  for(i=0;i<MAX_USER;i++){  //カウンタ変数が10になるまで10回繰り返す。
    if((Q35)){  //問35内容的に何かがEMPTYだったらという内容？
                //なので、buffer[i].age==EMPTYと予想。
      return &buffer[i];　//戻り値としてi番目の構造体USER型配列buffer[i]のアドレスを返す。
    }
  }
  return EOD;  //✖ループが終わったらアドレスとして０を返す。⇒〇満室ならEODを返して終了する。
}
struct USER *Append(char id[],char name[],int age){  //構造体USER型ﾎﾟｲﾝﾀを返す関数Append追加の意味。
    //リストの末尾に新しいユーザを追加する関数。
  struct USER *new, *p;  //構造体USER型ﾎﾟｲﾝﾀ　*newと*pの宣言
  new = FindEmpty();　//ﾎﾟｲﾝﾀnewにFindEmpty()の戻り値アドレスを代入⇒つまり空いている部屋を一つ見つける
  if(new==EOD){　  //もしﾎﾟｲﾝﾀnewの値が0なら、アドレス0をそのまま返す。
    return EOD;    //つまりfindemptyでEODが返ってきた＝満室で終了
  }
  strcpy(new->id,id);  //ﾎﾟｲﾝﾀnewの指すｱﾄﾞﾚｽのメンバに文字列idの値をコピー
  strcpy(new->name,name);　  
  new->age = age;  
  (Q36);  //内容的にアロー演算子でnew->next =だろうが何が代入されるのか思いつかない。
  /*新しく追加されるユーザは必ず末尾になる。そのため次はないことを示すEODを入れる
  new->next = EOD;*/
  if(top==EOD){  //ﾎﾟｲﾝﾀtopが0と言うことは初期化された後。
    (Q37);  //topが０といことは、リストが空と言うこと。なので今追加したnewのｱﾄﾞﾚｽが先頭になる
      //　top = new;
  }else{　//✖初期化されていなければ、⇒〇既にユーザが1人以上いた場合。
    p=top;　  //ﾎﾟｲﾝﾀtopのアドレスをﾎﾟｲﾝﾀに代入。  
    while((Q38)){　//whileの目的は一番最後のユーザを見つけること。なのでp->next != EODでない限り
      p=p->next;　  //ループを続ける。ﾎﾟｲﾝﾀ変数pの指すメンバのnextのｱﾄﾞﾚｽをpに代入する
    }               //つまり次のユーザに移る。
    p->next = new;　//ループを抜けたら追加したユーザのｱﾄﾞﾚｽをnextに入れる。
  }
  return new;
}
struct USER *Remove(void){ //リストの先頭からユーザを1人削除する関数。
  struct USER *p;
  if(top==EOD)
    return EOD;
  p=top;　//元の先頭ユーザが指していたアドレスを次の人のアドレスp->nextに書き換える。
  (Q39);　//なのでtop=p->nextが答え
  p->age=EMPTY;
  return p;
}










