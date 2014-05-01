import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

class Sonify {

	public AudioSample france = null;
	public AudioSample usa = null;
	public AudioSample china = null;
	public AudioSample uk = null;
	public AudioSample ussr = null;
	public AudioSample india = null;
	public AudioSample pakistan = null;

	Sonify() {
		try {

			france = minim.loadSample(sketchPath("") + "../audio/france.wav");
			usa = minim.loadSample(sketchPath("") + "../audio/usa.wav");
			china = minim.loadSample(sketchPath("") + "../audio/china.wav");	
			uk = minim.loadSample(sketchPath("") + "../audio/uk.wav");
			ussr = minim.loadSample(sketchPath("") + "../audio/usa.wav"); // !
			india = minim.loadSample(sketchPath("") + "../audio/usa.wav"); // !
			pakistan = minim.loadSample(sketchPath("") + "../audio/usa.wav"); // !

		}
		catch(Exception e){
			println("Sonify: Error! Can't open one of the sample files!");
		}
	}



	public void play(int i) {
		 
		if (dataset[i].country.equals("CHINA")){
		 	china.trigger();
		}
		else if (dataset[i].country.equals("UK")){
			uk.trigger();
		}
		else if (dataset[i].country.equals("USA")){
			//usa.trigger();
		}
		else if (dataset[i].country.equals("FRANCE")){
			france.trigger();
		}
		else if (dataset[i].country.equals("USSR")){
			ussr.trigger();
		}
		else if (dataset[i].country.equals("INDIA")){
			india.trigger();
		}
		else if (dataset[i].country.equals("PAKIST")){
			pakistan.trigger();
		}
		else {
			println("Sonify: Error! Country \"" + dataset[i].country + "\" isn't identified! Using sample for USA...");
			//usa.trigger();
		}	
	
	}


	public void setVolume(int i){
	
	}
	
	public int getVolume(){
		return 1;
	}

};