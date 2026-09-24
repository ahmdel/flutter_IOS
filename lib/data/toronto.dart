import '../models.dart';

// @formatter:off
final List<Restaurant> TORONTO_RESTAURANTS = [
  // دیتای رستوران‌های toronto را اینجا کپی کنید
 
  Restaurant(name: "رستوران شمشیری", name_map: "Shamshiri Restaurant", lat: 43.764446101045685, lon: -79.39837673099352, description: "رستوران ایرانی با انواع کباب و غذاهای سنتی", parkingInfo: "پارکینگ خیابانی و عمومی", city: "Toronto"),
  Restaurant(name: "رستوران شمشیری ۲", name_map: "Shamshiri Restaurant 2", lat: 43.827643142329634, lon: -79.42631804109728, description: "شعبه دوم رستوران شمشیری", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "رستوران شمشیری ۳", name_map: "Shamshiri Restaurant 3", lat: 43.66676906319846, lon: -79.38549318833593, description: "شعبه سوم رستوران شمشیری در مرکز شهر", parkingInfo: "پارکینگ عمومی اطراف", city: "Toronto"),
  Restaurant(name: "رستوران اصفهان تورنتو", name_map: "Esfahan Restaurant Toronto", lat: 43.76384350402345, lon: -79.39884232581039, description: "غذاهای اصیل ایرانی و اصفهانی", parkingInfo: "پارکینگ خیابانی", city: "Toronto"),
  Restaurant(name: "بره سفید", name_map: "BAREH SEFID", lat: 43.85594266168026, lon: -79.43074311778368, description: "رستوران ایرانی با کباب‌های معروف", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "رستوران افرا", name_map: "Afraa Restaurant", lat: 43.79759477394048, lon: -79.42592632944047, description: "رستوران و کترینگ ایرانی", parkingInfo: "پارکینگ رایگان در محل", city: "Toronto"),
  Restaurant(name: "پرشین تیست", name_map: "Persian taste", lat: 43.89812028932792, lon: -79.44402342944048, description: "طعم‌های اصیل ایرانی", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "کبابی", name_map: "Kababi", lat: 43.677184399227315, lon: -79.35322292882907, description: "تخصص در انواع کباب‌های زغالی", parkingInfo: "پارکینگ خیابانی", city: "Toronto"),
  Restaurant(name: "رستوران ارجان", name_map: "ARJAN RESTAURANT", lat: 43.87485305786047, lon: -79.43786493129471, description: "رستوران ایرانی با فضای مدرن", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "رستوران دیدار", name_map: "Deedar Persian Restaurant", lat: 43.79832063388618, lon: -79.46973278833593, description: "محیطی صمیمی برای صرف غذای ایرانی", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "پرشین تاپ میل", name_map: "Persian Top Meal", lat: 43.84395917723035, lon: -79.37811797176784, description: "ارائه دهنده غذاهای با کیفیت ایرانی", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "آشلند", name_map: "Aashland", lat: 43.849671244692836, lon: -79.43260912944046, description: "تخصص در انواع آش و حلیم ایرانی", parkingInfo: "پارکینگ در محل", city: "Toronto"),
  Restaurant(name: "رستوران ایرانی دانا (میسیساگا)", name_map: "Dana Kabob Mississauga", lat: 43.53808730665382, lon: -79.7284856410973, description: "کباب و غذاهای سنتی در میسیساگا", parkingInfo: "پارکینگ اختصاصی مرکز خرید", city: "Toronto"),
  Restaurant(name: "کباب بازاری", name_map: "Kebab Bazari", lat: 43.64581492099021, lon: -79.41002307054502, description: "کباب‌های سنتی با سبک بازار تهران", parkingInfo: "پارکینگ خیابانی", city: "Toronto"),
  Restaurant(name: "کباب پلیس", name_map: "Kabob Place", lat: 43.4754207793277, lon: -80.5356537024584, description: "ارائه دهنده کباب‌های لذیذ", parkingInfo: "پارکینگ خیابانی", city: "Toronto"),
  Restaurant(name: "تهران کباب کترینگ", name_map: "Tehran Kebab Catering", lat: 43.85092616100034, lon: -79.4336023527541, description: "کترینگ و تهیه غذای ایرانی", parkingInfo: "پارکینگ در محل", city: "Toronto"),
  Restaurant(name: "رستوران دورچین", name_map: "Dorchin restaurant", lat: 43.87426905907926, lon: -79.43774071778367, description: "غذاهای اصیل خانگی", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "رستوران چوکا", name_map: "Chokka Restaurant", lat: 43.7050243220531, lon: -79.38856362330635, description: "طعم‌های نوین ایرانی", parkingInfo: "پارکینگ عمومی", city: "Toronto"),
  Restaurant(name: "شف رضا (ریچموند هیل)", name_map: "Chef Reza Richmond Hill", lat: 43.94684783155693, lon: -79.4547438644109, description: "کباب‌های حرفه‌ای با متد شف رضا", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "رستوران تخت طاووس", name_map: "Takht-e Tavoos Restaurant", lat: 43.65255162553238, lon: -79.43311970734968, description: "صبحانه و غذاهای سنتی ایرانی", parkingInfo: "پارکینگ خیابانی", city: "Toronto"),
  Restaurant(name: "سیتی کباب", name_map: "City kebab Persian Restaurant", lat: 43.71576992756624, lon: -79.39997987667911, description: "کباب‌سرای مدرن ایرانی", parkingInfo: "پارکینگ خیابانی", city: "Toronto"),
  Restaurant(name: "تهرانتو", name_map: "Tehranto", lat: 43.78048028824501, lon: -79.41543941164956, description: "تلفیقی از تهران و تورنتو در طعم", parkingInfo: "پارکینگ عمومی", city: "Toronto"),
  Restaurant(name: "رستوران دربند", name_map: "Darband Restaurant", lat: 43.75518802651118, lon: -79.34840821594945, description: "پاتوق قدیمی ایرانیان برای کباب و دیزی", parkingInfo: "پارکینگ رایگان", city: "Toronto"),
  Restaurant(name: "شف رضا (تورن هیل)", name_map: "Chef Reza Thornhill", lat: 43.8260545957851, lon: -79.42589798833593, description: "شعبه تورن هیل شف رضا", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "رستوران هربی", name_map: "Herby Restaurant", lat: 43.677510686958854, lon: -79.35153015888821, description: "غذاهای گیاهی و سنتی ایرانی", parkingInfo: "پارکینگ خیابانی", city: "Toronto"),
  Restaurant(name: "رز کباب لند", name_map: "Roses Kebab Land Restaurant", lat: 43.852231028821485, lon: -79.4333546533655, description: "دنیای کباب‌های خوشمزه", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "کباب‌سرای گلپایگانی", name_map: "Golpayegani KababSara Corp", lat: 43.874856242139806, lon: -79.43785907606771, description: "تخصص در کباب‌های اصیل گلپایگان", parkingInfo: "پارکینگ در محل", city: "Toronto"),
  Restaurant(name: "کترینگ تورج", name_map: "Touraj Catering", lat: 44.07744790328564, lon: -79.42954497054504, description: "ارائه دهنده خدمات مجالس و غذای خانگی", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "رستوران ایران زمین", name_map: "Village of Kebab Restaurant", lat: 43.89617418957271, lon: -79.40306111778366, description: "غذاهای سنتی در محیطی گرم", parkingInfo: "پارکینگ عمومی", city: "Toronto"),
  Restaurant(name: "دانا کباب (آرورا)", name_map: "Dana Kabob Aurora", lat: 44.00532987582999, lon: -79.46833278833593, description: "شعبه آرورا رستوران دانا", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "سوپر یونیک", name_map: "Super Unique", lat: 43.70286120719334, lon: -79.39735681778366, description: "غذاهای آماده و کباب‌های ایرانی", parkingInfo: "پارکینگ خیابانی", city: "Toronto"),
  Restaurant(name: "جگرکی کبابنا", name_map: "Kabana B.B.Q jigaraki", lat: 43.875800175498355, lon: -79.4377497760677, description: "انواع جگر، دل و قلوه و کباب‌های خاص", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "صوفی گریل و لانژ", name_map: "Soufi Persian Grill & Lounge", lat: 43.884692478348704, lon: -79.46664368342464, description: "فضای شیک همراه با موزیک و غذای عالی", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "رستوران ملکه پرشیا", name_map: "QUEEN OF PERSIA Restaurant", lat: 43.68194575073107, lon: -79.4253562650223, description: "تجربه‌ای لوکس از غذاهای درباری ایران", parkingInfo: "پارکینگ خیابانی", city: "Toronto"),
  Restaurant(name: "مالاتا کباب و شاورما", name_map: "MALATA KEBAB & SHAWARMA", lat: 44.05813558728992, lon: -79.46434221164957, description: "کباب ایرانی و شاورما", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "رستوران رومی (وودبریج)", name_map: "Rumi's Restaurant", lat: 43.78233428799729, lon: -79.5735208355746, description: "غذاهای متنوع ایرانی در وودبریج", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "مستر دیزی", name_map: "Mr Dizi", lat: 43.76772845897553, lon: -79.46987339385863, description: "تخصص در دیزی سنگی و نان تازه", parkingInfo: "پارکینگ خیابانی", city: "Toronto"),
  Restaurant(name: "نیکا کیچن", name_map: "Nika Kitchen", lat: 43.85211751155614, lon: -79.43368689999275, description: "غذاهای خانگی و سالم", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "توچال (نیومارکت)", name_map: "Tochal Newmarket", lat: 44.05806884164991, lon: -79.46097894109728, description: "شعبه نیومارکت کترینگ توچال", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "تهرون کباب", name_map: "Tehroon Kabob", lat: 44.04063160733067, lon: -79.47599684109728, description: "طعم واقعی کباب تهرانی", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "رستوران درویش", name_map: "Darvish Restaurant", lat: 43.663407203870314, lon: -79.38405814109728, description: "رستوران با سابقه در مرکز تورنتو", parkingInfo: "پارکینگ عمومی اطراف", city: "Toronto"),
  Restaurant(name: "یم یم کباب", name_map: "Yum Yum kabob", lat: 43.54500282418263, lon: -80.24944775275411, description: "کباب‌های لذیذ و سریع", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "رستوران نایب", name_map: "Naeb Restaurant", lat: 43.87527517598282, lon: -79.43796325827678, description: "الهام گرفته از سبک کباب نایب ایران", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "ریهون پرشین ایتری", name_map: "Rayhoon Persian Eatery", lat: 43.32667604862612, lon: -79.79523632944047, description: "غذاهای محلی و خوش‌طعم ایرانی", parkingInfo: "پارکینگ خیابانی", city: "Toronto"),
  Restaurant(name: "بهار فاین فودز", name_map: "Bahar Fine Foods", lat: 44.204728808593195, lon: -79.46656024723139, description: "غذاهای آماده و با کیفیت", parkingInfo: "پارکینگ رایگان", city: "Toronto"),
  Restaurant(name: "رستوران کوروش", name_map: "Cyrus Persian Restaurant", lat: 43.885158490410134, lon: -78.84690872208355, description: "رستوران ایرانی با تنوع غذایی بالا", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "رستوران شازده", name_map: "Shazdeh Restaurant", lat: 43.854542011271086, lon: -79.37889865888822, description: "غذاهای سنتی در فضایی کلاسیک", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "رستوران نور کباب", name_map: "Noor Kabob Persian Food Restaurant", lat: 43.986460343137686, lon: -79.46369089999274, description: "انواع کباب و خورش ایرانی", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "رستوران قاجار", name_map: "QAJAR Restaurant", lat: 43.83203598135346, lon: -79.40539349999275, description: "الهام گرفته از دوران قاجار با طعم‌های اصیل", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "دربند اکسپرس (ریچموند هیل)", name_map: "Darband Express", lat: 43.94743363146892, lon: -79.45578079447006, description: "شعبه سریع و کترینگ دربند", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "شیک پیک کترینگ", name_map: "Chic Pick Restaurant and Catering", lat: 43.80623508480312, lon: -79.53373307667913, description: "ارائه دهنده غذاهای مجلسی", parkingInfo: "پارکینگ در محل", city: "Toronto"),
  Restaurant(name: "رستوران و بار کوچینی", name_map: "Koochini Restaurant & bar", lat: 43.80552298849795, lon: -79.41994941778368, description: "رستوران و فضای تفریحی ایرانی", parkingInfo: "پارکینگ عمومی", city: "Toronto"),
  Restaurant(name: "دربار پرشین گریل", name_map: "Darbar Persian Grill", lat: 43.735518787249745, lon: -79.41966671778367, description: "گریل ایرانی با کیفیت ممتاز", parkingInfo: "پارکینگ خیابانی", city: "Toronto"),
  Restaurant(name: "رستوران پارک وی", name_map: "Parkway Restaurant", lat: 43.70926140908049, lon: -79.38512505130012, description: "غذاهای ایرانی در منطقه میدتاون", parkingInfo: "پارکینگ عمومی", city: "Toronto"),
  Restaurant(name: "رز کباب تورنتو", name_map: "Rose Kebab Toronto", lat: 43.748250554961956, lon: -79.34856152330636, description: "کباب‌های لذیذ و با کیفیت", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "کباب شاله", name_map: "Kebab Chalet", lat: 44.06635528631987, lon: -79.43269195275408, description: "کباب‌های خانگی و لذیذ", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "رستوران بخارا", name_map: "Bokhara Restaurant", lat: 43.94289716342649, lon: -79.45478666441092, description: "غذاهای ایرانی و آسیای مرکزی", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "بابا برگر (ساندویچ)", name_map: "Baba's Burgers", lat: 43.82755726570711, lon: -79.42660768220182, description: "ساندویچ‌های سبک ایرانی و برگر", parkingInfo: "پارکینگ در محل", city: "Toronto"),
  Restaurant(name: "پارس گریل نورت یورک", name_map: "Pars Grill North York", lat: 43.79136743893401, lon: -79.41885949999273, description: "کباب و خورش در قلب نورت یورک", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "غذاهای اصفهان آوا", name_map: "Ava Esfahan Food Market", lat: 43.763887253379934, lon: -79.39912445888821, description: "فروشگاه و غذای آماده اصفهانی", parkingInfo: "پارکینگ خیابانی", city: "Toronto"),
  Restaurant(name: "رستوران پامگرنت (انار)", name_map: "Pomegranate Restaurant", lat: 43.65678779656598, lon: -79.40692778342465, description: "فضای هنری و غذاهای سنتی ایرانی", parkingInfo: "پارکینگ خیابانی", city: "Toronto"),
  Restaurant(name: "رستوران زعفران", name_map: "Zaffron Restaurant", lat: 43.793668722599854, lon: -79.4194142527541, description: "رستوران خانوادگی با کباب‌های عالی", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "رستوران صداقت", name_map: "Sedaghat Restaurant", lat: 43.69404928251708, lon: -79.27743339691568, description: "کترینگ و تهیه غذای سنتی", parkingInfo: "پارکینگ خیابانی", city: "Toronto"),
  Restaurant(name: "تاپ کباب", name_map: "Top kebab", lat: 44.05016617017726, lon: -79.47984432944048, description: "کباب‌های با کیفیت در منطقه نیومارکت", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "لیلی کیچن", name_map: "Lili Kitchen", lat: 43.65424728320665, lon: -79.39093859447004, description: "غذاهای خانگی و صمیمی", parkingInfo: "پارکینگ خیابانی", city: "Toronto"),
  Restaurant(name: "رستوران توچال", name_map: "Tochal Restaurant", lat: 43.87751297526911, lon: -79.43815026502233, description: "کترینگ معروف و با سابقه توچال", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "رستوران شیشلیک", name_map: "Shishlix Restaurant", lat: 43.86006883114935, lon: -79.43383821594944, description: "تخصص در کباب شیشلیک و دنده", parkingInfo: "پارکینگ در محل", city: "Toronto"),
  Restaurant(name: "مامز بایت", name_map: "Mom's Bite", lat: 43.89043340704988, lon: -79.43985250612684, description: "لقمه‌ها و غذاهای خانگی لذیذ", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "پرشین پالاس", name_map: "Persian Palace", lat: 43.88887027374884, lon: -79.44056018220182, description: "رستوران لوکس با دکوراسیون کاخی", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "کبابا", name_map: "Ka.ba.ba", lat: 43.9993674306322, lon: -79.46767309756392, description: "کباب‌سرای مدرن و با کیفیت", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "کباب استاپ", name_map: "Kebab Stop", lat: 43.42581752247643, lon: -79.7095716588882, description: "توقفگاهی برای کباب‌های لذیذ", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "ریحان کباب", name_map: "Rayhon Kebab", lat: 43.88216102407154, lon: -79.44144914661997, description: "غذاهای خوش‌طعم و تازه", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "کلبه کوچک کباب", name_map: "The Little House of Kebobs", lat: 43.88071104154617, lon: -79.39363062330635, description: "محیطی کوچک و دنج با کباب‌های عالی", parkingInfo: "پارکینگ عمومی", city: "Toronto"),
  Restaurant(name: "ته‌چین‌بار", name_map: "Tahchinbar", lat: 43.80317380497384, lon: -79.41965283496317, description: "تخصص در انواع ته‌چین‌های ایرانی", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "فرحزاد (شاورما)", name_map: "Farahzad", lat: 44.04057843543633, lon: -79.45422530612684, description: "غذاهای ایرانی و شاورما", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "پارس گریل وان", name_map: "Pars Grill Vaughan", lat: 43.864234043960984, lon: -79.46963873557459, description: "شعبه وان رستوران پارس گریل", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),

//   Shamshiri Restaurant
//   43.764446101045685, -79.39837673099352
//   Shamshiri Restaurant2
// 43.827643142329634, -79.42631804109728
// Shamshiri Restaurant3
// 43.66676906319846, -79.38549318833593
// Esfahan Restaurant Toronto
// 43.76384350402345, -79.39884232581039
// BAREH SEFID
// 43.85594266168026, -79.43074311778368
// Afraa Restaurant
// 43.79759477394048, -79.42592632944047
// Persian taste
// 43.89812028932792, -79.44402342944048
// Kababi
// 43.677184399227315, -79.35322292882907
// ARJAN RESTAURANT
// 43.87485305786047, -79.43786493129471
// Deedar Persian Restaurant
// 43.79832063388618, -79.46973278833593
// Persian Top Meal
// 43.84395917723035, -79.37811797176784
// Aashland
// 43.849671244692836, -79.43260912944046
// Dana Kabob Mississauga/رستوران ایرانی دانا
// 43.53808730665382, -79.7284856410973
// Kebab Bazari
// 43.64581492099021, -79.41002307054502
// Kabob Place
// 43.4754207793277, -80.5356537024584
// Tehran Kebab Catering
// 43.85092616100034, -79.4336023527541
// Dorchin restaurant
// 43.87426905907926, -79.43774071778367
// Chokka Restaurant
// 43.7050243220531, -79.38856362330635
// Chef Reza Richmond Hill
// 43.94684783155693, -79.4547438644109
// Takht-e Tavoos Restaurant
// 43.65255162553238, -79.43311970734968
// City kebab Persian Restaurant
// 43.71576992756624, -79.39997987667911
// Tehranto
// 43.78048028824501, -79.41543941164956
// Darband Restaurant
// 43.75518802651118, -79.34840821594945
// Chef Reza Thornhill
// 43.8260545957851, -79.42589798833593
// Herby Restaurant
// 43.677510686958854, -79.35153015888821
// Roses Kebab Land Restaurant
// 43.852231028821485, -79.4333546533655
// Golpayegani KababSara Corp
// 43.874856242139806, -79.43785907606771
// Touraj Catering
// 44.07744790328564, -79.42954497054504
// Village of Kebab Restaurant (Iran Zamin Restaurant )
// 43.89617418957271, -79.40306111778366
// Dana Kabob Aurora
// 44.00532987582999, -79.46833278833593
// Super Unique
// 43.70286120719334, -79.39735681778366
// Kabana B.B.Q jigaraki(جگرکی)
// 43.875800175498355, -79.4377497760677
// Soufi Persian Grill & Lounge
// 43.884692478348704, -79.46664368342464
// QUEEN OF PERSIA Restaurant
// 43.68194575073107, -79.4253562650223
// MALATA KEBAB & SHAWARMA مالاتا کباب
// 44.05813558728992, -79.46434221164957
// Rumi's Restaurant (Woodbridge)
// 43.78233428799729, -79.5735208355746
// Mr Dizi
// 43.76772845897553, -79.46987339385863
// Nika Kitchen
// 43.85211751155614, -79.43368689999275
// Tochal Newmarket
// 44.05806884164991, -79.46097894109728
// Tehroon Kabob
// 44.04063160733067, -79.47599684109728
// Darvish Restaurant
// 43.663407203870314, -79.38405814109728
// Yum Yum kabob
// 43.54500282418263, -80.24944775275411
// Naeb Restaurant
// 43.87527517598282, -79.43796325827678
// Rayhoon Persian Eatery
// 43.32667604862612, -79.79523632944047
// Bahar Fine Foods.
// 44.204728808593195, -79.46656024723139
// Cyrus Persian Restaurant
// 43.885158490410134, -78.84690872208355
// Shazdeh Restaurant
// 43.854542011271086, -79.37889865888822
// Noor Kabob Persian Food Restaurant
// 43.986460343137686, -79.46369089999274
// QAJAR Restaurant
// 43.83203598135346, -79.40539349999275
// Darband Express ( RichmondHill)
// 43.94743363146892, -79.45578079447006
// Chic Pick Restaurant and Catering
// 43.80623508480312, -79.53373307667913
// Koochini Restaurant & bar
// 43.80552298849795, -79.41994941778368
// Darbar Persian Grill & Wine Lounge
// 43.735518787249745, -79.41966671778367
// Parkway Restaurant
// 43.70926140908049, -79.38512505130012
// Rose Kebab Toronto
// 43.748250554961956, -79.34856152330636
// Kebab Chalet
// 44.06635528631987, -79.43269195275408
// Bokhara Restaurant
// 43.94289716342649, -79.45478666441092
// Baba's Burgers ,Sandwiches
// 43.82755726570711, -79.42660768220182
// Pars Grill North York
// 43.79136743893401, -79.41885949999273
// Ava Esfahan Food Market
// 43.763887253379934, -79.39912445888821
// Pomegranate Restaurant
// 43.65678779656598, -79.40692778342465
// Zaffron Restaurant
// 43.793668722599854, -79.4194142527541
// Sedaghat Restaurant
// 43.69404928251708, -79.27743339691568
// Top kebab
// 44.05016617017726, -79.47984432944048
// Lili Kitchen
// 43.65424728320665, -79.39093859447004
// Tochal Restaurant
// 43.87751297526911, -79.43815026502233
// Shishlix Restaurant
// 43.86006883114935, -79.43383821594944
// Mom's Bite
// 43.89043340704988, -79.43985250612684
// Persian Palace
// 43.88887027374884, -79.44056018220182
// Ka.ba.ba
// 43.9993674306322, -79.46767309756392
// Kebab Stop
// 43.42581752247643, -79.7095716588882
// Rayhon Kebab
// 43.88216102407154, -79.44144914661997
// The Little House of Kebobs
// 43.88071104154617, -79.39363062330635
// Tahchinbar
// 43.80317380497384, -79.41965283496317


Restaurant(name: "سوپرمارکت خوراک (سوپر خوراک)", name_map: "Khorak Supermarket (Super Khorak)", lat: 43.792245282428084, lon: -79.41808114695964, description: "سوپرمارکت قدیمی ایرانی با بخش غذای گرم معروف", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "شاطر عباس کوئینز کی", name_map: "shatter abbas Queens Quay", lat: 43.63974295120191, lon: -79.38261948806257, description: "کباب‌های معروف شاطر عباس در مرکز شهر تورنتو", parkingInfo: "پارکینگ عمومی", city: "Toronto"),
  Restaurant(name: "پرشین هات پلیت", name_map: "persian hot plate", lat: 43.48420761425138, lon: -80.52558782916695, description: "ارائه دهنده کباب‌های داغ و غذاهای سنتی ایرانی", parkingInfo: "پارکینگ خیابانی", city: "Toronto"),
  Restaurant(name: "سوپرمارکت کوروش", name_map: "Kourosh Supermarket", lat: 43.769856521220085, lon: -79.37591692364502, description: "سوپرمارکت ایرانی با تنوع بالای غذاهای آماده", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "رستوران و کترینگ یاسمن", name_map: "Yasaman Restaurant & Catering", lat: 43.80355332095848, lon: -79.41957681751039, description: "غذاهای سنتی و کترینگ مخصوص مراسم و مهمانی‌ها", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "کباب‌سرای پریا", name_map: "KABABSARA PARYA", lat: 43.98896419544749, lon: -79.46544075861478, description: "کباب‌های زغالی با طعم کلاسیک ایرانی", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "شاطر عباس اکسپرس", name_map: "Shatter Abbas Express", lat: 43.77013327384718, lon: -79.37452423530162, description: "سرویس سریع و بیرون‌بر کباب‌های شاطر عباس", parkingInfo: "پارکینگ در محل", city: "Toronto"),
  Restaurant(name: "صوفی داین-این", name_map: "Sophie's Dine-in", lat: 43.704867613592626, lon: -79.40822719419722, description: "محیطی صمیمی برای صرف انواع کباب و پلو ایرانی", parkingInfo: "پارکینگ خیابانی", city: "Toronto"),
  Restaurant(name: "کترینگ نامی", name_map: "Naami Catering", lat: 43.87656027525228, lon: -79.41691980033187, description: "متخصص در تهیه غذاهای اصیل خانگی و مجلسی", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "پیتزا بار لیت نایت", name_map: "Late Night Pizza Bar", lat: 43.80219628534296, lon: -79.42031024695818, description: "پیتزا به سبک ایرانی و فست‌فود شبانه", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "کباب هات", name_map: "Kabob Hut", lat: 43.47182216890967, lon: -80.5387735592275, description: "سرویس سریع انواع کباب‌های گریل شده", parkingInfo: "پارکینگ خیابانی", city: "Toronto"),
  Restaurant(name: "رستوران خاکی نورت یورک", name_map: "Khaki Restaurant North York", lat: 43.79157560228166, lon: -79.41794467967185, description: "رستوران ایرانی با منوی کامل کباب و خورشت", parkingInfo: "پارکینگ در محل", city: "Toronto"),
  Restaurant(name: "کباب‌سرای پرشین", name_map: "Persian Kebab House", lat: 43.943212749286694, lon: -79.45974366474942, description: "خانه کباب‌های سنتی در منطقه ریچموند هیل", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "رستوران نان نمک (افغانستانی)", name_map: "Bread and Salt Afghan Cuisine رستوران نان نمک", lat: 43.61153002812453, lon: -79.58053652975919, description: "غذاهای اصیل افغانستانی با نان تنوری تازه", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "رز نیویورک داون‌تاون", name_map: "Roses New York downtown", lat: 43.638898492418264, lon: -79.39897052916697, description: "شعبه مرکز شهر رستوران محبوب رز نیویورک", parkingInfo: "پارکینگ عمومی", city: "Toronto"),
  Restaurant(name: "کترینگ مینو", name_map: "Minoo Catering", lat: 43.82372888517886, lon: -79.42571679971917, description: "ارائه دهنده انواع پلوها و کباب‌های اصیل", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "رستوران گیلانه", name_map: "Gilaneh Restaurant", lat: 43.75628935414869, lon: -79.3495121058538, description: "تخصص در طبخ غذاهای شمالی و گیلکی با کیفیت بالا", parkingInfo: "پارکینگ رایگان", city: "Toronto"),
  Restaurant(name: "سوپرمارکت ارزان", name_map: "Arzon Supermarket", lat: 44.04072102755893, lon: -79.45303050033188, description: "سوپرمارکت بزرگ ایرانی با کترینگ داخلی پرطرفدار", parkingInfo: "پارکینگ اختصاصی بزرگ", city: "Toronto"),
  Restaurant(name: "خاکی اکسپرس", name_map: "Khaki express Restaurant", lat: 43.876408608851484, lon: -79.4385342469582, description: "سرویس بیرون‌بر سریع با کیفیت رستوران خاکی", parkingInfo: "پارکینگ در محل", city: "Toronto"),
  Restaurant(name: "رستوران شاطر عباس", name_map: "Shatter Abbas Restaurant", lat: 43.82626096589097, lon: -79.42625901751039, description: "کباب‌های مرغوب ایرانی در محیطی کلاسیک", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "رئال کباب (افغانستانی)", name_map: "Real Kebab, Afghan restaurant", lat: 43.907045420645446, lon: -79.26658675861475, description: "کباب‌های اصیل و نان سنتی افغانستان", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "هیوا فاین فودز", name_map: "Heeva Fine Foods", lat: 43.882421674471246, lon: -79.44027079419722, description: "کترینگ لوکس با منوی متنوع از غذاهای آماده", parkingInfo: "پارکینگ در محل", city: "Toronto"),
  Restaurant(name: "نان کباب (افغانستانی)", name_map: "NAAN KABOB, Afghan restaurant", lat: 43.70481329834784, lon: -79.36151213530162, description: "رستوران زنجیره‌ای محبوب با کباب‌های گریل شده", parkingInfo: "پارکینگ عمومی", city: "Toronto"),
  Restaurant(name: "رستوران رز نیویورک", name_map: "Roses New York Restaurant", lat: 43.79581763983781, lon: -79.4192007788151, description: "معروف‌ترین پیتزاها و کباب‌های سبک ایرانی", parkingInfo: "پارکینگ خیابانی", city: "Toronto"),
  Restaurant(name: "کترینگ تبریز", name_map: "Tabriz Catering", lat: 43.789592923276594, lon: -79.41726056474943, description: "غذاهای آذری و خورشت‌های سنتی با طعم خانگی", parkingInfo: "پارکینگ در محل", city: "Toronto"),
  Restaurant(name: "ووزارا فود فکتوری", name_map: "Vozara Food Factory", lat: 43.713651897168404, lon: -79.36545371751039, description: "تولیدکننده و عرضه‌کننده مستقیم غذاهای سنتی", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "رز نیویورک ریچموند هیل", name_map: "Rose newyork richmond hill", lat: 43.94784339089992, lon: -79.45589992915502, description: "شعبه ریچموند هیل رستوران رز نیویورک", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "کباب قطغن (افغانستانی)", name_map: "Qataghan Kabab & Catering, Afghan restaurant", lat: 43.74343634416851, lon: -79.30194242916697, description: "رستوران و کترینگ تخصصی با کباب‌های افغانی", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "سوپرمارکت تهران", name_map: "Tehran Supermarket", lat: 43.806105318760906, lon: -79.42119860769196, description: "سوپرمارکت ایرانی با بخش غذای آماده متنوع", parkingInfo: "پارکینگ در محل", city: "Toronto"),
  Restaurant(name: "ساندویچ ساب‌استریت", name_map: "Substreet Sandwiches - Subs & Dogs", lat: 43.882532157906255, lon: -79.43892831198845, description: "ساندویچ‌های سرد و گرم به سبک نوستالژیک ایران", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "رستوران نورث (شمال)", name_map: "North Restaurant", lat: 43.79808143787359, lon: -79.4245399058538, description: "فضای مدرن و غذاهای سنتی ایرانی با کیفیت بالا", parkingInfo: "پارکینگ عمومی", city: "Toronto"),
  Restaurant(name: "الیاس نان و کباب (افغانستانی)", name_map: "Elias Naan & Kabob, Afghan restaurant", lat: 43.91939710170019, lon: -78.95758152364502, description: "کباب‌های گریل شده با نان تازه افغانستانی", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "سلطان اکسپرس (میسیساگا)", name_map: "Sultan Xpress | Halal Catering in Mississauga", lat: 43.556880246173066, lon: -79.6424702058538, description: "کترینگ حلال و غذاهای خاورمیانه‌ای در میسیساگا", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "رستوران اپل", name_map: "Apple Restaurant", lat: 43.94792544861686, lon: -79.45591008806258, description: "ارائه انواع کباب‌ها و غذاهای کلاسیک ایرانی", parkingInfo: "پارکینگ در محل", city: "Toronto"),
  Restaurant(name: "قنادی دریانی", name_map: "Daryani Fine Bakery Inc.", lat: 43.887564005042584, lon: -79.44161802793407, description: "شیرینی‌های اصیل ایرانی و بستنی سنتی", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "کبابنا (باغچه سابق)", name_map: "Kabana B.B.Q restaurant (former Jigaraki Baghcheh)", lat: 43.8758072921339, lon: -79.43771468254063, description: "فضای باز و کباب‌های زغالی و جگرکی", parkingInfo: "پارکینگ در محل", city: "Toronto"),
  Restaurant(name: "رستوران نارنجستان", name_map: "Narenjestan Restaurant", lat: 43.88872449006199, lon: -79.44080597027136, description: "غذاهای سنتی و محلی ایران در محیطی گرم", parkingInfo: "پارکینگ اختصاصی", city: "Toronto"),
  Restaurant(name: "رز کافه سنسو", name_map: "Roses Cafe Senso", lat: 43.85258017921618, lon: -79.43349059726083, description: "کافه و رستوران ایرانی با منوی متنوع", parkingInfo: "پارکینگ در محل", city: "Toronto"),
  Restaurant(name: "رز کباب لند اکسپرس", name_map: "Roses Kebab Land Express (Take Out)", lat: 43.84939977756502, lon: -79.4324229058538, description: "سرویس سریع بیرون‌بر کباب‌های لذیذ رز لند", parkingInfo: "پارکینگ عمومی", city: "Toronto"),


// Farahzad - R &M Shawarma
// 44.04057843543633, -79.45422530612684
// Pars Grill Vaughan
// 43.864234043960984, -79.46963873557459
// Khorak Supermarket (Super Khorak)
// 43.792245282428084, -79.41808114695964
// shatter abbas Queens Quay
// 43.63974295120191, -79.38261948806257
// persian hot plate
// 43.48420761425138, -80.52558782916695
// Kourosh Supermarket
// 43.769856521220085, -79.37591692364502
// Yasaman Restaurant & Catering
// 43.80355332095848, -79.41957681751039
// KABABSARA PARYA
// 43.98896419544749, -79.46544075861478
// Shatter Abbas Express
// 43.77013327384718, -79.37452423530162
// Sophie's Dine-in
// 43.704867613592626, -79.40822719419722
// Naami Catering
// 43.87656027525228, -79.41691980033187
// Late Night Pizza Bar
// 43.80219628534296, -79.42031024695818
// Kabob Hut
// 43.47182216890967, -80.5387735592275
// Khaki Restaurant North York
// 43.79157560228166, -79.41794467967185
// Persian Kebab House
// 43.943212749286694, -79.45974366474942
// Bread and Salt Afghan Cuisine رستوران نان نمک
// 43.61153002812453, -79.58053652975919
// Roses New York downtown
// 43.638898492418264, -79.39897052916697
// Minoo Catering
// 43.82372888517886, -79.42571679971917
// Gilaneh Restaurant
// 43.75628935414869, -79.3495121058538
// Arzon Supermarket
// 44.04072102755893, -79.45303050033188
// Khaki express Restaurant
// 43.876408608851484, -79.4385342469582
// Shatter Abbas Restaurant
// 43.82626096589097, -79.42625901751039
// Real Kebab, Afghan restaurant 
// 43.907045420645446, -79.26658675861475
// Heeva Fine Foods
// 43.882421674471246, -79.44027079419722
// NAAN KABOB, Afghan restaurant
// 43.70481329834784, -79.36151213530162
// Roses New York Restaurant
// 43.79581763983781, -79.4192007788151
// Tabriz Catering
// 43.789592923276594, -79.41726056474943
// Vozara Food Factory
// 43.713651897168404, -79.36545371751039
// Rose newyork richmond hill
// 43.94784339089992, -79.45589992915502
// Qataghan Kabab & Catering, Afghan restaurant
// 43.74343634416851, -79.30194242916697
// Tehran Supermarket
// 43.806105318760906, -79.42119860769196
// Substreet Sandwiches - Subs & Dogs
// 43.882532157906255, -79.43892831198845
// North Restaurant
// 43.79808143787359, -79.4245399058538
// Elias Naan & Kabob, Afghan restaurant
// 43.91939710170019, -78.95758152364502
// Sultan Xpress | Halal Catering in Mississauga
// 43.556880246173066, -79.6424702058538
// Apple Restaurant
// 43.94792544861686, -79.45591008806258
// Daryani Fine Bakery Inc.
// 43.887564005042584, -79.44161802793407
// Kabana B.B.Q restaurant (former Jigaraki Baghcheh)
// 43.8758072921339, -79.43771468254063
// Narenjestan Restaurant
// 43.88872449006199, -79.44080597027136
// Roses Cafe Senso
// 43.85258017921618, -79.43349059726083
// Roses Kebab Land Express (Take Out)
// 43.84939977756502, -79.4324229058538


];
// @formatter:on
