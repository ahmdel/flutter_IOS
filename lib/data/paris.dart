import '../models.dart';

// @formatter:off
final List<Restaurant> PARIS_RESTAURANTS = [
  // check kon mokhtasatha ro  
  Restaurant(name: "رستوران نامک", name_map: "Namak - Restaurant Perse", lat: 48.87688480759255, lon: 2.3376752874770195, description: "رستوران ایرانی با غذاهای سنتی در نزدیکی ایستگاه سنت لازار", parkingInfo: "Parking Saint-Lazare", city: "Paris"),
  Restaurant(name: "رستوران پرشیانا", name_map: "Perchiana Restaurant", lat: 48.84363578222247, lon: 2.2940253491166955, description: "رستوران ایرانی با غذاهای اصیل و محیطی گرم", parkingInfo: "Parking Convention", city: "Paris"),
  Restaurant(name: "رستوران شبستان (شانزه‌لیزه)", name_map: "Shabestan Restaurant Champs-Elysees", lat: 48.872687560871206, lon: 2.309332016866409, description: "رستوران ایرانی با منوی سنتی در قلب منطقه شانزه‌لیزه", parkingInfo: "Parking George V", city: "Paris"),
  Restaurant(name: "رستوران شبستان (گرونل)", name_map: "Shabestan Restaurant Grenelle", lat: 48.84961389091849, lon: 2.2953622706115415, description: "ارائه دهنده غذاهای خوش‌طعم ایرانی در منطقه گرونل", parkingInfo: "Parking Beaugrenelle", city: "Paris"),
  Restaurant(name: "رستوران تورنج", name_map: "Toranj Restaurant", lat: 48.84009644944005, lon: 2.3406802311749857, description: "رستوران ایرانی با فضای سنتی و دلنشین", parkingInfo: "Parking Rue Gay-Lussac", city: "Paris"),
  Restaurant(name: "رستوران کاسپیان", name_map: "Caspian Restaurant", lat: 48.84537985399908, lon: 2.2884882834262257, description: "رستوران ایرانی با منوی کامل از انواع کباب‌ها و خورش‌ها", parkingInfo: "Parking Convention", city: "Paris"),
  Restaurant(name: "رستوران کاخ (لو پاله د لا پرس)", name_map: "Le Palais de la Perse", lat: 48.8402103102651, lon: 2.3406853431753825, description: "ترکیب طعم‌های لذیذ ایرانی و لبنانی در فضایی کلاسیک", parkingInfo: "Parking Rue Gay-Lussac", city: "Paris"),
  Restaurant(name: "رستوران شاپو", name_map: "Chapeau Restaurant", lat: 48.84366559578631, lon: 2.2806518152311828, description: "رستوران ایرانی محبوب با کیفیت ثابت و عالی", parkingInfo: "Parking Rue de la Croix Nivert", city: "Paris"),
  Restaurant(name: "رستوران مزه", name_map: "Mazeh Restaurant", lat: 48.845318983261635, lon: 2.2892356123712365, description: "رستوران و اغذیه‌فروشی مشهور ایرانی با غذاهای متنوع", parkingInfo: "Parking Convention", city: "Paris"),
  Restaurant(name: "رستوران آ تیبل", name_map: "A Table Restaurant", lat: 48.857171272234105, lon: 2.399889998349794, description: "رستوران ایرانی با منوی اصیل و فضایی مدرن", parkingInfo: "Parking Porte de Montreuil", city: "Paris"),
  Restaurant(name: "رستوران گویلاس", name_map: "Guylas Restaurant", lat: 48.84498975993987, lon: 2.2892844350174966, description: "تجربه‌ای اصیل از دست‌پخت و طعم‌های ایرانی", parkingInfo: "Parking Convention", city: "Paris"),
  Restaurant(name: "رستوران کباب مجید", name_map: "Kabab Majid", lat: 48.84647597264, lon: 2.2871819726018394, description: "تخصص در طبخ کباب‌های سنتی ایرانی با نان داغ", parkingInfo: "Parking Convention", city: "Paris"),
  Restaurant(name: "رستوران تهران", name_map: "Tehran Restaurant", lat: 48.84770759356026, lon: 2.2850561316099496, description: "رستوران ایرانی با تمرکز بر غذاهای خانگی و سالم", parkingInfo: "Parking Beaugrenelle", city: "Paris"),
  Restaurant(name: "رستوران کلبه", name_map: "Colbeh Restaurant", lat: 48.844261011025026, lon: 2.3492177806714842, description: "رستوران ایرانی با فضای دوستانه و صمیمی", parkingInfo: "Parking Censier Daubenton", city: "Paris"),
  Restaurant(name: "رستوران پرسپولیس", name_map: "Persepolis Restaurant", lat: 48.84338310192391, lon: 2.317001773281723, description: "رستوران ایرانی با امتیاز بالا و مشتریان وفادار", parkingInfo: "Parking Convention", city: "Paris"),
  Restaurant(name: "رستوران شِومینِه", name_map: "Cheminee Restaurant", lat: 48.845465851121624, lon: 2.288232743735638, description: "ارائه دهنده انواع خوراک‌های اصیل ایرانی", parkingInfo: "Parking Convention", city: "Paris"),
  Restaurant(name: "رستوران آنِلی", name_map: "ANELI Restaurant", lat: 48.872459211495205, lon: 2.3159804607583045, description: "رستوران ایرانی با دکوراسیون زیبا در مرکز پاریس", parkingInfo: "Parking Haussmann", city: "Paris"),
  Restaurant(name: "مرکز فرهنگی پویا", name_map: "Centre Culturel Pouya", lat: 48.86989913747731, lon: 2.3668999482424895, description: "مرکز فرهنگی پویا؛ محلی برای گردهمایی و صرف غذای ایرانی", parkingInfo: "Parking Bastille", city: "Paris"),
  Restaurant(name: "رستوران نوروز", name_map: "Norouz Restaurant", lat: 48.826633244340755, lon: 2.3746113542785423, description: "رستوران ایرانی با محیطی آرام در منطقه ۱۳ پاریس", parkingInfo: "Parking Porte d'Ivry", city: "Paris"),
  Restaurant(name: "رستوران جالیز", name_map: "Jaliz Restaurant", lat: 48.828005506107004, lon: 2.242225931967973, description: "رستوران ایرانی مدرن با کیفیت متمایز", parkingInfo: "Parking Porte de Saint-Cloud", city: "Paris"),
  Restaurant(name: "تیام – شز داریوش", name_map: "Tiam - Chez Darius", lat: 48.8475299873923, lon: 2.2920778717338313, description: "رستوران ایرانی با فضایی خانگی و گرم", parkingInfo: "Parking Beaugrenelle", city: "Paris"),
  Restaurant(name: "رستوران بزکشی", name_map: "Buzkashi Restaurant", lat: 48.88530455439495, lon: 2.3256530752034235, description: "تلفیقی از غذاهای لذیذ افغانستانی و ایرانی", parkingInfo: "Parking Montmartre", city: "Paris"),
  Restaurant(name: "پرشدلیس", name_map: "Persedelis", lat: 48.851016076455586, lon: 2.3097326930359094, description: "رستوران ایرانی دنج در منطقه توریستی پاریس", parkingInfo: "Parking George V", city: "Paris"),
];
// @formatter:on