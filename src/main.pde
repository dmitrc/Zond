import java.util.*;

Datapoint[] dataset;
int current_time = 0;

void setup() {
	size(200, 200);
	background(0);

	Parser parser = new Parser(true);
	dataset = parser.parse_file("dataset.csv");

	HashSet<String> options = new HashSet<String>();
	options.add("purpose");
	options.add("country");
	options.add("type");
	parser.print_unique(options);
}

void draw() {

}
