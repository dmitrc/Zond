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
		SamplePlayer sp;
		OnePoleFilter filter;
		
		try { 
			if (dataset[i].country.equals("CHINA")){
			 	sp = new SamplePlayer(ac, china);
		 	}
		 	else if (dataset[i].country.equals("UK")){
				sp = new SamplePlayer(ac, uk);
			}
			else if (dataset[i].country.equals("USA")){
				sp = new SamplePlayer(ac, usa);
			}
			else if (dataset[i].country.equals("FRANCE")){
				sp = new SamplePlayer(ac, france);
			}
			else if (dataset[i].country.equals("USSR")){
				sp = new SamplePlayer(ac, ussr);
			}
			else if (dataset[i].country.equals("INDIA")){
				sp = new SamplePlayer(ac, india);
			}
			else if (dataset[i].country.equals("PAKIST")){
				sp = new SamplePlayer(ac, pakistan);
			}
		 	else {
		 		println("Sonify: Error! Country \"" + dataset[i].country + "\" isn't identified! Using sample for USA...");
		 		sp = new SamplePlayer(ac, usa);
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

		Sample buff = changeTime(sp.getBuffer(), i%5+1);
		sp.setSample(buff);

		Glide pitchGlide = new Glide(ac,1,1);
		sp.setPitch(pitchGlide);
		pitchGlide.setValueImmediately(i%5+1);


		sp.setKillOnEnd(true);
		comp.addInput(g);

	}

	public Sample changeTime(Sample buffer, float mult){

			int piece = 100;

			Sample newBuff = new Sample(buffer.getLength()*ceil(mult+1));

			int NS = (int) newBuff.msToSamples(piece);

			float[][] frames = new float[2][NS];
			
			for(int j = 0; j<buffer.msToSamples(buffer.getLength()); j=j+piece){
			
				buffer.getFrames(j,frames);
				
				newBuff.putFrames(round(j*mult),frames);
		
		}
		return newBuff;
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