class View {
	public int decay_rate = 8;
	//public int growth_rate = 

	public int r = 255;
	public int g = 255;
	public int b = 255;

	public int x = round(random(width));
	public int y = round(random(height));

	public int shape = round(random(100));

	public float lifespan = 255.0;
	public int radius = 50;

	View() {}

	View(int _r, int _g, int _b, int _x, int _y, int _radius) {
		r = _r;
		g = _g;
		b = _b;	
		x = _x;
		y = _y;
		radius = _radius;
	}

	public void draw(PGraphics frame) {
		frame.fill(r, g, b, lifespan);
		frame.stroke(255, 255, 255, lifespan);

		if (shape < 60) { // 60% chance of ellipse
			frame.ellipse(x, y, radius, radius);
		}
		else if (shape < 90) { // 30% chance of square
			frame.rect(x, y, radius, radius);
		}
		else { // 10% chance of triangle
			frame.triangle(x-radius, y+radius, x, y-radius, x+radius, y+radius);
		}
	}

	public void decay() {
		lifespan -= decay_rate;
		radius += round(radius/10);
	}

	public boolean alive() {
		if (lifespan < decay_rate) {
			return false;
		}
		else {
			return true;
		}
	}
};

class Drawer {

	private ArrayList<View> objects;

	Drawer() {
		init();
	}

	public void init() {
		objects = new ArrayList<View>();
	}

	public void reset() {
		noStroke();
		
	 	fill(20);
	 	rect(0, 0, width, height - menubar_height);

	 	fill(35);
    	rect(0, height-menubar_height, width, menubar_height);
	}

	public void draw(int i) {
		int r, g, b;

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

		int radius = round(random(20,70));
		int x = round(random(radius, width-radius));
		int y = round(random(radius, height-menubar_height-radius));

		View obj = new View(r, g, b, x, y, radius);
		objects.add(obj);			    
	}

	public void update_objects() {
		reset();

		PGraphics frame = createGraphics(width, height-menubar_height);
		frame.beginDraw();

		frame.background(20);
		frame.ellipseMode(RADIUS);
		frame.rectMode(RADIUS);

		for (int i = 0; i < objects.size(); i++) {
			View obj = objects.get(i);
			obj.draw(frame);
			obj.decay();
		}

		// Remove separately to avoid flickering problems
		for (int i = 0; i < objects.size(); i++) {
			if (!objects.get(i).alive()) {
				objects.remove(i);
			}	
		}

		frame.endDraw();
		image(frame, 0, 0, width, height-menubar_height);
	}
};