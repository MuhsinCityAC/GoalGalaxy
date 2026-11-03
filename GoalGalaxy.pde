import java.util.ArrayList;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.util.Locale;

// GOAL GALAXY
// Premier League 2024-2025

Table matches;
ArrayList<FootballMatch> footballMatches =
  new ArrayList<FootballMatch>();

int totalGoals = 0;
int totalMatches = 0;

int homeWins = 0;
int awayWins = 0;
int draws = 0;

int totalHomeGoals = 0;
int totalAwayGoals = 0;

int invalidRows = 0;
int undatedMatches = 0;
int maxGoalsInMatch = 0;

// FOOTBALL MATCH CLASS

class FootballMatch 

  {String dateText;
  Date matchDate;

  int homeGoals;
  int awayGoals;
  int totalMatchGoals;

  FootballMatch(String dateText, Date matchDate,
                int homeGoals, int awayGoals) 

    {this.dateText = dateText;
    this.matchDate = matchDate;

    this.homeGoals = homeGoals;
    this.awayGoals = awayGoals;

    this.totalMatchGoals =
      getTotalGoals(homeGoals, awayGoals); }

  // Return the result of the match.
  String getResult() 

    {if (homeGoals > awayGoals) 
      {return "Home Win";}
     else if (awayGoals > homeGoals) 
      {return "Away Win";}
     else 
      {return "Draw";}
    }
  

  // Return the total number of goals.
  int getGoals() 
    {return totalMatchGoals;}
  }

// CALCULATE TOTAL GOALS

int getTotalGoals(int homeGoals, int awayGoals) 
  {return homeGoals + awayGoals;}

// SETUP

void setup() 

  {size(1300, 1200);

  matches = loadTable("E0.csv", "header");

  if (matches == null) 

    {println("ERROR: Could not load E0.csv.");
    println("Check that E0.csv is inside the data folder.");

    exit();
    return;}

  println("CSV rows loaded: " + matches.getRowCount());

  // Check required CSV columns.

  if (matches.getColumnIndex("FTHG") == -1 ||
      matches.getColumnIndex("FTAG") == -1 ||
      matches.getColumnIndex("Date") == -1) {

    println("ERROR: Required CSV columns are missing.");

    exit();
    return;}

  // Read and process the dataset.

  loadFootballData();

  // Display the report in the Processing console.

  printDataReport();

  // Draw the visualisation once.

  noLoop();}


// ==========================================
// LOAD AND VALIDATE FOOTBALL DATA
// ==========================================

void loadFootballData() {

  int totalRows = matches.getRowCount();

  for (int i = 0; i < totalRows; i++) 

    {TableRow row = matches.getRow(i);

    String homeText = row.getString("FTHG");
    String awayText = row.getString("FTAG");
    String dateText = row.getString("Date");

    // Check that both scores are present.

    if (homeText == null ||
        awayText == null ||
        homeText.trim().length() == 0 ||
        awayText.trim().length() == 0) {

      invalidRows++;
      continue;}

    int homeGoals;
    int awayGoals;

    // Convert scores into integers.

    try 

      {homeGoals = Integer.parseInt(homeText.trim());
      awayGoals = Integer.parseInt(awayText.trim());}

     catch (Exception e) 

      {invalidRows++;
      continue;}
    

    // Reject negative scores.

    if (homeGoals < 0 || awayGoals < 0) 

      {invalidRows++;
      continue;}
    

    // Parse the match date.

    Date matchDate = MatchDate(dateText);

    if (matchDate == null) 
      {undatedMatches++;}
    

    // Create a FootballMatch object.

    FootballMatch footballMatch =
      new FootballMatch(
        dateText,
        matchDate,
        homeGoals,
        awayGoals);
      

    footballMatches.add(footballMatch);

    // Calculate overall statistics.

    totalGoals += footballMatch.getGoals();
    totalMatches++;

    totalHomeGoals += homeGoals;
    totalAwayGoals += awayGoals;

    maxGoalsInMatch =
      max(maxGoalsInMatch, footballMatch.getGoals());

    // Count the match outcome.

    if (homeGoals > awayGoals) {

      homeWins++;}

     else if (awayGoals > homeGoals) 

      {awayWins++;}

     else 

      {draws++;}
    }
  }
// DIFFERENT DATE FORMATS

Date MatchDate(String dateText) {

  if (dateText == null ||
      dateText.trim().length() == 0) 

    {return null;}
  

  String[] formats = {
    "dd/MM/yyyy",
    "dd/MM/yy",
    "yyyy-MM-dd",
    "dd-MM-yyyy",
    "dd-MM-yy"  };


  for (int i = 0; i < formats.length; i++) 

    {try 

      {SimpleDateFormat formatter =
        new SimpleDateFormat(formats[i], Locale.UK);

      formatter.setLenient(false);

      return formatter.parse(dateText.trim());}

     catch (Exception e) {

// Try the next date format.
    }
  }

  return null;
}


// DRAW THE VISUALISATION

void draw() {

  background(12, 18, 40);

  // Title.

  fill(255);
  textAlign(CENTER, CENTER);
  textSize(34);

  text("THE GOAL GALAXY", width / 2, 38);

  textSize(16);
  fill(190);

  text(
    "Premier League | 2024-2025",
    width / 2,
    72
  );

  // Statistics panel.

  noStroke();
  fill(20, 30, 60);

  rect(25, 100, 1250, 125, 12);

  float averageGoals = 0;

  if (totalMatches > 0) {

    averageGoals =
      (float) totalGoals / totalMatches;
  }

  fill(255);
  textAlign(CENTER, CENTER);

  textSize(17);

  text("MATCH STATISTICS", width / 2, 122);

  textSize(16);

  text(
    "Matches: " + totalMatches,
    200, 158
  );

  text(
    "Total goals: " + totalGoals,
    440, 158
  );

  text(
    "Average goals: " + nf(averageGoals, 0, 2),
    700, 158
  );

  text(
    "Home wins: " + homeWins,
    200, 195
  );

  text(
    "Away wins: " + awayWins,
    440, 195
  );

  text(
    "Draws: " + draws,
    700, 195
  );

  // Main visualisation.

  drawTimeline();

  // Legend.

  drawLegend();

  // Home and away goals comparison.

  drawGoalsComparison();

  // Data validation information.

  drawValidationReport();

  // Source credit.

  fill(180);
  textAlign(LEFT, CENTER);
  textSize(13);

  text(
    "Data source: Football-Data.co.uk",
    30, 1160
  );
}


// TIMELINE VISUALISATION

void drawTimeline() {

  float chartX = 95;
  float chartY = 285;

  float chartWidth = 1120;
  float chartHeight = 350;

  float chartBottom = chartY + chartHeight;

  // Count matches with valid dates.

  int datedMatches = 0;

  long earliestDate = Long.MAX_VALUE;
  long latestDate = Long.MIN_VALUE;

  for (FootballMatch match : footballMatches) {

    if (match.matchDate != null) {

      datedMatches++;

      long time = match.matchDate.getTime();

      if (time < earliestDate) {
        earliestDate = time;
      }

      if (time > latestDate) {
        latestDate = time;
      }
    }
  }

  // Chart title.

  fill(255);
  textAlign(CENTER, CENTER);
  textSize(21);

  text(
    "MATCH GOALS ACROSS THE SEASON",
    width / 2,
    255
  );

  // Display information if dates cannot be used.

  if (datedMatches == 0) {

    fill(255);
    textSize(16);

    text(
      "No valid match dates were found.",
      width / 2,
      440
    );

    return;
  }

  int goalScale = max(6, maxGoalsInMatch);

  // Draw horizontal grid lines.

  stroke(55, 70, 100);
  strokeWeight(1);

  for (int goals = 0; goals <= goalScale; goals++) {

    float y =
      chartBottom -
      (goals / (float) goalScale) * chartHeight;

    line(chartX, y, chartX + chartWidth, y);

    fill(190);
    noStroke();

    textAlign(RIGHT, CENTER);
    textSize(12);

    text(goals, chartX - 12, y);

    stroke(55, 70, 100);
  }

  // Draw the chart axes.

  stroke(160);
  strokeWeight(2);

  line(
    chartX,
    chartY,
    chartX,
    chartBottom
  );

  line(
    chartX,
    chartBottom,
    chartX + chartWidth,
    chartBottom
  );

  // Axis labels.

  fill(210);
  noStroke();

  textAlign(CENTER, CENTER);
  textSize(14);

  text(
    "Match date",
    chartX + chartWidth / 2,
    chartBottom + 32
  );

  textAlign(CENTER, CENTER);

  text(
    "Total goals",
    38,
    chartY + chartHeight / 2
  );

  // Display the earliest and latest dates.

  String earliestText =
    formatDisplayDate(earliestDate);

  String latestText =
    formatDisplayDate(latestDate);

  textAlign(LEFT, CENTER);

  text(
    earliestText,
    chartX,
    chartBottom + 53
  );

  textAlign(RIGHT, CENTER);

  text(
    latestText,
    chartX + chartWidth,
    chartBottom + 53
  );

  // Plot each match as a circle.

  int matchIndex = 0;

  for (FootballMatch match : footballMatches) {

    if (match.matchDate == null) {
      continue;
    }

    long matchTime = match.matchDate.getTime();

    float x;

    if (latestDate == earliestDate) {

      x = chartX + chartWidth / 2;

    } else {

      double dateProgress =
        (matchTime - (double) earliestDate) /
        (latestDate - (double) earliestDate);

      x = chartX +
        (float) dateProgress * chartWidth;
    }

    // More goals appear higher on the chart.

    float y =
      chartBottom -
      (match.getGoals() / (float) goalScale) *
      chartHeight;

    // Slight horizontal adjustment to help distinguish
    // matches played on the same date.

    x += (matchIndex % 5 - 2) * 2;

    // Circle size represents the total goals scored.

    float circleSize = min(
      24,
      8 + match.getGoals() * 1.5
    );

    // Blue = home win.
    // Red = away win.
    // Yellow = draw.

    if (match.homeGoals > match.awayGoals) {

      fill(50, 140, 255, 220);

    } else if (match.awayGoals > match.homeGoals) {

      fill(255, 75, 90, 220);

    } else {

      fill(255, 205, 65, 230);
    }

    noStroke();

    ellipse(
      x,
      y,
      circleSize,
      circleSize
    );

    matchIndex++;
  }

  // Explain the chart.

  fill(195);
  textAlign(CENTER, CENTER);
  textSize(12);

  text(
    "Each circle represents one match. " +
    "Higher circles indicate more goals.",
    width / 2,
    chartBottom + 78
  );
}


// FORMAT DATES FOR DISPLAY

String formatDisplayDate(long time) {

  if (time == Long.MAX_VALUE ||
      time == Long.MIN_VALUE) {

    return "Unknown";
  }

  SimpleDateFormat formatter =
    new SimpleDateFormat("dd/MM/yyyy", Locale.UK);

  return formatter.format(new Date(time));
}


// LEGEND


void drawLegend() {

  float y = 775;

  fill(255);
  textAlign(CENTER, CENTER);
  textSize(17);

  text("MATCH OUTCOMES", width / 2, 750);

  // Home win.

  fill(50, 140, 255);
  noStroke();

  ellipse(300, y, 15, 15);

  fill(255);
  textAlign(LEFT, CENTER);

  text("Home win", 315, y);

  // Away win.

  fill(255, 75, 90);

  ellipse(490, y, 15, 15);

  fill(255);

  text("Away win", 505, y);

  // Draw.

  fill(255, 205, 65);

  ellipse(680, y, 15, 15);

  fill(255);

  text("Draw", 695, y);

  // Circle size.

  fill(190);

  text(
    "Circle size represents total match goals",
    810, y
  );
}


// HOME GOALS VS AWAY GOALS

void drawGoalsComparison() {

  float chartX = 70;
  float chartY = 885;

  float chartWidth = 490;
  float barHeight = 28;

  int maxGoals = max(
    totalHomeGoals,
    totalAwayGoals
  );

  fill(255);
  textAlign(CENTER, CENTER);
  textSize(19);

  text(
    "HOME GOALS VS AWAY GOALS",
    chartX + chartWidth / 2,
    850
  );

  fill(255);
  textAlign(LEFT, CENTER);
  textSize(15);

  // Home goals label.

  text(
    "Home goals: " + totalHomeGoals,
    chartX,
    chartY
  );

  // Home goals bar.

  fill(50, 140, 255);

  float homeBarWidth = 0;

  if (maxGoals > 0) {

    homeBarWidth =
      chartWidth * totalHomeGoals / (float) maxGoals;
  }

  noStroke();

  rect(
    chartX,
    chartY + 15,
    homeBarWidth,
    barHeight,
    4
  );

  // Away goals label.

  fill(255);

  text(
    "Away goals: " + totalAwayGoals,
    chartX,
    chartY + 65
  );

  // Away goals bar.

  fill(255, 75, 90);

  float awayBarWidth = 0;

  if (maxGoals > 0) {

    awayBarWidth =
      chartWidth * totalAwayGoals / (float) maxGoals;
  }

  rect(
    chartX,
    chartY + 80,
    awayBarWidth,
    barHeight,
    4
  );
}


// DATA VALIDATION REPORT

void drawValidationReport() {

  float x = 700;
  float y = 875;

  fill(255);
  textAlign(LEFT, CENTER);
  textSize(18);

  text("DATA VALIDATION REPORT", x, y);

  fill(190);
  textSize(14);

  text(
    "CSV rows: " + matches.getRowCount(),
    x,
    y + 35
  );

  text(
    "Valid matches: " + totalMatches,
    x,
    y + 60
  );

  text(
    "Invalid or incomplete score rows: " + invalidRows,
    x,
    y + 85
  );

  text(
    "Matches without usable dates: " + undatedMatches,
    x,
    y + 110
  );

  // Verify the match outcomes.

  int outcomeTotal = homeWins + awayWins + draws;

  if (outcomeTotal == totalMatches) {

    fill(100, 230, 150);

    text(
      "PASS: Match outcomes add up correctly.",
      x,
      y + 145
    );

  } else {

    fill(255, 100, 100);

    text(
      "WARNING: Match outcome totals do not match.",
      x,
      y + 145
    );
  }

  // Check the observation requirement.

  if (totalMatches >= 100) {

    fill(100, 230, 150);

    text(
      "PASS: At least 100 valid match observations.",
      x,
      y + 175
    );

  } else {

    fill(255, 180, 90);

    text(
      "WARNING: Fewer than 100 valid observations.",
      x,
      y + 175
    );
  }
}


// PRINT DATA REPORT TO CONSOLE

void printDataReport() {

  float averageGoals = 0;

  if (totalMatches > 0) {

    averageGoals =
      (float) totalGoals / totalMatches;
  }

  println();
  println("====================================");
  println("       GOAL GALAXY DATA REPORT");
  println("====================================");

  println("CSV rows: " + matches.getRowCount());

  println("Valid matches: " + totalMatches);

  println("Invalid rows: " + invalidRows);

  println("Matches without usable dates: " +
          undatedMatches);

  println("Total goals: " + totalGoals);

  println("Home goals: " + totalHomeGoals);

  println("Away goals: " + totalAwayGoals);

  println("Home wins: " + homeWins);

  println("Away wins: " + awayWins);

  println("Draws: " + draws);

  println("Average goals: " + nf(averageGoals, 0, 2));

  println("Match objects created: " +
          footballMatches.size());

  println("Total outcomes: " +
          (homeWins + awayWins + draws));

  if (homeWins + awayWins + draws == totalMatches) {

    println("PASS: Match outcomes add up correctly.");

  } else {

    println("WARNING: Match outcome totals do not match.");
  }

  if (totalMatches >= 100) {

    println("PASS: At least 100 valid observations.");

  } else {

    println("WARNING: Fewer than 100 valid observations.");
  }

  println("====================================");
}
