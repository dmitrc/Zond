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

	Gain g;

	Sonify() {
		init();
	}

	public void init() {
		try {
			ac = new AudioContext();
			comp = new Compressor(ac);
			comp.setThreshold(0.3f);
			ac.out.addInput(comp);
			g=new Gain(ac,1,1);

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

	public void update(int i) {
		GranularSamplePlayer sp;
		OnePoleFilter filter;
		Glide pitchValue;
		Glide rateValue;
		Glide randomnessValue;
		Glide grainSizeValue;
		Glide grainInterval;

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
			filter = new OnePoleFilter(ac,3100*ratio);
			filter.addInput(sp);
			g.addInput(filter);
		}
		else {
			g.addInput(sp);
		}

		rateValue = new Glide(ac,1,1);
		pitchValue = new Glide(ac,1,1);	
		randomnessValue = new Glide(ac,1,1);
		grainSizeValue = new Glide(ac,100,1);
		grainInterval = new Glide(ac,10,1);

		rateValue.setValueImmediately(1);
		pitchValue.setValueImmediately(1);
		randomnessValue.setValueImmediately(1);
		grainSizeValue.setValueImmediately(100);
		grainInterval.setValueImmediately(10);

		sp.setRate(rateValue);
		sp.setPitch(pitchValue);
		sp.setRandomness(randomnessValue);
		sp.setGrainSize(grainSizeValue);
		sp.setGrainInterval(grainInterval);

		sp.setKillOnEnd(true);
		comp.addInput(g);

	}

	public void setVolume(int i){
		Glide volume = new Glide(ac,g.getGain(),100);
		g.setGain(volume);
		volume.setValue(i/100);
	}
	
	public int getVolume(){
		return 100*round(g.getGain());
	}

	public void play(int i) {
		update(i);
		ac.start();
	}
};