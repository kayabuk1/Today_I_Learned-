#define STACK_SIZE 10
struct t_stack{
  int result;
  int sp;
  int buffer[STACK_SIZE]; 
};
void stack_inti(struct t_stack *p){
  p->sp=0;
};
void push(struct t_stack *p, int value){
  if(Q35){
    p->buffer[p->sp] = value;
    p->sp++;
    p->result = 0;
  }else{
    p->result = -1;
  }
};
int pop(struct t_stack *p){
  int value =0;
  if(p->sp > 0){
    (Q36);
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
  p->rp = 0;
  p->wp = 0;
};
void set(struct t_queue *p,int value){
  if(p->count < QUEUE_SIZE){
    (Q37);
    p->wp++;
    if(p->wp == (Q38))
      p->wp = 0;
    p->count++;
    p->result =0;
  }else{
    p->result = -1;
  }
};
int get(struct t_queue *p){
  int value = 0;
  if(p->count > 0){
    value = p->buffer[p->rp];
    p->rp++;
    if(p->rp == (Q38))
      p->rp = 0;
    (Q39);
    p->result = 0;
  }else{
    p->result = -1;
  }
  return value;
}





































