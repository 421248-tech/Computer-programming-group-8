// Connor DeWeerd
// Tool Constants
final int PENCIL = 0;
final int ERASER = 1;
final int FILL   = 2;
final int NUM_TOOLS = 3;

int currentTool = PENCIL;

// Palette & Color variables
color currentColor = #000000;
boolean showPalette = false;

color[] palette = {
  #000000, // Black
  #797979, // Gray
  #FFFFFF, // White
  #FF0000, // Red
  #FF7F00, // Orange
  #FFFF00, // Yellow
  #00FF00, // Green
  #00FFFF, // Cyan
  #0000FF, // Blue
  #8B00FF  // Purple
};

// Toolbar Dimensions & Positioning
final int TB_X = 10;
final int TB_Y = 10;
final int TB_BTN = 36;
final int TB_GAP = 8;

int toolbarW() { return TB_BTN + TB_GAP * 2; }
int toolbarH() { return NUM_TOOLS * TB_BTN + (NUM_TOOLS + 1) * TB_GAP; }

int toolBtnX() { return TB_X + TB_GAP; }
int toolBtnY(int i) { return TB_Y + TB_GAP + i * (TB_BTN + TB_GAP); }

// Color Button & Palette Dimensions
final int CP_BTN_W = 120;
final int CP_BTN_H = 32;
final int CP_SWATCH = 24;
final int CP_GAP = 6;

int cpBtnX() { return (width - CP_BTN_W) / 2; }
int cpBtnY() { return 10; }

int cpPanelW() { return palette.length * (CP_SWATCH + CP_GAP) + CP_GAP; }
int cpPanelH() { return CP_SWATCH + CP_GAP * 2; }
int cpPanelX() { return (width - cpPanelW()) / 2; }
int cpPanelY() { return cpBtnY() + CP_BTN_H + 6; }

int swatchX(int i) { return cpPanelX() + CP_GAP + i * (CP_SWATCH + CP_GAP); }
int swatchY() { return cpPanelY() + CP_GAP; }


// --- UI Drawing Methods ---

void drawToolbar() {
  stroke(uiStroke());
  strokeWeight(1);
  fill(uiFill());
  rect(TB_X, TB_Y, toolbarW(), toolbarH(), 8);

  for (int i = 0; i < NUM_TOOLS; i++) {
    int x = toolBtnX();
    int y = toolBtnY(i);
    boolean hover = overRect(x, y, TB_BTN, TB_BTN);

    stroke(uiStroke());
    strokeWeight(1);
    if (currentTool == i) fill(btnActive());
    else if (hover) fill(btnHover());
    else fill(btnFill());

    rect(x, y, TB_BTN, TB_BTN, 5);

    // Draw Tool Icons
    pushMatrix();
    translate(x + TB_BTN / 2.0, y + TB_BTN / 2.0);
    stroke(uiText());
    strokeWeight(2);
    fill(uiText());

    if (i == PENCIL) {
      // Pencil Icon
      line(-5, 5, 3, -3);
      line(3, -3, 6, -6);
    } else if (i == ERASER) {
      // Eraser Icon
      noFill();
      rect(-6, -6, 12, 12, 2);
      fill(uiText());
      rect(-6, 2, 12, 4);
    } else if (i == FILL) {
      // Paint Bucket Icon
      noFill();
      quad(-6, -2, -2, -6, 4, 0, 0, 4);
      line(2, 2, 6, 6);
    }
    popMatrix();
  }
}

void drawColorButton() {
  boolean hover = overRect(cpBtnX(), cpBtnY(), CP_BTN_W, CP_BTN_H);

  stroke(uiStroke());
  strokeWeight(1);
  fill(hover ? btnHover() : btnFill());
  rect(cpBtnX(), cpBtnY(), CP_BTN_W, CP_BTN_H, 6);

  // Active color preview square
  stroke(uiStroke());
  fill(currentColor);
  rect(cpBtnX() + 8, cpBtnY() + 6, 20, 20, 4);

  // Button label
  fill(uiText());
  textAlign(LEFT, CENTER);
  textSize(12);
  text("Color", cpBtnX() + 36, cpBtnY() + CP_BTN_H / 2.0 - 1);
}

void drawPalette() {
  stroke(uiStroke());
  strokeWeight(1);
  fill(uiFill());
  rect(cpPanelX(), cpPanelY(), cpPanelW(), cpPanelH(), 6);

  for (int i = 0; i < palette.length; i++) {
    int sx = swatchX(i);
    int sy = swatchY();
    boolean hover = overRect(sx, sy, CP_SWATCH, CP_SWATCH);

    stroke(hover ? uiText() : uiStroke());
    strokeWeight(hover ? 2 : 1);
    fill(palette[i]);
    rect(sx, sy, CP_SWATCH, CP_SWATCH, 4);
  }
}

// --- Flood Fill Algorithm (Queue BFS) ---

void floodFill(int startX, int startY) {
  if (startX < 0 || startX >= canvas.width || startY < 0 || startY >= canvas.height) return;

  canvas.beginDraw();
  canvas.loadPixels();

  color targetColor = canvas.pixels[startY * canvas.width + startX];
  color replacementColor = currentColor;

  // Don't fill if target color is already the current color
  if (targetColor == replacementColor) {
    canvas.endDraw();
    return;
  }

  int w = canvas.width;
  int h = canvas.height;
  int[] queue = new int[w * h];
  int head = 0;
  int tail = 0;

  queue[tail++] = startY * w + startX;
  canvas.pixels[startY * w + startX] = replacementColor;

  while (head < tail) {
    int idx = queue[head++];
    int x = idx % w;
    int y = idx / w;

    // Check adjacent pixels (North, South, East, West)
    if (x > 0 && canvas.pixels[idx - 1] == targetColor) {
      canvas.pixels[idx - 1] = replacementColor;
      queue[tail++] = idx - 1;
    }
    if (x < w - 1 && canvas.pixels[idx + 1] == targetColor) {
      canvas.pixels[idx + 1] = replacementColor;
      queue[tail++] = idx + 1;
    }
    if (y > 0 && canvas.pixels[idx - w] == targetColor) {
      canvas.pixels[idx - w] = replacementColor;
      queue[tail++] = idx - w;
    }
    if (y < h - 1 && canvas.pixels[idx + w] == targetColor) {
      canvas.pixels[idx + w] = replacementColor;
      queue[tail++] = idx + w;
    }
  }

  canvas.updatePixels();
  canvas.endDraw();
}
