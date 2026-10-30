Table matches;

int totalGoals = 0;
int totalMatches = 0;

int homeWins = 0;
int awayWins = 0;
int draws = 0;

int totalHomeGoals = 0;
int totalAwayGoals = 0;
int invalidRows = 0;

// Calculate the total goals in a match
int getTotalGoals(int homeGoals, int awayGoals) 
  {return homeGoals + awayGoals;}

void setup() 
  {size(1300, 1200);

  matches = loadTable("E0.csv", "header");

  if (matches == null) {
    println("ERROR: Could not load E0.csv.");
    println("Check that E0.csv is inside the data folder.");
    exit();
    return;}

  println("CSV rows loaded: " + matches.getRowCount());

  // Check required columns
  if (matches.getColumnIndex("FTHG") == -1 ||
      matches.getColumnIndex("FTAG") == -1 ||
      matches.getColumnIndex("Date") == -1) {
    println("ERROR: Required CSV columns are missing.");
    exit();
    return;}

  noLoop();}

void draw() 
  {background(12, 18, 40);

  // Reset statistics
  totalGoals = 0;
  totalMatches = 0;
  homeWins = 0;
  awayWins = 0;
  draws = 0;
  totalHomeGoals = 0;
  totalAwayGoals = 0;
  invalidRows = 0;

  // Title
  fill(255);
  textAlign(CENTER);
  textSize(30);
  text("THE GOAL GALAXY", width / 2, 45);

  textSize(15);
  fill(190);
  text("Premier League | 2024-2025",
       width / 2, 72);

  // Statistics panel
  noStroke();
  fill(20, 30, 60);
  rect(25, 105, 1250, 130, 12);

  int totalRows = matches.getRowCount();
  int displayed = 0;

  // Process the football data
  for (int i = 0; i < totalRows; i++) 

    {TableRow match = matches.getRow(i);

    String homeText = match.getString("FTHG");
    String awayText = match.getString("FTAG");

    // Validate both score fields
    if (homeText == null || awayText == null ||
        homeText.trim().length() == 0 ||
        awayText.trim().length() == 0) 

     { invalidRows++;
      continue;}

    int homeGoals;
    int awayGoals;

    try 
      {homeGoals = Integer.parseInt(homeText.trim());
      awayGoals = Integer.parseInt(awayText.trim());}
   
    catch (Exception e) 
      {invalidRows++;
      continue;}

    // Reject impossible negative scores
    if (homeGoals < 0 || awayGoals < 0) 
      {invalidRows++;
      continue;}

    // Calculate statistics
    totalGoals += getTotalGoals(homeGoals, awayGoals);
    totalMatches++;

    totalHomeGoals += homeGoals;
    totalAwayGoals += awayGoals;

    if (homeGoals > awayGoals) 
      {homeWins++;}
    else if (awayGoals > homeGoals) 
      {awayWins++;}
    else 
      {draws++;}

    // Arrange circles in a grid
    float x = 45 + (displayed % 20) * 63;
    float y = 285 + (displayed / 20) * 26;

    // More goals = larger circle
    float circleSize =
      8 + getTotalGoals(homeGoals, awayGoals) * 2;

    // Blue = home win, red = away win, yellow = draw
    if (homeGoals > awayGoals) 
      {fill(50, 140, 255);}
    else if (awayGoals > homeGoals) 
      {fill(255, 75, 90);}
    else 
      {fill(255, 205, 65);}

    noStroke();
    ellipse(x, y, circleSize, circleSize);

    displayed++;}

  // Calculate average goals
  float averageGoals = 0;

  if (totalMatches > 0) 
    {averageGoals = (float) totalGoals / totalMatches;}

  // Display statistics
  fill(255);
  textAlign(CENTER);
  textSize(16);

  text("Season: 2024-2025", 650, 135);

  text("Matches: " + totalMatches,
       200, 170);

  text("Total goals: " + totalGoals,
       440, 170);

  text("Average goals: " + nf(averageGoals, 0, 2),
       700, 170);

  text("Home wins: " + homeWins,
       200, 205);

  text("Away wins: " + awayWins,
       440, 205);

  text("Draws: " + draws,
       700, 205);

  // Visualisation information
  fill(200);
  textAlign(LEFT);
  textSize(14);

  text("Matches visualised: " + displayed,
       30, 795);

  // Legend
  textSize(15);

  fill(50, 140, 255);
  ellipse(220, 825, 14, 14);
  fill(255);
  text("Home win", 235, 830);

  fill(255, 75, 90);
  ellipse(365, 825, 14, 14);
  fill(255);
  text("Away win", 380, 830);

  fill(255, 205, 65);
  ellipse(510, 825, 14, 14);
  fill(255);
  text("Draw", 525, 830);

  // Home goals versus away goals chart
  float chartX = 100;
  float chartY = 925;
  float chartWidth = 500;
  float barHeight = 28;

  int maxGoals = max(totalHomeGoals, totalAwayGoals);

  fill(255);
  textAlign(CENTER);
  textSize(20);

  text("HOME GOALS VS AWAY GOALS",
       chartX + chartWidth / 2, 885);

  if (maxGoals > 0) {

    // Home goals
    fill(255);
    textAlign(LEFT);
    textSize(16);

    text("Home goals: " + totalHomeGoals,
         chartX, chartY);

    fill(50, 140, 255);

    rect(chartX, chartY + 10,
         chartWidth * totalHomeGoals / maxGoals,
         barHeight);

    // Away goals
    fill(255);

    text("Away goals: " + totalAwayGoals,
         chartX, chartY + 65);

    fill(255, 75, 90);

    rect(chartX, chartY + 75,
         chartWidth * totalAwayGoals / maxGoals,
         barHeight);}

  // Data validation report
  fill(180);
  textSize(13);
  textAlign(LEFT);

  text("CSV rows: " + totalRows,
       750, 955);

  text("Valid matches: " + totalMatches,
       750, 980);

  text("Invalid or incomplete rows: " + invalidRows,
       750, 1005);

  // Source credit
  text("Data source: Football-Data.co.uk",
       30, 1155);

  // Check the results
  println("----- GOAL GALAXY DATA REPORT -----");
  println("CSV rows: " + totalRows);
  println("Valid matches: " + totalMatches);
  println("Invalid rows: " + invalidRows);
  println("Total goals: " + totalGoals);
  println("Home wins: " + homeWins);
  println("Away wins: " + awayWins);
  println("Draws: " + draws);
  println("Average goals: " + nf(averageGoals, 0, 2));

  println("Outcome total: " +
          (homeWins + awayWins + draws));

  if (homeWins + awayWins + draws == totalMatches) 
    {println("PASS: Match outcomes add up correctly.");}
  else 
    {println("WARNING: Match outcome totals do not match.");}
  }
