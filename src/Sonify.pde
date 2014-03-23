import java.util.*;
import beads.*;

class Sonify {
	public Datapoint[] dataset = null;
	public boolean verbose = false;

	// Default settings
	public String franceSample = sketchPath("") + "../audio/france.wav";
	public String usaSample = sketchPath("") + "../audio/usa.wav";
	public String chinaSample = sketchPath("") + "../audio/china.wav";
	public String ukSample = sketchPath("") + "../audio/uk.wav";
	public String ussrSample = sketchPath("") + "../audio/ussr.wav";
	public String pakistanSample = sketchPath("") + "../audio/pakistan.wav";

	Sonify(Datapoint[] d) {
		dataset = d;
	}

	Sonify(Datapoint[] d, boolean v) {
		dataset = d;
		verbose = v;
	}

	public void set_samples(String france, String usa, String china, String uk, String ussr, String pakistan) {
		franceSample = sketchPath("") + "../audio/" + france;
		usaSample = sketchPath("") + "../audio/" + usa;
		chinaSample = sketchPath("") + "../audio/" + china;
		ussrSample = sketchPath("") + "../audio/" + ussr;
		pakistanSample = sketchPath("") + "../audio/" + pakistan;
	}

	// Set all the filter settings
	
	// Method to produce a note at this point of dataset
	
	// Derping around
	public void play_sine() {
		AudioContext ac = new AudioContext();

		WavePlayer wp = new WavePlayer(ac, 440, Buffer.SINE);
		Gain g = new Gain(ac, 1, 0.4);

		g.addInput(wp);
		ac.out.addInput(g);
		ac.start();
	}

	public void play_sample() {
		String sourceFile =  sketchPath("") + "../audio/sample.wav";
		AudioContext ac = new AudioContext();
		SamplePlayer sp;

		try { 
		 	sp = new SamplePlayer(ac, new Sample(sourceFile));
		}
		catch(Exception e) {
			println("Sonify: Error! Couldn't load the sample!");
			return;
		}

		sp.setKillOnEnd(true);
		Gain g = new Gain(ac, 1, 1.0);

		g.addInput(sp);
		ac.out.addInput(g);
		ac.start();
	}
};