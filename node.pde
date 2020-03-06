color colorBool(boolean a){
  
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
  
  
  void d(){
    if(!val||!valid)return;
    
    point(x,y);
    
  }
  int getLiveNeighbors(){
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
  
  void setNextVal(boolean v){
  
    next_grid[x][y].val = v;
    
  }

  void tick(){
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
