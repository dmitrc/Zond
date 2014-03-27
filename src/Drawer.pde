import java.util.*;

class Drawer {
	public Datapoint[] dataset = null;
	public boolean verbose = false;

	Drawer(Datapoint[] d) {
		dataset = d;
		init();
	}

	Drawer(Datapoint[] d, boolean v) {
		dataset = d;
		verbose = v;
		init();
	}

	public void init() {
		PFont f = createFont("Arial",14,true);
		textFont(f,14);
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

  		int d = 50;
  		int a = 255;

  		int x = round(random(d, width-d));
  		int y = round(random(d, height-d));
  		fill(r, g, b, a);

  		ellipseMode(RADIUS);
  		ellipse(x,y,d,d);

  		fill(255);
  		text(dataset[i].name, x-d+10, y+7);
	}
};