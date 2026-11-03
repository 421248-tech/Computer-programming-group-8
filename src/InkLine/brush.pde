// Owen Sorensen
class Player {
// Member Variables
int x,y;
p1 PImage;

// Constructor
Player() {
  x = 50;
  y = 50;
  p1 = loadImage("");
}

// Member Method
void display() {
  // replace rect with an image
  fill(200,7,88);
  rect(x,y,50,50);
}
