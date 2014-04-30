class View {

	public int decay_rate = 5; // subtracted every step
	public float growth_rate = 0.05; // at every step radius += (radius * growth_rate)

	public Color c = null;

	public int x = 0;
	public int y = 0;

	public float lifespan = 255.0;
	public int radius = 0;

	View(Color _c, int _x, int _y, int _radius) {

		if (_c == null) {
			c = new Color(255, 255, 255);
		}
		else {
			c = _c;	
		}

		x = _x;
		y = _y;
		radius = _radius;
	}

	public void draw() {
		fill(c.getRed(), c.getGreen(), c.getBlue(), lifespan);
		stroke(255, 255, 255, lifespan);
		ellipse(x, y, radius, radius);
	}

	public void decay() {
		lifespan -= decay_rate;
		radius += round(radius * growth_rate);
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
	public HashMap<String,Color> colors;

	Drawer() {
		init();
	}

	public void init() {
		objects = new ArrayList<View>();
		colors = new HashMap<String,Color>();

		// Default colors
		colors.put("FRANCE", new Color(27, 161, 147));
		colors.put("USA", new Color(27, 63, 161));
		colors.put("CHINA", new Color(232, 116, 191));
		colors.put("UK", new Color(15, 110, 34));
		colors.put("INDIA", new Color(115, 76, 10));
		colors.put("PAKIST", new Color(57, 10, 115));
		colors.put("USSR", new Color(171, 34, 34));
	}

	public void reset() {
		noStroke();
		
	 	fill(20);
	 	rect(0, 0, width, height - menubar_height);
	}

	public void draw(int i) {
		
		Color c = colors.get(dataset[i].country);

		if (c == null)
		{
			println("Drawer: Error! Country \"" + dataset[i].country + "\" isn't identified! Using white c...");
		}

		int yield_u = round(min(dataset[i].yield_u, 1500));
		int radius = round(map(yield_u, 0, 1500, 25, 100));

		// (!) Uncomment for georgaphical coordinates positioning. Boring though :(
		//int x = round(map(dataset[i].lon, -169, 179, 0, width));
		//int y = round(map(dataset[i].lat, -50, 75, 0, height-menubar_height));
		
		int x = round(random(radius,width-radius));
		int y = round(random(radius,height-menubar_height-radius));

		View obj = new View(c, x, y, radius);
		objects.add(obj);			    
	}

	public void update_objects() {
		reset();
		ellipseMode(RADIUS);
		rectMode(RADIUS);

		for (int i = 0; i < objects.size(); i++) {
			View obj = objects.get(i);
			obj.draw();
		}

		// Decay and remove separately to avoid flickering problems
		for (int i = 0; i < objects.size(); i++) {
			View obj = objects.get(i);
			obj.decay();

			if (!obj.alive()) {
				objects.remove(i);
			}	
		}

		// Draw menu bar
		draw_menu_bar();
	}

	public void draw_menu_bar() {
		noStroke();
		rectMode(CORNER);
		fill(35, 35, 35, 150);
    	rect(0, height-menubar_height, width, menubar_height);
	}
};