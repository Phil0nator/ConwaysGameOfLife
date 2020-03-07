import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class ConwaysGameOfLife extends PApplet {

final int STARTER_LIFES = 80000;
final int INITIAL_DIV_FACTOR = 2;


float ZOOM_SCALE = 1.0f;
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
public void setGrid(){
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

public void resetNextGrid(){

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

public void handleGrid(){

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



public void setup(){

  
  setGrid();

}

public void mousePressed(){
  int x = (int)((mouseX)/ZOOM_SCALE)-X_OFFSET;
  int y = (int)((mouseY)/ZOOM_SCALE)-Y_OFFSET;
  GRID[x][y].val=true;
  if(x!=0&&y!=0){
    GRID[x+1][y+1].val=true;
    GRID[x-1][y-1].val=true;
  }

}
public void keyPressed(){

  if(key==UP){
    ZOOM_SCALE = constrain(ZOOM_SCALE+1, .5f, 10);
  }
  else if (key == DOWN){
    ZOOM_SCALE = constrain(ZOOM_SCALE-1, .5f, 10);
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

public void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if(e>0){
    ZOOM_SCALE = constrain(ZOOM_SCALE+1, .5f, 10);
  }else{
    ZOOM_SCALE = constrain(ZOOM_SCALE-1, .5f, 10);
  }
}

public void draw(){
  background(180);

  handleGrid();

  fill(255,0,255);
  text(frameRate, 50,50);

}
public int colorBool(boolean a){
  
  if(a)return color(0,0,200);
  return color(0);
}

class Node{
  boolean val = false;
  int x;
  int y;
  boolean valid = true;
  
  Node(int ix, int iy){
    x=ix;
    y=iy;
  }
  
  Node(){
  
    valid=false;
    
  }
  
  
  public void d(){
    if(!val||!valid)return;
    
    point(x,y);
    
  }
  public int getLiveNeighbors(){
    int c = 0;
    if(GRID[x-1][y].val)c++;
    if(GRID[x][y-1].val)c++;
    if(GRID[x+1][y].val)c++;
    if(GRID[x][y+1].val)c++;
    if(GRID[x+1][y+1].val)c++;
    if(GRID[x-1][y-1].val)c++;
    if(GRID[x+1][y-1].val)c++;
    if(GRID[x-1][y+1].val)c++;
    return c;
  }
  
  public void setNextVal(boolean v){
  
    next_grid[x][y].val = v;
    
  }

  public void tick(){
    if(!valid)return;
    int actN = getLiveNeighbors();
    if(val){
      if(actN < 2||actN>3){
        setNextVal(false);
        changeQueue.add(this);
      }else{
        setNextVal(true);
        
      }
    }else{
      if(actN==3){
        setNextVal(true);
        changeQueue.add(this);
      }else{
        setNextVal(false);
      }
    }
    
  }
  
  
}
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ConwaysGameOfLife" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
