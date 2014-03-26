import java.util.*;

class Datapoint {
	public String date;
	public float origin;
	public float id; // to allow check for NaN
	public String country;
	public String region;
	public String source;
	public float lat;
	public float lon;
	public float mb;
	public float ms;
	public float depth;
	public float yield_l;
	public float yield_u;
	public String purpose;
	public String name;
	public String type;

	public Datapoint() {}

	public Datapoint(String new_date, float new_origin, float new_id, String new_country, String new_region, String new_source, float new_lat, float new_lon, float new_mb, float new_ms, float new_depth, float new_yield_l, float new_yield_u, String new_purpose, String new_name, String new_type) {
		date = new_date;
		origin = new_origin;
		id = new_id;
		country = new_country;
		region = new_region;
		source = new_source;
		lat = new_lat;
		lon = new_lon;
		mb = new_mb;
		ms = new_ms;
		depth = new_depth;
		yield_l = new_yield_l;
		yield_u = new_yield_u;
		purpose = new_purpose;
		name = new_name;
		type = new_type;
	}
};

class Parser {
	private boolean verbose = false;

	public Parser() {}

	public Parser(boolean v) {
		verbose = v;
	}

	public Datapoint[] parse_file (String filename) {
	
		String[] data = loadStrings("../data/"+filename);	
		int count = data.length;

		if (data == null) {
			System.out.println("Error! File " + filename + " can't be opened!");
			return null;
		}

		if (verbose) {
			System.out.println("Parser: File " + filename + " read. " + count + " lines extracted.");
		}

		Datapoint[] dataset = new Datapoint[count];

		for (int i = 0; i < count; i++) {
			String[] list = split(data[i],",");

			// TODO: Check all this for validity!
			String date = list[0];

			float origin = float(list[1]);
			if (Float.isNaN(origin)) {
				if (verbose) {
					System.out.println("Parser: Origin is NaN (" + list[1] + ") for entry #" + i + ". Setting default value of 0.");
				}
				origin = 0.0;
			}

			float id = float(list[2]);
			if (Float.isNaN(id)) {
				if (verbose) {
					System.out.println("Parser: ID is NaN (" + list[2] + ") for entry #" + i + ". Setting default value of 0.");
				}
				id = 0.0;
			}

			String country = list[3];
			String region = list[4];
			String source = list[5];

			float lat = float(list[6]);
			if (Float.isNaN(lat)) {
				if (verbose) {
					System.out.println("Parser: Latitude is NaN (" + list[6] + ") for entry #" + i + ". Setting default value of 0.");
				}
				lat = 0.0;
			}

			float lon = float(list[7]);
			if (Float.isNaN(lon)) {
				if (verbose) {
					System.out.println("Parser: Longitude is NaN (" + list[7] + ") for entry #" + i + ". Setting default value of 0.");
				}
				lon = 0.0;
			}

			float mb = float(list[8]);
			if (Float.isNaN(mb)) {
				if (verbose) {
					System.out.println("Parser: mb is NaN (" + list[8] + ") for entry #" + i + ". Setting default value of 0.");
				}
				mb = 0.0;
			}

			float ms = float(list[9]);
			if (Float.isNaN(ms)) {
				if (verbose) {
					System.out.println("Parser: Ms is NaN (" + list[9] + ") for entry #" + i + ". Setting default value of 0.");
				}
				ms = 0.0;
			}

			float depth = float(list[10]);
			if (Float.isNaN(depth)) {
				if (verbose) {
					System.out.println("Parser: Depth is NaN (" + list[10] + ") for entry #" + i + ". Setting default value of 0.");
				}
				depth = 0.0;
			}

			float yield_l = float(list[11]);
			if (Float.isNaN(yield_l)) {
				if (verbose) {
					System.out.println("Parser: Yield l is NaN (" + list[11] + ") for entry #" + i + ". Setting default value of 0.");
				}
				yield_l = 0.0;
			}

			float yield_u = float(list[12]);
			if (Float.isNaN(yield_u)) {
				if (verbose) {
					System.out.println("Parser: Yield u is NaN (" + list[12] + ") for entry #" + i + ". Setting default value of 0.");
				}
				yield_u = 0.0;
			}

			String purpose = list[13];
			String name = list[14];
			String type = list[15];

			dataset[i] = new Datapoint(date, origin, id, country, region, source, lat, lon, mb, ms, depth, yield_l, yield_u, purpose, name, type);
		}

		if (verbose) {
			System.out.println("Parser: File successfully imported.");
		}
		return dataset;
	}

	public void print_unique(Datapoint[] dataset, HashSet<String> options) {
		boolean doCountry = false;
		boolean doRegion = false;
		boolean doSource = false;
		boolean doPurpose = false;
		boolean doName = false;
		boolean doType = false;

		if (options == null) {
			doCountry = true;
			doRegion = true;
			doSource = true;
			doPurpose = true;
			doName = true;
			doType = true;
		}
		else {
			if (options.contains("country")) doCountry = true;
			if (options.contains("region")) doRegion = true;
			if (options.contains("source")) doSource = true;
			if (options.contains("purpose")) doPurpose = true;
			if (options.contains("name")) doName = true;
			if (options.contains("type")) doType = true;
		}

		if (dataset == null) {
			if (verbose) {
				System.out.println("Parser: Can't print unique values, because dataset is NULL.");
			}
			return;
		}

		HashSet<String> countrySet = new HashSet<String>();
		HashSet<String> regionSet = new HashSet<String>();
		HashSet<String> sourceSet = new HashSet<String>();
		HashSet<String> purposeSet = new HashSet<String>();
		HashSet<String> nameSet = new HashSet<String>();
		HashSet<String> typeSet = new HashSet<String>();

		for (int i = 0; i < dataset.length; i++) {
			if (doCountry) countrySet.add(dataset[i].country);
			if (doRegion) regionSet.add(dataset[i].region);
			if (doSource) sourceSet.add(dataset[i].source);
			if (doPurpose) purposeSet.add(dataset[i].purpose);
			if (doName) nameSet.add(dataset[i].name);
			if (doType) typeSet.add(dataset[i].type);
		}

		if (doCountry) System.out.println("Parser: Countries:\n-> " + countrySet);
		if (doRegion) System.out.println("Parser: Regions:\n-> " + regionSet);
		if (doSource) System.out.println("Parser: Sources:\n-> " + sourceSet);
		if (doPurpose) System.out.println("Parser: Purposes:\n-> " + purposeSet);
		if (doName) System.out.println("Parser: Names:\n-> " + nameSet);
		if (doType) System.out.println("Parser: Types:\n-> " + typeSet);
	}
};