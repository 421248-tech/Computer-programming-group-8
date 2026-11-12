//Ian Hundley

int PENCIL = 0;
int ERASER = 1;
int FILL = 2;
int numTools = 3;
int currentTool = PENCIL;

color[] palette = {
  color(0), color(230, 40, 40), color(255, 140, 0), color(255, 210, 0),
  color(40, 170, 70), color(40, 100, 230), color(75, 0, 130), color(150, 64, 200)
};
color currentColor = color(0);
boolean showPalette = false;

int toolbarX = 10;
int toolbarY = 10;
int toolBtnSize = 40;
int toolBtnX = 18;
int toolbarW = 56;
int toolbarH = 160;

int paletteBtnX = 372;
int paletteBtnY = 10;
int paletteBtnW = 56;
int paletteBtnH = 30;
int swatchSize = 28;
int swatchY = 56;
int palettePanelX = 252;
int palettePanelY = 48;
int palettePanelW = 296;
int palettePanelH = 44;

int toolBtnY(int i) {
  return toolbarY + 8 + i * 48;
}

void drawToolbar() {
  stroke(lineColor);
  strokeWeight(1);
  fill(panelColor);
  rect(toolbarX, toolbarY, toolbarW, toolbarH, 8);

  for (int i = 0; i < numTools; i++) {
    int bx = toolBtnX;
    int by = toolBtnY(i);

    stroke(lineColor);
    strokeWeight(1);
    if (currentTool == i) {
      fill(activeColor);
    } else if (overRect(bx, by, toolBtnSize, toolBtnSize)) {
      fill(hoverColor);
    } else {
      fill(buttonColor);
    }
    rect(bx, by, toolBtnSize, toolBtnSize, 6);

    float cx = bx + toolBtnSize / 2;
    float cy = by + toolBtnSize / 2;
    if (i == PENCIL) {
      drawPencilIcon(cx, cy);
    }
    if (i == ERASER) {
      drawEraserIcon(cx, cy);
    }
    if (i == FILL) {
      drawFillIcon(cx, cy);
    }
  }
}

void drawPencilIcon(float x, float y) {
  stroke(0);
  strokeWeight(1);

  fill(250, 200, 60);
  quad(x - 12, y + 6, x - 6, y + 12, x + 10, y - 4, x + 4, y - 10);

  fill(235, 205, 160);
  triangle(x - 12, y + 6, x - 6, y + 12, x - 14, y + 14);

  fill(235, 130, 140);
  quad(x + 4, y - 10, x + 10, y - 4, x + 13, y - 7, x + 7, y - 13);
}

void drawEraserIcon(float x, float y) {
  stroke(0);
  strokeWeight(1);

  fill(240, 150, 165);
  rect(x - 12, y - 6, 14, 12, 3);

  fill(170, 175, 190);
  rect(x + 2, y - 6, 10, 12, 3);
}

void drawFillIcon(float x, float y) {
  stroke(0);
  strokeWeight(1);

  noFill();
  arc(x, y - 6, 18, 18, PI, TWO_PI);

  fill(90, 150, 230);
  quad(x - 9, y - 6, x + 9, y - 6, x + 6, y + 9, x - 6, y + 9);

  fill(40);
  rect(x - 9, y - 9, 18, 4, 2);

  noStroke();
  ellipse(x + 11, y + 8, 6, 6);
  triangle(x + 8.5, y + 6.5, x + 13.5, y + 6.5, x + 11, y + 1);
}

void floodFill(int startX, int startY) {
  canvas.beginDraw();
  canvas.loadPixels();

  color target = canvas.pixels[startY * width + startX];

  if (target != currentColor) {
    int[] listX = new int[width * height];
    int[] listY = new int[width * height];
    int count = 0;

    int[] dx = {1, -1, 0, 0};
    int[] dy = {0, 0, 1, -1};

    canvas.pixels[startY * width + startX] = currentColor;
    listX[count] = startX;
    listY[count] = startY;
    count++;

    while (count > 0) {
      count--;
      int x = listX[count];
      int y = listY[count];

      for (int i = 0; i < 4; i++) {
        int nx = x + dx[i];
        int ny = y + dy[i];

        if (nx >= 0 && nx < width && ny >= 0 && ny < height) {
          if (canvas.pixels[ny * width + nx] == target) {
            canvas.pixels[ny * width + nx] = currentColor;
            listX[count] = nx;
            listY[count] = ny;
            count++;
          }
        }
      }
    }
  }

  canvas.updatePixels();
  canvas.endDraw();
}

int swatchX(int i) {
  return palettePanelX + 8 + i * 36;
}

void drawColorButton() {
  stroke(lineColor);
  strokeWeight(1);
  if (showPalette) {
    fill(activeColor);
  } else if (overRect(paletteBtnX, paletteBtnY, paletteBtnW, paletteBtnH)) {
    fill(hoverColor);
  } else {
    fill(buttonColor);
  }
  rect(paletteBtnX, paletteBtnY, paletteBtnW, paletteBtnH, 6);

  stroke(lineColor);
  fill(currentColor);
  rect(paletteBtnX + 8, paletteBtnY + 7, 24, 16, 3);

  noStroke();
  fill(textColor);
  triangle(paletteBtnX + 38, paletteBtnY + 12, paletteBtnX + 48, paletteBtnY + 12, paletteBtnX + 43, paletteBtnY + 19);
}

void drawPalette() {
  stroke(lineColor);
  strokeWeight(1);
  fill(panelColor);
  rect(palettePanelX, palettePanelY, palettePanelW, palettePanelH, 8);

  for (int i = 0; i < palette.length; i++) {
    if (palette[i] == currentColor) {
      stroke(textColor);
      strokeWeight(3);
    } else {
      stroke(lineColor);
      strokeWeight(1);
    }
    fill(palette[i]);
    rect(swatchX(i), swatchY, swatchSize, swatchSize, 5);
  }
}
