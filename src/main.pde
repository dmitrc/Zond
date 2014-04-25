import java.util.*;
import javax.swing.*;
import controlP5.*;

int next_timeout;
int current_index = 0;
int menubar_height = 50;
float speed_multiplier = 1.0;
boolean is_playing = true;

Datapoint[] dataset = null;
Sonify sonify = null;
Drawer drawer = null;
ControlP5 cp5;

void setup() {
	size(1440, 900);
	background(20);

	Parser parser = new Parser(true);
	dataset = parser.parse_file("dataset.csv");

	// Debug starts
	HashSet<String> options = new HashSet<String>();
	options.add("purpose");
	options.add("country");
	options.add("type");
	parser.print_unique(dataset, options);
	// Debug ends

	sonify = new Sonify(dataset, true);
	drawer = new Drawer(dataset, menubar_height, true);

	setup_gui();
	next_timeout = millis();
}

void setup_gui() {
 	cp5 = new ControlP5(this);

    fill(35);
    rect(0, height-menubar_height, width, menubar_height);

    int unit = Math.round(width / 96);
    int h = Math.round(menubar_height * 0.6);
    int dx = 2 * unit;

    cp5.addButton("stop", 0, dx, height - menubar_height/2 - h/2, 2 * unit, h);
    dx += 2 * unit + unit;

    cp5.addButton("play_pause", 0, dx, height - menubar_height/2 - h/2, 2 * unit, h);
    cp5.controller("play_pause").captionLabel().setText("pause");
    dx += 2 * unit + 4 * unit;

    cp5.addSlider("status", 1, dataset.length, 1, dx, height - menubar_height/2 - h/2, 60 * unit, h)
    	.setNumberOfTickMarks(dataset.length)
    	.showTickMarks(false);
    cp5.controller("status").getValueLabel().setText("");
    dx += 60 * unit + 6 * unit;

    cp5.addSlider("speed", 0, 5, 1, dx, height - menubar_height/2 - h/2, 10 * unit, h);
    dx += 10 * unit + 5 * unit;

	cp5.addButton("exit", 0, dx, height - menubar_height/2 - h/2, 2 * unit, h);
    dx += 2 * unit + 2 * unit;

    // Takes care of all 96 "intervals" of the screen. Tested on 1440x900, hopefully will work with different widths...
}

void play_pause(int val) {
	if (is_playing) {
		// Pause
    	cp5.controller("play_pause").captionLabel().setText("play"); 
    	is_playing = false;
	}
	else {
		// Play
    	cp5.controller("play_pause").captionLabel().setText("pause"); 
    	is_playing = true;
	}
}

void stop(int val) {
	is_playing = false;
	current_index = 0;

	cp5.controller("play_pause").captionLabel().setText("play");
	cp5.controller("status").setValue(0);
	cp5.controller("status").getValueLabel().setText("");
	drawer.reset();
}
 
void exit(int val) {
	int res = JOptionPane.showConfirmDialog(null, "Are you sure you want to exit?", "Exit", 
		JOptionPane.YES_NO_OPTION, JOptionPane.PLAIN_MESSAGE);

	if (res == JOptionPane.YES_OPTION) {
		exit();
	}
}

void status(float val) {
	int i = Math.round(val);
	current_index = i;

	cp5.controller("status").getValueLabel().setText(dataset[i].print());
}

void speed(float val) {
	if (val == 0) {
		speed_multiplier = 999999;
	}
	else {
		speed_multiplier = 1/val;
	}
}

void draw() {
	if (!is_playing) {
		return;
	}

	if (current_index >= dataset.length) {
		// Set GUI to display finished
		return;
	}
	else if (millis() - next_timeout > dataset[current_index].timeSince * speed_multiplier) {
		next_timeout = millis();

		drawer.draw(current_index);
		sonify.play(current_index);

		cp5.controller("status").setValue(current_index);
		cp5.controller("status").getValueLabel().setText(dataset[current_index].print());

		current_index++;
	}
}
