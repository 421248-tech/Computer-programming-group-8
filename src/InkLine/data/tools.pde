// Connor DeWeerd
// Tools: toolbar, tool icons, fill tool, and color picker

// Tools (0 = pencil, 1 = eraser, 2 = fill)
int tool = 0;

// Colors: black first, then rainbow
color[] colors = { #000000, #E62828, #FF8C00, #FFD200, #28AA46, #2864E6, #4B0082, #9640C8 };
color currentColor = #000000;
boolean showColors = false;

// Fill settings
int whiteTolerance = 128;
int colorTolerance = 40;

// Toolbar position and sizes
int tbX = 10;
int tbY = 10;
int btnSize = 40;
int pad = 8;

// Color picker position and sizes
int cpW = 56;
int cpH = 30;
int swatchSize = 28;
int cpPad = 8;

void drawToolbar() {
  // Toolbar box
  int boxW = btnSize + pad * 2;
  int boxH = 3 * (btnSize + pad) + pad;
  
  stroke(150);
  strokeWeight(1);
  fill(230);
  rect(tbX, tbY, boxW, boxH, 8);

  // Draw the 3 tool buttons
  for (int i = 0; i < 3; i++) {
    int bx = tbX + pad;
    int by = tbY + pad + i * (btnSize + pad);

    stroke(150);
    strokeWeight(1);
    
    // Highlight if selected or hovering
    if (tool == i) {
      fill(180, 210, 255);
    } else if (mouseX > bx && mouseX < bx + btnSize && mouseY > by && mouseY < by + btnSize) {
      fill(210);
    } else {
      fill(245);
    }
    
    rect(bx, by, btnSize, btnSize, 6);

    // Draw the icon inside the button
    float cx = bx + btnSize / 2;
    float cy = by + btnSize / 2;
    
    if (i == 0) {
      drawPencil(cx, cy);
    } else if (i == 1) {
      drawEraser(cx, cy);
    } else if (i == 2) {
      drawFill(cx, cy);
    }
  }
}

void drawPencil(float x, float y) {
  stroke(0);
  strokeWeight(1);

  // Yellow body (drawn straight up and down)
  fill(250, 200, 60);
  rect(x - 4, y - 10, 8, 16);

  // Pink eraser on top
  fill(235, 130, 140);
  rect(x - 4, y - 14, 8, 4);

  // Wood tip
  fill(235, 205, 160);
  triangle(x - 4, y + 6, x + 4, y + 6, x, y + 14);

  // Pencil lead
  fill(40);
  triangle(x - 1.5, y + 11, x + 1.5, y + 11, x, y + 14);
}

void drawEraser(float x, float y) {
  stroke(0);
  strokeWeight(1);

  // Pink part
  fill(240, 150, 165);
  rect(x - 12, y - 7, 16, 14);
  
  // White sleeve part
  fill(255);
  rect(x + 4, y - 7, 8, 14);
}
