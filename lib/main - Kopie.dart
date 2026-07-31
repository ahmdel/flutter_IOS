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
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //stripe.Stripe.publishableKey = "pk_live_51SlnYX84wisLROHGR7thbisdDONC1SU0UmlZCvgKMBD7mL6qR9E0kKUQCbyMO8cKPiYUvfTpiCHZ9GxGbSuTHSAH00U7IPERlh";
 
  if (!kIsWeb) {
     stripe.Stripe.publishableKey = "pk_live_51SlnYX84wisLROHGR7thbisdDONC1SU0UmlZCvgKMBD7mL6qR9E0kKUQCbyMO8cKPiYUvfTpiCHZ9GxGbSuTHSAH00U7IPERlh";
      // در اندروید و آی‌اواس، بهتر است این متد هم فراخوانی شود
      try {
      await stripe.Stripe.instance.applySettings();
    } catch (e) {
      print("Stripe error: \$e");
    }
    }
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
  int _remainingDays = 1;
  final String _weatherData = 'در حال دریافت اطلاعات آب و هوا...';
  double temperature = 7;
  Timer? _alertTimer;
  bool _isProcessingPayment = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _checkTrialAndInit();
  }
  
// متد اصلی پرداخت

Future<void> _makePayment() async {
  setState(() => _isProcessingPayment = true); // شروع لودینگ
  try {
    final paymentIntentData = await _createPaymentIntent('500', 'EUR');

    await stripe.Stripe.instance.initPaymentSheet(
      paymentSheetParameters: stripe.SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentData['client_secret'],
        merchantDisplayName: 'Hanover Tour Guide',
        style: ThemeMode.light,
      ),
    );

    await _displayPaymentSheet();

  } catch (e) {
    print("خطا در فرآیند پرداخت: \$e");
    _showErrorMessage("خطا در اتصال به درگاه.: \$e");
  } finally {
    if (mounted) setState(() => _isProcessingPayment = false); // پایان لودینگ
  }
}

// Future<void> _makePayment() async {
//   try {
//     // ۱. ایجاد درخواست پرداخت
//     final paymentIntentData = await _createPaymentIntent('500', 'EUR');

//     // ۲. مقداردهی اولیه (استفاده از stripe. برای رفع خطای getter)
//     await stripe.Stripe.instance.initPaymentSheet(
//       paymentSheetParameters: stripe.SetupPaymentSheetParameters(
//         paymentIntentClientSecret: paymentIntentData['client_secret'],
//         merchantDisplayName: 'Hanover Tour Guide',
//         style: ThemeMode.light,
//       ),
//     );

//     // ۳. نمایش صفحه پرداخت
//     await _displayPaymentSheet();

//   } catch (e) {
//     print("خطا در فرآیند پرداخت: \$e");
//   }
// }

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

Future<void> _displayPaymentSheet() async {
  try {
    await stripe.Stripe.instance.presentPaymentSheet();
    
    // ذخیره وضعیت پرداخت در حافظه گوشی
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_paid', true);

    setState(() {
      _hasPaid = true; // تغییر نام متغیر به متغیری که در کد شما تعریف شده
      _remainingDays = 0;
    });
    
    _showSuccessMessage('پرداخت با موفقیت انجام شد و نسخه کامل فعال گردید!');
    
  } catch (e) {
    // اصلاح خطای StripeException
    if (e is stripe.StripeException) {
      print("خطای استرایپ: \${e.error.localizedMessage}");
    } else {
      print("خطای ناشناخته: \$e");
    }
  }
}

// تابع ایجاد Payment Intent
Future<Map<String, dynamic>> _createPaymentIntent(String amount, String currency) async {
  try {
    Map<String, dynamic> body = {
      'amount': amount,
      'currency': currency,
      'payment_method_types[]': 'card'
    };

    var response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: {
        'Authorization': 'Bearer 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', // کلید تستی خود را اینجا بگذارید
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: body,
    );
 if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      // اگر خطا داد، متن دقیق خطا را از بدنه پاسخ استخراج می‌کنیم
      final errorResult = jsonDecode(response.body);
      throw errorResult['error']['message'] ?? 'خطای ناشناخته از سمت استرایپ';
    }
  } catch (err) {
    print('error charging user: \${err.toString()}');
    throw Exception(err);
  }
}

  // چک کردن وضعیت ۲ روز رایگان و لود کردن اطلاعات
  Future<void> _checkTrialAndInit() async {
    final prefs = await SharedPreferences.getInstance();
    
    // ۱. بررسی وضعیت پرداخت
    _hasPaid = prefs.getBool('is_paid') ?? false;

    if (!_hasPaid) {
      // ۲. بررسی زمان نصب برای کاربر غیر پرمیوم
      DateTime now = DateTime.now();
      String? firstLaunch = prefs.getString('first_launch');

      if (firstLaunch == null) {
        await prefs.setString('first_launch', now.toIso8601String());
        _remainingDays = 1;
      } else {
        DateTime startDate = DateTime.parse(firstLaunch);
        int diff = now.difference(startDate).inDays;
        _remainingDays = (1 - diff) > 0 ? (1 - diff) : 0;
      }
    } else {
      _remainingDays = 0;
    }
    
    _determinePosition();
    _startWeatherAlertSystem();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
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

  // --- رندرینگ لیست با منطق جدید شما ---
  Widget _buildRestaurantsList() {
    if (currentUserPosition == null) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(20.0),
        child: CircularProgressIndicator(),
      ));
    }

    // فیلتر کردن رستوران‌های نزدیک (مثلاً شعاع ۵۰ کیلومتر)
    List<Restaurant> nearbyRestaurants = RESTAURANTS_DATA.where((r) {
      return calculateDistance(currentUserPosition!.latitude, currentUserPosition!.longitude, r.lat, r.lon) <= 50;
    }).toList();

    List<Restaurant> restaurantsToShow;
    
    if (_hasPaid) {
      // اگر پول داده، همه را ببین
      restaurantsToShow = nearbyRestaurants;
    } else if (_remainingDays > 0) {
      // اگر هنوز در ۲ روز تست است، فقط ۳ مورد آخر را ببیند
      restaurantsToShow = nearbyRestaurants.length > 3 
          ? nearbyRestaurants.sublist(nearbyRestaurants.length - 3) 
          : nearbyRestaurants;
    } else {
      // اگر ۲ روز تمام شده و پول نداده، هیچی نبیند
      restaurantsToShow = [];
    }

    return Column(
      children: [
        if (!_hasPaid)
          _buildInfoBanner(
            _remainingDays > 0 
            ? "🎁 دوره تست (۲ روزه): فقط ۳ رستوران نمایش داده می‌شود. (\$_remainingDays روز باقی‌مانده)"
            : "⚠️ مهلت تست شما تمام شده است. برای مشاهده لیست، اشتراک تهیه کنید."
          ),

        ...restaurantsToShow.map((r) {
          final dist = calculateDistance(currentUserPosition!.latitude, currentUserPosition!.longitude, r.lat, r.lon);
          return _buildRestaurantItem(r, 'فاصله: \${dist.toStringAsFixed(1)} کیلومتر');
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
              onPressed: () => _openDirections(restaurant.name, restaurant.lat, restaurant.lon),
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
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
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

  Future<void> _openDirections(String name, double lat, double lon) async {
    final url = Uri.parse("https://www.google.com/maps/search/?api=1&query=\$lat,\$lon");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('راهنمای هوشمند سفر'),
        backgroundColor: const Color(0xff004d99),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: '🍴 رستوران‌ها'), Tab(text: '🏛️ برنامه سفر')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(padding: const EdgeInsets.all(16), child: _buildRestaurantsList()),
          const Center(child: Text('بخش برنامه سفر - به زودی')),
        ],
      ),
    );
  }
}