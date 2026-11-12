int penSize = 3;
int eraserSize = 20;
boolean uiClick = false;

int boxX = 560;
int boxY = 10;
int boxW = 230;
int boxH = 181;
boolean controlsHidden = false;

void drawStroke() {
  if (mouseButton == LEFT && currentTool == PENCIL) {
    canvas.stroke(currentColor);
    canvas.strokeWeight(penSize);
    canvas.line(pmouseX, pmouseY, mouseX, mouseY);
  }

  if (mouseButton == RIGHT || (mouseButton == LEFT && currentTool == ERASER)) {
    canvas.stroke(255);
    canvas.strokeWeight(eraserSize);
    canvas.line(pmouseX, pmouseY, mouseX, mouseY);
  }
}

void adjustSize(int change) {
  if (currentTool == ERASER || (mousePressed && mouseButton == RIGHT)) {
    eraserSize = constrain(eraserSize + change * 2, 2, 100);
  } else {
    penSize = constrain(penSize + change, 1, 50);
  }
}

void mousePressed() {
  if (overRect(paletteBtnX, paletteBtnY, paletteBtnW, paletteBtnH)) {
    showPalette = !showPalette;
    uiClick = true;
    return;
  }

  if (showPalette && overRect(palettePanelX, palettePanelY, palettePanelW, palettePanelH)) {
    uiClick = true;
    for (int i = 0; i < palette.length; i++) {
      if (overRect(swatchX(i), swatchY, swatchSize, swatchSize)) {
        currentColor = palette[i];
        showPalette = false;
        if (currentTool == ERASER) {
          currentTool = PENCIL;
        }
      }
    }
    return;
  }

  showPalette = false;

  for (int i = 0; i < numTools; i++) {
    if (overRect(toolBtnX, toolBtnY(i), toolBtnSize, toolBtnSize)) {
      currentTool = i;
      uiClick = true;
      return;
    }
  }

  if (overRect(toolbarX, toolbarY, toolbarW, toolbarH)) {
    uiClick = true;
    return;
  }

  if (overRect(settingsBtnX, settingsBtnY, settingsBtnSize, settingsBtnSize)) {
    showSettings = !showSettings;
    uiClick = true;
    return;
  }

  if (showSettings && overRect(panelX, panelY, panelW, panelH)) {
    uiClick = true;

    if (overRect(trackX1 - 10, trackY - 14, trackX2 - trackX1 + 20, 28)) {
      draggingSlider = true;
      updateSlider();
    }

    if (overRect(themeX, themeY, themeW, themeH)) {
      darkMode = !darkMode;
      updateColors();
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
  adjustSize(-event.getCount() * sensitivity);
}

void updateBox() {
  if (controlsHidden) {
    boxW = 44;
    boxH = 42;
  } else {
    boxW = 230;
    boxH = 181;
  }
  boxX = width - boxW - 10;

  settingsBtnX = boxX + boxW - 36;
  settingsBtnY = boxY + 8;

  panelY = boxY + boxH + 8;
  trackY = panelY + 58;
  themeY = panelY + 84;
}

void drawControls() {
  stroke(lineColor);
  strokeWeight(1);
  fill(panelColor);
  rect(boxX, boxY, boxW, boxH, 8);

  if (controlsHidden == false) {
    fill(textColor);
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
