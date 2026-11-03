//Ian Hundley
int penSize = 3;           
int eraserSize = 20;       
boolean uiClick = false;   


int boxW, boxH, boxX, boxY;
final int FULL_W = 230;
final int FULL_H = 181;
final int HIDDEN_W = 44;
final int HIDDEN_H = 42;
boolean controlsHidden = false; 

void drawStroke() {
  boolean erasing = (mouseButton == RIGHT) || (mouseButton == LEFT && currentTool == ERASER);
  boolean drawing = (mouseButton == LEFT && currentTool == PENCIL);

  if (drawing) {
    canvas.stroke(currentColor);
    canvas.strokeWeight(penSize);
    canvas.line(pmouseX, pmouseY, mouseX, mouseY);
  } else if (erasing) {
    canvas.stroke(255);
    canvas.strokeWeight(eraserSize);
    canvas.line(pmouseX, pmouseY, mouseX, mouseY);
  }
}

boolean usingEraser() {
  return (mousePressed && mouseButton == RIGHT) || currentTool == ERASER;
}

void adjustSize(int change) {
  if (usingEraser()) {
    eraserSize = constrain(eraserSize + change * 2, 2, 100);
  } else {
    penSize = constrain(penSize + change, 1, 50);
  }
}


void mousePressed() {
  // Color button: open or close the palette
  if (overRect(cpBtnX(), cpBtnY(), CP_BTN_W, CP_BTN_H)) {
    showPalette = !showPalette;
    uiClick = true;
    return;
  }

  if (showPalette && overRect(cpPanelX(), cpPanelY(), cpPanelW(), cpPanelH())) {
    uiClick = true;
    for (int i = 0; i < palette.length; i++) {
      if (overRect(swatchX(i), swatchY(), CP_SWATCH, CP_SWATCH)) {
        currentColor = palette[i];
        showPalette = false;
        if (currentTool == ERASER) currentTool = PENCIL;
      }
    }
    return;
  }

  showPalette = false;

  for (int i = 0; i < NUM_TOOLS; i++) {
    if (overRect(toolBtnX(), toolBtnY(i), TB_BTN, TB_BTN)) {
      currentTool = i;
      uiClick = true;
      return;
    }
  }

  if (overRect(TB_X, TB_Y, toolbarW(), toolbarH())) {
    uiClick = true;
    return;
  }

  if (overRect(btnX(), btnY(), btnS(), btnS())) {
    showSettings = !showSettings;
    uiClick = true;
    return;
  }

  if (showSettings && overRect(panelX(), panelY(), panelW(), panelH())) {
    uiClick = true;

    if (overRect(trackX1() - 10, trackY() - 14, trackX2() - trackX1() + 20, 28)) {
      draggingSlider = true;
      updateSlider();
    }

    if (overRect(themeX(), themeY(), themeW(), themeH())) {
      darkMode = !darkMode;
    }
    return;
  }

  if (overRect(boxX, boxY, boxW, boxH)) {
    uiClick = true;
    return;
  }

  if (mouseButton == LEFT && currentTool == FILL) {
    floodFill(mouseX, mouseY);
  }
}

void mouseDragged() {
  if (draggingSlider) {
    updateSlider();
  }
}

void mouseReleased() {
  draggingSlider = false;
  uiClick = false;
}

void mouseWheel(MouseEvent event) {
  adjustSize(-(int) event.getCount() * sensitivity);
}

void updateBox() {
  boxW = controlsHidden ? HIDDEN_W : FULL_W;
  boxH = controlsHidden ? HIDDEN_H : FULL_H;
  boxX = width - boxW - 10;
}

void drawControls() {
  stroke(uiStroke());
  strokeWeight(1);
  fill(uiFill());
  rect(boxX, boxY, boxW, boxH, 8);

  if (!controlsHidden) {
    fill(uiText());
    textAlign(LEFT, TOP);
    textSize(14);
    text("Controls", boxX + 12, boxY + 10);

    textSize(12);
    text("Left click:  use selected tool", boxX + 12, boxY + 36);
    text("Right click:  erase", boxX + 12, boxY + 54);
    text("Scroll wheel:  tool thickness", boxX + 12, boxY + 72);
    text("Up / Down or + / -:  tool thickness", boxX + 12, boxY + 90);
    text("P / E / F:  pencil / eraser / fill", boxX + 12, boxY + 108);
    text("Top center button:  pick a color", boxX + 12, boxY + 126);
    text("C:  clear canvas", boxX + 12, boxY + 144);
    text("H:  hide controls", boxX + 12, boxY + 162);
  }

  drawSettingsButton();
}


void keyPressed() { 
  if (key == 'c' || key == 'C') {
    clearCanvas();
  }

  if (key == 'h' || key == 'H') {
    controlsHidden = !controlsHidden;
    updateBox();
  }

  if (key == 'p' || key == 'P') {
    currentTool = PENCIL;
  }
  if (key == 'e' || key == 'E') {
    currentTool = ERASER;
  }
  if (key == 'f' || key == 'F') {
    currentTool = FILL;
  }

  if (keyCode == UP || key == '+' || key == '=') {
    adjustSize(1);
  }

  if (keyCode == DOWN || key == '-') {
    adjustSize(-1);
  }

  if (key == ']') {
    eraserSize = min(eraserSize + 2, 100);
  }

  if (key == '[') {
    eraserSize = max(eraserSize - 2, 2);
  }
}
