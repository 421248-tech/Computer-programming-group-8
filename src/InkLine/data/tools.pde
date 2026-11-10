// Connor DeWeerd
// Tools: toolbar, tool icons, fill tool, and the color picker

// Tools
final int PENCIL = 0;
final int ERASER = 1;
final int FILL = 2;
final int NUM_TOOLS = 3;
int currentTool = PENCIL;

// Colors: black first, then the colors of the rainbow
color[] palette = { #000000, #E62828, #FF8C00, #FFD200, #28AA46, #2864E6, #4B0082, #9640C8 };
color currentColor = #000000;   // the color used by the pencil and fill tools
boolean showPalette = false;

// Fill settings
final int FILL_TOLERANCE = 128;        // used when filling white areas (reaches the edge of anti-aliased lines)
final int COLOR_FILL_TOLERANCE = 40;   // used when filling colored areas (so it doesn't leak into other colors)

// Toolbar layout (left side)
final int TB_X = 10;
final int TB_Y = 10;
final int TB_BTN = 40;
final int TB_PAD = 8;

// Color picker layout (top center)
final int CP_BTN_W = 56;
final int CP_BTN_H = 30;
final int CP_SWATCH = 28;
final int CP_PAD = 8;

// ---------- Toolbar ----------

int toolbarW() { return TB_BTN + TB_PAD * 2; }
int toolbarH() { return NUM_TOOLS * (TB_BTN + TB_PAD) + TB_PAD; }
int toolBtnX() { return TB_X + TB_PAD; }
int toolBtnY(int i) { return TB_Y + TB_PAD + i * (TB_BTN + TB_PAD); }

void drawToolbar() {
  // Background
  stroke(uiStroke());
  strokeWeight(1);
  fill(uiFill());
  rect(TB_X, TB_Y, toolbarW(), toolbarH(), 8);

  // Tool buttons
  for (int i = 0; i < NUM_TOOLS; i++) {
    int bx = toolBtnX();
    int by = toolBtnY(i);
    boolean hover = overRect(bx, by, TB_BTN, TB_BTN);

    stroke(uiStroke());
    strokeWeight(1);
    if (currentTool == i) fill(btnActive());
    else if (hover) fill(btnHover());
    else fill(btnFill());
    rect(bx, by, TB_BTN, TB_BTN, 6);

    float cx = bx + TB_BTN / 2.0;
    float cy = by + TB_BTN / 2.0;
    if (i == PENCIL) drawPencilIcon(cx, cy);
    if (i == ERASER) drawEraserIcon(cx, cy);
    if (i == FILL)   drawFillIcon(cx, cy);
  }
}

void drawPencilIcon(float cx, float cy) {
  pushMatrix();
  translate(cx, cy);
  rotate(PI / 4);
  stroke(0);
  strokeWeight(1);

  // Body
  fill(250, 200, 60);
  rect(-4, -13, 8, 17);

  // Top band
  fill(235, 130, 140);
  rect(-4, -13, 8, 4);

  // Wooden tip
  fill(235, 205, 160);
  triangle(-4, 4, 4, 4, 0, 12);

  // Lead
  fill(40);
  triangle(-1.5, 9, 1.5, 9, 0, 12);
  popMatrix();
}

void drawEraserIcon(float cx, float cy) {
  pushMatrix();
  translate(cx, cy);
  rotate(-PI / 6);
  stroke(0);
  strokeWeight(1);

  // Pink eraser end
  fill(240, 150, 165);
  rect(-12, -7, 14,
