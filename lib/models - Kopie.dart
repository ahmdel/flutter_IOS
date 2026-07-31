// lib/models.dart

// ⭐️ توجه: این ثابت‌ها از data.js گرفته شده‌اند و باید در Dart تعریف شوند.

// ******************************************************************************
// ⚠️ حتماً این مقدار را با کلید OpenWeatherMap API خود جایگزین کنید.
const String WEATHER_API_KEY = "8ecea89fafb957ea20ff6dff7c6c1b6e"; 
// ******************************************************************************

// --- ثابت‌های برنامه‌ریزی سفر ---
const double MAX_DISTANCE_KM = 50;
const double AVERAGE_SPEED_KMH = 50; 
const int BUFFER_TIME_MINUTES = 10; 
const int PARKING_BUFFER_MINUTES = 10; // ⭐️ جدید: بافر زمان پارکینگ
const double WALKING_SPEED_KMH = 5; // ⭐️ جدید: سرعت پیاده‌روی
const double WALKING_DISTANCE_THRESHOLD_KM = 1.0; // ⭐️ جدید: آستانه مسافت پیاده‌روی

const int DAY_END_HOUR = 20; // 8 PM
const int NEXT_DAY_START_HOUR = 10; // 10 AM
const int LUNCH_START_HOUR = 12; // 12 PM
const int LUNCH_END_HOUR = 15; // 3 PM
const int LUNCH_DURATION_MINUTES = 60; // 1 hour for lunch
const int CLOSING_ALARM_MINUTES = 30;


// --- کلاس برای ساختار رستوران ---
class Restaurant {
  final String name;
  final String name_map;
  final double lat;
  final double lon;
  final String description;
  final String parkingInfo;

  Restaurant({required this.name, required this.name_map, required this.lat, required this.lon, required this.description, required this.parkingInfo});
}

// --- کلاس برای ساختار دیدنی‌ها (POI) ---
class Poi {
  final String name;
  final String name_map;
  final double lat;
  final double lon;
  final double rating;
  final String description;
  final String duration;
  final String best_season;
  final String suitable_age;
  final String unsuitable_age;
  final String opening_hours;
  final String ticket_price;
  final String ticket_link;

  Poi({
    required this.name,
    required this.name_map,
    required this.lat,
    required this.lon,
    required this.rating,
    required this.description,
    required this.duration,
    required this.best_season,
    required this.suitable_age,
    required this.unsuitable_age,
    required this.opening_hours,
    required this.ticket_price,
    required this.ticket_link,
  });
  // ⭐️ سازنده جدید برای ساخت آبجکت Poi از یک Map (JSON)
  factory Poi.fromJson(Map<String, dynamic> json) {
    return Poi(
      name: json['name'] as String,
      name_map: json['name_map'] as String,
      lat: json['lat'] as double,
      lon: json['lon'] as double,
      rating: json['rating'] as double,
      description: json['description'] as String,
      duration: json['duration'] as String,
      // توجه: در فایل‌های JS شما از "best_season" استفاده شده بود.
      // اما در مدل Dart شما از "bestSeason" استفاده شده است.
      // فرض می‌کنیم در JSON، از فرمت "best_season" استفاده می‌کنید:
      best_season: json['best_season'] as String, 
      suitable_age: json['suitable_age'] as String,
      unsuitable_age: json['unsuitable_age'] as String,
      opening_hours: json['opening_hours'] as String, 
      ticket_price: json['ticket_price'] as String,
      ticket_link: json['ticket_link'] as String,
    );
  }
}

// --- داده‌های رستوران‌ها ---
final List<Restaurant> RESTAURANTS_DATA = [
    // --- رستوران‌های هانوفر (Hannover) ---
    Restaurant(name: "رستوران کافه(Shirin)", name_map: "Shirin restaurant", lat: 52.37449880205847, lon: 9.712514870378651, description: "غذاهای ایرانی و کافی‌شاپ", parkingInfo: "در  ۵۰ متری پارکینگ REWE. (پارکینگ خیابانی محدود)"),
    Restaurant(name: "رستوران (Alborz)", name_map: "Alborz restaurant", lat: 52.377668567872355,  lon: 9.728442128607409, description: "غذاهای ایرانی", parkingInfo: "پارکینگ عمومی (Parkhaus Steintor) در ۴۰۰ متری."),
    Restaurant(name: "رستوران (Shahre raz)", name_map: "Shahre raz restaurant", lat: 52.40653579844794, lon: 9.729493319811787, description: "غذاهای ایرانی", parkingInfo: "پارکینگ خیابانی دارد"),
    Restaurant(name: "رستوران (Safran)", name_map: "Safran restaurant", lat: 52.37959363732814, lon: 9.732997290493056, description: "غذاهای ایرانی", parkingInfo: "پارکینگ عمومی (Parkhaus Hauptbahnhof) در ۶۰۰ متری."),
    Restaurant(name: "رستوران (Nasim Banoo)", name_map: "Nasim Banoo restaurant", lat: 52.37959363732814, lon: 9.733347687561183, description: "غذاهای ایرانی", parkingInfo: "پارکینگ عمومی (Parkhaus Hauptbahnhof) در  ۶۰۰ متری."),
    
    // Fast food Hannover
    Restaurant(name: "McDonald's (Kröpcke)", name_map: "McDonald's Hannover Kröpcke", lat: 52.373900, lon: 9.736900, description: "معروف‌ترین شعبه، در قلب مرکز شهر و نزدیک برج Kröpcke.", parkingInfo: "پارکینگ زیرزمینی Kröpcke (پولی و شلوغ)."),
    Restaurant(name: "McDonald's (Hauptbahnhof)", name_map: "McDonald's Hauptbahnhof", lat: 52.376820, lon: 9.740250, description: "شعبه پرتردد در داخل ایستگاه قطار مرکزی، مناسب برای گردشگران.", parkingInfo: "پارکینگ عمومی زیرزمینی ایستگاه مرکزی (پولی)."),
    Restaurant(name: "Burger King (Steintor)", name_map: "Burger King Hannover Steintor", lat: 52.376100, lon: 9.730500, description: "نزدیک به خیابان‌های خرید Steintor و مناطق تفریحی.", parkingInfo: "پارکینگ‌های عمومی اطراف Steintor (پولی)."),
    Restaurant(name: "KFC (Ernst-August-Galerie)", name_map: "KFC Ernst-August-Galerie", lat: 52.377800, lon: 9.737800, description: "مرغ سوخاری کنتاکی در داخل مرکز خرید بزرگ هانوفر.", parkingInfo: "پارکینگ داخلی مرکز خرید Ernst-August-Galerie (پولی)."),
    Restaurant(name: "Domino's Pizza (Mitte)", name_map: "Domino's Pizza Hannover Mitte", lat: 52.375050, lon: 9.728900, description: "تحویل سریع پیتزا و شعبه مرکزی برای سرویس دهی به مرکز شهر.", parkingInfo: "پارکینگ خیابانی محدود در مرکز (پولی)."),
    Restaurant(name: "Subway (Georgstraße)", name_map: "Subway Georgstraße", lat: 52.373500, lon: 9.735000, description: "ساندویچ‌های سرد و گرم سفارشی در خیابان اصلی خرید.", parkingInfo: "پارکینگ عمومی زیرزمینی Kröpcke یا Galeria Kaufhof (پولی)."),
    Restaurant(name: "Vapiano (City)", name_map: "Vapiano Hannover", lat: 52.374500, lon: 9.735500, description: "فست کژوال ایتالیایی (پاستا و پیتزا) با محیط مدرن.", parkingInfo: "پارکینگ عمومی مرکز شهر (پولی)."),
    //Dönner Hannover
    Restaurant(name: "Stern Kebap", name_map: "Stern Kebap", lat: 52.375670, lon: 9.736020, description: "کباب ترکی بسیار پرطرفدار نزدیک ایستگاه مرکزی (Hauptbahnhof) و مرکز شهر.", parkingInfo: "پارکینگ عمومی زیرزمینی ایستگاه مرکزی (پولی)."),
    Restaurant(name: "Hades Grill (Linden)", name_map: "Hades Grill", lat: 52.368812, lon: 9.704255, description: "دونر کباب با کیفیت عالی در منطقه پرجنب‌وجوش لیندن (نزدیک مرکز شهر).", parkingInfo: "پارکینگ خیابانی در منطقه لیندن (محدود و دارای دستگاه پولی)."),
    Restaurant(name: "Adana Grill (Nordstadt)", name_map: "Adana Grill", lat: 52.388044, lon: 9.716173, description: "کباب ترکی اصیل و قدیمی نزدیک دانشگاه هانوفر.", parkingInfo: "پارکینگ خیابانی در نوردشتات (غالباً رایگان یا با محدودیت زمانی)."),
    Restaurant(name: "Maschsee Kebab", name_map: "Kebab Haus Maschsee", lat: 52.355105, lon: 9.740880, description: "دونر کباب خوب و مناسب برای گردشگران دریاچه ماسچزه.", parkingInfo: "پارکینگ عمومی کنار دریاچه ماسچزه (محدود)."),
    Restaurant(name: "O-Kebab (Lister Meile)", name_map: "O-Kebab", lat: 52.380120, lon: 9.750550, description: "دونر کباب با شهرت بالا در خیابان پرطرفدار Lister Meile.", parkingInfo: "پارکینگ خیابانی در Lister Meile (پولی و شلوغ)."),
   
    // --- رستوران‌های بن (Bonn) ---
    Restaurant(name: "رستوران (Shiraz)", name_map: "Shiraz restaurant", lat: 50.749707645174894, lon: 7.101631136787984, description: "غذاهای ایرانی با فضای باز", parkingInfo: "پارکینگ عمومی (Parkhaus Friedrichstraße) در  ۲۰۰ متری."),
    Restaurant(name: "رستوران (Zagros)", name_map: "Zagros restaurant", lat: 50.75926450296553, lon: 7.04532620770528, description: "غذاهای ایرانی", parkingInfo: "پارکینگ عمومی (Parkhaus P+R Endenicher Str.) در ۸۰۰ متری. (پارکینگ محله‌ای)"),
    Restaurant(name: "رستوران (Nirvan)", name_map: "Nirvan restaurant", lat: 50.763607884171215, lon: 7.097511263928273, description: "غذاهای ایرانی", parkingInfo: "پارکینگ عمومی (Parkhaus Stiftsgarage) در  ۵۰۰ متری."),

    // --- رستوران‌های کلن (Cologne) ---
    Restaurant(name: "رستوران (Alborz)", name_map: "Alborz", lat: 50.93127276745225, lon: 6.937821572779951, description: "غذاهای ایرانی", parkingInfo: "(پارکینگ خیابانی محدود)پارکینگ عمومی (Parkhaus Theaterpassage) در ۳۰۰ متری."),
    Restaurant(name: "رستوران (Mana)", name_map: "Mana restaurant", lat: 50.921850308811194, lon: 6.848455041104789, description: "غذاهای ایرانی", parkingInfo: "پارکینگ دارد"),
    
    // Amsterdam Restaurants
    Restaurant(name: "رستوران (Persia)", name_map: "Persia Iranian Restaurant", lat: 52.3734, lon: 4.9080, description: "رستوران مرکزی با دکوراسیون ایرانی و محیط دلنشین.", parkingInfo: "پارکینگ عمومی (Parking Centrum Oosterdok) در ۷۰۰ متری. (پارک در مرکز شهر گران است)"),
    Restaurant(name: "رستوران (Shiraz)", name_map: "Shiraz Restaurant", lat: 52.3664, lon: 4.8872, description: "غذاهای شیرازی و کباب‌های اصیل.", parkingInfo: "پارکینگ عمومی (Q-Park Museumplein) در ۴۰۰ متری."),
    Restaurant(name: "رستوران (Dirozeh)", name_map: "Dirozeh Restaurant", lat: 52.3691, lon: 4.8965, description: "رستوران کوچک با غذاهای خانگی و قیمت مناسب.", parkingInfo: "پارکینگ عمومی (P1 Parking Waterlooplein) در ۶۰۰ متری."),
    Restaurant(name: "رستوران (Moordam)", name_map: "Moordam Restaurant", lat: 52.3776, lon: 4.8994, description: "غذاهای ایرانی و مدیترانه‌ای، نزدیک به ایستگاه مرکزی.", parkingInfo: "پارکینگ عمومی (Parking Centrum Oosterdok) در ۴۰۰ متری."),
    Restaurant(name: "رستوران (Rey)", name_map: "Rey Restaurant", lat: 52.3521, lon: 4.8860, description: "رستوران با غذاهای ایرانی و فضای سنتی، نزدیک به موزه‌ها.", parkingInfo: "پارکینگ خیابانی بسیار گران و کمیاب. توصیه می‌شود از پارکینگ‌های P+R در حومه شهر استفاده شود."),
    Restaurant(name: "رستوران (Tehrani)", name_map: "Tehrani Restaurant", lat: 52.3598, lon: 4.8703, description: "رستوران مدرن با سرویس بیرون‌بر، معروف به جوجه کباب.", parkingInfo: "پارکینگ عمومی (Parkeergarage Overtoom) در ۸۰۰ متری."),
    Restaurant(name: "رستوران (Sadaf)", name_map: "Sadaf Restaurant", lat: 52.3789, lon: 4.8770, description: "رستوران کلاسیک ایرانی با محیط آرام و غذاهای متنوع.", parkingInfo: "پارکینگ عمومی (Parking Westerdok) در ۱ کیلومتری."),
    
    // Amsterdam Fastfood 
    Restaurant(name: "McDonald's (Damrak)", name_map: "McDonald's Amsterdam Damrak", lat: 52.375200, lon: 4.896700, description: "شعبه مرکزی و شلوغ در نزدیکی میدان دام و ایستگاه مرکزی.", parkingInfo: "پارکینگ عمومی Q-Park De Bijenkorf (پولی و شلوغ)."),
    Restaurant(name: "Burger King (Centraal)", name_map: "Burger King Amsterdam Centraal Station", lat: 52.378700, lon: 4.901500, description: "در داخل ایستگاه مرکزی آمستردام، مناسب برای مسافران.", parkingInfo: "پارکینگ زیرزمینی ایستگاه مرکزی (پولی)."),
    Restaurant(name: "KFC (Leidsestraat)", name_map: "KFC Amsterdam Leidsestraat", lat: 52.365900, lon: 4.885600, description: "نزدیک به میدان لایدزپلاین و مناطق تفریحی.", parkingInfo: "پارکینگ خیابانی محدود (پولی)."),
    Restaurant(name: "Domino's Pizza (Centrum)", name_map: "Domino's Pizza Amsterdam Centrum", lat: 52.368000, lon: 4.887000, description: "تحویل پیتزا سریع به منطقه مرکزی و کانال‌های اطراف.", parkingInfo: "پارکینگ خیابانی محدود در Centrum (پولی)."),
    Restaurant(name: "Subway (Rokin)", name_map: "Subway Rokin", lat: 52.369500, lon: 4.893500, description: "ساندویچ‌های سرد و گرم سفارشی نزدیک به موزه مادام توسو.", parkingInfo: "پارکینگ عمومی Rokin (پولی)."),
    // Amsterdam Dönner
    Restaurant(name: "Manneken Pis (Frites)", name_map: "Manneken Pis Frites", lat: 52.377000, lon: 4.896000, description: "معروف‌ترین سیب‌زمینی سرخ کرده هلندی با سس‌های متنوع، نزدیک ایستگاه مرکزی.", parkingInfo: "پارکینگ عمومی زیرزمینی ایستگاه مرکزی (پولی)."),
    Restaurant(name: "Febo (Croquette/Frikandel)", name_map: "Febo Leidsestraat", lat: 52.366500, lon: 4.885000, description: "فست فود هلندی با غذاهای کروکتی در دستگاه‌های خودکار (Automatiek).", parkingInfo: "پارکینگ خیابانی محدود در Leidsestraat (پولی)."),
    Restaurant(name: "Has Döner (Döner Kebab)", name_map: "Has Döner Kebab", lat: 52.373000, lon: 4.890500, description: "یکی از دونرهای پرطرفدار و با کیفیت در مرکز شهر.", parkingInfo: "پارکینگ عمومی نزدیک به وسترکرک (پولی)."),
    Restaurant(name: "Maoz Vegetarian (Falafel)", name_map: "Maoz Vegetarian Falafel", lat: 52.370500, lon: 4.892000, description: "فلافل فروشی محبوب که مشتری می‌تواند مواد داخل ساندویچ را خود انتخاب کند.", parkingInfo: "پارکینگ عمومی Rokin (پولی)."),
    Restaurant(name: "Vleminckx (Frites)", name_map: "Vleminckx The Sausmeesters", lat: 52.370000, lon: 4.891000, description: "سیب‌زمینی سرخ کرده تخصصی دیگر، کمی دورتر از مرکز شلوغ.", parkingInfo: "پارکینگ خیابانی محدود (پولی)."),


    // Hamburg Fastfood
    Restaurant(name: "McDonald's (Hauptbahnhof)", name_map: "McDonald's Hamburg Hauptbahnhof", lat: 53.552900, lon: 10.003900, description: "شعبه بزرگ و شلوغ در ایستگاه مرکزی، مناسب برای مسافران.", parkingInfo: "پارکینگ زیرزمینی ایستگاه مرکزی (پولی)."),
    Restaurant(name: "Burger King (Mönckebergstraße)", name_map: "Burger King Hamburg Mönckebergstraße", lat: 53.551000, lon: 9.998000, description: "در خیابان اصلی خرید هامبورگ، نزدیک به Rathaus و Binnenalster.", parkingInfo: "پارکینگ زیرزمینی مرکز شهر (پولی)."),
    Restaurant(name: "KFC (Reeperbahn)", name_map: "KFC Hamburg Reeperbahn", lat: 53.548700, lon: 9.970100, description: "در منطقه تفریحی و پرجنب‌وجوش رپر‌بان.", parkingInfo: "پارکینگ عمومی محدود در نزدیکی Reeperbahn (پولی)."),
    Restaurant(name: "Domino's Pizza (City)", name_map: "Domino's Pizza Hamburg City", lat: 53.550000, lon: 9.995000, description: "سرویس‌دهی پیتزا به منطقه مرکزی شهر.", parkingInfo: "پارکینگ خیابانی محدود در City (پولی)."),
    Restaurant(name: "Subway (Speersort)", name_map: "Subway Speersort", lat: 53.551500, lon: 10.005000, description: "ساندویچ‌های ساب، نزدیک به مرکز رسانه‌ای و تجاری.", parkingInfo: "پارکینگ زیرزمینی Speersort (پولی)."),

    // Hamburg Restaurants
    Restaurant(name: "رستوران (Safran)", name_map: "Safran Iranian Restaurant", lat: 53.5516, lon: 9.9984, description: "غذاهای اصیل ایرانی با تمرکز بر کباب و خورش.", parkingInfo: "پارکینگ عمومی (Parkhaus Große Reichenstraße) در فاصله ۲۰۰ متری."),
    Restaurant(name: "رستوران (Mashid)", name_map: "Mashid Restaurant", lat: 53.5658, lon: 10.0152, description: "فضای شیک و مدرن، مناسب برای دورهمی‌های خانوادگی.", parkingInfo: "دارای پارکینگ اختصاصی کوچک در پشت ساختمان."),
    Restaurant(name: "رستوران (Persepolis)", name_map: "Persepolis Restaurant", lat: 53.5574, lon: 9.9715, description: "منوی کامل ایرانی با پیش‌غذاهای متنوع و محیط سنتی.", parkingInfo: "پارکینگ خیابانی محدود. پارکینگ عمومی (Tiefgarage Gänsemarkt) در ۶۰۰ متری."),
    Restaurant(name: "رستوران (Schahrasad)", name_map: "Schahrasad Restaurant", lat: 53.5630, lon: 10.0076, description: "غذاهای ایرانی و گیاهی، معروف به کیفیت برنج.", parkingInfo: "پارکینگ عمومی (Parkhaus Hauptbahnhof) در ۸۰۰ متری."),
    Restaurant(name: "رستوران (Pars)", name_map: "Pars Restaurant", lat: 53.5439, lon: 9.9880, description: "نزدیک به منطقه Hafencity، مناسب برای گردشگران.", parkingInfo: "پارکینگ عمومی (Contipark Tiefgarage Überseequartier) در ۳۰۰ متری."),
    Restaurant(name: "رستوران (Tehran)", name_map: "Tehran Restaurant", lat: 53.5702, lon: 9.9701, description: "رستوران قدیمی با طعم‌های خانگی و محیط گرم.", parkingInfo: "پارکینگ خیابانی (احتمالاً رایگان در شب)."),
    Restaurant(name: "رستوران (Rumi)", name_map: "Rumi Restaurant", lat: 53.5580, lon: 9.9805, description: "رستوران ایرانی با تمرکز بر غذاهای شرقی.", parkingInfo: "پارکینگ عمومی (Parkhaus Alsterhaus) در ۵۰۰ متری."),
    
    // Hamburg Dönner
    Restaurant(name: "Efe Döner (St. Georg)", name_map: "Efe Döner", lat: 53.557000, lon: 10.009000, description: "یکی از مشهورترین دونر کباب‌های هامبورگ، نزدیک ایستگاه مرکزی.", parkingInfo: "پارکینگ خیابانی در St. Georg (پولی)."),
    Restaurant(name: "Imbiss Kiez", name_map: "Imbiss Kiez Döner", lat: 53.547500, lon: 9.970000, description: "دونر کباب سریع و محبوب در منطقه Reeperbahn.", parkingInfo: "پارکینگ عمومی محدود در نزدیکی Reeperbahn (پولی)."),
    Restaurant(name: "Batman (Ottensen)", name_map: "Batman Döner", lat: 53.546000, lon: 9.904000, description: "دونر کباب با شهرت بالا در منطقه غربی هامبورگ.", parkingInfo: "پارکینگ خیابانی در Ottensen (محدود)."),
    Restaurant(name: "City Döner (Rathaus)", name_map: "City Döner", lat: 53.550500, lon: 9.995500, description: "دونر کباب در قلب مرکز شهر، نزدیک به تالار شهر (Rathaus).", parkingInfo: "پارکینگ زیرزمینی Rathaus (پولی)."),
    Restaurant(name: "Döner Point (Eimsbüttel)", name_map: "Döner Point", lat: 53.570000, lon: 9.950000, description: "دونر کباب پرطرفدار در منطقه دانشجویی Eimsbüttel.", parkingInfo: "پارکینگ خیابانی (محدود).")









//New York
Restaurant(name:"Ravagh Persian Grill",name_map:"Ravagh Persian Grill New York",lat:40.76754030727453,lon:-73.99135634609802,description:"Persian / Iranian Restaurant",parkingInfo:"Street parking & nearby public parking"),

Restaurant(name:"Shiraz Kitchen & Wine Bar",name_map:"Shiraz Kitchen & Wine Bar New York",lat:40.77274051723356,lon:-73.99272963711363,description:"Persian restaurant with wine bar",parkingInfo:"Street parking & nearby public parking"),

Restaurant(name:"Persepolis",name_map:"Persepolis Restaurant New York",lat:40.78937845417999,lon:-73.95015761562955,description:"Classic Persian cuisine",parkingInfo:"Street parking"),

Restaurant(name:"Eyval",name_map:"Eyval Restaurant New York",lat:40.72384247777431,lon:-73.92543837734847,description:"Modern Persian cuisine",parkingInfo:"Street parking"),

Restaurant(name:"Miraj Healthy Grill",name_map:"Miraj Healthy Grill New York",lat:40.76233969035203,lon:-73.97487685391063,description:"Healthy Persian grill",parkingInfo:"Street parking"),

Restaurant(name:"Sofreh",name_map:"Sofreh Restaurant New York",lat:40.69781823439094,lon:-73.9721302718794,description:"Persian restaurant with traditional flavors",parkingInfo:"Street parking"),

Restaurant(name:"Brooklyn Noosh",name_map:"Brooklyn Noosh Persian Restaurant New York",lat:40.70406498039346,lon:-73.96938368984817,description:"Persian / Iranian diner",parkingInfo:"Street parking"),

Restaurant(name:"Nasrin's Kitchen",name_map:"Nasrin's Kitchen New York",lat:40.798735462192504,lon:-73.98311660000432,description:"Homestyle Persian cooking",parkingInfo:"Street parking"),

Restaurant(name:"Ravagh Persian Grill (Midtown)",name_map:"Ravagh Persian Grill Midtown New York",lat:40.781060006656546,lon:-73.96526381680131,description:"Persian grill and kebabs",parkingInfo:"Street parking"),

Restaurant(name:"Ravagh Persian Grill (Long Island)",name_map:"Ravagh Persian Grill Long Island New York",lat:40.80705169553062,lon:-73.6507801742254,description:"Persian grill and kebabs",parkingInfo:"Parking lot available"),

Restaurant(name:"Miraj Healthy Grill (Long Island)",name_map:"Miraj Healthy Grill Long Island New York",lat:40.77482048726493,lon:-73.65215346524103,description:"Healthy Persian cuisine",parkingInfo:"Parking lot available"),

Restaurant(name:"Colbeh Restaurant",name_map:"Colbeh Restaurant New York",lat:40.81432754490513,lon:-73.72493788906864,description:"Persian restaurant with traditional menu",parkingInfo:"Parking lot available"),

Restaurant(name:"Pardis Persian Grill",name_map:"Pardis Persian Grill New York",lat:41.011510060564284,lon:-74.10808608242532,description:"Persian grill & kebabs",parkingInfo:"Parking lot available"),

Restaurant(name:"Patoug Persian Cuisine",name_map:"Patoug Persian Cuisine New York",lat:40.76754030727453,lon:-73.75789687344341,description:"Persian cuisine",parkingInfo:"Street parking"),

Restaurant(name:"Bijan's",name_map:"Bijan's Restaurant New York",lat:40.711352110300936,lon:-73.99135634609802,description:"Traditional Persian dishes",parkingInfo:"Street parking"),

Restaurant(name:"FandoQ",name_map:"FandoQ Restaurant New York",lat:40.764419985955946,lon:-73.58211562344464,description:"Persian comfort food",parkingInfo:"Parking lot available"),

Restaurant(name:"Sands of Persia Lounge & Restaurant",name_map:"Sands of Persia Restaurant New York",lat:40.78209986957679,lon:-73.91719863125479,description:"Persian lounge & dining",parkingInfo:"Street parking"),

Restaurant(name:"Chatanooga Glatt Kosher Persian Restaurant",name_map:"Chatanooga Glatt Kosher Persian Restaurant New York",lat:40.804972734885524,lon:-73.72493788906864,description:"Kosher Persian restaurant",parkingInfo:"Parking lot available"),

Restaurant(name:"Masquerade",name_map:"Masquerade Restaurant New York",lat:40.73216808744674,lon:-73.94466445156708,description:"Persian fusion cuisine",parkingInfo:"Street parking"),

Restaurant(name:"Zaffron Bloom",name_map:"Zaffron Bloom Restaurant New York",lat:40.88496569974731,lon:-74.07100722500371,description:"Persian fine dining",parkingInfo:"Parking lot available"),

Restaurant(name:"Seven Valleys",name_map:"Seven Valleys Restaurant New York",lat:40.783139716217256,lon:-74.03392836758209,description:"Modern Persian cuisine",parkingInfo:"Parking lot available"),

Restaurant(name:"Shiraz",name_map:"Shiraz Restaurant New York",lat:40.83095506173797,lon:-73.73180434414672,description:"Persian restaurant",parkingInfo:"Parking lot available"),

Restaurant(name:"Parisa Persian Grill",name_map:"Parisa Persian Grill New York",lat:41.00218310681013,lon:-74.13143202969077,description:"Persian grill",parkingInfo:"Parking lot available"),

Restaurant(name:"The Cottage by Colbeh",name_map:"The Cottage by Colbeh New York",lat:40.81328818669833,lon:-73.65764662930349,description:"Persian cuisine in cozy setting",parkingInfo:"Parking lot available"),






// London
Restaurant(name:"Berenjak Borough",name_map:"Berenjak Borough London",lat:51.51291417484626,lon:-0.09062441820412062,description:"Modern Persian cuisine",parkingInfo:"Street parking nearby"),

Restaurant(name:"Tajrish Restaurant",name_map:"Tajrish Restaurant London",lat:51.52171914311672,lon:-0.1810145580680503,description:"Traditional Persian restaurant",parkingInfo:"Street parking"),

Restaurant(name:"Naroon Fitzrovia",name_map:"Naroon Fitzrovia London",lat:51.52684577213361,lon:-0.1405024759406448,description:"Modern Persian dining",parkingInfo:"Street parking"),

Restaurant(name:"Chef Javad Persian Cuisine & Bar",name_map:"Chef Javad Persian Cuisine & Bar London",lat:51.5024891433047,lon:-0.20367385816482667,description:"Persian cuisine & bar",parkingInfo:"Street parking"),

Restaurant(name:"Diba Persian Restaurant (Chelsea)",name_map:"Diba Persian Restaurant Chelsea London",lat:51.49180230236709,lon:-0.18101455801919625,description:"Classic Persian cuisine",parkingInfo:"Street parking"),

Restaurant(name:"Naroon Marylebone",name_map:"Naroon Marylebone London",lat:51.52385530866497,lon:-0.15217544874293915,description:"Persian fine dining",parkingInfo:"Street parking"),

Restaurant(name:"Sima’s Persian Grill",name_map:"Sima’s Persian Grill London",lat:51.61263102732989,lon:-0.18856765806773979,description:"Persian grill & kebabs",parkingInfo:"Parking available nearby"),

Restaurant(name:"Mother Restaurant",name_map:"Mother Restaurant London",lat:51.61604201663462,lon:-0.19200088536253226,description:"Home-style Persian food",parkingInfo:"Parking available nearby"),

Restaurant(name:"Almas Restaurant",name_map:"Almas Restaurant London",lat:51.54521145344672,lon:-0.18376113985503026,description:"Persian traditional cuisine",parkingInfo:"Street parking"),

Restaurant(name:"Bibi Persian Kitchen",name_map:"Bibi Persian Kitchen London",lat:51.558020331159156,lon:-0.18925430352669825,description:"Persian home cooking",parkingInfo:"Street parking"),

Restaurant(name:"Berenjak Soho",name_map:"Berenjak Soho London",lat:51.52171914308354,lon:-0.13157608497418422,description:"Modern Persian cuisine",parkingInfo:"Street parking"),

Restaurant(name:"Sufi Authentic Persian Kitchen",name_map:"Sufi Persian Kitchen London",lat:51.51018211731405,lon:-0.24418594024337828,description:"Authentic Persian food",parkingInfo:"Street parking"),

Restaurant(name:"Iran Restaurant",name_map:"Iran Restaurant London",lat:51.51531004508721,lon:-0.15011551236606369,description:"Classic Iranian restaurant",parkingInfo:"Street parking"),

Restaurant(name:"Signature Persian Kitchen & Bar",name_map:"Signature Persian Kitchen & Bar London",lat:51.56271601602812,lon:-0.2105403127544118,description:"Modern Persian cuisine",parkingInfo:"Street parking"),

Restaurant(name:"Yasmin Restaurant",name_map:"Yasmin Restaurant London",lat:51.48966463349132,lon:-0.2167201218850383,description:"Persian traditional dishes",parkingInfo:"Street parking"),

Restaurant(name:"Diba Persian Restaurant (Marylebone)",name_map:"Diba Persian Restaurant Marylebone London",lat:51.52898169722406,lon:-0.15217544874293926,description:"Persian fine dining",parkingInfo:"Street parking"),

Restaurant(name:"Bamanoosh Persian Kitchen",name_map:"Bamanoosh Persian Kitchen London",lat:51.39593637165036,lon:-0.2956843496652658,description:"Persian street food",parkingInfo:"Parking available"),

Restaurant(name:"Sadaf Restaurant",name_map:"Sadaf Restaurant London",lat:51.52898169722406,lon:-0.19474746719836628,description:"Traditional Persian cuisine",parkingInfo:"Street parking"),

Restaurant(name:"Diba Persian Restaurant (Wimbledon)",name_map:"Diba Persian Restaurant Wimbledon London",lat:51.426344233624135,lon:-0.20161392178795126,description:"Persian cuisine",parkingInfo:"Street parking"),

Restaurant(name:"Farsi Restaurant",name_map:"Farsi Restaurant London",lat:51.61391017835877,lon:-0.19062759444461524,description:"Traditional Persian food",parkingInfo:"Parking nearby"),

Restaurant(name:"Rose Restaurant",name_map:"Rose Restaurant London",lat:51.38822412252963,lon:-0.2792048586502618,description:"Persian cuisine",parkingInfo:"Parking available"),

Restaurant(name:"Oniseh",name_map:"Oniseh Restaurant London",lat:51.39722162011299,lon:-0.29911757696005836,description:"Persian cuisine",parkingInfo:"Parking available"),

Restaurant(name:"Sinuhe Restaurant",name_map:"Sinuhe Restaurant London",lat:51.52513695991492,lon:-0.19200088536253232,description:"Persian & Middle Eastern cuisine",parkingInfo:"Street parking"),

Restaurant(name:"Kish Persian Restaurant",name_map:"Kish Persian Restaurant London",lat:51.54393036730851,lon:-0.1885676580677397,description:"Persian kebabs & stews",parkingInfo:"Street parking"),

Restaurant(name:"Massimo Restaurant London",name_map:"Massimo Restaurant London London",lat:51.58021384289673,lon:-0.20779373091857767,description:"Persian & Mediterranean cuisine",parkingInfo:"Street parking"),

Restaurant(name:"Tehroon",name_map:"Tehroon Restaurant London",lat:51.587040436168394,lon:-0.19612075811628324,description:"Modern Persian cuisine",parkingInfo:"Street parking"),

Restaurant(name:"Mehr O Mah Restaurant",name_map:"Mehr O Mah Restaurant London",lat:51.62755221311277,lon:-0.17895462164232073,description:"Persian traditional cuisine",parkingInfo:"Parking available"),

Restaurant(name:"Seymour Kitchen",name_map:"Seymour Kitchen London",lat:51.522573621340925,lon:-0.16590835792210926,description:"Home-style Persian cuisine",parkingInfo:"Street parking"),

Restaurant(name:"Beheshte Barin",name_map:"Beheshte Barin London",lat:51.63991176481259,lon:-0.17346145797065282,description:"Persian ceremonial dishes",parkingInfo:"Parking available"),


//Zurich
//Banoo Im Rössli 47.236946820003894, 8.816749329554238
//Karun Persisches Restaurant 47.42050118478684, 8.459859829554231
//NUUH persian cooking 47.455478432245556, 8.536351238811477
// kookoo restaurant 47.380573000675966, 8.545771338576548
//Persienmarkt 47.47230751209381, 8.30734847247261
//Höngger Oriental 47.40414786508359, 8.497273299136827
//Mama Persia 47.30516173273241, 8.560775947482972
//Payam Persian Food 47.404277045187435, 8.498082757388552
//Grosser Alexander | Shahrzad 47.47602668593128, 8.311152460123544
//Afghan Anar 47.374635125633986, 8.55386125738856


//Dubai
Restaurant(name:"رستوران ایران زمین",name_map:"Iran Zamin Restaurant Dubai",lat:25.197270,lon:55.274290,description:"رستوران محبوب ایرانی با غذای سنتی در Downtown",parkingInfo:"پارکینگ عمومی Dubai Mall"),

Restaurant(name:"رستوران ایرانیش",name_map:"Iranish Iranian Restaurant Dubai",lat:25.237800,lon:55.250900,description:"رستوران ایرانی با منوی کلاسیک در جمیرا",parkingInfo:"پارکینگ عمومی Al Wasl Road"),

Restaurant(name:"رستوران لذیذ",name_map:"Laziz Persian Restaurant Dubai",lat:25.227400,lon:55.283500,description:"رستوران ایرانی با طعم اصیل",parkingInfo:"پارکینگ عمومی اطراف Al Jadaf"),

Restaurant(name:"رستوران بهار",name_map:"Bahar Restaurant Dubai",lat:25.241000,lon:55.262000,description:"رستوران ایرانی با غذاهای سنتی",parkingInfo:"پارکینگ عمومی اطراف Al Mina Street"),

Restaurant(name:"رستوران فارسی",name_map:"Farsi Restaurant Dubai",lat:25.075700,lon:55.145900,description:"رستوران ایرانی در JLT / Sheikh Zayed Rd",parkingInfo:"پارکینگ عمومی JLT"),

Restaurant(name:"الاوستاد کباب خاص",name_map:"Al Ustad Special Kebab Dubai",lat:25.263800,lon:55.296100,description:"کبابی ایرانی کلاسیک در Al Fahidi",parkingInfo:"پارکینگ عمومی Al Fahidi"),

Restaurant(name:"رستوران پارس",name_map:"Pars Iranian Restaurant Dubai",lat:25.259500,lon:55.330000,description:"رستوران ایرانی در Al Dhiyafa Rd",parkingInfo:"پارکینگ عمومی Trade Centre"),

Restaurant(name:"رستوران شبستان",name_map:"Shabestan Restaurant Dubai",lat:25.270600,lon:55.327800,description:"رستوران ایرانی در Radisson Blu Deira Creek",parkingInfo:"پارکینگ هتل Radisson Blu"),

Restaurant(name:"رستوران سیب",name_map:"The SIB Restaurant Dubai",lat:25.213000,lon:55.255000,description:"رستوران پرسیان محبوب در Palm Strip Mall",parkingInfo:"پارکینگ Palm Strip Mall"),

Restaurant(name:"رستوران ایران زمین (مارینا)",name_map:"Iran Zamin Marina Dubai",lat:25.078900,lon:55.137000,description:"شعبه مارینای رستوران ایران زمین",parkingInfo:"پارکینگ Marina Mall"),

Restaurant(name:"رستوران هاتم (دبی مال)",name_map:"Hatam Dubai Mall Dubai",lat:25.197200,lon:55.279800,description:"رستوران ایرانی در Dubai Mall",parkingInfo:"پارکینگ Dubai Mall"),

Restaurant(name:"رستوران هاتم (دیره)",name_map:"Hatam Deira Dubai",lat:25.263200,lon:55.326500,description:"رستوران ایرانی در Deira City Center",parkingInfo:"پارکینگ Deira City Center"),

Restaurant(name:"رستوران انار",name_map:"Anar Persian Cuisine Dubai",lat:25.204500,lon:55.270500,description:"رستوران ایرانی با فضای مدرن",parkingInfo:"پارکینگ عمومی اطراف"),

Restaurant(name:"رستوران کبابک",name_map:"Kababak Iranian Restaurant Dubai",lat:25.081000,lon:55.311000,description:"رستوران ایرانی در Dragon Mart",parkingInfo:"پارکینگ Dragon Mart"),

Restaurant(name:"اسپشیال کباب",name_map:"Special Kabab Dubai",lat:25.095000,lon:55.206000,description:"کبابی ایرانی محبوب",parkingInfo:"پارکینگ عمومی Al Hudaiba"),

Restaurant(name:"رستوران آبشار",name_map:"Grand Abshar Restaurant Dubai",lat:25.249000,lon:55.260000,description:"رستوران ایرانی با غذاهای خانگی",parkingInfo:"پارکینگ عمومی Umm Suqeim"),

Restaurant(name:"رستوران یاشار پالاس",name_map:"Yashar Palace Restaurant Dubai",lat:25.239000,lon:55.269000,description:"رستوران ایرانی در جمیرا",parkingInfo:"پارکینگ عمومی Jumeirah Rd"),

Restaurant(name:"باشگاه ایرانیان",name_map:"Iranian Club Restaurant Dubai",lat:25.243000,lon:55.300000,description:"رستوران ایرانی/باشگاه اجتماعی",parkingInfo:"پارکینگ Iranian Club Oud Metha"),



//Munic
Restaurant(name:"رستوران شاندیز",name_map:"Shandiz Restaurant Munich",lat:48.146390,lon:11.559360,description:"رستوران ایرانی با منوی سنتی و کباب‌های محبوب",parkingInfo:"پارکینگ عمومی اطراف Stiglmaierplatz"),

Restaurant(name:"رستوران ته‌دیگ",name_map:"Tahdig Munich",lat:48.142840,lon:11.587020,description:"رستوران ایرانی با ته‌دیگ و غذاهای سنتی",parkingInfo:"پارکینگ عمومی اطراف Max-Weber-Platz"),

Restaurant(name:"رستوران پارس",name_map:"Pars Restaurant Munich",lat:48.148050,lon:11.557820,description:"رستوران ایرانی با غذاهای کلاسیک",parkingInfo:"پارکینگ عمومی اطراف Stiglmaierplatz"),

Restaurant(name:"رستوران دهباشی",name_map:"Dehbaschi Restaurant Munich",lat:48.148230,lon:11.558410,description:"رستوران ایرانی با غذاهای اصیل",parkingInfo:"پارکینگ عمومی اطراف Stiglmaierplatz"),

Restaurant(name:"رستوران دیوان",name_map:"Diwan Restaurant Munich",lat:48.157380,lon:11.532740,description:"رستوران ایرانی با فضای سنتی و منوی متنوع",parkingInfo:"پارکینگ عمومی اطراف Nymphenburg"),

Restaurant(name:"رستوران موما",name_map:"Mama's persische Küche Munich",lat:48.132540,lon:11.584200,description:"رستوران ایرانی با غذاهای خانگی",parkingInfo:"پارکینگ عمومی اطراف Ostbahnhof"),

Restaurant(name:"رستوران حافظ",name_map:"Hafez Restaurant Munich",lat:48.123500,lon:11.600700,description:"رستوران ایرانی با غذاهای سنتی درجه‌یک",parkingInfo:"پارکینگ عمومی اطراف Giesing"),

Restaurant(name:"رستوران طاووس",name_map:"Tawuus Restaurant Munich",lat:48.158100,lon:11.554900,description:"رستوران ایرانی با غذاهای باکیفیت",parkingInfo:"پارکینگ عمومی اطراف Scheidplatz"),

Restaurant(name:"رستوران رزموری",name_map:"Rosmori Catering Persian Restaurant Munich",lat:48.120870,lon:11.460100,description:"رستوران ایرانی (کترینگ) با غذاهای خانگی",parkingInfo:"پارکینگ عمومی اطراف Solln S-Bahn"),


//Frankfurt
Restaurant(name:"رستوران کیش",name_map:"Kish Restaurant Frankfurt",lat:50.121124,lon:8.649151,description:"رستوران پرسیان کلاسیک با منوی متنوع (Persian/Iranian)",parkingInfo:"پارکینگ عمومی اطراف Leipziger Str / Bockenheim area"),

Restaurant(name:"رستوران پرشیا",name_map:"Persia Restaurant Frankfurt",lat:50.108700,lon:8.666200,description:"رستوران ایرانی با کباب‌ها و خورش‌های سنتی",parkingInfo:"پارکینگ عمومی اطراف Esslinger Str / Gutleutviertel"),

Restaurant(name:"رستوران شاندیس",name_map:"Schandis Persian Specialities Frankfurt",lat:50.114600,lon:8.698800,description:"رستوران پرسیان با غذاهای سنتی و حلال",parkingInfo:"پارکینگ خیابانی Nordendstraße و اطراف"),

Restaurant(name:"رستوران زرتشت",name_map:"Zarathustra Restaurant Frankfurt",lat:50.120386,lon:8.686099,description:"رستوران پرسیان با غذاهای سنتی در مرکز فرانکفورت",parkingInfo:"پارکینگ عمومی اطراف Jahnstraße / Innenstadt"),

Restaurant(name:"رستوران هانی",name_map:"Hani Restaurant Frankfurt",lat:50.108300,lon:8.663900,description:"رستوران ایرانی با غذاهای پرسیان خوش‌طعم",parkingInfo:"پارکینگ عمومی اطراف Gutleutstraße"),

Restaurant(name:"رستوران دایانا",name_map:"Dayana Persisches Restaurant Frankfurt",lat:50.090800,lon:8.620100,description:"رستوران پرسیان با فضای دوستانه",parkingInfo:"پارکینگ عمومی اطراف Höchst area"),

Restaurant(name:"رستوران شمال",name_map:"SHOMAL Persisches Restaurant Frankfurt",lat:50.129100,lon:8.716700,description:"رستوران پرسیان با منوی کامل",parkingInfo:"پارکینگ خیابانی Höhenstraße"),

Restaurant(name:"رستوران پسته",name_map:"Pistazie Persian & Vegetarian Frankfurt",lat:50.119000,lon:8.670000,description:"رستوران ایرانی و گیاهی",parkingInfo:"پارکینگ عمومی اطراف Westend"),

Restaurant(name:"رستوران بابام",name_map:"Babam Persian Restaurant Frankfurt",lat:50.108900,lon:8.663500,description:"رستوران پرسیان محبوب",parkingInfo:"پارکینگ عمومی اطراف Münchener Str."),

Restaurant(name:"رستوران منوتو",name_map:"Manoto Persian Restaurant Frankfurt",lat:50.120600,lon:8.712500,description:"رستوران ایرانی با منوی پرسیان",parkingInfo:"پارکینگ خیابانی اطراف Dieburger Str."),

Restaurant(name:"رستوران یاام",name_map:"YAAM Persian Restaurant Frankfurt",lat:50.109000,lon:8.650000,description:"رستوران پرسیان با فضای کژوال",parkingInfo:"پارکینگ عمومی اطراف Mainzer Landstraße"),

Restaurant(name:"رستوران رَندِوو",name_map:"Rendezvous Persian Restaurant Frankfurt",lat:50.109000,lon:8.664000,description:"رستوران ایرانی در Baseler Straße",parkingInfo:"پارکینگ عمومی اطراف Baseler Straße"),

Restaurant(name:"رستوران مهناز",name_map:"Mahnaz Persische Spezialitäten Frankfurt",lat:50.107800,lon:8.667900,description:"رستوران ایرانی با غذاهای کلاسیک",parkingInfo:"پارکینگ عمومی اطراف Europa-Allee"),

Restaurant(name:"رستوران شاه",name_map:"SHAH Persian Restaurant Frankfurt",lat:50.121000,lon:8.688000,description:"رستوران پرسیان با غذاهای اصیل",parkingInfo:"پارکینگ عمومی اطراف Sachsenhausen"),


//Amsterdam
Restaurant(name:"رستوران آردیگه پرس",name_map:"De Aardige Pers Amsterdam",lat:52.368310,lon:4.872860,description:"رستوران ایرانی اصیل با غذاهای سنتی و فضای گرم",parkingInfo:"پارکینگ خیابانی اطراف Tweede Hugo de Grootstraat"),

Restaurant(name:"رستوران پارسا",name_map:"Parsa Restaurant Amsterdam",lat:52.369780,lon:4.871440,description:"رستوران ایرانی با منوی کامل و سنتی",parkingInfo:"پارکینگ عمومی اطراف De Clercqstraat"), 

Restaurant(name:"رستوران اورکیده",name_map:"Orchidee Restaurant Amsterdam",lat:52.364540,lon:4.879410,description:"رستوران ایرانی با امتیاز بالا و غذای اصیل",parkingInfo:"پارکینگ عمومی اطراف Bilderdijkstraat"),

Restaurant(name:"رستوران طهران",name_map:"Tehran Restaurant Amsterdam",lat:52.366130,lon:4.889020,description:"رستوران ایرانی با نوشیدنی‌ها و غذاهای سنتی",parkingInfo:"پارکینگ خیابانی اطراف Rozengracht"),

Restaurant(name:"رستوران شاندیز",name_map:"Shandiez Persian Restaurant Amsterdam",lat:52.363280,lon:4.865060,description:"رستوران ایرانی با کباب‌های محبوب",parkingInfo:"پارکینگ خیابانی اطراف Johan Huizingalaan"),

Restaurant(name:"رستوران من و تو",name_map:"Manoto Restaurant Amsterdam",lat:52.369450,lon:4.871980,description:"رستوران ایرانی با فضای دوستانه",parkingInfo:"پارکینگ عمومی اطراف De Clercqstraat"),



//Madrid
Restaurant(name:"پارسی",name_map:"PARSI Persian Restaurant Madrid",lat:40.426715,lon:-3.717821,description:"رستوران پرسیان و حلال در مرکز مادرید با غذاهای سنتی ایرانی",parkingInfo:"پارکینگ عمومی Plaza de España / Calle de la Princesa"),  
Restaurant(name:"البُرز",name_map:"Alborz Restaurant Madrid",lat:40.457128,lon:-3.678788,description:"رستوران ایرانی با غذاهای کلاسیک و محبوب",parkingInfo:"پارکینگ عمومی اطراف Calle de López de Hoyos"),  
Restaurant(name:"تبریز",name_map:"Tabriz Restaurante Madrid",lat:40.416122,lon:-3.702948,description:"رستوران پرسیان با منوی کامل ایرانی",parkingInfo:"پارکینگ عمومی اطراف Avenida de América"),  
Restaurant(name:"پِرسیکو",name_map:"Pérsico Restaurant Madrid",lat:40.434850,lon:-3.697613,description:"رستوران ایرانی با امتیاز بالا و غذای اصیل",parkingInfo:"پارکینگ عمومی اطراف Calle de Sandoval"),  
Restaurant(name:"زعفران",name_map:"Sabor Azafrán Restaurant Madrid",lat:40.442680,lon:-3.665937,description:"رستوران با بیش از ۳۰ سال سابقه در ارائه غذاهای ایرانی",parkingInfo:"پارکینگ عمومی اطراف Calle de Arturo Soria"),  
Restaurant(name:"اصفهان",name_map:"Esfahan Restaurant Madrid",lat:40.422090,lon:-3.692498,description:"رستوران ایرانی کلاسیک در مرکز شهر",parkingInfo:"پارکینگ عمومی اطراف Calle de San Bernardino"),  
Restaurant(name:"مستر کباب",name_map:"Mr Kabab Restaurant Madrid",lat:40.472410,lon:-3.693386,description:"رستوران ایرانی با کباب‌ها و غذاهای محبوب",parkingInfo:"پارکینگ عمومی اطراف Tetuán area"),  
Restaurant(name:"بانِ بانو",name_map:"Banibanoo Restaurant Madrid",lat:40.426110,lon:-3.677320,description:"رستوران با منوی غذاهای خانگی ایرانی",parkingInfo:"پارکینگ عمومی اطراف Calle de Mártires Concepcionistas"),  
Restaurant(name:"نیوُ اسپاثیو ۲",name_map:"Nuevo Espacio 2 Persian Restaurant Madrid",lat:40.590730,lon:-3.631350,description:"رستوران ایرانی محبوب در منطقه Alcobendas (Madrid)",parkingInfo:"پارکینگ عمومی اطراف Avenida Olímpica"),  
Restaurant(name:"تن‌تن پِی شهلاء",name_map:"Ten Ten Pie Shahla Persian Restaurant Madrid",lat:40.422134,lon:-3.698325,description:"رستوران پرسیان با غذای خانگی",parkingInfo:"پارکینگ عمومی اطراف Calle de San Vicente Ferrer"),  
Restaurant(name:"رستوران بی‌بی",name_map:"BIBI Restaurant Madrid",lat:40.531000,lon:-3.703300,description:"رستوران ایرانی با منوی اصیل",parkingInfo:"پارکینگ عمومی اطراف Fuencarral-El Pardo"),  
Restaurant(name:"دُرّادوس",name_map:"DORRADOS Madrid",lat:40.489071,lon:-3.702948,description:"رستوران ایرانی محبوب با غذای با کیفیت",parkingInfo:"پارکینگ عمومی اطراف Calle de Juan Sánchez"),



//Barcellona
Restaurant(name:"Persian Restaurant Rincón Persa",name_map:"Rincón Persa Barcelona",lat:51.51291417484626,lon:-0.09062441820412062,description:"رستوران پرسیان با منوی سنتی ایرانی",parkingInfo:"پارکینگ عمومی اطراف مرکز شهر"),

Restaurant(name:"Kourosh Persian Restaurant",name_map:"Kourosh Persian Restaurant Barcelona",lat:51.52171914311672,lon:-0.1810145580680503,description:"رستوران ایرانی با طعم‌های اصیل",parkingInfo:"پارکینگ عمومی اطراف منطقه Eixample"),

Restaurant(name:"Restaurante Shiraz",name_map:"Restaurante Shiraz Barcelona",lat:51.52684577213361,lon:-0.1405024759406448,description:"رستوران ایرانی با غذای اصیل و کباب",parkingInfo:"پارکینگ عمومی اطراف Calle Calabria"),

Restaurant(name:"Noush Barcelona",name_map:"Noush Persian Restaurant Barcelona",lat:51.5024891433047,lon:-0.20367385816482667,description:"رستوران ایرانی با منوی سنتی و گیاهی",parkingInfo:"پارکینگ عمومی اطراف Sants-Montjuïc"),

Restaurant(name:"Restaurante Caspian",name_map:"Restaurante Caspian Barcelona",lat:51.49180230236709,lon:-0.18101455801919625,description:"رستوران پرسیان با فضای مدرن و غذای سنتی",parkingInfo:"پارکینگ عمومی اطراف L'Eixample"),

Restaurant(name:"Sabor Persa Restaurant",name_map:"Sabor Persa Barcelona",lat:51.52385530866497,lon:-0.15217544874293915,description:"رستوران ایرانی با منوی کلاسیک",parkingInfo:"پارکینگ عمومی اطراف Carrer de València"),


//Rome
Restaurant(name:"رستوران کباب ایرانی",name_map:"Kebab Iranian Restaurant Rome",lat:41.968700,lon:12.487900,description:"رستوران ایرانی با کباب‌ها و غذاهای اصیل ایرانی",parkingInfo:"پارکینگ خیابانی اطراف Via di Grottarossa 52"), 

Restaurant(name:"رستوران پارسه",name_map:"Parseh Restaurant Rome",lat:41.903150,lon:12.465400,description:"رستوران پرسیان با منوی سنتی و گرم",parkingInfo:"پارکینگ عمومی اطراف Via Isidoro di Carace 6"), 

Restaurant(name:"رستوران تنور",name_map:"Tanur Persian Restaurant Rome",lat:41.921570,lon:12.505540,description:"رستوران ایرانی با تنور و غذاهای سنتی",parkingInfo:"پارکینگ خیابانی اطراف Via Chiana 54"), 

Restaurant(name:"رستوران تابرنا پرسیانا",name_map:"Taberna Persiana Rome",lat:41.853900,lon:12.482300,description:"رستوران پرسیان با غذاهای اصیل ایرانی در منطقه Ostiense",parkingInfo:"پارکینگ خیابانی اطراف Via Ostiense 36/H-G"), 

Restaurant(name:"رستوران آریا",name_map:"Ariya Iranian Restaurant Rome",lat:41.907500,lon:12.520300,description:"رستوران ایرانی با غذاهای محبوب و کباب‌های خوش‌طعم",parkingInfo:"پارکینگ خیابانی اطراف Via dell'Aquila Reale 8"), 


//Stockholm
Restaurant(name:"Tajrish Restaurang",name_map:"Tajrish Restaurang Stockholm",lat:59.344020,lon:18.047680,description:"رستوران ایرانی با غذاهای خانگی و سنتی",parkingInfo:"پارکینگ عمومی نزدیک Torsplan"), :contentReference[oaicite:0]{index=0}

Restaurant(name:"Coup D'etat",name_map:"Coup D'etat Stockholm",lat:59.338980,lon:18.079460,description:"رستوران ایرانی/پرسیان با غذاهای متنوع",parkingInfo:"پارکینگ عمومی اطراف Östermalm"), :contentReference[oaicite:1]{index=1}

Restaurant(name:"Malakeh Persisk Restaurang",name_map:"Malakeh Persisk Restaurang Stockholm",lat:59.332900,lon:18.068400,description:"رستوران ایرانی محبوب در مرکز شهر",parkingInfo:"پارکینگ عمومی اطراف Drottninggatan"), :contentReference[oaicite:2]{index=2}

Restaurant(name:"Diwan",name_map:"Diwan Stockholm",lat:59.342330,lon:18.082060,description:"رستوران ایرانی با منوی اصیل پرسیان",parkingInfo:"پارکینگ عمومی اطراف Valhallavägen"), :contentReference[oaicite:3]{index=3}

Restaurant(name:"Farsi Restaurant",name_map:"Farsi Restaurant Stockholm",lat:59.360120,lon:18.002750,description:"رستوران ایرانی در Solna با غذاهای سنتی",parkingInfo:"پارکینگ عمومی اطراف Solna Centrum"), :contentReference[oaicite:4]{index=4}

Restaurant(name:"Sima Deli",name_map:"Sima Deli Stockholm",lat:59.342360,lon:18.080865,description:"رستوران ایرانی/پرسیان با غذاهای سبک و سالم",parkingInfo:"پارکینگ عمومی اطراف Valhallavägen"), :contentReference[oaicite:5]{index=5}

Restaurant(name:"Tehran Grill (Timmermansgatan)",name_map:"Tehran Grill Timmermansgatan Stockholm",lat:59.337650,lon:18.048710,description:"رستوران ایرانی با منوی Grill و پرسیان",parkingInfo:"پارکینگ عمومی اطراف Södermalm"), :contentReference[oaicite:6]{index=6}

Restaurant(name:"AVA GRILL",name_map:"AVA GRILL Stockholm",lat:59.337070,lon:18.048590,description:"رستوران ایرانی با منوی پرسیان",parkingInfo:"پارکینگ عمومی اطراف Norrmalm"), :contentReference[oaicite:7]{index=7}

Restaurant(name:"Gröndals deli",name_map:"Gröndals deli Stockholm",lat:59.316230,lon:18.026540,description:"رستوران کوچک ایرانی/پرسیان با منوی خانگی",parkingInfo:"پارکینگ عمومی اطراف Gröndal"), :contentReference[oaicite:8]{index=8}

Restaurant(name:"Tehran Grill (Rörstrandsgatan)",name_map:"Tehran Grill Rörstrandsgatan Stockholm",lat:59.345090,lon:18.049680,description:"شعبه دیگر Tehran Grill با طعم‌های ایرانی",parkingInfo:"پارکینگ عمومی اطراف Vasastan"), :contentReference[oaicite:9]{index=9}

Restaurant(name:"Shahrzad",name_map:"Shahrzad Stockholm",lat:59.337820,lon:18.061230,description:"رستوران ایرانی سنتی با منوی buffet",parkingInfo:"پارکینگ خیابانی اطراف Regeringsgatan"), :contentReference[oaicite:10]{index=10}

//Purtegal
//Warsaw
//LA
//Belgium

















    ];



// --- داده‌های رمز عبور ---
const List<Map<String, String>> PASSWORDS_DATA = [
  { "password": "res", "expiryDate": "2026-03-31" },
  { "password": "guest2025", "expiryDate": "2025-12-31" }
];