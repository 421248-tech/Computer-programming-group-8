//Ian Gorchos

PGraphics canvas;      // separate drawing layer so the UI stays on top

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

  // Show the drawing, then the UI on top of it
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
