import java.util.*;

Datapoint[] dataset;
Thread thread;
final Sonify sonify;
final Drawer drawer;

void setup() {
	size(26, 100);
	background(255);

	Parser parser = new Parser(true);
	dataset = parser.parse_file("dataset.csv");

	HashSet<String> options = new HashSet<String>();
	options.add("purpose");
	options.add("country");
	options.add("type");
	parser.print_unique(dataset, options);

	sonify = new Sonify(dataset, true);
	drawer = new Drawer(dataset, true);

	run();	
}

void draw() {}

void run() {
	Runnable runnable = new Runnable(){
		public void run(){
			for (int i = 0; i < dataset.length; i++) {
				System.out.println("Datapoint #" + (i+1) + ". Date: ", dataset[i].date);

				try {
					Thread.sleep(point.timeSince);
				}
				catch (InterruptedException e) {
					System.out.println("gotta catch 'em all!");
				}

				sonify.play(i);
				drawer.draw(i);
			}
		}
	};

	thread = new Thread(runnable);
	thread.start();
}
