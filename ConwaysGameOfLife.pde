final int STARTER_LIFES = 100000;

float ZOOM_SCALE = 1.0;

Node[][] GRID;
Node[][] next_grid;

ArrayList<Node> changeQueue;

int[] initSeedX;
int[] initSeedY;

void setGrid(){
  changeQueue = new ArrayList<Node>();
  int GSIZEX = width;
  int GSIZEY = height;
  
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
  
  for(int i = 0 ; i < width;i++){
   for(int j = 0 ; j < height; j++){
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
  for(int i = 1 ; i < width;i++){
   for(int j = 1 ; j < height; j++){
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
  int x = (int)(mouseX);
  int y = (int)(mouseY);
  GRID[x][y].val=true;
  if(x!=0&&y!=0){
    GRID[x+1][y+1].val=true;
    GRID[x-1][y-1].val=true;
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
