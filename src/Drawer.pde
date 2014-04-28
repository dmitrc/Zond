class Bomb {
	public int r = 255;
	public int g = 255;
	public int b = 255;

	public int x = round(random(0, width));
	public int y = round(random(0, height));

	public float lifespan = 255.0;
	public int radius = 50;

	Bomb() {}

	Bomb(int _r, int _g, int _b, int _x, int _y, int _radius) {
		r = _r;
		g = _g;
		b = _b;	
		x = _x;
		y = _y;
		radius = _radius;
	}

	public void draw() {
		fill(r, g, b, lifespan);
		stroke(255, 255, 255, lifespan);
		ellipse(x, y, radius, radius);
	}

	public void decay() {
		lifespan -= 10.0;
		radius += 3.0;
	}

	public boolean alive() {
		if (lifespan < 0.0) {
			return false;
		}
		else {
			return true;
		}
	}
};

class Drawer {

	private ArrayList<Bomb> objects;

	Drawer() {
		init();
	}

	public void init() {
		objects = new ArrayList<Bomb>();
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

		Bomb obj = new Bomb(r, g, b, x, y, radius);
		objects.add(obj);			    
	}

	public void update_objects() {
		reset();
		ellipseMode(RADIUS);

		for (int i = 0; i < objects.size(); i++) {
			Bomb obj = objects.get(i);
			obj.draw();
			obj.decay();

			if (!obj.alive()) {
				objects.remove(i);
			}
		}
	}
};