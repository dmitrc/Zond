class Drawer {
  
  private int prevX = -1;
  private int prevY = -1;
  private int prevR = -1;
  private int prevG = -1;
  private int prevB = -1;


	Drawer() {
		init();
	}

	public void init() {
		PFont f = createFont("Arial",14,true);
		textFont(f,14);
	}

  public void reset() {
    prevX = -1;
    prevY = -1;
    prevR = -1;
    prevG = -1;
    prevB = -1;

    fill(20);
    rect(0, 0, width, height - menubar_height);
  }

	public void draw(int i) {
		int r = 255; 
		int g = 255;
		int b = 255;

		if (dataset[i].country.equals("FRANCE")) {
			r = 27;
			g = 161;
			b = 147;
		}
		else if (dataset[i].country.equals("USA")) {
			r = 27;
			g = 63;
			b = 161;
		}
		else if (dataset[i].country.equals("CHINA")) {
			r = 232;
			g = 116;
			b = 191;
		}
		else if (dataset[i].country.equals("UK")) {
			r = 15;
			g = 110;
			b = 34;
		}
		else if (dataset[i].country.equals("INDIA")) {
			r = 115;
			g = 76;
			b = 10;
		}
		else if (dataset[i].country.equals("PAKIST")) {
			r = 57;
			g = 10;
			b = 115;
		}
		else if (dataset[i].country.equals("USSR")) {
			r = 171;
			g = 34;
			b = 34;
		}

		int d = 10;
		int a = 255;

		int x = round(random(d, width-d));
		int y = round(random(d, height-menubar_height-d));

    if (!(prevX < 0 || prevY < 0 || prevR < 0 || prevG < 0 || prevB < 0)) {
      stroke(prevR, prevG, prevB, 255);
      strokeWeight(1);

      line(prevX, prevY, round((prevX+x)/2), round((prevY+y)/2));

      stroke(r, g, b, 255);
      line(round((prevX+x)/2), round((prevY+y)/2), x, y);
    }

    noStroke();
		fill(r, g, b, a);

		ellipseMode(RADIUS);
		ellipse(x,y,d,d);

    prevX = x;
    prevY = y;
    prevR = r;
    prevG = g;
    prevB = b;

		fill(255);
	}
};