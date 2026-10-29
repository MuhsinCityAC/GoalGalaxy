Table matches;

int totalGoals = 0;
int totalMatches = 0;

int homeWins = 0;
int awayWins = 0;
int draws = 0;

int totalHomeGoals = 0;
int totalAwayGoals = 0;

// Calculate the total goals in a match
int getTotalGoals(int homeGoals, int awayGoals) {
  return homeGoals + awayGoals;
}

void setup() {
  size(1300, 1200);

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

  // Reset statistics before processing the CSV
  totalGoals = 0;
  totalMatches = 0;
  homeWins = 0;
  awayWins = 0;
  draws = 0;
  totalHomeGoals = 0;
  totalAwayGoals = 0;

  // Main title
  fill(255);
  textAlign(CENTER);
  textSize(28);
  text("THE GOAL GALAXY", width / 2, 40);

  textSize(14);
  fill(190);
  text("Real Premier League match results, 2024-2025",
       width / 2, 65);

  // Statistics panel
  noStroke();
  fill(20, 30, 60);
  rect(20, 115, 860, 90, 12);

  // Process the CSV data
  int total = matches.getRowCount();
  int displayed = 0;

  for (int i = 0; i < total; i++) {
    TableRow match = matches.getRow(i);

    String homeText = match.getString("FTHG");
    String awayText = match.getString("FTAG");

    // Skip rows with missing goal data
    if (homeText == null || awayText == null ||
        homeText.trim().length() == 0 ||
        awayText.trim().length() == 0) {
      continue;
    }

    int homeGoals = match.getInt("FTHG");
    int awayGoals = match.getInt("FTAG");

    // Calculate match statistics
    totalGoals += getTotalGoals(homeGoals, awayGoals);
    totalMatches++;

    totalHomeGoals += homeGoals;
    totalAwayGoals += awayGoals;

    if (homeGoals > awayGoals) {
      homeWins++;
    } else if (awayGoals > homeGoals) {
      awayWins++;
    } else {
      draws++;
    }

    // Position the match circles
    float x = 60 + (displayed % 20) * 61;
    float y = 300 + (displayed / 20) * 25;

    // Larger circles represent more goals
    float circleSize =
      8 + getTotalGoals(homeGoals, awayGoals) * 2;

    // Blue = home win
    // Red = away win
    // Yellow = draw
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

  // Statistics panel text
  fill(255);
  textAlign(CENTER);
  textSize(16);

  text("Season: 2024-2025", 650, 135);
  text("Matches: " + totalMatches, 230, 170);
  text("Total goals: " + totalGoals, 420, 170);

  if (totalMatches > 0) {
    float averageGoals =
      (float) totalGoals / totalMatches;

    text("Average goals: " +
         nf(averageGoals, 0, 2), 650, 170);
  } else {
    text("Average goals: 0.00", 650, 170);
  }

  text("Home wins: " + homeWins, 650, 195);

  // Match count
  fill(255);
  textAlign(LEFT);
  textSize(14);
  text("Matches visualised: " + displayed,
       30, height - 20);

  // LEGEND
  textSize(14);
  textAlign(LEFT);

  // Home win
  fill(50, 140, 255);
  ellipse(220, 800, 13, 13);
  fill(255);
  text("Home win", 235, 805);

  // Away win
  fill(255, 75, 90);
  ellipse(350, 800, 13, 13);
  fill(255);
  text("Away win", 365, 805);

  // Draw
  fill(255, 205, 65);
  ellipse(480, 800, 13, 13);
  fill(255);
  text("Draw", 495, 805);

  // HOME GOALS VS AWAY GOALS CHART
  float chartX = 100;
  float chartY = 900;
  float chartWidth = 500;
  float barHeight = 25;

  int maxGoals =
    max(totalHomeGoals, totalAwayGoals);

  if (maxGoals > 0) {

    // Chart title
    fill(255);
    textAlign(CENTER);
    textSize(18);

    text("HOME GOALS VS AWAY GOALS",
         chartX + chartWidth / 2, 860);

    // Home goals label
    fill(255);
    textAlign(LEFT);
    textSize(16);

    text("Home goals: " + totalHomeGoals,
         chartX, chartY);

    // Home goals bar
    fill(50, 140, 255);

    rect(chartX, chartY + 10,
         chartWidth * totalHomeGoals / maxGoals,
         barHeight);

    // Away goals label
    fill(255);

    text("Away goals: " + totalAwayGoals,
         chartX, chartY + 60);

    // Away goals bar
    fill(255, 75, 90);

    rect(chartX, chartY + 70,
         chartWidth * totalAwayGoals / maxGoals,
         barHeight);
  }
}
```
