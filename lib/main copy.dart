import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'dart:math';
import 'models.dart';
import 'dart:async';
import 'package:another_flushbar/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Firebase initialization error: \$e");
  }
  runApp(const MyApp());
}
//stripe.Stripe.publishableKey = "pk_live_51SlnYX84wisLROHGR7thbisdDONC1SU0UmlZCvgKMBD7mL6qR9E0kKUQCbyMO8cKPiYUvfTpiCHZ9GxGbSuTHSAH00U7IPERlh";


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'جستجوی محلی و توریستی',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Tahoma',
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // --- متغیرهای وضعیت ---
  Position? currentUserPosition;
  bool _hasPaid = false; 
  bool _isPurchased = false;


 
  final String _weatherData = 'در حال دریافت اطلاعات آب و هوا...';
  double temperature = 7;
  Timer? _alertTimer;
  bool _isProcessingPayment = false;
  // شناسه محصولی که در کنسول گوگل‌‌پلی تعریف کردید
  final String _productId = 'premiumunlock1';

  //static const int _trialDays = 30; // مقدار دوره تست (مثلاً ۳۰ روز)
  int _trialDays = 30;
  int _remainingDays = 20;

  // شناسه محصولی که در کنسول گوگل پلی تعریف می‌کنید
  static const String _premiumId = 'premiumunlock1'; 
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
String _selectedCity = "اطراف من";
//final List<String> _allCities = ["اطراف من", "Hannover", "Bremen", "Brussels", "Düsseldorf", "Berlin", "Hamburg", "Köln", "Munic", "Frankfurt", "Bonn", "Paris", "Amsterdam", "Barcelona", "Madrid", "Rome", "Milan", "Zurich", "Warsaw", "Stockholm", "Dubai", "New York","Los Angeles","Lisbon","Porto","Oslo","Helsinki","Toronto","Vancuuer","Sydney","Melborne"];
final List<String> _allCities = [
  "اطراف من", 
  "Hannover", 
  "Brussels", 
  "Dusseldorf", 
  "Berlin", 
  "Hamburg", 
  "Koln", 
  "Munich", // اصلاح املا
  "Frankfurt", 
  "Bonn", 
  "Paris", 
  "Amsterdam", 
  "Barcelona", 
  "Madrid", 
  "Rome", 
  "Milan", 
  "Zurich", 
  "Warsaw", 
  "Stockholm", 
  "Istanbul", // جدید (ترکیه)
  "Ankara",    // جدید (ترکیه)
  "Athens",    // جدید (یونان)
  "Prague",    // جدید (چک)
  "Oslo", 
  "Helsinki", 
  "Lisbon", 
  "Porto", 
  "Dubai", 
  "New York", 
  "Los Angeles", 
  "Tokyo",
  "Vienna",
  "Strasbourg",
  "nice", 
  "Vancouver", // اصلاح املا
  "Sydney", 
  "Melbourne",  // اصلاح املا
   "Toronto"

];
  @override
  void initState() {
    super.initState();

    // ۱. اولویت با مقداردهی اولیه است

  
  // ۲. سایر بخش‌ها
  _tabController = TabController(length: 1, vsync: this);
  _initializePurchase(); 
  _checkTrialAndInit();
  
  }

//   Future<void> _initializePurchase() async {
//   // بررسی دسترسی به سرویس قبل از گوش دادن
//   final bool available = await _inAppPurchase.isAvailable();
//   if (!available) return;

//   // گوش دادن به تغییرات با مدیریت صحیح
//   _subscription = _inAppPurchase.purchaseStream.listen(
//     (List<PurchaseDetails> purchaseDetailsList) {
//       for (var purchaseDetails in purchaseDetailsList) {
//         if (purchaseDetails.status == PurchaseStatus.purchased ||
//             purchaseDetails.status == PurchaseStatus.restored) {
//           _verifyAndDeliver(purchaseDetails);
//         } else if (purchaseDetails.status == PurchaseStatus.error) {
//           print("خطا در پرداخت: ${purchaseDetails.error}");
//         }
//       }
//     },
//     onError: (error) {
//       print("خطای استریم: $error");
//     },
//   );
// }
Future<void> _initializePurchase() async {
  final bool available = await _inAppPurchase.isAvailable();
  if (!available) return;

  _subscription = _inAppPurchase.purchaseStream.listen(
    (List<PurchaseDetails> purchaseDetailsList) async { // اضافه شدن async
      for (var purchaseDetails in purchaseDetailsList) {
        if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          
          // ۱. اول ثبت در فایربیس (بسیار حیاتی)
          await _handleSuccessfulPayment(); 

          // ۲. بعد اعلام اتمام تراکنش به گوگل
          if (purchaseDetails.pendingCompletePurchase) {
            await _inAppPurchase.completePurchase(purchaseDetails);
          }
          
          setState(() {
            _isPurchased = true;
            _isProcessingPayment = false;
          });

        } else if (purchaseDetails.status == PurchaseStatus.error) {
          _showErrorMessage("خطا در پرداخت: ${purchaseDetails.error?.message}");
          setState(() => _isProcessingPayment = false);
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          _showErrorMessage("پرداخت لغو شد.");
          setState(() => _isProcessingPayment = false);
        }
      }
    },
    onError: (error) {
      print("خطای استریم: $error");
      setState(() => _isProcessingPayment = false);
    },
  );
}



  // void _verifyAndDeliver(PurchaseDetails details) {
  //   // اینجا رسید خرید را به سرور خود می‌فرستید تا تایید شود
  //   setState(() => _isPurchased = true);
  //   _inAppPurchase.completePurchase(details);
  // }

// void _verifyAndDeliver(PurchaseDetails purchaseDetails) async {
//   if (purchaseDetails.status == PurchaseStatus.purchased ||
//       purchaseDetails.status == PurchaseStatus.restored) {
    
//     // ۱. حتماً وضعیت را در فایربیس آپدیت کنید (همان متدی که قبلاً نوشتید)
//     await _handleSuccessfulPayment();

//     // ۲. به گوگل اعلام کنید که خرید تحویل داده شد تا پول برگشت نخورد
//     if (purchaseDetails.pendingCompletePurchase) {
//       await _inAppPurchase.completePurchase(purchaseDetails);
//     }

//     setState(() {
//       _isPurchased = true;
//       _hasPaid = true;
//       _isProcessingPayment = false;
//     });
//   }
// }



Widget _buildCitySelector() {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: _allCities.map((city) {
        final isSelected = _selectedCity == city;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ChoiceChip(
            label: Text(city),
            selected: isSelected,
            onSelected: (selected) {
              setState(() => _selectedCity = city);
            },
          ),
        );
      }).toList(),
    ),
  );
}

// متد اصلی پرداخت

Future<void> _makePayment() async {
  setState(() => _isProcessingPayment = true);

  final bool available = await _inAppPurchase.isAvailable();
  if (!available) {
    _showErrorMessage("فروشگاه در دسترس نیست.");
    setState(() => _isProcessingPayment = false);
    return;
  }

  const Set<String> kIds = <String>{_premiumId};
  final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(kIds);

  if (response.productDetails.isEmpty) {
    // اصلاح پیام برای عیب‌یابی دقیق‌تر
    _showErrorMessage("محصول یافت نشد. شناسه‌ای که کد جستجو کرد: $_premiumId");
    print("Not found IDs: ${response.notFoundIDs}"); // این را در ترمینال چک کنید
    setState(() => _isProcessingPayment = false);
    return;
  }

  final ProductDetails productDetails = response.productDetails.first;
  final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);

  // اجرای درخواست خرید
  _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
}

// متدی که نتیجه خرید را از گوگل دریافت می‌کند
// void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
//   for (var purchaseDetails in purchaseDetailsList) {
//     if (purchaseDetails.status == PurchaseStatus.pending) {
//       setState(() => _isProcessingPayment = true);
//     } else {
//       if (purchaseDetails.status == PurchaseStatus.purchased || 
//           purchaseDetails.status == PurchaseStatus.restored) {
        
//         // ۱. ابتدا آپدیت فایربیس (تحویل محصول به کاربر)
//         await _handleSuccessfulPayment(); 

//         // ۲. سپس اعلام به گوگل برای نهایی کردن تراکنش
//         if (purchaseDetails.pendingCompletePurchase) {
//           await _inAppPurchase.completePurchase(purchaseDetails);
//         }
        
//       } else if (purchaseDetails.status == PurchaseStatus.error) {
//         _showErrorMessage("خطا در خرید: ${purchaseDetails.error?.message}");
//       } else if (purchaseDetails.status == PurchaseStatus.canceled) {
//         // مدیریت حالتی که کاربر خودش پرداخت را لغو می‌کند
//         _showErrorMessage("پرداخت توسط شما لغو شد."); 

//       }
      
//       // در هر صورت (خطا یا موفقیت) لودینگ را ببند
//       setState(() => _isProcessingPayment = false);
//     }
//   }
// }

Future<void> _initiatePurchase() async {
  setState(() => _isProcessingPayment = true);
  
  const Set<String> kIds = <String>{'premiumunlock1'};
  final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(kIds);

  if (response.productDetails.isNotEmpty) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: response.productDetails.first);
    // اجرای خرید
    await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  } else {
    _showErrorMessage("محصولی در گوگل پلی یافت نشد.");
    setState(() => _isProcessingPayment = false);
  }
}

Future<void> _handleSuccessfulPayment() async {
  final deviceInfo = DeviceInfoPlugin();
  String? deviceId;

  if (Platform.isAndroid) {
    var androidInfo = await deviceInfo.androidInfo;
    deviceId = androidInfo.id;
  }

  if (deviceId != null) {
    // آپدیت وضعیت در فایربیس - منبع اصلی تایید خرید
    await FirebaseFirestore.instance
        .collection('trial_users')
        .doc(deviceId)
        .update({
          'is_paid': true,
          'payment_date': DateTime.now().toIso8601String(),
        });
  }

  setState(() {
    _hasPaid = true;
    _remainingDays = 0;
  });
  
  _showSuccessMessage('پرداخت با موفقیت انجام شد و نسخه کامل فعال گردید!');
}

// تابع نمایش پیام روی گوشی
void _showMessageBox(String title, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(child: Text(message)),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("باشه"))],
    ),
  );
}


void _showErrorMessage(String message) {
  Flushbar(
    message: message,
    icon: const Icon(Icons.error, color: Colors.white),
    backgroundColor: Colors.red, // رنگ قرمز برای خطا
    duration: const Duration(seconds: 3),
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    leftBarIndicatorColor: Colors.redAccent,
  ).show(context);
}


Future<void> _checkTrialAndInit() async {

  if (kIsWeb) { 
    setState(() {
      _hasPaid = true;
      _isPurchased = true;
      _remainingDays = 0;
    });
    _startWeatherAlertSystem(); // فعال‌سازی سیستم آب و هوا
    return; // خارج شدن از متد و عدم اجرای کدهای فایربیس و اندروید
  }

  setState(() {
    _hasPaid = false;
    _remainingDays = 0;
  });

  final deviceInfo = DeviceInfoPlugin();
  String? deviceId;

  try {
    // ۱. دریافت تنظیمات کلی اپلیکیشن از فایربیس (بازه تست)
    var settingsDoc = await FirebaseFirestore.instance
        .collection('app_settings')
        .doc('global_config')
        .get();
    
    if (settingsDoc.exists && settingsDoc.data() != null) {
      setState(() {
        _trialDays = settingsDoc.data()!['trial_period'] ?? 30;
      });
    }

    if (Platform.isAndroid) {
      var androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
    }

    if (deviceId != null) {
      var userDoc = await FirebaseFirestore.instance.collection('trial_users').doc(deviceId).get();

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> userData = userDoc.data()!;
        bool paidStatus = userData['is_paid'] == true; 

        if (paidStatus) {
          setState(() {
            _hasPaid = true;
            _remainingDays = 0;
          });
        } else {
          if (userData.containsKey('first_launch')) {
            DateTime startDate = DateTime.parse(userData['first_launch']);
            int daysPassed = DateTime.now().difference(startDate).inDays;
            setState(() {
              _hasPaid = false;
              // محاسبه بر اساس مقداری که همین الان از فایربیس دریافت شد
              _remainingDays = (_trialDays - daysPassed) > 0 ? (_trialDays - daysPassed) : 0;
            });
          }
        }
      } else {
        // کاربر جدید
        await FirebaseFirestore.instance.collection('trial_users').doc(deviceId).set({
          'first_launch': DateTime.now().toIso8601String(),
          'is_paid': false,
        });
        setState(() {
          _hasPaid = false;
          _remainingDays = _trialDays; 
        });
      }
    }
  } catch (e) {
    print("Error in _checkTrialAndInit: $e");
    setState(() {
      _hasPaid = false;
      _remainingDays = 0;
    });
  }
  _startWeatherAlertSystem();
}

Future<void> _resetPaymentStatusForTesting() async {
  final deviceInfo = DeviceInfoPlugin();
  String? deviceId;

  if (Platform.isAndroid) {
    var androidInfo = await deviceInfo.androidInfo;
    deviceId = androidInfo.id;
  }

  if (deviceId != null) {
    await FirebaseFirestore.instance
        .collection('trial_users')
        .doc(deviceId)
        .update({
          'is_paid': false,
          'first_launch': DateTime.now().toIso8601String(),
        });
    
    // اجرای مجدد چک کردن برای اعمال تغییرات در اپلیکیشن
    await _checkTrialAndInit();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("وضعیت به 'پرداخت نشده' تغییر یافت. حالا دکمه خرید را تست کنید.")),
    );
  }
}

  @override
  void dispose() {
    _subscription.cancel();
    _tabController.dispose();
    _alertTimer?.cancel();
    super.dispose();
  }

  // --- شبیه‌ساز پرداخت ۵ یورو ---
  Future<void> _processPayment() async {
    setState(() => _isProcessingPayment = true);
    
    // شبیه ساز درگاه بانکی
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_paid', true);

    setState(() {
      _hasPaid = true;
      _isProcessingPayment = false;
      _remainingDays = 0;
    });

    _showSuccessMessage('پرداخت با موفقیت انجام شد. دسترسی کامل فعال گردید.');
  }

  void _showSuccessMessage(String message) {
    Flushbar(
      message: message,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }


  Widget _buildRestaurantsList() {
  if (currentUserPosition == null && _selectedCity == "اطراف من") {
    //return const Center(child: CircularProgressIndicator());
    return Column(
      children: [
        _buildCitySelector(),
        _buildLocationRequestCard(), // نمایش کارت جدید به جای لودر ابدی
      ],
    );
  }

  // ۱. تهیه یک لیست کامل از تمام رستوران‌های موجود در همه شهرها
  final allPossibleRestaurants = RESTAURANTS_DATA.values.expand((list) => list).toList();

  List<Restaurant> filteredRestaurants;

  if (_selectedCity == "اطراف من") {
    // فیلتر بر اساس فاصله (بدون توجه به نام شهر)
    filteredRestaurants = allPossibleRestaurants.where((r) {
      if (currentUserPosition == null) return false;
      double dist = calculateDistance(
          currentUserPosition!.latitude,
          currentUserPosition!.longitude,
          r.lat,
          r.lon);
      return dist <= 50;
    }).toList();
  } else {
    // ۲. فیلتر دقیق بر اساس فیلد city که داخل کلاس Restaurant تعریف کردیم
    // این کار باعث می‌شود اگر در "نام" رستوران اسم شهر دیگری باشد، اشتباه نشود
    filteredRestaurants = allPossibleRestaurants.where((r) {
      return (r.city.toLowerCase() ?? "") == _selectedCity.toLowerCase();
    }).toList();
  }

  // بقیه منطق محدودیت نمایش (رایگان/پولی)
  List<Restaurant> restaurantsToShow;
  if (_hasPaid) {
    restaurantsToShow = filteredRestaurants;
  } else if (_remainingDays > 0) {
    restaurantsToShow = filteredRestaurants.length > 3
        ? filteredRestaurants.sublist(0, 3)
        : filteredRestaurants;
  } else {
    restaurantsToShow = [];
  }

  return Column(
    children: [
      _buildCitySelector(), // نمایش لیست شهرها
      
      if (!_hasPaid)
        _buildInfoBanner(_remainingDays > 0
            ? "🎁 دوره تست ($_trialDays روزه): فقط ۳ رستوران نمایش داده می‌شود. ($_remainingDays روز باقی‌مانده)"
            : "⚠️ مهلت تست $_trialDays روزه شما تمام شده است. برای مشاهده لیست، اشتراک تهیه کنید."
            ),

      // نمایش لیست رستوران‌های فیلتر شده
      if (filteredRestaurants.isEmpty)
        const Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("رستورانی برای این شهر یافت نشد."),
        )
      else
        ...restaurantsToShow.map((r) {
          String detail = "";
          if (currentUserPosition != null) {
            final dist = calculateDistance(currentUserPosition!.latitude,
                currentUserPosition!.longitude, r.lat, r.lon);
            detail = 'فاصله تقریبی: ${dist.toStringAsFixed(1)} کیلومتر';
          }
          return _buildRestaurantItem(r, detail);
        }),

      if (!_hasPaid) _buildPaymentPrompt(),
      const SizedBox(height: 30),
    ],
  );
}

  Widget _buildInfoBanner(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.orange.shade50, 
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade200)
      ),
      child: Text(message, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
    );
  }

  Widget _buildPaymentPrompt() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 20),
      color: const Color(0xfffff9c4),
      shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.orange), borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.stars, size: 40, color: Colors.orange),
            const SizedBox(height: 10),
            const Text('دسترسی به لیست کامل (Premium)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('با پرداخت ۵ یورو، تمامی رستوران‌های اطراف را بدون محدودیت ببینید.', textAlign: TextAlign.center),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: _isProcessingPayment ? null : _makePayment,//_processPayment,simulation
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12)),
              child: _isProcessingPayment 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('فعالسازی آنی - ۵ یورو', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantItem(Restaurant restaurant, String detail) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(restaurant.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(detail, style: const TextStyle(color: Colors.blueGrey, fontSize: 12)),
            const SizedBox(height: 8),
            Text(restaurant.description, textDirection: TextDirection.rtl),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => _openDirections(restaurant),
              icon: const Icon(Icons.map),
              label: const Text('مسیریابی'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371;
    final dLat = (lat2 - lat1) * (pi / 180);
    final dLon = (lon2 - lon1) * (pi / 180);
    final a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1 * pi / 180) * cos(lat2 * pi / 180) * sin(dLon / 2) * sin(dLon / 2);
    return R * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  Future<void> _determinePosition() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    _showErrorMessage("Lotfan GPS goushi ro roshan konid.");
    return;
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      _showErrorMessage("Dastresi be makan dade nashod. Mitavanid shahr ro dasti entekhab konid.");
      return;
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    _showErrorMessage("Dastresi hamishegi radd shode. Lotfan az tanzimat faal konid.");
    return;
  }

  Position position = await Geolocator.getCurrentPosition();
  if (mounted) {
    setState(() => currentUserPosition = position);
  }
}

  void _startWeatherAlertSystem() {
    _alertTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      if (temperature < 8 && mounted) _showWeatherFlushbar();
    });
  }

  void _showWeatherFlushbar() {
    Flushbar(
      title: 'هشدار سردی هوا', 
      message: 'لطفاً لباس گرم بپوشید.', 
      duration: const Duration(seconds: 4)
    ).show(context);
  }

  Future<void> _openDirections(Restaurant restaurant) async {
    await _determinePosition();
    if (currentUserPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('لطفاً ابتدا موقعیت مکانی خود را فعال کنید.')),
      );
      return;
    }

    // در Flutter از پکیج url_launcher استفاده می‌کنیم
    // final String origin =
    //     '\${currentUserPosition!.latitude},\${currentUserPosition!.longitude}';
    final String origin = "${currentUserPosition!.latitude},${currentUserPosition!.longitude}";
    //final String destination = "$lat,$lon";
    String Name = restaurant.name_map;
    final String destination = Name;
    // final url = Uri.parse(
    //     'https://www.google.com/maps/dir/?api=1&origin=\$origin&destination=\$name');
    //final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=\$lat,\$lon');
    final String googleMapsUrl = "https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&travelmode=driving";
    final Uri url = Uri.parse(googleMapsUrl);
    try {
      // ⭐️ [FIXED]: حذف canLaunchUrl و اجرای مستقیم launchUrl
      // اگر launchUrl موفق نشود، یک خطا (استثنا) پرتاب می‌کند و به بلاک catch می‌رود.
      bool launched =
          await launchUrl(url, mode: LaunchMode.externalApplication);

      if (!launched) {
        // این بخش در صورت شکست launchUrl اجرا می‌شود.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('نمی‌توان URL را باز کرد')),
        );
      }
    } catch (e) {
      // مدیریت خطا در صورت بروز مشکل سیستمی یا عدم نصب اپلیکیشن
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا در باز کردن مسیر: \${e.toString()}')),
      );
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('راهنمای هوشمند سفر'),
      backgroundColor: const Color(0xff004d99),
      foregroundColor: Colors.white,
      actions: [
        // اصلاح نام آیکون و استفاده از kDebugMode
        if (kDebugMode)
          IconButton(
            icon: const Icon(Icons.restart_alt, color: Colors.orange), 
            onPressed: _resetPaymentStatusForTesting,
            tooltip: 'تست: ریست وضعیت پرداخت',
          ),
      ],
      bottom: TabBar(
        controller: _tabController,
        labelColor: Colors.white,
        tabs: const [Tab(text: '🍴 رستوران‌ها'),],// Tab(text: '🏛️ برنامه سفر')],
      ),
    ),
    body: Stack(
      children: [
        TabBarView(
          controller: _tabController,
          children: [
            RefreshIndicator(
              onRefresh: _checkTrialAndInit,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (kDebugMode)
                      Container(
                        width: double.infinity,
                        color: _hasPaid ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          _hasPaid ? "وضعیت: نسخه کامل (Paid)" : "وضعیت: نسخه آزمایشی (Trial)",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    _buildRestaurantsList(),
                  ],
                ),
              ),
            ),
            //const Center(child: Text('بخش برنامه سفر - به زودی')),
          ],
        ),
        if (_isProcessingPayment)
          Container(
            color: Colors.black54,
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 20),
                  Text('در حال برقراری ارتباط با گوگل‌پلی...',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
      ],
    ),
  );
} // <--- حتما دقت کنید این آکولا و آکولای مربوط به کلاس در انتها بسته شده باشند
Widget _buildLocationRequestCard() {
  return Card(
    margin: const EdgeInsets.all(16),
    color: Colors.blue.shade50,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Icon(Icons.location_searching, color: Color(0xff004d99), size: 40),
          const SizedBox(height: 10),
          const Text(
            "رستوران‌های نزدیک شما",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 5),
          const Text(
            "برای نمایش دقیق رستوران‌های اطرافتان و محاسبه فاصله، نیاز به دسترسی به مکان یاب داریم.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              _determinePosition(); // اجرای تابع قبلی خودتان
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff004d99)),
            child: const Text("اجازه دسترسی و جستجو", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ),
  );
}
}
