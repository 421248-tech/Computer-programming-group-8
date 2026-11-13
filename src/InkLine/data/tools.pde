// Connor DeWeerd

int PENCIL = 0;
int ERASER = 1;
int FILL = 2;
int numTools = 3;
int currentTool = PENCIL;

PImage pencilImg;
PImage eraserImg;
PImage bucketImg;

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

    if (i == PENCIL) {
      image(pencilImg, bx + 4, by + 4, 32, 32);
    }
    if (i == ERASER) {
      image(eraserImg, bx + 4, by + 4, 32, 32);
    }
    if (i == FILL) {
      image(bucketImg, bx + 4, by + 4, 32, 32);
    }
  }
}

void floodFill(int startX, int startY) {
  if (startX < 0 || startX >= width || startY < 0 || startY >= height) {
    return;
  }

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
