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
	parser.print_unique(dataset, options);

	Sonify sonify = new Sonify(dataset, true);
	//sonify.play_sine();
	//sonify.play_sample();

	
	for (int i=0; i<dataset.length; i++){
		sonify.soundTheAlarm(dataset[i]);
		try{
			Thread.sleep(dataset[i].timeSince);
		}
		catch (InterruptedException e){
			System.out.println("gotta catch 'em all!");
		}
	}
	

}

void draw() {

}
