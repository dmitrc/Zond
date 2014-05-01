import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

class Sonify {

	Map<String, Sampler[]> map;
	Map<String, Integer> octaves;

	AudioOutput out;

	public Sampler[] FRANCE = new Sampler[5];
	public Sampler[] USA = new Sampler[5];
	public Sampler[] CHINA = new Sampler[5];
	public Sampler[] UK = new Sampler[5];
	public Sampler[] USSR = new Sampler[5];
	public Sampler[] INDIA = new Sampler[5];
	public Sampler[] PAKIST = new Sampler[5];

	int voices=25;

	float xCenter=0;
	float yCenter=0;

	Sonify() {
		out=minim.getLineOut();

		map = new HashMap<String, Sampler[]>();
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
			for(int i=0; i<5; i++){
				//map.get("FRANCE")[i] = new Sampler(sketchPath("") + "../audio/france-"+i+".wav", voices, minim);
				map.get("USA")[i] = new Sampler(sketchPath("") + "../audio/usa-" + i + ".wav", voices, minim);
				//map.get("CHINA")[i] = new Sampler(sketchPath("") + "../audio/china-"+i+".wav", voices, minim);
				//map.get("UK")[i] = new Sampler(sketchPath("") + "../audio/uk-"+i+".wav", voices, minim);
				//map.get("USSR")[i] = new Sampler(sketchPath("") + "../audio/ussr-"+i+".wav", voices, minim); // !
				//map.get("INDIA")[i] = new Sampler(sketchPath("") + "../audio/india-"+i+".wav", voices, minim); // !
				//map.get("PAKIST")[i] = new Sampler(sketchPath("") + "../audio/pakistan-"+i+".wav", voices, minim); // !
			}
		}
		catch(Exception e){
			println("Sonify: Error! Can't open one of the sample files!");
		}		
	}

	public Sampler[] pickCountry(int i){
		if(map.containsKey(dataset[i].country)){
			//return map.get(dataset[i].country);
			return map.get("USA");
		}
		else{
			println("Sonify: Error! Undefined country! Loading default");
			return map.get("USA");
		}	
	}

	public void pickPan(Sampler sampler, int i){
		Pan pan = new Pan(0);
		float panValue=((2)*(dataset[i].lat+180))/(360)-1;
		pan.setPan(panValue);
		sampler.patch(pan);
		pan.patch(out);
	}

	public Sampler pickOctave(Sampler[] country, int i){
		if(octaves.containsKey(dataset[i].purpose)){
			return country[octaves.get(dataset[i].purpose)];
		}
		else{
			println("Sonify: Error! Undefined purpose! Loading default");
			return country[1];
		}	
	}

	public void play(int i) {
		Sampler sampler = pickOctave(pickCountry(i), i);
		pickPan(sampler,i);
		sampler.trigger();
	}


	public void setVolume(int i){
	
	}
	
	public int getVolume(){
		return 1;
	}

};