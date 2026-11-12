//Ian Gorchos


void setup() {
  size(800, 600);
  canvas = createGraphics(800, 600);
  canvas.noSmooth();  
  clearCanvas();
  updateColors();
  updateBox();
}

void draw() {
  canvas.beginDraw();
  if (mousePressed && uiClick == false) {
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
