import java.util.*;

int fade_timeout;
int next_timeout;
int current_index = 0;

Datapoint[] dataset = null;
Sonify sonify = null;
Drawer drawer = null;

void setup() {
	size(1024, 768);
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

	fade_timeout = millis();
	next_timeout = millis();
}

void draw() {
	if (millis() - fade_timeout > 90) {
		fill(0, 0, 0, 15);
		rect(0, 0, width, height);
		fade_timeout = millis();
	}

	if (current_index >= dataset.length) {
		// Set GUI to display finished
		return;
	}
	else if (millis() - next_timeout > dataset[current_index].timeSince) {
		next_timeout = millis();

		System.out.println("Datapoint #" + (current_index+1) + ". Date: " + dataset[current_index].date);
		drawer.draw(current_index);
		sonify.play(current_index);

		current_index++;
	}
}
