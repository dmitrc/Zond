import beads.*;

class Sonify {

	public Sample france = null;
	public Sample usa = null;
	public Sample china = null;
	public Sample uk = null;
	public Sample ussr = null;
	public Sample india = null;
	public Sample pakistan = null;

	private AudioContext ac = null;
	private Compressor comp = null;

	Sonify() {
		init();
	}

	public void init() {
		try {
			ac = new AudioContext();
			comp = new Compressor(ac);

			comp.setThreshold(0.3f);
			ac.out.addInput(comp);

			france = new Sample(sketchPath("") + "../audio/france.wav");
			usa = new Sample(sketchPath("") + "../audio/usa.wav");
			china = new Sample(sketchPath("") + "../audio/china.wav");	
			uk = new Sample(sketchPath("") + "../audio/uk.wav");
			ussr = new Sample(sketchPath("") + "../audio/usa.wav"); // !
			india = new Sample(sketchPath("") + "../audio/usa.wav"); // !
			pakistan = new Sample(sketchPath("") + "../audio/usa.wav"); // !			
		}
		catch(Exception e){
			println("Sonify: Error! Can't open one of the sample files!");
		}
	}

	// Set all the filter settings
	

	// Method to produce a note at this point of dataset
	public void play(int i) {
		update(i);		
		play_sample(i);
	}

	public void update(int i) {

	}
	
	public void play_sample(int i) {
		GranularSamplePlayer sp;
		OnePoleFilter filter;
		Gain g;
		Glide pitchValue;
		Glide rateValue;

		try { 
			if (dataset[i].country.equals("CHINA")){
			 	sp = new GranularSamplePlayer(ac, china);
		 	}
		 	else if (dataset[i].country.equals("UK")){
				sp = new GranularSamplePlayer(ac, uk);
			}
			else if (dataset[i].country.equals("USA")){
				sp = new GranularSamplePlayer(ac, usa);
			}
			else if (dataset[i].country.equals("FRANCE")){
				sp = new GranularSamplePlayer(ac, france);
			}
			else if (dataset[i].country.equals("USSR")){
				sp = new GranularSamplePlayer(ac, ussr);
			}
			else if (dataset[i].country.equals("INDIA")){
				sp = new GranularSamplePlayer(ac, india);
			}
			else if (dataset[i].country.equals("PAKIST")){
				sp = new GranularSamplePlayer(ac, pakistan);
			}
		 	else {
		 		println("Sonify: Error! Country \"" + dataset[i].country + "\" isn't identified! Using sample for USA...");
		 		sp = new GranularSamplePlayer(ac, usa);
		 	}	 	
		}
		catch (Exception e) {
			println("Sonify: Error! Couldn't load the sample!");
			return;
		}

		if (dataset[i].depth > 0){
			float ratio = (float) Math.log(6/dataset[i].depth);

			println("ratio = " + ratio);

			filter = new OnePoleFilter(ac,3100*ratio);
			filter.addInput(sp);

			println(filter.getFrequency());
			g = new Gain(ac, 1, 1);
			g.addInput(filter);
		}
		else {
			g = new Gain(ac, 1, 1);
			g.addInput(sp);
		}

		rateValue = new Glide(ac,1,1);
		pitchValue = new Glide(ac,1,1);	

		rateValue.setValueImmediately(0.5);
		pitchValue.setValueImmediately(2);

		sp.setRate(rateValue);
		sp.setPitch(pitchValue);

		//g=new Gain(ac,1,0.4);
		//g.addInput(sp);
		sp.setKillOnEnd(true);
		//g.addInput(sp);
		comp.addInput(g);
		//ac.out.addInput(g);
		ac.start();
	}
};