//Ian Gorchos

PGraphics canvas;     

void setup() {
  size(800, 600);
  boxY = 10;
  updateBox();
  canvas = createGraphics(width, height);
  clearCanvas();
}

void draw() {
  canvas.beginDraw();
  if (!uiClick && mousePressed) {
    drawStroke();
  }
  canvas.endDraw();

 
  image(canvas, 0, 0);
  drawToolbar();
  drawColorButton();
  drawControls();
  if (showSettings) {
    drawSettings();
  }
  if (showPalette) {
    drawPalette();
  }
}
