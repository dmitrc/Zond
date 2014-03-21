import java.util.*;

Datapoint[] dataset;

void setup() {
	size(200, 200);
	background(0);

	System.out.println(int("ABC"));

	Parser parser = new Parser(true);
	dataset = parser.parse_file("dataset.csv");
}

void draw() {

}
