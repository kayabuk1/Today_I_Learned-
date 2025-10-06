#include<stdio>
#define MAX_USER 10
#define EMPTY (-1)
#define EDO ((void*)0)
struct USER{
  char id[10];
  char name[80];
  int age;
  struct USER *next;
};
struct USER buffer[MAX_USER];
struct USER *top;
void Intialize(void){
    int i;
    for(i=0;i<MAX_USER;i++){
      buffrer[i].age = EMPTY;
    }
    top = EDO;
}
struct USER *FindEmpty(void){
  int i;
  for(i=0;i<MAX_USER;i++){
    if((Q35)){
      return &buffer[i];
    }
  }
  return EOD;
}
struct USER *Append(char id[],char name[],int age){
  struct USER *new, *p;
  new = FindEmpty();
  if(new==EOD){
    return EOD;
  }
  strcpy(new->id,id);
  strcpy(new->name,name);
  new->age = age;
  (Q36);
  if(top==EOD){
    (Q37);
  }else{
    p=top;
    while((Q38)){
      p=p->next;
    }
    p->next = new;
  }
  return = new;
}
struct USER *Remove(void){
  struct USER *p;
  if(top==EOD)
    return EOD;
  p=top;
  (Q39);
  p->age=EMPTY;
  return p;
}










