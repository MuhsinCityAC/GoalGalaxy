Table matches;
int getTotalGoals(int homeGoals, int awayGoals) {
  return homeGoals + awayGoals;
}

void setup() {
  size(900, 650);

  matches = loadTable("E0.csv", "header");

  if (matches == null) {
    println("Could not load E0.csv. Check the data folder.");
    exit();
  }

  println("Matches loaded: " + matches.getRowCount());
  noLoop();
}

void draw() {
  background(12, 18, 40);

  fill(255);
  textAlign(CENTER);
  textSize(28);
  text("THE GOAL GALAXY", width / 2, 40);

  textSize(14);
  fill(190);
  text("Real Premier League match results, 2024–2025",
       width / 2, 65);

  int total = matches.getRowCount();
  int displayed = 0;

  for (int i = 0; i < total; i++) {
    TableRow match = matches.getRow(i);

    String homeText = match.getString("FTHG");
    String awayText = match.getString("FTAG");

    if (homeText == null || awayText == null ||
        homeText.length() == 0 || awayText.length() == 0) {
      continue;
    }

    int homeGoals = match.getInt("FTHG");
    int awayGoals = match.getInt("FTAG");

    float x = 45 + (displayed % 20) * 42;
    float y = 115 + (displayed / 20) * 42;

    float circleSize = 12 + getTotalGoals(homeGoals, awayGoals) * 3;

    if (homeGoals > awayGoals) {
      fill(50, 140, 255);
    } else if (awayGoals > homeGoals) {
      fill(255, 75, 90);
    } else {
      fill(255, 205, 65);
    }

    noStroke();
    ellipse(x, y, circleSize, circleSize);
    displayed++;
  }

  fill(255);
  textAlign(LEFT);
  textSize(14);
  text("Matches visualised: " + displayed, 30, height - 20);
  
  // Legend
textSize(14);
textAlign(LEFT);

// Blue = Home win
fill(50, 140, 255);
ellipse(220, 565, 13, 13);
fill(255);
text("Home win", 235, 570);

// Red = Away win
fill(255, 75, 90);
ellipse(350, 565, 13, 13);
fill(255);
text("Away win", 365, 570);

// Yellow = Draw
fill(255, 205, 65);
ellipse(480, 565, 13, 13);
fill(255);
text("Draw", 495, 570);
}
