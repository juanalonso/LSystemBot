import twitter4j.*;
import twitter4j.conf.*;
import java.util.*;


static final int LOOPLENGTH = 240;
static float ANGLEARC = radians(3)/2;
static final boolean SAVEMOVIE = false;
static final boolean INVERTCOLORS = true;
static final int REFRESHINTERVAL = 600000;


float angle, currAngle;
processing.data.JSONObject lsystemTweet;
long runningTime;


Twitter twitter;
LSystem lsystem;


void setup() {

  size(800, 800, P2D);
  smooth();
  frameRate(60);

  runningTime = -REFRESHINTERVAL;

  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey("");
  cb.setOAuthConsumerSecret("");
  cb.setOAuthAccessToken("");
  cb.setOAuthAccessTokenSecret("");

  TwitterFactory tf = new TwitterFactory(cb.build());
  twitter = tf.getInstance();
}



void draw() {

  if (millis()-runningTime >= REFRESHINTERVAL) {

    int parseTime = millis();

    String jsondata = getJSONFromTwitter();
    lsystem = new LSystem(jsondata);

    parseTime = millis() - parseTime;

    println("Generation time: " + parseTime + "ms");
    println("System length:   " + lsystem.expandedSystem.length() + " chars");

    angle = radians(lsystem.angle);
    currAngle = angle - ANGLEARC;

    runningTime = millis();
  }

  background(INVERTCOLORS ? 0 : 255);

  if (!SAVEMOVIE) {
    fill(INVERTCOLORS ? 255 : 0);
    text(lsystem.seed + " - " + degrees(currAngle), 10, 20);
  } 

  lsystem.draw(currAngle, INVERTCOLORS);

  if (frameCount % (LOOPLENGTH * 2) < LOOPLENGTH) {
    currAngle = easeFunction(frameCount % LOOPLENGTH, angle-ANGLEARC, ANGLEARC*2, LOOPLENGTH);
  } else {
    currAngle = easeFunction(frameCount % LOOPLENGTH, angle+ANGLEARC, -ANGLEARC*2, LOOPLENGTH);
  }

  if (SAVEMOVIE) {
    saveFrame("lsystem-"+lsystem.seed+"-######.tga");
  }
}



String getJSONFromTwitter() {

  String data = "";

  try {
    Paging paging = new Paging(1, 1);
    List<Status> statuses = twitter.getUserTimeline("lsystembot", paging);
    for (Status status : statuses) {
      //println(status);
      data = status.getText();
      System.out.println(data);
      data = trim(data.substring(0, data.indexOf("http://")));
    }
  } 
  catch (TwitterException te) {
    System.out.println("Failed to search tweets: " + te.getMessage());
  }

  //Test data.
  //data = "{\"start\":\"FFH\",\"rules\":{\"F\":\"FFFHI\",\"I\":\"\",\"H\":\"HCH-H+C\",\"C\":\"FI\"},\"a\":60,\"iter\":6}";
  //data = "{\"start\":\"YHYF\",\"rules\":{\"F\":\"+YF+FFFH+\",\"Y\":\"FFHY\",\"H\":\"[[]F-]H\"},\"a\":60,\"iter\":6} ";
  //data = "{\"start\":\"YK\",\"rules\":{\"F\":\"FC\",\"R\":\"KF\",\"K\":\"K-FYR\",\"C\":\"FKR+\",\"Y\":\"FK-F\"},\"a\":135,\"iter\":7}";
  //data = "{\"start\":\"FSQQ\",\"rules\":{\"F\":\"F[Y]F\",\"Q\":\"AF-FSFAF\",\"Y\":\"Y[+]ANFAF\",\"S\":\"YN[QNY]F+S\",\"N\":\"+F+FA-+YS\",\"A\":\"[A]+\"}}";
  //data = "{\"start\":\"NIIN\",\"rules\":{\"F\":\"F-[F]-\",\"I\":\"-\",\"N\":\"W\",\"W\":\"FI\",\"K\":\"FV+FVI\",\"V\":\"[-W]VFFNF\"},\"a\":45,\"iter\":10}";
  
  return data;
}



float easeFunction( float t, float b, float c, float d) {
  return -c/2 * (cos(PI*t/d) - 1) + b;
}

