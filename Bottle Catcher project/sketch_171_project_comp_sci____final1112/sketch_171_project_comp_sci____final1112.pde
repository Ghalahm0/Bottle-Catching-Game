// This is all referenced from java.com, and class notes like lab 2 and lab 3.


PImage waste_bin, recycable_bin, compost_bin, special_coin;     //load images 
PImage background1 ;

int canvasWidth = 800;    //canvas dimensions
int canvasHeight = 600;

int binWidth = 100;     //setting bin dimensions and gap
int binHeight = 50;
int binGap = 10;

// setting garbage size and spawn rate
int garbageSize = 30;            
int maxGarbageSpawnRate = 200; 
int minGarbageSpawnRate = 200;  
int garbageSpawnRate = maxGarbageSpawnRate;

//setting garbage speed and how much the speed increases per level
float garbageSpeed = 1;
float speedIncreasePerLevel = 0.01;
int garbageSpeedIncreaseInterval = 10;

// setting the spawn rate of the special coin
int specialCoinSpawnRate = 1500; 
int specialCoinCounter = 0; 

// setting the three bins and their position
int compostBinX, wasteBinX, recyclingBinX;
int compostBinY, wasteBinY, recyclingBinY;

// setting the score and the maximum attempts it can take to lose
int score = 0;
int incorrectAttempts = 0;
int maxIncorrectAttempts = 3;
int level = 1;


ArrayList<Garbage> garbageList = new ArrayList<Garbage>();   //list to store the elements for the game
ArrayList<Bin> bins = new ArrayList<Bin>();
boolean gameStarted = false;                               // this is the flags for the game stats
boolean gameOver = false;

void setup() {
 size(600, 600);
  
  //loading and importing images for game elements
  waste_bin = loadImage("black bag icon.png");
  recycable_bin = loadImage("garbage bag recycable green.png");
  compost_bin = loadImage("GBblue.jpg");
  special_coin = loadImage("coin special.png");
  
 
  // loading background  image and resizing it to fit the canvas
  background1 = loadImage("background 171.jpg");
  background1.resize(canvasWidth, canvasHeight);
  
  
  // calculating the initial postions for the bins
  compostBinX = (canvasWidth - 3 * binWidth - 2 * binGap) / 2;
  wasteBinX = compostBinX + binWidth + binGap;
  recyclingBinX = wasteBinX + binWidth + binGap;

  compostBinY = wasteBinY = recyclingBinY = canvasHeight - binHeight - 20;
  
  
  // creating bins and adding them to the arraylist
  bins.add(new Bin(compostBinX, compostBinY, binWidth, binHeight, color(100, 200, 100), recycable_bin));
  bins.add(new Bin(wasteBinX, wasteBinY, binWidth, binHeight, color(200, 100, 100), waste_bin));
  bins.add(new Bin(recyclingBinX, recyclingBinY, binWidth, binHeight, color(100, 100, 200), compost_bin));
}

void draw() {
  
image(background1, 0, 0);

  //checking if the game has started
  if (!gameStarted) {
    drawIntroScreen();
  } else {
    drawBins();
    drawScore();

// spawning garbage and special coin based on the framecount
    if (frameCount % garbageSpawnRate == 0) {
      spawnGarbage();
    }

    if (frameCount % specialCoinSpawnRate == 0) {
      spawnSpecialCoin();
    }

    moveGarbage();
    moveSpecialCoin();
    moveBins();
    checkCollision();
    
    //increasing garbage speed
    if (level % garbageSpeedIncreaseInterval == 0) {
      garbageSpeed += speedIncreasePerLevel;
    }
    
    // Adjust spawn rate based on level
    garbageSpawnRate = max(maxGarbageSpawnRate - (level - 1), minGarbageSpawnRate);
    
    // Added to handle game levels
    checkLevelUp();
    
    // Check for game over
    checkGameOver();
  }
}

// this is the function for drawing the starting screen
void drawIntroScreen() {
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(30);
  text("Welcome to my 171 project", width / 2, height / 2 - 30);
  textSize(20);
  text("Press any key to enter", width / 2, height / 2 + 10);
}

//function to pressing key
void keyPressed() {
  if (!gameOver) {
    gameStarted = true;
  }
}

//function to drawing bins on the screen
void drawBins() {
  for (Bin bin : bins) {
    bin.display();
  }
}

//function to drawing the score on the screen
void drawScore() {
  fill(0);
  textSize(20);
  text("Score: " + score, 20, 30);
  text("Incorrect Attempts: " + incorrectAttempts + " / " + maxIncorrectAttempts, 20, 60);
}

//function for checking for level up
void checkLevelUp() {
  if (score > 0 && score % 5 == 0) {
    level++;
  }
}


//function for checking if the game was over
void checkGameOver() {
  if (incorrectAttempts >= maxIncorrectAttempts) {
    fill(255, 0, 0);
    textSize(40);
    textAlign(CENTER, CENTER);
    text("Game Over. Press 'R' to restart.", width / 2, height / 2);
    noLoop(); 
    gameOver = true;
  }
}

void keyReleased() {
  if (gameOver && (key == 'R' || key == 'r')) {
    restartGame();
  }
}


// function to restart the game, reset game statistics and clear garbage list
void restartGame() {
  
  score = 0;
  incorrectAttempts = 0;
  level = 1;
  garbageList.clear();
  gameOver = false;
  garbageSpeed = 0.5;
  garbageSpeedIncreaseInterval = 10;
  specialCoinSpawnRate = 1500;

      
  loop();
}

class Garbage {
  float x, y;
  PImage image;
  int binColor;

// garbage properties
  Garbage(PImage image, int binColor) {
    this.x = random(width - garbageSize);
    this.y = 0;
    this.image = image;
    this.binColor = binColor;
  }

//function to display garbage on the screen
  void display() {
    fill(0);
    ellipse(x, y, garbageSize, garbageSize);
    image(image, x - garbageSize / 2, y - garbageSize / 2, garbageSize, garbageSize);
  }

//function to move garbage downwards
  void move() {
    y += garbageSpeed;
  }
}

// class represting bins
class Bin {
  float x, y, width, height;
  int binColor;
  PImage image;

  Bin(float x, float y, float width, float height, int binColor, PImage image) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.binColor = binColor;
    this.image = image;
  }

  void display() {
    fill(binColor);
    rect(x, y, width, height);
    image(image, x, y, width, height);
  }
}

class SpecialCoin extends Garbage {
  SpecialCoin() {
    super(special_coin, color(255, 215, 0)); // Gold color
  }
}

void spawnGarbage() {
  int randomBin = int(random(bins.size()));
  Garbage garbage = new Garbage(bins.get(randomBin).image, bins.get(randomBin).binColor);
  garbageList.add(garbage);
}

void spawnSpecialCoin() {
  SpecialCoin coin = new SpecialCoin();
  garbageList.add(coin);
}

void moveGarbage() {
  for (Garbage garbage : new ArrayList<Garbage>(garbageList)) {
    garbage.move();
    garbage.display();
    
    
    if (garbage.y > canvasHeight) {
      garbageList.remove(garbage);
      
      incorrectAttempts++;
    }
  }
}

// function to move special coin downward
void moveSpecialCoin() {
  for (Garbage garbage : new ArrayList<Garbage>(garbageList)) {
    if (garbage instanceof SpecialCoin) {
      SpecialCoin coin = (SpecialCoin) garbage;
      coin.move();
      coin.display();

      
      if (coin.y > canvasHeight) {
        garbageList.remove(coin);
      }
    }
  }
}


// function to move the bins to the side horizontally
void moveBins() {
  if (keyPressed) {
    if (keyCode == LEFT) {
      for (Bin bin : bins) {
        bin.x -= 5;
      }
    } else if (keyCode == RIGHT) {
      for (Bin bin : bins) {
        bin.x += 5;
      }
    }
  }
}

void checkCollision() {
  for (Garbage garbage : new ArrayList<Garbage>(garbageList)) {
    if (garbage instanceof SpecialCoin) {
      SpecialCoin coin = (SpecialCoin) garbage;
      for (Bin bin : bins) {
        if (coin.y > canvasHeight - bin.height && coin.y < canvasHeight) {
          if (coin.x > bin.x && coin.x < bin.x + bin.width) {
            garbageList.remove(coin);
            activateSpecialPower();
          }
        }
      }
    } else {
      for (Bin bin : bins) {
        if (garbage.y > canvasHeight - bin.height && garbage.y < canvasHeight) {
          if (garbage.x > bin.x && garbage.x < bin.x + bin.width) {
            garbageList.remove(garbage);
            score += 1;
          }
        }
      }
    }
  }
}

// function for the special power to activate when catching the coin which is plus 10
void activateSpecialPower() {
 
  score += 10;
}
void activateSpecialCoinEffect() {
  for (Garbage garbage : new ArrayList<Garbage>(garbageList)) {
    if (garbage instanceof SpecialCoin) {
      garbageList.remove(garbage);
      score += 3; 
      gravitationalPull();
    }
  }
}

void gravitationalPull() {
  float gravity = 0.1;
  for (Garbage garbage : garbageList) {
    if (!(garbage instanceof SpecialCoin)) {
      float d = dist(garbage.x, garbage.y, bins.get(0).x + bins.get(0).width / 2, bins.get(0).y + bins.get(0).height / 2);
      float force = gravity / d;
      float directionX = (bins.get(0).x + bins.get(0).width / 2 - garbage.x) / d;
      float directionY = (bins.get(0).y + bins.get(0).height / 2 - garbage.y) / d;
      garbage.x += force * directionX;
      garbage.y += force * directionY;
    }
  }
}
