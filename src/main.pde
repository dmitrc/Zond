import java.util.*;
import javax.swing.*;
import java.awt.*;
import controlP5.*;

int next_timeout = -1;
int menubar_height = -1;
int current_index = 0;
float speed_multiplier = 1.0;
boolean debug = true;
boolean is_playing = true;

Datapoint[] dataset = null;
Sonify sonify = null;
Drawer drawer = null;
ControlP5 cp5 = null;
String os = System.getProperty("os.name");

boolean sketchFullScreen() {
	if (os.equals("Linux")) {
		// Full-screen mode not really supported :(
		return false;
	}
	else {
		return true;
	}
}

void setup() {
	if (os.equals("Linux")) {
		// Tweak around these two values to fit with all menus/bars on your screen:
		int dx = 100;
		int dy = 100;

		size(displayWidth - dx, displayHeight - dy, P2D);
	}
	else {
		size(displayWidth, displayHeight, P2D);
	}

	background(20);
	frameRate(30);

	menubar_height = round(height / 18);

	Parser parser = new Parser();
	dataset = parser.parse_file("dataset.csv");

	if (debug) {
		HashSet<String> options = new HashSet<String>();
		options.add("purpose");
		options.add("country");
		options.add("type");
		parser.print_unique(dataset, options);
	}

	sonify = new Sonify();
	drawer = new Drawer();

	setup_gui();
	next_timeout = millis();
}

void setup_gui() {
	drawer.draw_menu_bar();
 	cp5 = new ControlP5(this);

    fill(35);
    rect(0, height-menubar_height, width, menubar_height);

    int unit = round(width / 96);
    int h = round(menubar_height * 0.6);
    int dx = 2 * unit;

    cp5.addButton("stop", 0, dx, height - menubar_height/2 - h/2, 2 * unit, h);
    dx += 2 * unit + unit;

    cp5.addButton("play_pause", 0, dx, height - menubar_height/2 - h/2, 2 * unit, h);
    cp5.controller("play_pause").captionLabel().setText("pause");
    dx += 2 * unit + 2 * unit;

    cp5.addSlider("status", 0, dataset.length-1, 1, dx, height - menubar_height/2 - h/2, 60 * unit, h)
    	.setNumberOfTickMarks(dataset.length)
    	.showTickMarks(false);
    cp5.controller("status").getValueLabel().setText("");
    dx += 60 * unit + 5 * unit;

    cp5.addSlider("speed", 0, 5, 1, dx, height - menubar_height/2 - h/2, 10 * unit, h);
    dx += 10 * unit + 5 * unit;

    cp5.addButton("about", 0, dx, height - menubar_height/2 - h/2, 2 * unit, h);
    dx += 2 * unit + unit;

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

void about(int val) {
	String about_text = "Authors:\n"
		+ "Dmitrii Cucleschin (Programming)\n"
		+ "Nikoloz Kapanadze (Programming) \n"
		+ "Zurab Babunashvili (Sounds)\n"
		+ "Oguz Oral (Sheyleo)\n\n"
		+ "As a part of our project for the course Let The Data Speak, we were\n"
		+ "asked to use sonification and visualization techniques to represent a\n"
		+ "dataset. This project aims at demonstrating worldwide nuclear launches in\n"
		+ "time period of 1945-1998 (data from SIPRI). Simple interface, distinctive\n"
		+ "sounds for different counties and visuals should assist in understanding\n"
		+ "main patterns in nuclear development and raise awareness of the massive\n"
		+ "footprint we are leaving as the result.\n\n"
		+ "By the way, this project is proudly open-source. Check it out, tweak it,\n"
		+ "or do anything else with it (as long as there is a mention of an original):\n"
		+ "https://github.com/dmitryfd/Zond\n\n"
		+ "Thanks for trying Zond! Any feedback will be more than welcome! :)"
	;

	JOptionPane.showMessageDialog(null, about_text, "About", JOptionPane.PLAIN_MESSAGE);
}
 
void exit(int val) {
	int res = JOptionPane.showConfirmDialog(null, "Are you sure you want to exit?", "Exit", 
		JOptionPane.YES_NO_OPTION, JOptionPane.PLAIN_MESSAGE);

	if (res == JOptionPane.YES_OPTION) {
		exit();
	}
}

void status(float val) {
	int i = round(val);
	current_index = i;

	cp5.controller("status").getValueLabel().setText(dataset[i].print());
}

void speed(float val) {
	if (val == 0) {
		speed_multiplier = 999;
	}
	else {
		speed_multiplier = 1/val;
	}
}

void draw() {
	if (is_playing && current_index < dataset.length) {
		drawer.update_objects();

		if (millis() - next_timeout > dataset[current_index].time_since * speed_multiplier) {
			next_timeout = millis();

			drawer.draw(current_index);
			
			// Do sounds on a separate threads to keep animation (fps) smooth
			Thread thread = new Thread(){
    			public void run(){
      				sonify.play(current_index);
    			}
  			};
 			thread.start();

			cp5.controller("status").setValue(current_index);
			cp5.controller("status").getValueLabel().setText(dataset[current_index].print());

			current_index++;
		}
	}

	if (debug) {
		fill(0);
		rect(10, 5, 130, 20);

		fill(255);
  		text("FPS: " + frameRate, 20, 20);
	}
}
