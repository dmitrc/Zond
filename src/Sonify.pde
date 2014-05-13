import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

class Sonify {

	Map<String, MultiChannelBuffer[]> map;
	Map<String, Integer> octaves;
	Map<String, Float> volumes;

	AudioOutput out;

	public MultiChannelBuffer[] FRANCE = new MultiChannelBuffer[5];
	public MultiChannelBuffer[] USA = new MultiChannelBuffer[5];
	public MultiChannelBuffer[] CHINA = new MultiChannelBuffer[5];
	public MultiChannelBuffer[] UK = new MultiChannelBuffer[5];
	public MultiChannelBuffer[] USSR = new MultiChannelBuffer[5];
	public MultiChannelBuffer[] INDIA = new MultiChannelBuffer[5];
	public MultiChannelBuffer[] PAKIST = new MultiChannelBuffer[5];

	private class Chain {
		Sampler sampler;
		Pan pan;
		Constant amplitude;
		BitCrush crusher;

		Chain(Sampler inputSampler, Pan inputPan, Constant inputAmplitude, BitCrush inputCrusher){
			sampler = inputSampler;
			pan = inputPan;
			amplitude = inputAmplitude;
			crusher = inputCrusher;
			sampler.patch(crusher);
			amplitude.patch(sampler.amplitude);
			crusher.patch(pan);
			pan.patch(out);
		}

		public void dispose() {
			try { 
				sampler.unpatch(crusher);
				crusher.unpatch(pan);
				pan.unpatch(out);
			}
			catch (Exception e) {
				println("Sonify: Minim used Unpatch. Minim is confused. Minim hurt itself in its confusion!");
			}
		}

		public void play(){
			sampler.trigger();
		}
	}

	LinkedList<Chain> samples = new LinkedList<Chain>();

	Sonify() {
		out = minim.getLineOut();
		map = new HashMap<String, MultiChannelBuffer[]>();
		octaves = new HashMap<String, Integer>();
		volumes = new HashMap<String, Float>();
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

		volumes.put("UW",0.30);
		volumes.put("SHAFT",0.37);
		volumes.put("CRATER",0.44);
		volumes.put("WATERSURFACE",0.51);
		volumes.put("SURFACE",0.58);
		volumes.put("BARGE",0.65);
		volumes.put("TOWER",0.82);
		volumes.put("BALOON",0.89);
		volumes.put("AIRDROP",0.95);
		volumes.put("ROCKET",1.0);

		recorder = minim.createRecorder(out, "../audio/out.wav");

		try {
			for(int i = 0; i < 5; i++){
				map.get("FRANCE")[i] = new MultiChannelBuffer(1,2);		
				minim.loadFileIntoBuffer(sketchPath("") + "../audio/france-" + i + ".wav", map.get("FRANCE")[i]);

				map.get("USA")[i] = new MultiChannelBuffer(1,2);		
				minim.loadFileIntoBuffer(sketchPath("") + "../audio/usa-" + i + ".wav", map.get("USA")[i]);

				map.get("CHINA")[i] = new MultiChannelBuffer(1,2);				
				minim.loadFileIntoBuffer(sketchPath("") + "../audio/china-" + i + ".wav", map.get("CHINA")[i]);

				map.get("UK")[i] = new MultiChannelBuffer(1,2);
				minim.loadFileIntoBuffer(sketchPath("") + "../audio/uk-" + i + ".wav", map.get("UK")[i]);

				map.get("USSR")[i] = new MultiChannelBuffer(1,2);
				minim.loadFileIntoBuffer(sketchPath("") + "../audio/ussr-" + i + ".wav",map.get("USSR")[i]); 

				map.get("INDIA")[i] = new MultiChannelBuffer(1,2);
				minim.loadFileIntoBuffer(sketchPath("") + "../audio/india-" + i + ".wav", map.get("INDIA")[i]); 

				map.get("PAKIST")[i] = new MultiChannelBuffer(1,2);
				minim.loadFileIntoBuffer(sketchPath("") + "../audio/pakistan-" + i + ".wav", map.get("PAKIST")[i]);
			}
		}
		catch(Exception e){
			println("Sonify: Error! Can't open one of the sample files!");
		}	
	}

	public MultiChannelBuffer[] pickCountry(int i){
		if(map.containsKey(dataset[i].country)){
			return map.get(dataset[i].country);
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
		float pan = map(dataset[i].lon, -169, 179, -1, 1);
		return pan;	
	}

	public BitCrush pickBit(int i){
		float bits = log((dataset[i].yield_u+0.0001)/50000);
		bits = round(map(bits, -21, 0, 14, 5));
		BitCrush crusher = new BitCrush(bits, 44100);
		return crusher;		
	}

	public void updateSamples(){
		while (!samples.isEmpty() && samples.size() >= max_samples) {		
			try {	
				samples.getFirst().dispose();
				samples.removeFirst();
			}
			catch (Exception e) {
				println("Sonify: Error! Minim used Unpatch. Minim is confused. Minim hurt itself in its confusion.");
			}
		}
	}

	public float pickVolume(int i){
		if(volumes.containsKey(dataset[i].type)){
			return volumes.get(dataset[i].type);
		}
		else{
			return 0.75;
		}
	}

	public void play(int i) {
		if(i==0){
			recorder.beginRecord();
		}
		if(i==4){ // temporary checker for enrecord !!! needs figuring out
			recorder.endRecord();
		}
		updateSamples();
		MultiChannelBuffer[] buffs = pickCountry(i);
		MultiChannelBuffer buff = pickOctave(buffs, i);
		Pan pan = new Pan(pickPan(i));
		Sampler sample = new Sampler(buff, 44100, 1);
		Constant amplitude = new Constant(pickVolume(i));
		BitCrush crusher = pickBit(i);
		Chain chain = new Chain(sample, pan, amplitude, crusher);
		samples.addLast(chain);
		chain.play();
	}
};