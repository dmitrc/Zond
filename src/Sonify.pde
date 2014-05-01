import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

class Sonify {

	Map<String, MultiChannelBuffer[]> map;
	Map<String, Integer> octaves;

	AudioOutput out;

	int sampleCount = 50;

	public MultiChannelBuffer[] FRANCE = new MultiChannelBuffer[5];
	public MultiChannelBuffer[] USA = new MultiChannelBuffer[5];
	public MultiChannelBuffer[] CHINA = new MultiChannelBuffer[5];
	public MultiChannelBuffer[] UK = new MultiChannelBuffer[5];
	public MultiChannelBuffer[] USSR = new MultiChannelBuffer[5];
	public MultiChannelBuffer[] INDIA = new MultiChannelBuffer[5];
	public MultiChannelBuffer[] PAKIST = new MultiChannelBuffer[5];

	public float[] pannerList = new float[37];

	MultiChannelBuffer buff;
	MultiChannelBuffer[] buffs;

	private class Chain {
		Sampler sampler;
		Pan pan;

		Chain(Sampler inputSampler, Pan inputPan){
			sampler = inputSampler;
			pan = inputPan;
			sampler.patch(pan);
			pan.patch(out);
		}

		public void dispose(){
			sampler.unpatch(pan);
			pan.unpatch(out);
		}

		public void play(){
			sampler.trigger();
		}
	}

	ArrayList<Chain> samples = new ArrayList<Chain>();

	Sonify() {
		out = minim.getLineOut();

		map = new HashMap<String, MultiChannelBuffer[]>();
		octaves = new HashMap<String, Integer>();

		init();			
	}

	public void init(){
		map.put("FRANCE", FRANCE);
		map.put("USA", USA);
		map.put("CHINA", CHINA);
		map.put("UK", UK);
		map.put("USSR", USSR);
		map.put("INDIA", INDIA);
		map.put("PAKIST", PAKIST);

		octaves.put("COMBAT",4);
		octaves.put("WR",3);
		octaves.put("ME",3);
		octaves.put("FMS",2);
		octaves.put("TRANSP",2);
		octaves.put("WE",1);
		octaves.put("PNE",1);
		octaves.put("SAM",0);
		octaves.put("SE",0);

		try {
			for(int i = 0; i < 5; i++){
				// minim.loadFileIntoBuffer(sketchPath("") + "../audio/france-" + i + ".wav", map.get("FRANCE")[i]);
				map.get("USA")[i] = new MultiChannelBuffer(1,2);		
				minim.loadFileIntoBuffer(sketchPath("") + "../audio/usa-" + i + ".wav", map.get("USA")[i]);
				//minim.loadFileIntoBuffer(sketchPath("") + "../audio/china-" + i + ".wav", map.get("CHINA")[i]);
				//minim.loadFileIntoBuffer(sketchPath("") + "../audio/uk-" + i + ".wav", map.get("UK")[i]);
				//minim.loadFileIntoBuffer(sketchPath("") + "../audio/ussr-" + i + ".wav",map.get("USSR")[i]); // !
				//minim.loadFileIntoBuffer(sketchPath("") + "../audio/india-" + i + ".wav", map.get("INDIA")[i]); // !
				//minim.loadFileIntoBuffer(sketchPath("") + "../audio/pakistan-" + i + ".wav", map.get("PAKIST")[i]); // !
			}
		}
		catch(Exception e){
			println("Sonify: Error! Can't open one of the sample files!");
		}	

		for(int i = 0; i < 37; i++){
			pannerList[i] = - (1.0 / 18.0) * (i - 18.0);
		}		
	}

	public MultiChannelBuffer[] pickCountry(int i){
		if(map.containsKey(dataset[i].country)){
			//return map.get(dataset[i].country);
			return map.get("USA");
		}
		else{
			println("Sonify: Error! Undefined country! Loading default");
			return map.get("USA");
		}	
	}

	public MultiChannelBuffer pickOctave(MultiChannelBuffer[] country, int i){
		if(octaves.containsKey(dataset[i].purpose)){
			return country[octaves.get(dataset[i].purpose)];
		}
		else{
			println("Sonify: Error! Undefined purpose! Loading default");
			return country[1];
		}	
	}

	public float pickPan(int i){
		int panValue = round(dataset[i].lon / 10.0 ) + 18;
		println(pannerList[panValue]);
		return pannerList[panValue];	
	}

	public void pickFilter(){

	}

	public void updateSamples(){
		if (samples.size() > sampleCount){
			samples.get(0).dispose();
			samples.remove(0);
		}
	}

	public void play(int i) {
		updateSamples();
		buffs = pickCountry(i);
		buff = pickOctave(buffs, i);
		Pan pan = new Pan(pickPan(i));
		Sampler sample = new Sampler(buff, 44100, 1);
		//sample.patch(pan);
		//pan.patch(out);
		Chain chain = new Chain(sample,pan);
		samples.add(chain);
		chain.play();
	}


	public void setVolume(int i){
	
	}
	
	public int getVolume(){
		return 1;
	}

};