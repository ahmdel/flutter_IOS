import '../models.dart';

// @formatter:off
final List<Restaurant> NEW_YORK_RESTAURANTS = [
  // دیتای رستوران‌های new_york را اینجا کپی کنید
  Restaurant(name: "رواق گریل ایرانی", name_map: "Ravagh Persian Grill", lat: 40.747288424930474, lon: -73.98315769853954, description: "رستوران ایرانی با انواع کباب", parkingInfo: "پارکینگ خیابانی و عمومی اطراف", city: "New York"),
  Restaurant(name: "شیراز (آشپزخانه و بار شراب)", name_map: "Shiraz Kitchen & Wine Bar", lat: 40.739706270809336, lon: -73.99612829998227, description: "رستوران ایرانی با فضای مدرن و بار شراب", parkingInfo: "پارکینگ خیابانی و عمومی اطراف", city: "New York"),
  Restaurant(name: "پرسپولیس", name_map: "Persepolis Restaurant", lat: 40.769819916594415, lon: -73.95795579918865, description: "غذاهای کلاسیک و اصیل ایرانی", parkingInfo: "پارکینگ خیابانی", city: "New York"),
  Restaurant(name: "ایوال", name_map: "Eyval Restaurant", lat: 40.704177610029234, lon: -73.93316725499179, description: "آشپزی مدرن ایرانی", parkingInfo: "پارکینگ خیابانی", city: "New York"),
  Restaurant(name: "میراج گریل سلامت", name_map: "Miraj Healthy Grill", lat: 40.746397314577834, lon: -73.98032159744601, description: "گریل ایرانی سالم و سبک", parkingInfo: "پارکینگ خیابانی", city: "New York"),
  Restaurant(name: "سفره", name_map: "Sofreh Restaurant", lat: 40.67984538129058, lon: -73.97400031247336, description: "رستوران ایرانی با طعم‌های سنتی", parkingInfo: "پارکینگ خیابانی", city: "New York"),
  Restaurant(name: "نوش بروکلین", name_map: "Brooklyn Noosh Persian Restaurant", lat: 40.68023271361236, lon: -73.96125262077742, description: "رستوران ایرانی با حال‌وهوای خانگی", parkingInfo: "پارکینگ خیابانی", city: "New York"),
  Restaurant(name: "آشپزخانه نسرین", name_map: "Nasrin's Kitchen", lat: 40.76396336594715, lon: -73.97588591876318, description: "غذاهای خانگی ایرانی", parkingInfo: "پارکینگ خیابانی", city: "New York"),
  Restaurant(name: "رواق گریل ایرانی (میدتاون)", name_map: "Ravagh Persian Grill Midtown", lat: 40.74729197516759, lon: -73.98315476564638, description: "کباب‌ها و گریل‌های اصیل ایرانی", parkingInfo: "پارکینگ خیابانی", city: "New York"),
  Restaurant(name: "رواق گریل ایرانی (لانگ آیلند)", name_map: "Ravagh Persian Grill Long Island", lat: 40.78627718081705, lon: -73.64893687109102, description: "گریل و کباب ایرانی", parkingInfo: "پارکینگ اختصاصی", city: "New York"),
  Restaurant(name: "میراج گریل سلامت (لانگ آیلند)", name_map: "Miraj Healthy Grill Long Island", lat: 40.75563980374079, lon: -73.64602713566708, description: "غذاهای سالم ایرانی", parkingInfo: "پارکینگ اختصاصی", city: "New York"),
  Restaurant(name: "کلبه", name_map: "Colbeh Restaurant", lat: 40.7882248213669, lon: -73.7251108843498, description: "رستوران ایرانی با منوی سنتی", parkingInfo: "پارکینگ اختصاصی", city: "New York"),
  Restaurant(name: "پردیس گریل ایرانی", name_map: "Pardis Persian Grill", lat: 40.97973116803268, lon: -74.1187750538847, description: "گریل و کباب ایرانی", parkingInfo: "پارکینگ اختصاصی", city: "New York"),
  Restaurant(name: "پاتوق", name_map: "Patoug Persian Cuisine", lat: 40.748599602052934, lon: -73.75754095264655, description: "غذاهای اصیل ایرانی", parkingInfo: "پارکینگ خیابانی", city: "New York"),
  Restaurant(name: "بیژن", name_map: "Bijan's Restaurant", lat: 40.68798495242207, lon: -73.98670649197551, description: "غذاهای سنتی ایرانی", parkingInfo: "پارکینگ خیابانی", city: "New York"),
  Restaurant(name: "فندق", name_map: "FandoQ Restaurant", lat: 40.74687282961576, lon: -73.58837193529588, description: "غذاهای راحت و خانگی ایرانی", parkingInfo: "پارکینگ اختصاصی", city: "New York"),
  Restaurant(name: "شن‌های پارس", name_map: "Sands of Persia Restaurant", lat: 40.76775652418912, lon: -73.91156680558106, description: "لانژ و رستوران ایرانی", parkingInfo: "پارکینگ خیابانی", city: "New York"),
  Restaurant(name: "چاتانوگا (ایرانی کوشر)", name_map: "Chatanooga Glatt Kosher Persian Restaurant", lat: 40.78665227084258, lon: -73.7296869660575, description: "رستوران ایرانی کوشر", parkingInfo: "پارکینگ اختصاصی", city: "New York"),
  Restaurant(name: "ماسکراد", name_map: "Masquerade Restaurant", lat: 40.70781235483496, lon: -73.9557661408916, description: "غذاهای تلفیقی ایرانی", parkingInfo: "پارکینگ خیابانی", city: "New York"),
  Restaurant(name: "زعفران بلوم", name_map: "Zaffron Bloom Restaurant", lat: 40.861082841775584, lon: -74.07888375610264, description: "رستوران لوکس ایرانی", parkingInfo: "پارکینگ اختصاصی", city: "New York"),
  Restaurant(name: "هفت وادی", name_map: "Seven Valleys Restaurant", lat: 40.74845483148231, lon: -74.02777232871689, description: "آشپزی مدرن ایرانی", parkingInfo: "پارکینگ اختصاصی", city: "New York"),
  Restaurant(name: "شیراز", name_map: "Shiraz Restaurant", lat: 40.739693815976715, lon: -73.99612808211793, description: "رستوران ایرانی", parkingInfo: "پارکینگ اختصاصی", city: "New York"),
  Restaurant(name: "پریسا گریل ایرانی", name_map: "Parisa Persian Grill", lat: 40.98027151506842, lon: -74.11939139395005, description: "گریل ایرانی", parkingInfo: "پارکینگ اختصاصی", city: "New York"),
  Restaurant(name: "کلبه (شاخه دنج)", name_map: "The Cottage by Colbeh", lat: 40.791084506534496, lon: -73.65357352386566, description: "غذاهای ایرانی در فضایی دنج", parkingInfo: "پارکینگ اختصاصی", city: "New York"),
  Restaurant(name: "رز", name_map: "Rose Restaurant", lat: 40.98159491909254, lon: -74.11828109260598, description: "رستوران ایرانی", parkingInfo: "پارکینگ خیابانی", city: "New York"),
  Restaurant(name: "دونیا کباب هاوس", name_map: "Dunya Kabab House", lat: 40.64056443405074, lon: -73.96936477454017, description: "کباب و غذاهای خاورمیانه‌ای", parkingInfo: "پارکینگ خیابانی", city: "New York"),
];
// @formatter:on
