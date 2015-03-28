# LSystemBot for Processing

This Processing sketch parses and animates the LSystems tweeted by [@LSystemBot](https://twitter.com/LSystemBot). The sketch does its best to center and scale the LSystem when drawing the middle frame.

![](http://media.giphy.com/media/xTiTngmPlvT75Ru0RG/giphy.gif)

You can set the following parameters:
* `LOOPLENGTH`: Number of frames per loop. The higher the number, the smoother the animation will be.
* `ANGLEARC`: The amount of *radians* per loop.
* `SAVEMOVIE`: If set to `true` each animation frame will be saved to disk. **Each**.
* `INVERTCOLORS`: `true`: black background, white lines. `false`: white background, black lines.
* `REFRESHINTERVAL`: the wait period between successive timeline checks, in milliseconds. 600000 (every ten minutes) is a good starting point.
* Also, by digging into the LSystem class, you can change the opacity of the lines, by changing the `ALPHA` constant.

**Dependencies**: In order to access @LSystemBot's timeline, you will need the [Twitter4J library](http://twitter4j.org/en/index.html)

**Warning**: As usual, you will need create a Twitter app and fill the standard token / secret parameters:

```
cb.setOAuthConsumerKey("");
cb.setOAuthConsumerSecret("");
cb.setOAuthAccessToken("");
cb.setOAuthAccessTokenSecret("");
```
