import java.util.*;

class Sonify {
	public Datapoint[] dataset;
	public boolean verbose;

	// Default settings
	public String franceSample;
	public String usaSample;
	public String chinaSample;
	public String ukSample;
	public String ussrSample;
	public String pakistanSample;

	Sonify(Datapoint[] d) {
		dataset = d;
		verbose = false;
	}

	Sonify(Datapoint[] d, bool v) {
		dataset = d;
		verbose = v;
	}

	public void set_samples(String france, String usa, String china, String uk, String ussr, String pakistan) {
		franceSample = "../audio/" + france;
		usaSample = "../audio/" + usa;
		chinaSample = "../audio/" + china;
		ussrSample = "../audio/" + ussr;
		pakistanSample = "../audio/" + pakistan;
	}

	// Set all the filter settings
	
	// Method to produce a note at this point of dataset
};