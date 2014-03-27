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
		PFont f = createFont("Arial",16,true);
		textFont(f,16);
  		fill(255);
	}

	public void draw(int i) {
  		background(0);
  		text(dataset[i].date, 5, 10);
	}
};