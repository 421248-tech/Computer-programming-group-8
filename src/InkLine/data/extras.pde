// Owen Sorensen

int sensitivity = 1;

boolean showSettings = false;
boolean draggingSlider = false;
boolean darkMode = false;

color panelColor;
color textColor;
color lineColor;
color buttonColor;
color hoverColor;
color activeColor;
color trackColor;

int settingsBtnX = 754;
int settingsBtnY = 18;
int settingsBtnSize = 26;

int panelX = 560;
int panelY = 199;
int panelW = 230;
int panelH = 122;

int trackX1 = 576;
int trackX2 = 774;
int trackY = 257;

int themeX = 572;
int themeY = 283;
int themeW = 206;
int themeH = 26;

void updateColors() {
  if (darkMode) {
    panelColor = color(50, 50, 50, 235);
    textColor = color(240);
    lineColor = color(200);
    buttonColor = color(70);
    hoverColor = color(95);
    activeColor = color(80, 100, 150);
    trackColor = color(150);
  } else {
    panelColor = color(245, 245, 245, 230);
    textColor = color(0);
    lineColor = color(0);
    buttonColor = color(255);
    hoverColor = color(225);
    activeColor = color(200, 215, 255);
    trackColor = color(120);
  }
}

void drawSettingsButton() {
  stroke(lineColor);
  strokeWeight(1);
  if (showSettings) {
    fill(activeColor);
  } else if (overRect(settingsBtnX, settingsBtnY, settingsBtnSize, settingsBtnSize)) {
    fill(hoverColor);
  } else {
    fill(buttonColor);
  }
  rect(settingsBtnX, settingsBtnY, settingsBtnSize, settingsBtnSize, 5);

  float cx = settingsBtnX + settingsBtnSize / 2;
  float cy = settingsBtnY + settingsBtnSize / 2;
  stroke(textColor);
  strokeWeight(2);
  for (int i = 0; i < 8; i++) {
    float angle = i * TWO_PI / 8;
    line(cx + cos(angle) * 6, cy + sin(angle) * 6, cx + cos(angle) * 9, cy + sin(angle) * 9);
  }
  strokeWeight(1);
  fill(buttonColor);
  ellipse(cx, cy, 13, 13);
  fill(textColor);
  ellipse(cx, cy, 4, 4);
}

void drawSettings() {
  stroke(lineColor);
  strokeWeight(1);
  fill(panelColor);
  rect(panelX, panelY, panelW, panelH, 8);

  fill(textColor);
  textAlign(LEFT, TOP);
  textSize(14);
  text("Settings", panelX + 12, panelY + 10);
  textSize(12);
  text("Scroll sensitivity:  " + sensitivity, panelX + 12, panelY + 32);

  stroke(trackColor);
  strokeWeight(4);
  line(trackX1, trackY, trackX2, trackY);

  float dotX = map(sensitivity, 1, 10, trackX1, trackX2);
  stroke(lineColor);
  strokeWeight(1);
  fill(buttonColor);
  ellipse(dotX, trackY, 16, 16);

  stroke(lineColor);
  strokeWeight(1);
  if (overRect(themeX, themeY, themeW, themeH)) {
    fill(hoverColor);
  } else {
    fill(buttonColor);
  }
  rect(themeX, themeY, themeW, themeH, 5);

  fill(textColor);
  textAlign(CENTER, CENTER);
  textSize(12);
  if (darkMode) {
    text("Switch to Light Mode", themeX + themeW / 2, themeY + themeH / 2);
  } else {
    text("Switch to Dark Mode", themeX + themeW / 2, themeY + themeH / 2);
  }
  textAlign(LEFT, TOP);
}

void updateSlider() {
  float value = map(mouseX, trackX1, trackX2, 1, 10);
  sensitivity = constrain(round(value), 1, 10);
}

boolean overRect(int x, int y, int w, int h) {
  return mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;
}

void clearCanvas() {
  canvas.beginDraw();
  canvas.background(255);
  canvas.endDraw();
}
