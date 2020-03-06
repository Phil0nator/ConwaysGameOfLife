final int STARTER_LIFES = 100000;
final int INITIAL_DIV_FACTOR = 3;


float ZOOM_SCALE = 1.0;
int X_OFFSET = 0;
int Y_OFFSET = 0;


int velx;
int vely;


Node[][] GRID;
Node[][] next_grid;

ArrayList<Node> changeQueue;

int[] initSeedX;
int[] initSeedY;
int GSIZEX;
int GSIZEY;
void setGrid(){
  changeQueue = new ArrayList<Node>();
  
  GSIZEX = width/INITIAL_DIV_FACTOR;
  GSIZEY = height/INITIAL_DIV_FACTOR;
  
  ZOOM_SCALE = INITIAL_DIV_FACTOR;
  
  initSeedX = new int[STARTER_LIFES];
  initSeedY = new int[STARTER_LIFES];
  
  for(int i = 0 ; i < STARTER_LIFES;i++){
    
    initSeedX[i] =(int)random(1,GSIZEX);
    initSeedY[i] = (int)random(1,GSIZEY);
  }
  
  
  GRID = new Node[GSIZEX+2][GSIZEY+2];
  for(int i = 0 ; i < GSIZEX+1;i++){
   for(int j = 0 ; j < GSIZEY+1; j++){
       if(j!=0&&i!=0&&i!=GSIZEX&&j!=GSIZEY){
         GRID[i][j] = new Node(i,j);
       }else{
         GRID[i][j] = new Node();
       }
     }
  }
  next_grid = new Node[GSIZEX+2][GSIZEY+2];
  for(int i = 0 ; i < GSIZEX+1;i++){
   for(int j = 0 ; j < GSIZEY+1; j++){
     if(j!=0&&i!=0&&i!=GSIZEX&&j!=GSIZEY){
       next_grid[i][j] = new Node(i,j);
     }else{
       next_grid[i][j] = new Node();
     }
     }
  }
  
  for(int i = 0 ; i < STARTER_LIFES;i++){
    
    GRID[initSeedX[i]][initSeedY[i]].val=true;
  }
  
  
}

void resetNextGrid(){
  
  for(int i = 0 ; i < GSIZEX;i++){
   for(int j = 0 ; j < GSIZEY; j++){
       GRID[i][j].val = next_grid[i][j].val;
       next_grid[i][j].val = false;
     }
  }
  
  
  /*
  for(int i = 0 ; i < changeQueue.size();i++){
    Node temp = changeQueue.get(i);
    GRID[temp.x][temp.y].val = next_grid[temp.x][temp.y].val;
    next_grid[temp.x][temp.y].val = false;
  }
  */
}

void handleGrid(){

  stroke(colorBool(true));
  scale(ZOOM_SCALE);
  translate(X_OFFSET, Y_OFFSET);
  for(int i = 1 ; i < GSIZEX;i++){
   for(int j = 1 ; j < GSIZEY; j++){
       GRID[i][j].d();
       GRID[i][j].tick();
     }
  }
  resetNextGrid();
}



void setup(){
  
  fullScreen();
  setGrid();
  
}

void mousePressed(){
  int x = (int)(mouseX/ZOOM_SCALE);
  int y = (int)(mouseY/ZOOM_SCALE);
  GRID[x][y].val=true;
  if(x!=0&&y!=0){
    GRID[x+1][y+1].val=true;
    GRID[x-1][y-1].val=true;
  }

}
void keyPressed(){

  if(key==UP){
    ZOOM_SCALE = constrain(ZOOM_SCALE+1, .5, 10);  
  } 
  else if (key == DOWN){
    ZOOM_SCALE = constrain(ZOOM_SCALE-1, .5, 10);  
  } 
    
  
  if (key == 'a'){
    X_OFFSET++; 
  }else if (key == 'd'){
    X_OFFSET--; 
  }
  
  if(key == 'w'){
    Y_OFFSET++;
  }
  
  if(key == 's'){
    Y_OFFSET--;
  }

}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if(e>0){
    ZOOM_SCALE = constrain(ZOOM_SCALE+1, .5, 10);
  }else{
    ZOOM_SCALE = constrain(ZOOM_SCALE-1, .5, 10);
  }
}

void draw(){
  background(180);
  
  handleGrid();
  
  fill(255,0,255);
  text(frameRate, 50,50);
  
}
