class Drawer {

	Drawer() {
		init();
	}

	public void init() {
		// Empty?
	}

	public void reset() {
		noStroke();

	 	fill(20);
	 	rect(0, 0, width, height - menubar_height);

	 	fill(35);
    	rect(0, height-menubar_height, width, menubar_height);
	}

	public void fade() {
		noStroke();

	 	fill(20, 20, 20, 10);
	 	rect(0, 0, width, height - menubar_height);
	}

	public void draw(int i) {
		int r, g, b;
		ellipseMode(RADIUS);

		if (dataset[i].country.equals("FRANCE")) {
			r = 27; g = 161; b = 147;
		}
		else if (dataset[i].country.equals("USA")) {
			r = 27; g = 63; b = 161;
		}
		else if (dataset[i].country.equals("CHINA")) {
			r = 232; g = 116; b = 191;
		}
		else if (dataset[i].country.equals("UK")) {
			r = 15; g = 110; b = 34;
		}
		else if (dataset[i].country.equals("INDIA")) {
			r = 115; g = 76; b = 10;
		}
		else if (dataset[i].country.equals("PAKIST")) {
			r = 57; g = 10; b = 115;
		}
		else if (dataset[i].country.equals("USSR")) {
			r = 171; g = 34; b = 34;
		}
		else {
			println("Drawer: Error! Country \"" + dataset[i].country + "\" isn't identified! Using white color...");
			r = 255; g = 255; b = 255;
		}

		int radius = round(random(50,100));
		int x = round(random(radius, width-radius));
		int y = round(random(radius, height-menubar_height-radius));

		fill(r, g, b);
		stroke(255, 255, 255);
		ellipse(x, y, radius, radius);		    
	}
};