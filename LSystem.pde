class LSystem {


  float SEGMENTLENGTH = 4;
  static final int ALPHA = 96;


  String seed;
  float angle;
  int iterations;
  String[] rules = new String[255];
  String expandedSystem;
  boolean firstDraw, firstPoint;

  float minX=Float.MAX_VALUE, minY=Float.MAX_VALUE, maxX=-Float.MAX_VALUE, maxY=-Float.MAX_VALUE;
  float firstX, firstY;
  float scaleX, scaleY, scale;


  LSystem(String jsondata) {

    firstDraw = true;
    firstPoint = true;

    rules['+'] = "+";
    rules['-'] = "-";
    rules['['] = "[";
    rules[']'] = "]";
    for (char f='A'; f<='Z'; f++) {
      rules[f] = f+"";
    }

    lsystemTweet = processing.data.JSONObject.parse(jsondata);

    seed = lsystemTweet.getString("start");
        
    angle = lsystemTweet.hasKey("a") ? lsystemTweet.getInt("a") : 60;
    iterations = lsystemTweet.hasKey("iter") ? lsystemTweet.getInt("iter") : 5;  

    processing.data.JSONObject JSOrules = lsystemTweet.getJSONObject("rules");
    java.util.Iterator keyIterator = JSOrules.keyIterator();
    while (keyIterator.hasNext ()) {
      String key = (String)keyIterator.next();
      rules[key.charAt(0)] = JSOrules.getString(key);
    }

    expandedSystem = expandRules();
  }



  String expandRules() {

    int currentIteration = 0;
    String system = seed;

    while (currentIteration < iterations) {

      String newSystem = "";

      for (int f=0; f<system.length (); f++) {

        char key = system.charAt(f);
        String app = rules[key];
        newSystem = newSystem.concat(app);

      }

      system = newSystem;
      currentIteration++;
    }

    return system;
  }



  void draw(float currAngle, boolean invert) {

    stroke(invert ? 255 : 0, ALPHA);

    if (firstDraw) {
      currAngle = radians(lsystem.angle);
    } else {

      //Debugging hints
//      line(0, 0, width, height);
//      line(0, height, width, 0);
//      noFill();    
//      pushMatrix();
//      strokeWeight(3);
//      translate(width/2, height/2);
//      rect(-(maxX-minX)*scale/2, -(maxY-minY)*scale/2, (maxX-minX)*scale, (maxY-minY)*scale);
//      strokeWeight(1);
//      popMatrix();

      translate(width/2 -(maxX+minX)*scale/2+firstX, 
      height/2-(maxY+minY)*scale/2+firstY);

      //Debugging hints
//      ellipse (0,0,18,18);

    }

    
    for (int f=0; f<expandedSystem.length (); f++) {
      char c = expandedSystem.charAt(f);
      switch (c) {
      case 'F':

        if (firstPoint) {
          firstX  = modelX(0, 0, 0);
          firstY = modelY(0, 0, 0);
          //println(firstX + ", " + firstY);
          firstPoint = false;
        }

        line(0, 0, 0, -SEGMENTLENGTH);
        translate(0, -SEGMENTLENGTH);
        break;
      case '+':
        rotate(currAngle);
        break;
      case '-':
        rotate(-currAngle);
        break;
      case '[':
        pushMatrix();
        break;
      case ']':
        popMatrix();
        break;
      }

      if (firstDraw) {
        float modelX = modelX(0, 0, 0);
        float modelY = modelY(0, 0, 0);
        if (modelX < minX) {
          minX = modelX;
        }
        if (modelY < minY) {
          minY = modelY;
        }
        if (modelX > maxX) {
          maxX = modelX;
        }
        if (modelY > maxY) {
          maxY = modelY;
        }
      }
    }

    if (firstDraw) {
      firstDraw = false;
      scaleX = (maxX-minX) > 0 ? (width / (maxX-minX)) : Float.MAX_VALUE;
      scaleY = (maxY-minY) > 0 ? (height / (maxY-minY)) : Float.MAX_VALUE;

      println("Min: (" + minX + "," + minY + ")");
      println("Max: (" + maxX + "," + maxY + ")");
      println("Scale: (" + scaleX + "," + scaleY + ")");
      scale = min(scaleX, scaleY) * 0.7;
      SEGMENTLENGTH *= scale;
      println("SEGMENTLENGTH = " + SEGMENTLENGTH);
    }
  }
}

