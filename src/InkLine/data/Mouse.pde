//Ian Hundley
int penSize = 3;           // current pen thickness
int eraserSize = 20;       // current eraser thickness
boolean uiClick = false;   // true when a click started on the UI (so we don't draw)

// Controls box layout (changes size when hidden)
int boxW, boxH, boxX, boxY;
final int FULL_W = 230;
final int FULL_H = 181;
final int HIDDEN_W = 44;
final int HIDDEN_H = 42;
boolean controlsHidden = false;  // when true, only the settings button stays visible

// ---------- Drawing ----------

// Draws one segment of pencil or eraser stroke (call between canvas.beginDraw/endDraw)
void drawStroke() {
  // Right mouse button always erases; left button uses the selected tool
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

// True when the eraser is the tool currently in use
boolean usingEraser() {
  return (mousePressed && mouseButton == RIGHT) || currentTool == ERASER;
}

// Change the thickness of whichever tool is in use (change can be negative)
void adjustSize(int change) {
  if (usingEraser()) {
    eraserSize = constrain(eraserSize + change * 2, 2, 100);
  } else {
    penSize = constrain(penSize + change, 1, 50);
  }
}

// ---------- Mouse input ----------

void mousePressed() {
  // Color button: open or close the palette
  if (overRect(cpBtnX(), cpBtnY(), CP_BTN_W, CP_BTN_H)) {
    showPalette = !showPalette;
    uiClick = true;
    return;
  }

  // Color palette: pick a color
  if (showPalette && overRect(cpPanelX(), cpPanelY(), cpPanelW(), cpPanelH())) {
    uiClick = true;
    for (int i = 0; i < palette.length; i++) {
      if (overRect(swatchX(i), swatchY(), CP_SWATCH, CP_SWATCH)) {
        currentColor = palette[i];
        showPalette = false;
        // Picking a color while the eraser is selected switches back to the pencil
        if (currentTool == ERASER) currentTool = PENCIL;
      }
    }
    return;
  }

  // Clicking anywhere else closes the palette
  showPalette = false;

  // Tool buttons
  for (int i = 0; i < NUM_TOOLS; i++) {
    if (overRect(toolBtnX(), toolBtnY(i), TB_BTN, TB_BTN)) {
      currentTool = i;
      uiClick = true;
      return;
    }
  }

  // Anywhere else on the toolbar: don't draw underneath it
  if (overRect(TB_X, TB_Y, toolbarW(), toolbarH())) {
    uiClick = true;
    return;
  }

  // Settings button
  if (overRect(btnX(), btnY(), btnS(), btnS())) {
    showSettings = !showSettings;
    uiClick = true;
    return;
  }

  // Settings panel
  if (showSettings && overRect(panelX(), panelY(), panelW(), panelH())) {
    uiClick = true;

    // Slider
    if (overRect(trackX1() - 10, trackY() - 14, trackX2() - trackX1() + 20, 28)) {
      draggingSlider = true;
      updateSlider();
    }

    // Dark/light mode button
    if (overRect(themeX(), themeY(), themeW(), themeH())) {
      darkMode = !darkMode;
    }
    return;
  }

  // Anywhere else on the controls box: don't draw underneath it
  if (overRect(boxX, boxY, boxW, boxH)) {
    uiClick = true;
    return;
  }

  // Fill tool: left click fills the area under the mouse
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

// Scroll wheel changes the thickness of the current tool
void mouseWheel(MouseEvent event) {
  adjustSize(-(int) event.getCount() * sensitivity);
}

// ---------- Controls box ----------

// Resize the controls box depending on whether controls are hidden
void updateBox() {
  boxW = controlsHidden ? HIDDEN_W : FULL_W;
  boxH = controlsHidden ? HIDDEN_H : FULL_H;
  boxX = width - boxW - 10;
}

void drawControls() {
  // Box
  stroke(uiStroke());
  strokeWeight(1);
  fill(uiFill());
  rect(boxX, boxY, boxW, boxH, 8);

  // Text (only when controls are shown)
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

  // The settings button always stays visible
  drawSettingsButton();
}

// ---------- Keyboard shortcuts ----------

void keyPressed() {
  // Press 'c' to clear the canvas
  if (key == 'c' || key == 'C') {
    clearCanvas();
  }

  // Press 'h' to hide or show the controls
  if (key == 'h' || key == 'H') {
    controlsHidden = !controlsHidden;
    updateBox();
  }

  // Press 'p' for the pencil, 'e' for the eraser, 'f' for fill
  if (key == 'p' || key == 'P') {
    currentTool = PENCIL;
  }
  if (key == 'e' || key == 'E') {
    currentTool = ERASER;
  }
  if (key == 'f' || key == 'F') {
    currentTool = FILL;
  }

  // UP arrow or '+' makes the current tool thicker
  if (keyCode == UP || key == '+' || key == '=') {
    adjustSize(1);
  }

  // DOWN arrow or '-' makes the current tool thinner
  if (keyCode == DOWN || key == '-') {
    adjustSize(-1);
  }

  // ']' makes the eraser bigger
  if (key == ']') {
    eraserSize = min(eraserSize + 2, 100);
  }

  // '[' makes the eraser smaller
  if (key == '[') {
    eraserSize = max(eraserSize - 2, 2);
