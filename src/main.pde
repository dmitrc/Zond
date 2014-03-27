import java.util.*;

Datapoint[] dataset = null;
Thread thread = null;
Sonify sonify = null;
Drawer drawer = null;

void setup() {
	size(100, 40);
	background(0);

	Parser parser = new Parser(true);
	dataset = parser.parse_file("dataset.csv");

	HashSet<String> options = new HashSet<String>();
	options.add("purpose");
	options.add("country");
	options.add("type");
	parser.print_unique(dataset, options);

	sonify = new Sonify(dataset, true);
	drawer = new Drawer(dataset, true);
	
	Runnable runnable = new Runnable(){
		public void run(){
			for (int i = 0; i < dataset.length; i++) {
				try {
					Thread.sleep(dataset[i].timeSince);
				}
				catch (InterruptedException e) {
					System.out.println("Sleep was interruped! :(");
					exit();
				}

				System.out.println("Datapoint #" + (i+1) + ". Date: " + dataset[i].date);
				drawer.draw(i);
				sonify.play(i);
			}
		}
	};

	thread = new Thread(runnable);
	thread.start();
}

void draw() {}
