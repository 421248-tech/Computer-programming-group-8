//Owen Sorensen
int sensitivity = 1;   // scroll wheel sensitivity (1 to 10)

// Settings state
boolean showSettings = false;
boolean draggingSlider = false;
boolean darkMode = false;        // only affects the UI, never the canvas

// ---------- UI theme colors (canvas is not affected) ----------

color uiFill()    { return darkMode ? color(50, 50, 50, 235)    : color(245, 245, 245, 230); }
color uiText()    { return darkMode ? color(240) : color(0); }
color uiStroke()  { return darkMode ? color(200) : color(0); }
color btnFill()   { return darkMode ? color(70)  : color(255); }
color btnHover()  { return darkMode ? color(95)  : color(225); }
color btnActive() { return darkMode ? color(80, 100, 150) : color(200, 215, 255); }
color trackColor(){ return darkMode ? color(150) : color(120); }

// ---------- Settings button ----------

// Settings button (top right of the controls box)
int btnX() { return boxX + boxW - 36; }
int btnY() { return boxY + 8; }
int btnS() { return 26; }

void drawSettingsButton() {
  boolean hover = overRect(btnX(), btnY(), btnS(), btnS());

  stroke(uiStroke());
  strokeWeight(1);
  if (showSettings) fill(btnActive());
  else if (hover) fill(btnHover());
  else fill(btnFill());
  rect(btnX(), btnY(), btnS(), btnS(), 5);

  // Simple gear icon
  float cx = btnX() + btnS() / 2.0;
  float cy = btnY() + btnS() / 2.0;
  pushMatrix();
  translate(cx, cy);
  stroke(uiText());
  strokeWeight(2);
  for (int i = 0; i < 8; i++) {
    float a = i * TWO_PI / 8;
    line(cos(a) * 6, sin(a) * 6, cos(a) * 9, sin(a) * 9);
  }
  strokeWeight(1);
  fill(btnFill());
  ellipse(0, 0, 13, 13);
  fill(uiText());
  ellipse(0, 0, 4, 4);
  popMatrix();
}

// ---------- Settings panel ----------

// The panel stays full width and right-aligned, whether or not controls are hidden
int panelX() { return width - FULL_W - 10; }
int panelY() { return boxY + boxH + 8; }
int panelW() { return FULL_W; }
int panelH() { return 122; }

int trackX1() { return panelX() + 16; }
int trackX2() { return panelX() + panelW() - 16; }
int trackY()  { return panelY() + 58; }

// Dark/light mode button
int themeX() { return panelX() + 12; }
int themeY() { return panelY() + 84; }
int themeW() { return panelW() - 24; }
int themeH() { return 26; }

void drawSettings() {
  // Panel
  stroke(uiStroke());
  strokeWeight(1);
  fill(uiFill());
  rect(panelX(), panelY(), panelW(), panelH(), 8);

  // Text
  fill(uiText());
  textAlign(LEFT, TOP);
  textSize(14);
  text("Settings", panelX() + 12, panelY() + 10);
  textSize(12);
  text("Scroll sensitivity:  " + sensitivity, panelX() + 12, panelY() + 32);

  // Slider track
  stroke(trackColor());
  strokeWeight(4);
  line(trackX1(), trackY(), trackX2(), trackY());

  // Slider knob
  float kx = map(sensitivity, 1, 10, trackX1(), trackX2());
  stroke(uiStroke());
  strokeWeight(1);
  fill(btnFill());
  ellipse(kx, trackY(), 16, 16);

  // Dark/light mode button
  boolean hover = overRect(themeX(), themeY(), themeW(), themeH());
  stroke(uiStroke());
  strokeWeight(1);
  fill(hover ? btnHover() : btnFill());
  rect(themeX(), themeY(), themeW(), themeH(), 5);

  fill(uiText());
  textAlign(CENTER, CENTER);
  textSize(12);
  text(darkMode ? "Switch to Light Mode" : "Switch to Dark Mode",
       themeX() + themeW() / 2.0, themeY() + themeH() / 2.0);
  textAlign(LEFT, TOP);
}

void updateSlider() {
  float v = map(mouseX, trackX1(), trackX2(), 1, 10);
  sensitivity = constrain(round(v), 1, 10);
}

// ---------- Helpers ----------

boolean overRect(int x, int y, int w, int h) {
  return mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;
}

void clearCanvas() {
  canvas.beginDraw();
  canvas.background(255);
  canvas.endDraw();
}
