import '../models.dart';

// @formatter:off
final List<Restaurant> BERLIN_RESTAURANTS = [  
  Restaurant(name: "میت می هاف‌وی", name_map: "Meet Me Halfway", lat: 52.5319475298412, lon: 13.38324391714666, description: "کافه و غذای ایرانی", parkingInfo: "پارکینگ عمومی نزدیک", city: "Berlin"),
  Restaurant(name: "کافه کارداموم", name_map: "Café Kardamom", lat: 52.48549823472936, lon: 13.340305620051199, description: "کافه ایرانی با فضای دنج", parkingInfo: "پارکینگ عمومی نزدیک", city: "Berlin"),
  Restaurant(name: "سرای یَم", name_map: "Sarayam Restaurant", lat: 52.52060430562699, lon: 13.299798352046839, description: "غذاهای ایرانی و خاورمیانه‌ای", parkingInfo: "پارکینگ عمومی نزدیک", city: "Berlin"),
  Restaurant(name: "رستوران بیستون", name_map: "Bistoun Restaurant", lat: 52.45035262210486, lon: 13.384597192926257, description: "رستوران ایرانی سنتی", parkingInfo: "پارکینگ عمومی نزدیک", city: "Berlin"),
  Restaurant(name: "رستوران ارکیده", name_map: "Orkide Restaurant", lat: 52.51100383108343, lon: 13.29388617785024, description: "غذاهای اصیل ایرانی", parkingInfo: "پارکینگ عمومی نزدیک", city: "Berlin"),
  Restaurant(name: "پارادیسو", name_map: "Paradiso Restaurant", lat: 52.43882354647504, lon: 13.21476600047441, description: "رستوران ایرانی پارادیسو", parkingInfo: "پارکینگ عمومی نزدیک", city: "Berlin"),
  Restaurant(name: "نوش", name_map: "Noosh Restaurant", lat: 52.505762752025895, lon: 13.320441895441219, description: "غذاهای ایرانی مدرن و شیک", parkingInfo: "پارکینگ عمومی نزدیک", city: "Berlin"),
  Restaurant(name: "فانوس", name_map: "Fanous Restaurant", lat: 52.45739535944064, lon: 13.323382767549935, description: "غذاهای ایرانی فانوس", parkingInfo: "پارکینگ عمومی نزدیک", city: "Berlin"),
  Restaurant(name: "کارون", name_map: "Karun Restaurant", lat: 52.508044506199646, lon: 13.30799215188593, description: "تخصص در غذاهای جنوبی ایران", parkingInfo: "پارکینگ عمومی نزدیک", city: "Berlin"),
  Restaurant(name: "ناردون", name_map: "Naardoun Restaurant", lat: 52.506450996175936, lon: 13.299586393889262, description: "غذاهای اصیل و سنتی ایرانی", parkingInfo: "پارکینگ عمومی نزدیک", city: "Berlin"),
  Restaurant(name: "آفتاب", name_map: "Aftab Restaurant", lat: 52.53808066847726, lon: 13.40956778896652, description: "رستوران ایرانی آفتاب", parkingInfo: "پارکینگ عمومی نزدیک", city: "Berlin"),
  Restaurant(name: "نفیس", name_map: "Nafis Restaurant", lat: 52.49614600599233, lon: 13.359163039163132, description: "رستوران ایرانی لوکس با دکوراسیون زیبا", parkingInfo: "پارکینگ عمومی نزدیک", city: "Berlin"),
  Restaurant(name: "سیمرغ", name_map: "Simorgh Restaurant", lat: 52.507214578448156, lon: 13.279521331115578, description: "غذاهای اصیل و باکیفیت ایرانی", parkingInfo: "پارکینگ عمومی نزدیک", city: "Berlin"),
  Restaurant(name: "پونه", name_map: "Pooneh Restaurant", lat: 52.527475731041996, lon: 13.33092732292195, description: "رستوران ایرانی پونه", parkingInfo: "پارکینگ عمومی نزدیک", city: "Berlin"),
  Restaurant(name: "کوروش", name_map: "Kourosh Restaurant", lat: 52.51940986745433, lon: 13.4267427422334, description: "غذاهای سنتی و کباب‌های ایرانی", parkingInfo: "پارکینگ عمومی نزدیک", city: "Berlin"),
  Restaurant(name: "پرسر ویچ", name_map: "Perserwich", lat: 52.517699856092015, lon: 13.300112591300135, description: "ساندویچ‌های سبک ایرانی و فست‌فود", parkingInfo: "پارکینگ عمومی نزدیک", city: "Berlin"),
  Restaurant(name: "خاتون", name_map: "Khatoon Restaurant", lat: 52.55161403171683, lon: 13.35548694692095, description: "غذاهای خانگی و اصیل ایرانی", parkingInfo: "پارکینگ عمومی نزدیک", city: "Berlin"),
  Restaurant(name: "پرسپولیس", name_map: "Perspolis Restaurant", lat: 52.50237517621832, lon: 13.351735383866169, description: "رستوران ایرانی سنتی پرسپولیس", parkingInfo: "پارکینگ عمومی نزدیک", city: "Berlin"),
  Restaurant(name: "شایان", name_map: "Shayan Restaurant", lat: 52.49443436977713, lon: 13.354080332812394, description: "غذاهای اصیل و طعم‌های ماندگار", parkingInfo: "پارکینگ عمومی نزدیک", city: "Berlin"),
  Restaurant(name: "بهار", name_map: "Bahar Restaurant", lat: 52.481506307966484, lon: 13.348266544935862, description: "غذاهای سنتی و محلی ایرانی", parkingInfo: "پارکینگ عمومی نزدیک", city: "Berlin"),
  Restaurant(name: "بی‌بی", name_map: "Bibi Restaurant", lat: 52.535910835664566, lon: 13.300475586668396, description: "رستوران ایرانی بی‌بی", parkingInfo: "پارکینگ عمومی نزدیک", city: "Berlin"),
  Restaurant(name: "حافظ", name_map: "Hafez Restaurant", lat: 52.50634174305078, lon: 13.283488020359156, description: "غذاهای کلاسیک ایرانی با سابقه طولانی", parkingInfo: "پارکینگ عمومی نزدیک", city: "Berlin"),
];
// @formatter:on