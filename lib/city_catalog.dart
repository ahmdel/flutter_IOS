import 'models.dart';

const String kAroundMeCity = "اطراف من";
const String kDeTownsCity = "DE Towns";
const String kOtherCitiesKey = "__OTHER__";
const String kOtherCitiesFa = "سایر شهرها";
const String kRestworldKey = "Restworld";

class GeoBox {
  final double? minLat;
  final double? maxLat;
  final double? minLon;
  final double? maxLon;

  const GeoBox({this.minLat, this.maxLat, this.minLon, this.maxLon});

  bool contains(double lat, double lon) {
    if (minLat != null && lat < minLat!) return false;
    if (maxLat != null && lat > maxLat!) return false;
    if (minLon != null && lon < minLon!) return false;
    if (maxLon != null && lon > maxLon!) return false;
    return true;
  }
}

class ExtraCityMatch {
  final String name;
  final GeoBox box;
  const ExtraCityMatch(this.name, this.box);
}

class CityDef {
  final String fa;
  final String en;
  final List<String> aliases;
  final GeoBox? box;
  final List<ExtraCityMatch> extraCities;

  const CityDef({
    required this.fa,
    required this.en,
    this.aliases = const [],
    this.box,
    this.extraCities = const [],
  });
}

class CountryDef {
  final String fa;
  final List<CityDef> cities;
  final Set<String> allCities;

  const CountryDef({
    required this.fa,
    required this.cities,
    this.allCities = const {},
  });
}

String _norm(String value) => value.toLowerCase().trim();

bool restaurantMatchesCity(Restaurant r, CityDef city) {
  if (city.en == kOtherCitiesKey ||
      city.en == kDeTownsCity ||
      city.en == kRestworldKey ||
      city.en == kAroundMeCity) {
    return false;
  }

  final cityName = _norm(r.city);
  final names = {
    _norm(city.en),
    ...city.aliases.map(_norm),
  };

  if (names.contains(cityName)) {
    if (city.box != null && !city.box!.contains(r.lat, r.lon)) return false;
    return true;
  }

  for (final extra in city.extraCities) {
    if (_norm(extra.name) == cityName && extra.box.contains(r.lat, r.lon)) {
      return true;
    }
  }
  return false;
}

bool restaurantMatchesOther(Restaurant r, CountryDef country) {
  for (final city in country.cities) {
    if (restaurantMatchesCity(r, city)) return false;
  }

  final cityName = _norm(r.city);
  if (!country.allCities.contains(cityName)) return false;

  // نام شهرهای اصلی این کشور نباید در «سایر شهرها» تکرار شود
  // (مثلاً Vienna ویرجینیا نباید زیر اتریش برود).
  for (final city in country.cities) {
    final names = {_norm(city.en), ...city.aliases.map(_norm)};
    if (names.contains(cityName)) return false;
  }
  return true;
}

CountryDef? countryByFa(String countryFa) {
  for (final country in kCountryCatalog) {
    if (country.fa == countryFa) return country;
  }
  return null;
}

CityDef? cityByFa(CountryDef country, String cityFa) {
  for (final city in country.cities) {
    if (city.fa == cityFa) return city;
  }
  return null;
}

List<Restaurant> filterRestaurantsForSelection({
  required List<Restaurant> all,
  required String countryFa,
  required String cityFa,
}) {
  final country = countryByFa(countryFa);
  if (country == null) {
    return all.where((r) => _norm(r.city) == _norm(cityFa)).toList();
  }

  final city = cityByFa(country, cityFa);
  if (city == null) {
    return all.where((r) => _norm(r.city) == _norm(cityFa)).toList();
  }

  if (city.en == kOtherCitiesKey) {
    return all.where((r) => restaurantMatchesOther(r, country)).toList();
  }
  if (city.en == kDeTownsCity) {
    return RESTAURANTS_DATA["DE Towns"] ?? [];
  }
  if (city.en == kRestworldKey) {
    return all.where((r) {
      for (final c in kCountryCatalog) {
        if (c.fa == "مکان‌یابی من") continue;
        for (final named in c.cities) {
          if (named.en == kRestworldKey ||
              named.en == kAroundMeCity ||
              named.en == kDeTownsCity) {
            continue;
          }
          if (restaurantMatchesCity(r, named)) return false;
        }
        if (c.fa != "سایر کشورها" && restaurantMatchesOther(r, c)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  return all.where((r) => restaurantMatchesCity(r, city)).toList();
}

Map<String, List<String>> buildCountryCityMap() {
  return {
    for (final country in kCountryCatalog)
      country.fa: [for (final city in country.cities) city.fa],
  };
}

Map<String, String> buildCityTranslationMap() {
  final map = <String, String>{};
  for (final country in kCountryCatalog) {
    for (final city in country.cities) {
      map[city.fa] = city.en;
    }
  }
  return map;
}

const List<CountryDef> kCountryCatalog = [
  CountryDef(
    fa: "مکان‌یابی من",
    cities: [CityDef(fa: kAroundMeCity, en: kAroundMeCity)],
  ),
  CountryDef(
    fa: "آلمان",
    allCities: {
      "aachen",
      "aachen/maastricht area",
      "augsburg",
      "bayreuth",
      "berlin",
      "bielefeld",
      "bochum",
      "bonn",
      "bremen",
      "chemnitz",
      "darmstadt",
      "detmold",
      "dortmund",
      "dresden",
      "dusseldorf",
      "düsseldorf",
      "erlangen",
      "essen",
      "frankfurt",
      "freiburg",
      "göttingen",
      "gärtringen",
      "hamburg",
      "hannover",
      "heidelberg",
      "heilbronn",
      "hildesheim",
      "kassel",
      "kiel",
      "koln",
      "leipzig",
      "leonberg",
      "lübeck",
      "mannheim",
      "munich",
      "nuremberg",
      "osnabrück",
      "paderborn",
      "rottenburg",
      "rüsselsheim",
      "schriesheim",
      "stuttgart",
      "trier",
      "wesseling (koln area)",
      "wuppertal",
      "würzburg",
      "zwickau",
      "böblingen (stuttgart area)",
    },
    cities: [
      CityDef(fa: "برلین", en: "Berlin"),
      CityDef(fa: "برمن", en: "Bremen"),
      CityDef(
        fa: "دوسلدورف",
        en: "Dusseldorf",
        aliases: ["Düsseldorf"],
      ),
      CityDef(fa: "هامبورگ", en: "Hamburg"),
      CityDef(
        fa: "کلن",
        en: "Koln",
        aliases: ["Wesseling (Koln Area)"],
      ),
      CityDef(fa: "مونیخ", en: "Munich"),
      CityDef(fa: "فرانکفورت", en: "Frankfurt"),
      CityDef(fa: "هانوفر", en: "Hannover"),
      CityDef(fa: "بون", en: "Bonn"),
      CityDef(
        fa: "اشتوتگارت",
        en: "Stuttgart",
        aliases: ["Böblingen (Stuttgart Area)"],
      ),
      CityDef(
        fa: "آخن",
        en: "Aachen",
        aliases: ["Aachen/Maastricht Area"],
      ),
      CityDef(fa: "شهرهای دیگر آلمان", en: kDeTownsCity),
    ],
  ),
  CountryDef(
    fa: "فرانسه",
    allCities: {
      "paris",
      "strasbourg",
      "nice",
      "lyon",
      "marseille",
      "toulouse",
      "grenoble",
      "aix-en-provence",
    },
    cities: [
      CityDef(fa: "پاریس", en: "Paris"),
      CityDef(fa: "استراسبورگ", en: "Strasbourg"),
      CityDef(fa: "نیس", en: "Nice"),
      CityDef(fa: "لیون", en: "Lyon"),
      CityDef(fa: "مارسی", en: "Marseille"),
      CityDef(fa: "تولوز", en: "Toulouse"),
      CityDef(fa: "گرنوبل", en: "Grenoble"),
      CityDef(fa: kOtherCitiesFa, en: kOtherCitiesKey),
    ],
  ),
  CountryDef(
    fa: "ایتالیا",
    allCities: {
      "rome",
      "milan",
      "florence",
      "torino",
      "bologna",
      "baja sardinia",
      "italy",
    },
    cities: [
      CityDef(fa: "رم", en: "Rome"),
      CityDef(fa: "میلان", en: "Milan"),
      CityDef(fa: "فلورانس", en: "Florence"),
      CityDef(fa: "تورین", en: "Torino"),
      CityDef(fa: kOtherCitiesFa, en: kOtherCitiesKey),
    ],
  ),
  CountryDef(
    fa: "اسپانیا",
    allCities: {
      "barcelona",
      "madrid",
      "malaga",
      "valencia",
      "marbella",
      "cáceres (spain)",
      "torrevieja (spain)",
      "dénia (spain)",
    },
    cities: [
      CityDef(fa: "بارسلونا", en: "Barcelona"),
      CityDef(fa: "مادرید", en: "Madrid"),
      CityDef(fa: "مالاگا", en: "Malaga", aliases: ["Marbella"]),
      CityDef(fa: "والنسیا", en: "Valencia"),
      CityDef(fa: kOtherCitiesFa, en: kOtherCitiesKey),
    ],
  ),
  CountryDef(
    fa: "ترکیه",
    allCities: {"istanbul", "ankara", "alanya", "turkey"},
    cities: [
      CityDef(fa: "استانبول", en: "Istanbul"),
      CityDef(fa: "آنکارا", en: "Ankara"),
      CityDef(fa: kOtherCitiesFa, en: kOtherCitiesKey),
    ],
  ),
  CountryDef(
    fa: "کانادا",
    allCities: {
      "vancouver",
      "toronto",
      "coquitlam",
      "burnaby",
      "north vancouver",
      "port coquitlam",
      "richmond",
      "west vancouver",
      "vancouver downtown",
      "maple ridge",
      "langley",
    },
    cities: [
      CityDef(
        fa: "ونکوور",
        en: "Vancouver",
        aliases: [
          "Coquitlam",
          "Burnaby",
          "North Vancouver",
          "Port Coquitlam",
          "Richmond",
          "West Vancouver",
          "Vancouver Downtown",
          "Maple Ridge",
          "Langley",
        ],
      ),
      CityDef(fa: "تورنتو", en: "Toronto"),
    ],
  ),
  CountryDef(
    fa: "آمریکا",
    allCities: {
      "new york",
      "los angeles",
      "dallas",
      "miami",
      "houston",
      "san diego",
      "san francisco",
      "chicago",
      "washington",
      "atlanta",
      "las vegas",
      "austin",
      "portland",
      "seattle",
      "denver",
      "phoenix",
      "sacramento",
      "san jose",
      "salt lake city",
      "oklahoma city",
      "albuquerque",
      "mclean",
      "kirkland",
      "arlington",
      "alpharetta",
      "walnut creek",
      "watertown",
      "sandy springs",
      "fort lauderdale",
      "richardson",
      "longwood",
      "columbia",
      "rockville",
      "ellicott city",
      "college park",
      "raleigh",
      "peachtree corners",
      "johns creek",
      "oakland",
      "omaha",
      "scottsdale",
      "poway",
      "sunnyvale",
      "san rafael",
      "berkeley",
      "beaverton",
      "tacoma",
      "bellevue",
      "lynnwood",
      "katy",
      "plano",
      "sugar land",
      "naples",
      "kendall",
      "south miami",
      "tampa",
      "orlando",
      "coral gables",
      "farmington hills",
      "ypsilanti",
      "park ridge",
      "hickory hills",
      "highwood",
      "morton grove",
      "aurora",
      "skokie",
      "oak brook",
      "lombard",
      "belmont",
      "revere",
      "peabody",
      "west roxbury",
      "westborough",
      "cambridge",
      "woburn",
      "gaithersburg",
      "baltimore",
      "towson",
      "parkville",
      "waldorf",
      "bethesda",
      "germantown",
      "durham",
      "greenville",
      "stone mountain",
      "roswell",
      "kennesaw",
      "marietta",
      "blue ridge",
      "warr acres",
      "tulsa",
      "norman",
      "chandler",
      "gilbert",
      "tempe",
      "cupertino",
      "san carlos",
      "pleasanton",
      "folsom",
      "campbell",
      "roseville",
      "palo alto",
      "fresno",
      "mountain view",
      "hayward",
      "citrus heights",
      "falls church",
      "cottonwood heights",
      "midvale",
      "centennial",
      "boca raton",
      "sunrise (miami area)",
      "coral springs",
      "miami lakes",
      "miami beach",
      "lake worth",
      "davie",
      "north miami",
      "doral",
      "naples (miami area)",
    },
    cities: [
      CityDef(fa: "نیویورک", en: "New York"),
      CityDef(fa: "لوس‌آنجلس", en: "Los Angeles"),
      CityDef(
        fa: "دالاس",
        en: "Dallas",
        aliases: ["Richardson", "Plano"],
      ),
      CityDef(
        fa: "میامی",
        en: "Miami",
        aliases: [
          "Fort Lauderdale",
          "Boca Raton",
          "Sunrise (Miami Area)",
          "Coral Springs",
          "Miami Lakes",
          "Miami Beach",
          "Lake Worth",
          "Davie",
          "Kendall",
          "North Miami",
          "Doral",
          "Naples (Miami Area)",
          "South Miami",
          "Coral Gables",
        ],
      ),
      CityDef(
        fa: "هیوستون",
        en: "Houston",
        aliases: ["Katy", "Sugar Land"],
      ),
      CityDef(fa: "سن‌دیگو", en: "San Diego", aliases: ["Poway"]),
      CityDef(fa: "سان‌فرانسیسکو", en: "San Francisco"),
      CityDef(
        fa: "سن‌خوزه",
        en: "San Jose",
        aliases: ["Sunnyvale", "Cupertino", "Campbell", "Palo Alto", "Mountain View"],
      ),
      CityDef(fa: "شیکاگو", en: "Chicago"),
      CityDef(
        fa: "واشنگتن",
        en: "Washington",
        aliases: [
          "McLean",
          "Falls Church",
          "Rockville",
          "Ellicott City",
          "College Park",
          "Gaithersburg",
          "Baltimore",
          "Towson",
          "Parkville",
          "Waldorf",
          "Bethesda",
          "Germantown",
        ],
        extraCities: [
          ExtraCityMatch("Vienna", GeoBox(maxLon: -70)),
          ExtraCityMatch("Arlington", GeoBox(minLat: 36, maxLon: -70)),
        ],
      ),
      CityDef(
        fa: "آتلانتا",
        en: "Atlanta",
        aliases: [
          "Alpharetta",
          "Sandy Springs",
          "Peachtree Corners",
          "Johns Creek",
          "Stone Mountain",
          "Roswell",
          "Kennesaw",
          "Marietta",
        ],
      ),
      CityDef(fa: "لاس‌وگاس", en: "Las Vegas"),
      CityDef(fa: "آستین", en: "Austin"),
      CityDef(fa: "پورتلند", en: "Portland", aliases: ["Beaverton"]),
      CityDef(
        fa: "سیاتل",
        en: "Seattle",
        aliases: ["Kirkland", "Tacoma", "Bellevue", "Lynnwood"],
      ),
      CityDef(fa: "دنور", en: "Denver", aliases: ["Centennial"]),
      CityDef(
        fa: "فینیکس",
        en: "Phoenix",
        aliases: ["Scottsdale", "Tucson", "Chandler", "Gilbert", "Tempe"],
      ),
      CityDef(
        fa: "ساکرامنتو",
        en: "Sacramento",
        aliases: ["Folsom", "Roseville", "Citrus Heights"],
      ),
      CityDef(
        fa: "سالت‌لیک‌سیتی",
        en: "Salt Lake City",
        aliases: ["Cottonwood Heights", "Midvale"],
      ),
      CityDef(
        fa: "اوکلاهماسیتی",
        en: "Oklahoma City",
        aliases: ["Warr Acres", "Tulsa", "Norman"],
      ),
      CityDef(fa: kOtherCitiesFa, en: kOtherCitiesKey),
    ],
  ),
  CountryDef(
    fa: "استرالیا",
    allCities: {"sydney", "melbourne"},
    cities: [
      CityDef(fa: "سیدنی", en: "Sydney"),
      CityDef(fa: "ملبورن", en: "Melbourne"),
    ],
  ),
  CountryDef(
    fa: "هلند",
    allCities: {"amsterdam", "utrecht", "eindhoven", "maastricht"},
    cities: [
      CityDef(fa: "آمستردام", en: "Amsterdam"),
      CityDef(fa: "اوترخت", en: "Utrecht"),
      CityDef(fa: "آیندهوون", en: "Eindhoven"),
      CityDef(fa: "ماستریخت", en: "Maastricht"),
    ],
  ),
  CountryDef(
    fa: "بلژیک",
    allCities: {
      "brussels",
      "antwerp",
      "namur",
      "kortrijk",
      "bruges",
      "ghent",
      "leuven",
    },
    cities: [
      CityDef(fa: "بروکسل", en: "Brussels"),
      CityDef(fa: "آنتورپ", en: "Antwerp"),
      CityDef(fa: kOtherCitiesFa, en: kOtherCitiesKey),
    ],
  ),
  CountryDef(
    fa: "سوئیس",
    allCities: {
      "zurich",
      "geneva",
      "basel",
      "geneva area",
      "saint-louis (basel area)",
      "freiburg (basel area)",
    },
    cities: [
      CityDef(fa: "زوریخ", en: "Zurich"),
      CityDef(fa: "ژنو", en: "Geneva", aliases: ["Geneva Area"]),
      CityDef(
        fa: "بازل",
        en: "Basel",
        aliases: ["Saint-Louis (Basel Area)", "Freiburg (Basel Area)"],
      ),
    ],
  ),
  CountryDef(
    fa: "اتریش",
    allCities: {"vienna", "wörgl (austria)"},
    cities: [
      CityDef(
        fa: "وین",
        en: "Vienna",
        box: GeoBox(minLon: 0),
      ),
      CityDef(fa: kOtherCitiesFa, en: kOtherCitiesKey),
    ],
  ),
  CountryDef(
    fa: "پرتغال",
    allCities: {"lisbon", "porto"},
    cities: [
      CityDef(fa: "لیسبون", en: "Lisbon"),
      CityDef(fa: "پورتو", en: "Porto"),
    ],
  ),
  CountryDef(
    fa: "امارات",
    allCities: {"dubai"},
    cities: [CityDef(fa: "دبی", en: "Dubai")],
  ),
  CountryDef(
    fa: "ژاپن",
    allCities: {"tokyo", "kyoto", "yokohama"},
    cities: [
      CityDef(fa: "توکیو", en: "Tokyo"),
      CityDef(fa: "کیوتو", en: "Kyoto"),
      CityDef(fa: "یوکوهاما", en: "Yokohama"),
    ],
  ),
  CountryDef(
    fa: "یونان",
    allCities: {"athens"},
    cities: [CityDef(fa: "آتن", en: "Athens")],
  ),
  CountryDef(
    fa: "سوئد",
    allCities: {"stockholm"},
    cities: [CityDef(fa: "استکهلم", en: "Stockholm")],
  ),
  CountryDef(
    fa: "نروژ",
    allCities: {"oslo"},
    cities: [CityDef(fa: "اسلو", en: "Oslo")],
  ),
  CountryDef(
    fa: "فنلاند",
    allCities: {"helsinki"},
    cities: [CityDef(fa: "هلسینکی", en: "Helsinki")],
  ),
  CountryDef(
    fa: "لهستان",
    allCities: {"warsaw"},
    cities: [CityDef(fa: "ورشو", en: "Warsaw")],
  ),
  CountryDef(
    fa: "چک",
    allCities: {"prague"},
    cities: [CityDef(fa: "پراگ", en: "Prague")],
  ),
  CountryDef(
    fa: "انگلیس",
    allCities: {
      "london",
      "manchester",
      "glasgow",
      "edinburgh",
      "liverpool",
      "leeds",
      "nottingham",
      "middlesbrough",
      "henley-on-thames",
      "dunfermline",
      "brighton and hove",
      "bristol",
      "bradford",
      "oldham",
      "oldham (manchester area)",
    },
    cities: [
      CityDef(fa: "لندن", en: "London"),
      CityDef(
        fa: "منچستر",
        en: "Manchester",
        aliases: ["Oldham", "Oldham (Manchester Area)"],
      ),
      CityDef(fa: "گلاسگو", en: "Glasgow"),
      CityDef(fa: "ادینبرو", en: "Edinburgh"),
      CityDef(fa: "لیورپول", en: "Liverpool"),
      CityDef(fa: kOtherCitiesFa, en: kOtherCitiesKey),
    ],
  ),
  CountryDef(
    fa: "ایرلند",
    allCities: {"dublin", "dublin (ireland)", "galway (ireland)"},
    cities: [
      CityDef(fa: "دوبلین", en: "Dublin", aliases: ["Dublin (Ireland)"]),
      CityDef(fa: kOtherCitiesFa, en: kOtherCitiesKey),
    ],
  ),
  CountryDef(
    fa: "دانمارک",
    allCities: {"copenhagen"},
    cities: [CityDef(fa: "کپنهاگ", en: "Copenhagen")],
  ),
  CountryDef(
    fa: "چین",
    allCities: {"shanghai", "beijing"},
    cities: [
      CityDef(fa: "شانگهای", en: "Shanghai"),
      CityDef(fa: "پکن", en: "Beijing"),
    ],
  ),
  CountryDef(
    fa: "مالزی",
    allCities: {"kuala lumpur", "ampang"},
    cities: [
      CityDef(
        fa: "کوالالامپور",
        en: "Kuala Lumpur",
        aliases: ["Ampang"],
      ),
    ],
  ),
  CountryDef(
    fa: "اسرائیل",
    allCities: {"tel aviv", "jerusalem"},
    cities: [
      CityDef(fa: "تل‌آویو", en: "Tel Aviv"),
      CityDef(fa: "اورشلیم", en: "Jerusalem"),
    ],
  ),
  CountryDef(
    fa: "عربستان",
    allCities: {"riyadh", "jeddah", "khobar", "dammam", "al hofuf"},
    cities: [
      CityDef(fa: "ریاض", en: "Riyadh"),
      CityDef(fa: "جده", en: "Jeddah"),
      CityDef(fa: "خبر", en: "Khobar"),
      CityDef(fa: kOtherCitiesFa, en: kOtherCitiesKey),
    ],
  ),
  CountryDef(
    fa: "قطر",
    allCities: {"doha"},
    cities: [CityDef(fa: "دوحه", en: "Doha")],
  ),
  CountryDef(
    fa: "سایر کشورها",
    allCities: {
      "seoul",
      "são paulo",
      "nairobi",
      "accra",
      "johannesburg",
      "cape town",
      "manama",
      "medellín",
      "tijuana",
      "florianópolis",
      "puerto varas",
    },
    cities: [
      CityDef(fa: "سئول", en: "Seoul"),
      CityDef(fa: "سائوپائولو", en: "São Paulo"),
      CityDef(fa: "نایروبی", en: "Nairobi"),
      CityDef(fa: "آکرا", en: "Accra"),
      CityDef(fa: "ژوهانسبورگ", en: "Johannesburg"),
      CityDef(fa: "کیپ‌تاون", en: "Cape Town"),
      CityDef(fa: "منامه", en: "Manama"),
      CityDef(fa: "مدلین", en: "Medellín"),
      CityDef(fa: "تیخوانا", en: "Tijuana"),
      CityDef(fa: "فلوریانوپولیس", en: "Florianópolis"),
      CityDef(fa: "پورتوواراس", en: "Puerto Varas"),
      CityDef(fa: kOtherCitiesFa, en: kRestworldKey),
    ],
  ),
];
