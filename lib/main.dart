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
import 'package:in_app_update/in_app_update.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// ایمپورت فایل منیجرهای شما (PurchaseManager, AppAdManager, AppTimelineManager)
import 'purchase_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await MobileAds.instance.initialize();
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
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Tahoma'),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _restaurantScrollController = ScrollController();
  bool _showScrollToTopButton = false;

  final String _currentVersion = "1.0.1"; // نسخه فعلی اپلیکیشن شما

  // --- متغیرهای وضعیت ---
  Position? currentUserPosition;
  bool _hasPaid = false;
  bool _isPurchased = false;
  double _fontScale = 1.0;
  List<String> _favoriteRestaurantIds = [];
  static const String _favoritesKey = 'favorite_restaurants';

  final String _weatherData = 'در حال دریافت اطلاعات آب و هوا...';
  double temperature = 7;
  Timer? _alertTimer;
  bool _isProcessingPayment = false;
  // شناسه محصولی که در کنسول گوگل‌‌پلی تعریف کردید
  final String _productId = 'premiumunlock1';

  //static const int _trialDays = 30; // مقدار دوره تست (مثلاً ۳۰ روز)
  int _trialDays = 30;
  int _remainingDays = 30;

  // شناسه محصولی که در کنسول گوگل پلی تعریف می‌کنید
  static const String _premiumId = 'premiumunlock1';
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  //late StreamSubscription<List<PurchaseDetails>> _subscription;

  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;

  // --- متغیرهای مربوط به کشور و شهر ---
  String _selectedCountry = "مکان‌یابی من";
  String _selectedCity = "اطراف من";

  // دسته‌بندی شهرها بر اساس کشور
  final Map<String, List<String>> _countryCityMap = {
    "مکان‌یابی من": ["اطراف من"],
    //"Rest World": ["Restworld"],
    "آلمان": [
      "برلین",
      "برمن",
      "دوسلدورف",
      "هامبورگ",
      "کلن",
      "مونیخ",
      "فرانکفورت",
      "هانوفر",
      "بون",
      "شهرهای دیگر آلمان",
    ], // "Hannover"
    "فرانسه": ["پاریس", "استراسبورگ", "نیس"],
    "ایتالیا": ["رم", "میلان"],
    "اسپانیا": ["بارسلونا", "مادرید", "مالاگا"],
    "ترکیه": ["استانبول", "آنکارا"],
    "کانادا": ["ونکوور", "تورنتو"],
    "آمریکا": ["نیویورک", "لوس‌آنجلس"],
    "استرالیا": ["سیدنی", "ملبورن"],
    "هلند": ["آمستردام"],
    "بلژیک": ["بروکسل"],
    "سوئیس": ["زوریخ"],
    "اتریش": ["وین"],
    "پرتغال": ["لیسبون", "پورتو"],
    "امارات": ["دبی"],
    "ژاپن": ["توکیو"],
    "یونان": ["آتن"],
    "سوئد": ["استکهلم"],
    "نروژ": ["اسلو"],
    "فنلاند": ["هلسینکی"],
    "لهستان": ["ورشو"],
    "چک": ["پراگ"],  
  };

  // مپ ترجمه نام‌های فارسی به نام‌های انگلیسی برای جستجو در دیتابیس رستوران‌ها
  final Map<String, String> _cityTranslationMap = {
    "اطراف من": "اطراف من",
    "Restworld": "Restworld",
    "برلین": "Berlin",
    "برمن": "Bremen",
    "دوسلدورف": "Dusseldorf",
    "هامبورگ": "Hamburg",
    "هانوفر": "Hannover",
    "کلن": "Koln",
    "مونیخ": "Munich",
    "فرانکفورت": "Frankfurt",
    "بون": "Bonn",
    "شهرهای دیگر آلمان": "DE Towns",
    "پاریس": "Paris",
    "استراسبورگ": "Strasbourg",
    "نیس": "Nice",
    "رم": "Rome",
    "میلان": "Milan",
    "بارسلونا": "Barcelona",
    "مادرید": "Madrid",
    "مالاگا": "Malaga",
    "استانبول": "Istanbul",
    "آنکارا": "Ankara",
    "ونکوور": "Vancouver",
    "تورنتو": "Toronto",
    "نیویورک": "New York",
    "لوس‌آنجلس": "Los Angeles",
    "سیدنی": "Sydney",
    "ملبورن": "Melbourne",
    "آمستردام": "Amsterdam",
    "بروکسل": "Brussels",
    "زوریخ": "Zurich",
    "وین": "Vienna",
    "لیسبون": "Lisbon",
    "پورتو": "Porto",
    "دبی": "Dubai",
    "توکیو": "Tokyo",
    "آتن": "Athens",
    "استکهلم": "Stockholm",
    "اسلو": "Oslo",
    "هلسینکی": "Helsinki",
    "ورشو": "Warsaw",
    "پراگ": "Prague",
  };

  @override
  void initState() {
    super.initState();

    // ۱. اولویت با مقداردهی اولیه است

    _loadFavoriteRestaurants();

    // ۲. سایر بخش‌ها
    _tabController = TabController(length: 1, vsync: this);
    _restaurantScrollController.addListener(_handleRestaurantScroll);

    _initTimelineAndPurchase();

    //_initializePurchase();//----------------
    //_checkTrialAndInit();//-----------------
  }

  Future<void> _initTimelineAndPurchase() async {
    await _checkForUpdates();
    
    // ۱. هماهنگی زمان‌بندی نصب کاربر
    await AppTimelineManager().initializeAndSync();

    // ۲. راه‌اندازی درگاه پرداخت جدید
    PurchaseManager().initialize(
      onError: (msg) => _showErrorMessage(msg),
      onSuccess: () => _showSuccessMessage('پرداخت با موفقیت انجام شد و نسخه کامل فعال گردید!'),
    );

    // ۳. گوش دادن به وضعیت پرداخت برای بروزرسانی UI
    PurchaseManager().isPremiumUser.addListener(() {
      if (mounted) setState(() {});
    });
    PurchaseManager().isProcessing.addListener(() {
      if (mounted) setState(() {});
    });

    // ۴. بارگذاری بنر تبلیغاتی بر اساس فاز زمانی
    _checkAndLoadBannerAd();

    // بروزرسانی اولیه صفحه
    if (mounted) setState(() {});
  }

  void _checkAndLoadBannerAd() {
    if (PurchaseManager().isPremiumUser.value) return;
    
    int daysUsed = AppTimelineManager().daysUsed;
    // طبق سناریو: از روز ۳ به بعد بنر نمایش داده شود
    if (daysUsed >= 3) {
      _bannerAd = BannerAd(
        adUnitId: AppAdManager().bannerUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (_) {
            setState(() {
              _isBannerLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            print('Banner Ad failed to load: $error');
            ad.dispose();
          },
        ),
      )..load();
    }
  }

  @override
  void dispose() {
    _restaurantScrollController.removeListener(_handleRestaurantScroll);
    _restaurantScrollController.dispose();
    //_subscription.cancel();
    _tabController.dispose();
    _alertTimer?.cancel();
    _bannerAd?.dispose();
    super.dispose();
  }


  Future<void> _checkForUpdates() async {
    final prefs = await SharedPreferences.getInstance();
    final String? lastCheckStr = prefs.getString('last_update_check');
    final DateTime now = DateTime.now();

    bool shouldCheck = false;
    if (lastCheckStr == null) {
      shouldCheck = true; // دفعه اول حتماً چک شود
    } else {
      final DateTime lastCheck = DateTime.parse(lastCheckStr);
      // اگر ۹۰ روز (۳ ماه) از آخرین چک گذشته باشد
      if (now.difference(lastCheck).inDays >= 90) {
        shouldCheck = true;
      }
    }

    // اگر هنوز ۳ ماه نشده است، نیازی به چک کردن فایربیس نیست و برنامه باز می‌شود
    if (!shouldCheck) return;

    try {
      // دریافت اطلاعات آپدیت از فایرستور
      final doc = await FirebaseFirestore.instance
          .collection('app_settings')
          .doc('config')
          .get();

      if (doc.exists && doc.data() != null) {
        final String latestVersion = doc.data()!['latest_version'] ?? "1.0.0";
        final String playStoreUrl = doc.data()!['play_store_url'] ?? "https://play.google.com/store/apps/details?id=YOUR_PACKAGE_NAME";

        // اگر نسخه دیتابیس با نسخه فعلی گوشی یکی نبود (نسخه جدید آمده است)
        if (latestVersion != _currentVersion) {
          _showUpdateDialog(playStoreUrl);
        } else {
          // اگر برنامه به‌روز بود، تاریخ امروز را به عنوان آخرین چک ذخیره کن تا ۳ ماه بعد
          await prefs.setString('last_update_check', now.toIso8601String());
        }
      }
    } catch (e) {
      print("خطا در بررسی به‌روزرسانی: $e");
    }
  }

  // نمایش دایالوگ مسدودکننده که اجازه خروج به کاربر نمی‌دهد
  void _showUpdateDialog(String playStoreUrl) {
    showDialog(
      context: context,
      barrierDismissible: false, // کاربر نمی‌تواند با کلیک روی بیرون صفحه دایالوگ را ببندد
      builder: (BuildContext context) {
        return PopScope(
          canPop: false, // دکمه بازگشت (Back) گوشی را کاملاً غیرفعال می‌کند
          child: AlertDialog(
            title: const Text(
              "به‌روزرسانی اجباری",
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            content: const Text(
              "نسخه جدیدی از اپلیکیشن منتشر شده است. برای ادامه استفاده از برنامه، لطفا آن را به‌روزرسانی کنید.",
              textAlign: TextAlign.right,
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff004d99),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  ),
                  onPressed: () async {
                    final Uri url = Uri.parse(playStoreUrl);
                    try {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    } catch (e) {
                      print("Could not launch $url");
                    }
                  },
                  child: const Text(
                    "به‌روزرسانی از گوگل پلی",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleRestaurantScroll() {
    final shouldShow = _restaurantScrollController.offset > 300;
    if (shouldShow != _showScrollToTopButton) {
      setState(() {
        _showScrollToTopButton = shouldShow;
      });
    }
  }

  void _scrollToTop() {
    _restaurantScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
 
  // Future<void> _initializePurchase() async {
  //   final bool available = await _inAppPurchase.isAvailable();
  //   if (!available) return;

  //   _subscription = _inAppPurchase.purchaseStream.listen(
  //     (List<PurchaseDetails> purchaseDetailsList) async {
  //       // اضافه شدن async
  //       for (var purchaseDetails in purchaseDetailsList) {
  //         if (purchaseDetails.status == PurchaseStatus.purchased ||
  //             purchaseDetails.status == PurchaseStatus.restored) {
  //           // ۱. اول ثبت در فایربیس (بسیار حیاتی)
  //           await _handleSuccessfulPayment();

  //           // ۲. بعد اعلام اتمام تراکنش به گوگل
  //           if (purchaseDetails.pendingCompletePurchase) {
  //             await _inAppPurchase.completePurchase(purchaseDetails);
  //           }

  //           setState(() {
  //             _isPurchased = true;
  //             _isProcessingPayment = false;
  //           });
  //         } else if (purchaseDetails.status == PurchaseStatus.error) {
  //           _showErrorMessage(
  //             "خطا در پرداخت: ${purchaseDetails.error?.message}",
  //           );
  //           setState(() => _isProcessingPayment = false);
  //         } else if (purchaseDetails.status == PurchaseStatus.canceled) {
  //           _showErrorMessage("پرداخت لغو شد.");
  //           setState(() => _isProcessingPayment = false);
  //         }
  //       }
  //     },
  //     onError: (error) {
  //       print("خطای استریم: $error");
  //       setState(() => _isProcessingPayment = false);
  //     },
  //   );
  // }



  Widget _buildCountryCitySelectors() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        children: [
          // ---------------- کمبوباکس اول: کشورها ----------------
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedCountry,
                  icon: const Icon(
                    Icons.public,
                    color: Color(0xff004d99),
                    size: 20,
                  ),
                  style: const TextStyle(
                    color: Color(0xff004d99),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    fontFamily: 'Tahoma',
                  ),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedCountry = newValue;
                        // ⭐️ با تغییر کشور، شهر پیش‌فرض به اولین شهر آن کشور تغییر می‌کند
                        _selectedCity = _countryCityMap[newValue]!.first;
                      });
                    }
                  },
                  items: _countryCityMap.keys.map<DropdownMenuItem<String>>((
                    String value,
                  ) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13 * _fontScale)),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          const SizedBox(width: 10), // فاصله بین دو کمبوباکس
          // ---------------- کمبوباکس دوم: شهرها ----------------
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedCity,
                  icon: const Icon(
                    Icons.location_city,
                    color: Colors.green,
                    size: 20,
                  ),
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    fontFamily: 'Tahoma',
                  ),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedCity = newValue;
                      });
                    }
                  },
                  // ⭐️ لیست شهرها بر اساس کشور انتخاب شده در کمبوباکس اول لود می‌شود
                  items: _countryCityMap[_selectedCountry]!
                      .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13 * _fontScale)),
                        );
                      })
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

 

  // تابع نمایش پیام روی گوشی
  void _showMessageBox(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(message)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("باشه"),
          ),
        ],
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

 

  // ۱. متد استاندارد دریافت شناسه یکتای سخت‌افزاری دستگاه
  Future<String?> _getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id; // شناسه یکتای دستگاه اندروید
      } else if (Platform.isIOS) {
        var iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor; // شناسه یکتای دستگاه آی‌اواس
      }
    } catch (e) {
      print("خطا در دریافت شناسه دستگاه: $e");
    }
    return null;
  }

  // ۲. متد اصلی مدیریت بازه تست، آپدیت اجباری و فایربیس در شروع برنامه
  Future<void> _checkTrialAndInit() async {
    // الف. اگر محیط وب (کروم) بود، مستقیم دسترسی پرمیوم بده و خارج شو
    if (kIsWeb) {
      setState(() {
        _hasPaid = true;
        _isPurchased = true;
        _remainingDays = 0;
      });
      return; 
    }

    // ب. بررسی اجباری بودن آپدیت اپلیکیشن (هر ۳ ماه یک‌بار) از فایربیس
    await _checkForUpdates(); 

    // ج. دریافت شناسه یکتای دستگاه از متد بالا
    String? deviceId = await _getDeviceId();
    if (deviceId == null) {
      // اگر آیدی دستگاه به هر دلیلی دریافت نشد، برای امنیت بیشتر دسترسی را ببند
      setState(() {
        _hasPaid = false;
        _remainingDays = 0;
      });
      return;
    }

    try {
      // د. دریافت تنظیمات کلی بازه تست (مثلا ۳۰ روز) از فایربیس
      var settingsDoc = await FirebaseFirestore.instance
          .collection('app_settings')
          .doc('global_config')
          .get();

      if (settingsDoc.exists && settingsDoc.data() != null) {
        setState(() {
          _trialDays = settingsDoc.data()!['trial_period'] ?? 30;
        });
      }

      // هـ. بررسی وضعیت کاربر در فایربیس براساس آیدی سخت‌افزاری دستگاه
      var userDoc = await FirebaseFirestore.instance
          .collection('trial_users')
          .doc(deviceId)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> userData = userDoc.data()!;
        bool paidStatus = userData['is_paid'] == true;

        if (paidStatus) {
          // کاربر قبلاً خرید انجام داده است
          setState(() {
            _hasPaid = true;
            _remainingDays = 0;
          });
        } else {
          // کاربر خرید نکرده، بررسی روزهای باقی‌مانده از تست
          if (userData.containsKey('first_launch')) {
            DateTime startDate = DateTime.parse(userData['first_launch']);
            int daysPassed = DateTime.now().difference(startDate).inDays;
            
            setState(() {
              _hasPaid = false;
              _remainingDays = (_trialDays - daysPassed) > 0
                  ? (_trialDays - daysPassed)
                  : 0;
            });
          } else {
            // اگر داکیومنت بود ولی تاریخ نداشت (جهت احتیاط)
            setState(() {
              _hasPaid = false;
              _remainingDays = 0;
            });
          }
        }
      } else {
        // و. کاربر کاملاً جدید است (ثبت در فایربیس و شروع دوره تست)
        await FirebaseFirestore.instance
            .collection('trial_users')
            .doc(deviceId)
            .set({
          'first_launch': DateTime.now().toIso8601String(),
          'is_paid': false,
        });
        
        setState(() {
          _hasPaid = false;
          _remainingDays = _trialDays;
        });
      }
    } catch (e) {
      print("Error in _checkTrialAndInit: $e");
      // در صورت بروز خطای اینترنت، برای امنیت برنامه دسترسی آفلاین را ببند
      setState(() {
        _hasPaid = false;
        _remainingDays = 0;
      });
    }
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
         SnackBar(
          content: Text(
            "وضعیت به 'پرداخت نشده' تغییر یافت. حالا دکمه خرید را تست کنید.", style: TextStyle(    
    fontSize: 12 * _fontScale,
  ),
          ),
        ),
      );
    }
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

  Future<void> _loadFavoriteRestaurants() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteRestaurantIds = prefs.getStringList(_favoritesKey) ?? [];
    });
  }

  Future<void> _saveFavoriteRestaurants() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, _favoriteRestaurantIds);
  }

  bool _isFavorite(Restaurant restaurant) {
    return _favoriteRestaurantIds.contains(restaurant.name_map);
  }

  void _toggleFavorite(Restaurant restaurant) async {
    final restaurantId = restaurant.name_map;
    setState(() {
      if (_favoriteRestaurantIds.contains(restaurantId)) {
        _favoriteRestaurantIds.remove(restaurantId);
      } else {
        _favoriteRestaurantIds.remove(restaurantId);
        _favoriteRestaurantIds.insert(0, restaurantId);
      }
    });
    await _saveFavoriteRestaurants();
    final message = _favoriteRestaurantIds.contains(restaurantId)
        ? 'رستوران به علاقه‌مندی‌ها اضافه شد.'
        : 'رستوران از علاقه‌مندی‌ها حذف شد.';
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message,style: TextStyle(   
    fontSize: 12 * _fontScale,
  ),)));
  }

  List<Restaurant> _sortRestaurantsByFavorites(List<Restaurant> restaurants) {
    final sorted = List<Restaurant>.from(restaurants);
    sorted.sort((a, b) {
      final aIndex = _favoriteRestaurantIds.indexOf(a.name_map);
      final bIndex = _favoriteRestaurantIds.indexOf(b.name_map);
      final aOrder = aIndex == -1 ? 999999 : aIndex;
      final bOrder = bIndex == -1 ? 999999 : bIndex;
      return aOrder.compareTo(bOrder);
    });
    return sorted;
  }

  Widget _buildRestaurantsList() {
    if (currentUserPosition == null && _selectedCity == "اطراف من") {
      return Column(
        children: [_buildCountryCitySelectors(), _buildLocationRequestCard()],
      );
    }

    // تهیه یک لیست کامل از تمام رستوران‌های موجود
    final allPossibleRestaurants = RESTAURANTS_DATA.values
        .expand((list) => list)
        .toList();

    List<Restaurant> filteredRestaurants;

    // ⭐️ تبدیل نام فارسی شهر به نام انگلیسی برای مطابقت با دیتابیس
    String internalCityName =
        _cityTranslationMap[_selectedCity] ?? _selectedCity;

    if (_selectedCity == "اطراف من") {
      // فیلتر بر اساس فاصله
      filteredRestaurants = allPossibleRestaurants.where((r) {
        if (currentUserPosition == null) return false;
        double dist = calculateDistance(
          currentUserPosition!.latitude,
          currentUserPosition!.longitude,
          r.lat,
          r.lon,
        );
        return dist <= 50;
      }).toList();
    } else if (internalCityName == "DE Towns") {
      // فراخوانی مستقیم رستوران‌های شهرهای دیگر آلمان
      filteredRestaurants = RESTAURANTS_DATA["DE Towns"] ?? [];
    } else if (internalCityName == "Restworld") {
      // فراخوانی مستقیم رستوران‌های جهانی
      filteredRestaurants = RESTAURANTS_DATA["Restworld"] ?? [];
    } else {
      // فیلتر دقیق بر اساس نام شهر در دیتابیس
      filteredRestaurants = allPossibleRestaurants.where((r) {
        return (r.city.toLowerCase() ?? "") == internalCityName.toLowerCase();
      }).toList();
    }

    filteredRestaurants = _sortRestaurantsByFavorites(filteredRestaurants);

   // --- ⭐️ جایگذاری کدهای جدید اینجاست ⭐️ ---
    // دریافت وضعیت لحظه‌ای کاربر مستقیماً از منیجرها
    bool isPremium = PurchaseManager().isPremiumUser.value;
    int daysUsed = AppTimelineManager().daysUsed;
    bool isFreeTierExpired = AppTimelineManager().isFreeTierExpired;

    // بررسی اشتراک برای نمایش لیست رستوران‌ها
    List<Restaurant> restaurantsToShow;
    if (isPremium) {
      // اگر کاربر خریدار است: نمایش کل لیست
      restaurantsToShow = filteredRestaurants;
    } else if (!isFreeTierExpired) {
      // اگر خریدار نیست اما هنوز زمان رایگانش (۹۰ روز) تمام نشده: نمایش فقط ۳ رستوران
      restaurantsToShow = filteredRestaurants.length > 3
          ? filteredRestaurants.sublist(0, 3)
          : filteredRestaurants;
    } else {
      // اگر زمان رایگان کاملاً تمام شده باشد: لیست خالی می‌شود تا مجبور به خرید شود
      restaurantsToShow = [];
    }
    // ------------------------------------------
    return Column(
      children: [
        _buildCountryCitySelectors(),

        if (!isPremium)
          _buildInfoBanner(
            //_remainingDays > 0
            daysUsed < 3
                ? "🎁 شما در فاز اولیه هستید . برای مشاهده همه رستوران‌ها ارتقا دهید."
            : "⚠️ تنها ۳ رستوران نمایش داده می‌شود. جهت حذف محدودیت و تبلیغات، اشتراک تهیه کنید.",
          ),

        if (filteredRestaurants.isEmpty)
           Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "رستورانی برای این شهر یافت نشد.",
              style: TextStyle(fontWeight: FontWeight.bold,
    fontSize: 16 * _fontScale,
  ),
            ),
          )
        else
          ...restaurantsToShow.map((r) {
            String detail = "";
            if (currentUserPosition != null) {
              final dist = calculateDistance(
                currentUserPosition!.latitude,
                currentUserPosition!.longitude,
                r.lat,
                r.lon,
              );
              detail = 'فاصله تقریبی: ${dist.toStringAsFixed(1)} کیلومتر';
            }
            return _buildRestaurantItem(r, detail);
          }),

        if (!isPremium) _buildPaymentPrompt(),
        const SizedBox(height: 50),
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
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style:  TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.orange,fontSize: 14 * _fontScale,
        ),
      ),
    );
  }

  Widget _buildPaymentPrompt() {
    bool isProcessing = PurchaseManager().isProcessing.value;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 20),
      color: const Color(0xfffff9c4),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.orange),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.stars, size: 40, color: Colors.orange),
            const SizedBox(height: 10),
             Text(
              'دسترسی به لیست کامل (Premium)',
              style: TextStyle(fontSize: 18* _fontScale, fontWeight: FontWeight.bold),
            ),
             Text(
              'با پرداخت ۵ یورو، تمامی رستوران‌های اطراف را بدون محدودیت ببینید.',
              textAlign: TextAlign.center, style: TextStyle(
    color: Colors.white, 
    fontSize: 12 * _fontScale,
  ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: isProcessing//_isProcessingPayment
                  ? null
                  : () => PurchaseManager().buyPremium(),//_makePayment, //_processPayment,simulation
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
              ),
              child: isProcessing//_isProcessingPayment
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  :  Text(
                      'فعالسازی آنی',
                      style: TextStyle(color: Colors.white,fontSize: 12 * _fontScale,),
        
                    ),
            ),
            
            TextButton(
              onPressed: isProcessing
                  ? null
                  : () => PurchaseManager().restorePurchases(),
              child:  Text(
                'قبلاً خرید کرده‌اید؟ بازیابی خرید',
                style: TextStyle(
                  color: Color(0xff004d99),
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  fontSize: 12 * _fontScale,
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantItem(Restaurant restaurant, String detail) {
    // شناسه افیلیت شما برای درآمدزایی (این مقدار را با شناسه واقعی خود جایگزین کنید)
    const String myAffiliateId = "YOUR_AFFILIATE_ID_HERE";

    // تابع کمکی برای بررسی معتبر بودن اطلاعات
    bool isValid(String? value) {
      if (value == null) return false;
      final cleanValue = value.trim().toLowerCase();
      return cleanValue.isNotEmpty &&
          cleanValue != 'n/a' &&
          cleanValue != 'null' &&
          cleanValue != '-';
    }

    // تابع عمومی برای باز کردن لینک‌ها و تماس تلفنی
    Future<void> launchUrlish(String urlString, {bool isPhone = false}) async {
      final Uri url = Uri.parse(urlString);
      try {
        if (await canLaunchUrl(url)) {
          await launchUrl(
            url,
            mode: isPhone
                ? LaunchMode.externalApplication
                : LaunchMode.platformDefault,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('امکان باز کردن این لینک وجود ندارد.'),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطا: ${e.toString()}')));
      }
    }

    // ویجت کمکی برای ردیف‌های اطلاعات تماس قابل کلیک (تلفن، سایت، آدرس)
    Widget buildContactRow(
      IconData icon,
      String text,
      Color iconColor,
      VoidCallback? onTap,
    ) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    text,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      fontSize: 13* _fontScale,
                      color: onTap != null
                          ? Colors.blue.shade800
                          : Colors.grey.shade800,
                      decoration: onTap != null
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(icon, size: 18, color: iconColor),
              ],
            ),
          ),
        ),
      );
    }

    bool hasContactInfo =
        isValid(restaurant.address) ||
        isValid(restaurant.phone) ||
        isValid(restaurant.website);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // ردیف اول: نام رستوران و امتیاز
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isValid(restaurant.rating))
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Row(
                      children: [
                        Text(
                          restaurant.rating!,
                          style: TextStyle(
                            color: Colors.amber.shade900,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                      ],
                    ),
                  )
                else
                  const SizedBox(),

                Expanded(
                  child: Text(
                    restaurant.name,
                    textAlign: TextAlign.right,
                    style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18 * _fontScale,
                      color: Color(0xff004d99),
                    ),
                  ),
                ),
                if (isValid(restaurant.phone))
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: IconButton(
                      onPressed: () => launchUrlish(
                        "tel:${restaurant.phone!.replaceAll(' ', '')}",
                        isPhone: true,
                      ),
                      icon: Icon(
                        Icons.call,
                        color: Colors.green.shade700,
                        size: 20,
                      ),
                      tooltip: 'تماس',
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.green.shade50,
                        side: BorderSide(color: Colors.green.shade200),
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => _toggleFavorite(restaurant),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _isFavorite(restaurant)
                          ? Colors.red.shade50
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      _isFavorite(restaurant)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: _isFavorite(restaurant)
                          ? Colors.red
                          : Colors.grey.shade700,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // ردیف دوم: شهر و فاصله تقریبی
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isValid(restaurant.city))
                  Text(
                    "${restaurant.city}  •  ",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                Text(
                  detail,
                  style:  TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 12 * _fontScale,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 0.5),

            // بخش توضیحات
            Text(
              restaurant.description,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 14 * _fontScale,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),

            // چیپ‌های اطلاعاتی (ساعت کار، قیمت، پارکینگ)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.end,
              children: [
                // if (isValid(restaurant.workingHours))
                //   _buildInfoChip(Icons.access_time_rounded, restaurant.workingHours!, Colors.blue.shade700, Colors.blue.shade50),
                if (isValid(restaurant.price))
                  _buildInfoChip(
                    Icons.euro_rounded,
                    restaurant.price!,
                    Colors.green.shade700,
                    Colors.green.shade50,
                  ),
                if (isValid(restaurant.parkingInfo))
                  _buildInfoChip(
                    Icons.local_parking_rounded,
                    restaurant.parkingInfo!,
                    Colors.orange.shade700,
                    Colors.orange.shade50,
                  ),
              ],
            ),

            // باکس اطلاعات تماس (با قابلیت کلیک روی سایت و شماره تلفن)
            if (hasContactInfo) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    // if (isValid(restaurant.address))
                    //   buildContactRow(Icons.location_on_outlined, restaurant.address!, Colors.red.shade400, null),
                    if (isValid(restaurant.phone))
                      buildContactRow(
                        Icons.phone_outlined,
                        restaurant.phone!,
                        Colors.teal.shade600,
                        () => launchUrlish(
                          "tel:${restaurant.phone!.replaceAll(' ', '')}",
                          isPhone: true,
                        ),
                      ),
                    if (isValid(restaurant.website))
                      buildContactRow(
                        Icons.language_outlined,
                        restaurant.website!,
                        Colors.indigo.shade500,
                        () => launchUrlish(restaurant.website!),
                      ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            const SizedBox(height: 12),

            // دکمه مسیریابی: کاربر بین Apple Maps و Google Maps انتخاب می‌کند
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openDirections(restaurant),
                icon: const Icon(Icons.directions, color: Colors.white),
                label:  Text(
                  'مسیریابی (Directions)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 14 * _fontScale,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ⭐️ ویجت اختصاصی برای ساخت کپسول‌های اطلاعاتی کوچک (Chips)
  Widget _buildInfoChip(
    IconData icon,
    String text,
    Color textColor,
    Color bgColor,
  ) {
    return Container(
      // ۱. محدود کردن حداکثر عرض چیپ برای جلوگیری از اورفلو در صفحات کوچک
      constraints: const BoxConstraints(maxWidth: 200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ۲. قرار دادن متن داخل Flexible تا بتونه خودش رو با فضای موجود وفق بده
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 12* _fontScale,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow
                  .ellipsis, // ۳. سه نقطه گذاشتن در صورت طولانی شدن متن
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 6),
          Icon(icon, color: textColor, size: 16),
        ],
      ),
    );
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371;
    final dLat = (lat2 - lat1) * (pi / 180);
    final dLon = (lon2 - lon1) * (pi / 180);
    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLon / 2) *
            sin(dLon / 2);
    return R * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  // Evaluate working hours string and determine state relative to now.
  // Returns a map with keys: valid (bool), closed (bool), minutesUntilClose (int? nullable)
  Map<String, dynamic> _evaluateWorkingHours(String? workingHours) {
    if (workingHours == null)
      return {'valid': false, 'closed': false, 'minutesUntilClose': null};
    final now = DateTime.now();

    // Pattern 1: "Closes 9:30 pm" (case-insensitive)
    final closesRegex = RegExp(
      r'Closes\s+(\d{1,2})(?::(\d{2}))?\s*(am|pm)?',
      caseSensitive: false,
    );
    final m1 = closesRegex.firstMatch(workingHours);
    if (m1 != null) {
      try {
        int hour = int.parse(m1.group(1)!);
        int minute = m1.group(2) != null ? int.parse(m1.group(2)!) : 0;
        final ampm = m1.group(3);
        if (ampm != null) {
          final lower = ampm.toLowerCase();
          if (lower == 'pm' && hour < 12) hour += 12;
          if (lower == 'am' && hour == 12) hour = 0;
        }
        final closeTime = DateTime(now.year, now.month, now.day, hour, minute);
        final diff = closeTime.difference(now).inMinutes;
        if (diff <= 0)
          return {'valid': true, 'closed': true, 'minutesUntilClose': null};
        return {'valid': true, 'closed': false, 'minutesUntilClose': diff};
      } catch (e) {
        return {'valid': false, 'closed': false, 'minutesUntilClose': null};
      }
    }

    // Pattern 2: "11-22" (open-close in 24h, e.g., 11-22)
    final rangeRegex = RegExp(
      r'^(\d{1,2})(?::(\d{2}))?\s*-\s*(\d{1,2})(?::(\d{2}))?\s*\$',
    );
    final m2 = rangeRegex.firstMatch(workingHours.trim());
    if (m2 != null) {
      try {
        final openH = int.parse(m2.group(1)!);
        final openM = m2.group(2) != null ? int.parse(m2.group(2)!) : 0;
        var closeH = int.parse(m2.group(3)!);
        final closeM = m2.group(4) != null ? int.parse(m2.group(4)!) : 0;

        // If close hour <= open hour, assume close is next day
        var closeTime = DateTime(now.year, now.month, now.day, closeH, closeM);
        final openTime = DateTime(now.year, now.month, now.day, openH, openM);
        if (closeTime.isBefore(openTime) ||
            closeTime.isAtSameMomentAs(openTime)) {
          closeTime = closeTime.add(const Duration(days: 1));
        }

        if (now.isBefore(openTime)) {
          // not open yet -> consider closed
          return {'valid': true, 'closed': true, 'minutesUntilClose': null};
        }

        if (now.isAfter(closeTime)) {
          return {'valid': true, 'closed': true, 'minutesUntilClose': null};
        }

        final diff = closeTime.difference(now).inMinutes;
        return {'valid': true, 'closed': false, 'minutesUntilClose': diff};
      } catch (e) {
        return {'valid': false, 'closed': false, 'minutesUntilClose': null};
      }
    }

    // Unsupported/invalid formats (e.g., "Closed - Opens 11 am Thu")
    return {'valid': false, 'closed': false, 'minutesUntilClose': null};
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
        _showErrorMessage(
          "Dastresi be makan dade nashod. Mitavanid shahr ro dasti entekhab konid.",
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showErrorMessage(
        "Dastresi hamishegi radd shode. Lotfan az tanzimat faal konid.",
      );
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
      duration: const Duration(seconds: 4),
    ).show(context);
  }

  Future<void> _launchExternalUrl(Uri primary, Uri fallback) async {
    try {
      if (await canLaunchUrl(primary)) {
        final launched = await launchUrl(
          primary,
          mode: LaunchMode.externalApplication,
        );
        if (launched) return;
      }
    } catch (_) {}

    try {
      await launchUrl(fallback, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'خطا در باز کردن مسیر: ${e.toString()}',
            style: TextStyle(fontSize: 12 * _fontScale),
          ),
        ),
      );
    }
  }

  Future<void> _openAppleMaps({
    required String origin,
    required double destLat,
    required double destLng,
  }) async {
    // Native Maps scheme opens Apple Maps on iPhone.
    final native = Uri.parse(
      'maps://?saddr=$origin&daddr=$destLat,$destLng&dirflg=d',
    );
    // HTTPS always resolves to Apple Maps on iOS.
    final https = Uri.parse(
      'https://maps.apple.com/?saddr=$origin&daddr=$destLat,$destLng&dirflg=d',
    );
    await _launchExternalUrl(native, https);
  }

  Future<void> _openGoogleMaps({
    required String origin,
    required double destLat,
    required double destLng,
  }) async {
    final native = Uri.parse(
      'comgooglemaps://?saddr=$origin&daddr=$destLat,$destLng&directionsmode=driving',
    );
    final https = Uri.https('www.google.com', '/maps/dir/', {
      'api': '1',
      'origin': origin,
      'destination': '$destLat,$destLng',
      'travelmode': 'driving',
    });
    await _launchExternalUrl(native, https);
  }

  void _showNavigateWithSheet({
    required String origin,
    required double destLat,
    required double destLng,
    required String destinationName,
  }) {
    void launchWithAds(Future<void> Function() open) {
      void run() async {
        await open();
      }

      // شرط فاز ۳ (روز ۳۰ تا ۶۰ برای کاربر رایگان)
      if (!PurchaseManager().isPremiumUser.value &&
          AppTimelineManager().daysUsed >= 30 &&
          AppTimelineManager().daysUsed < 60) {
        AppAdManager().showNavigationRewardedAd(() => run());
      } else {
        run();
      }
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Navigate with',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18 * _fontScale,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'مسیریابی با',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14 * _fontScale,
                  ),
                ),
                if (destinationName.trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    destinationName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12 * _fontScale,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    child: Icon(
                      Icons.map_outlined,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  title: const Text(
                    'Apple Maps',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text('نقشه اپل'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    launchWithAds(
                      () => _openAppleMaps(
                        origin: origin,
                        destLat: destLat,
                        destLng: destLng,
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.shade50,
                    child: Icon(
                      Icons.public,
                      color: Colors.green.shade700,
                    ),
                  ),
                  title: const Text(
                    'Google Maps',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text('نقشه گوگل'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    launchWithAds(
                      () => _openGoogleMaps(
                        origin: origin,
                        destLat: destLat,
                        destLng: destLng,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openDirections(Restaurant restaurant) async {
    await _determinePosition();
    if (currentUserPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text('لطفاً ابتدا موقعیت مکانی خود را فعال کنید.',style: TextStyle(
    fontSize: 12 * _fontScale,
  ),),
        ),
      );
      return;
    }

    // Evaluate working hours first.
    final wh = _evaluateWorkingHours(restaurant.workingHours);

    // If format indicates closed, block navigation and inform user briefly.
    if (wh['valid'] == true && wh['closed'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('این رستوران در حال حاضر بسته است.')),
      );
      return;
    }

    final String origin =
        "${currentUserPosition!.latitude},${currentUserPosition!.longitude}";
    final String destinationName = "${restaurant.name_map}, ${restaurant.city}";

    void openMapChooser() {
      _showNavigateWithSheet(
        origin: origin,
        destLat: restaurant.lat,
        destLng: restaurant.lon,
        destinationName: destinationName,
      );
    }

    // If working hours format is invalid or missing, proceed silently.
    if (wh['valid'] != true) {
      openMapChooser();
      return;
    }

    final minutes = wh['minutesUntilClose'] as int?;
    if (minutes != null && minutes > 0 && minutes <= 60) {
      // show blocking dialog for a short moment
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('توجه'),
          content: Text('این رستوران ظرف ${minutes} دقیقه بسته می‌شود.',style: TextStyle(

    fontSize: 12 * _fontScale,
  ),),
        ),
      );

      // wait briefly then pop and open map chooser
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) Navigator.of(context).pop();

      openMapChooser();
      return;
    }

    // Default: let the user pick Apple Maps or Google Maps
    openMapChooser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('راهنمای رستوران‌ وطنی'),
        backgroundColor: const Color(0xff004d99),
        foregroundColor: Colors.white,
        actions: [
          // دکمه جدید برای ثبت رستوران
          IconButton(
            icon: const Icon(Icons.add_business_outlined, color: Colors.white),
            tooltip: 'ثبت رستوران جدید',
            onPressed: _showAddRestaurantDialog,
          ),
           IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: () {
              setState(() {
                if (_fontScale < 1.5) _fontScale += 0.1;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out),
            onPressed: () {
              setState(() {
                if (_fontScale > 0.8) _fontScale -= 0.1;
              });
            },
          ),
          // اگر دکمه‌های تست دیگری دارید، می‌توانید زیر این خط قرار دهید
          IconButton(
            icon: const Icon(Icons.support_agent_outlined, color: Colors.white),
            tooltip: 'پشتیبانی و پیشنهادات',
            onPressed: _showSupportDialog,
          ),
        ],

        
       
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          tabs: const [
            Tab(text: '🍴 رستوران‌ها'),
          ], // Tab(text: '🏛️ برنامه سفر')],
        ),
      ),
     body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    RefreshIndicator(
                      onRefresh: _initTimelineAndPurchase,
                      child: SingleChildScrollView(
                        controller: _restaurantScrollController,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // نمایش وضعیت پولی/رایگان دیباگ به صورت واکنش‌گرا
                            if (kDebugMode)
                              ValueListenableBuilder<bool>(
                                valueListenable: PurchaseManager().isPremiumUser,
                                builder: (context, isPremium, child) {
                                  return Container(
                                    width: double.infinity,
                                    color: isPremium
                                        ? Colors.green.withOpacity(0.2)
                                        : Colors.red.withOpacity(0.2),
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      isPremium
                                          ? "وضعیت: نسخه کامل (Paid)"
                                          : "وضعیت: نسخه آزمایشی (Trial)",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12 * _fontScale),
                                    ),
                                  );
                                },
                              ),
                            _buildRestaurantsList(),
                          ],
                        ),
                      ),
                    ),
                    // const Center(child: Text('بخش برنامه سفر - به زودی')),
                  ],
                ),
              ),
              // نمایش بنر تبلیغاتی در پایین صفحه (اگر لود شده باشد و کاربر رایگان باشد)
              if (_isBannerLoaded && _bannerAd != null)
                Container(
                  alignment: Alignment.center,
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
            ],
          ),
          
          // لایه لودینگ پرداخت (کاملاً متصل به وضعیت خرید سراسری)
          ValueListenableBuilder<bool>(
            valueListenable: PurchaseManager().isProcessing,
            builder: (context, isProcessing, child) {
              if (!isProcessing) return const SizedBox.shrink();
              return Container(
                color: Colors.black54,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 20),
                      Text(
                        'در حال برقراری ارتباط با گوگل‌پلی...',
                        style: TextStyle(color: Colors.white, fontSize: 12 * _fontScale),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      
      // دکمه بازگشت به بالا با پدینگ هوشمند (که روی تبلیغ بنری نیفتد)
      floatingActionButton: _showScrollToTopButton
          ? Padding(
              padding: EdgeInsets.only(bottom: _isBannerLoaded ? 60.0 : 0.0),
              child: FloatingActionButton(
                onPressed: _scrollToTop,
                backgroundColor: const Color(0xff004d99),
                child: const Icon(Icons.arrow_upward, color: Colors.white),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  } // پایان متد build


  // ۱. متد نمایش پنجره فرم ثبت رستوران جدید
  void _showAddRestaurantDialog() {
    final formKey = GlobalKey<FormState>();
    
    // مقداردهی اولیه شهر با آخرین شهر انتخابی کاربر در صفحه اصلی (اگر روی "اطراف من" نباشد)
    final cityController = TextEditingController(
      text: _selectedCity == "اطراف من" ? "" : _selectedCity,
    );
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    //final emailController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false, // کاربر باید حتماً فرم را پر کند یا انصراف بزند
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title:  Row(
            textDirection: TextDirection.rtl,
            children: [
              Icon(Icons.add_business, color: Color(0xff004d99)),
              SizedBox(width: 8),
              Text(
                "ثبت رستوران یا کافه جدید",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16 * _fontScale,
                 
                  fontFamily: 'Tahoma',
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // جعبه پیام راهنما درباره تایید ادمین
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 253, 253, 252),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child:  Text(
                      "⚠️ توجه: درخواست شما از طریق ایمیل ارسال می‌شود. رستوران جدید پس از بررسی و تایید نهایی توسط ادمین و تماس با شما، به لیست سراسری اپلیکیشن اضافه خواهد شد.",
                      style: TextStyle(
                        fontSize: 12 * _fontScale,
                        color: const Color.fromARGB(255, 2, 2, 2),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tahoma',
                      ),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  // فیلد شهر
                  TextFormField(
                    controller: cityController,
                    decoration: const InputDecoration(
                      labelText: "شهر مورد نظر",
                      prefixIcon: Icon(Icons.location_city, color: Colors.green),
                      border: OutlineInputBorder(),
                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "لطفاً شهر را وارد کنید";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // فیلد نام رستوران یا کافه
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "نام رستوران یا کافه",
                      prefixIcon: Icon(Icons.restaurant, color: Color(0xff004d99)),
                      border: OutlineInputBorder(),
                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "لطفاً نام رستوران یا کافه را وارد کنید";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // فیلد آدرس دقیق
                  TextFormField(
                    controller: addressController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: "آدرس دقیق",
                      prefixIcon: Icon(Icons.map, color: Colors.grey),
                      border: OutlineInputBorder(),
                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "لطفاً آدرس دقیق را وارد کنید";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                 
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("انصراف", style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff004d99),
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final cityName = cityController.text.trim();
                  final restName = nameController.text.trim();
                  final address = addressController.text.trim();
                  //final email = emailController.text.trim();

                  // بستن دیالوگ فرم
                  Navigator.pop(context);

                  // اجرای متد ارسال ایمیل
                  await _sendRestaurantProposal(
                    cityName: cityName,
                    restaurantName: restName,
                    address: address,
                    //userEmail: email,
                  );
                }
              },
              child: Text("ارسال درخواست", style: TextStyle(color: Colors.white,fontSize: 12 * _fontScale)),
            ),
          ],
        );
      },
    );
  }

  // متد نمایش پیام به کاربر برای پشتیبانی
  void _showSupportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Row(
            textDirection: TextDirection.rtl,
            children: [
              Icon(Icons.support_agent, color: Color(0xff004d99)),
              SizedBox(width: 8),
              Text(
                "پشتیبانی و پیشنهادات",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Tahoma',
                ),
              ),
            ],
          ),
          content: const Text(
            "شما می‌توانید مشکلات یا پیشنهادات خود را در مورد اپلیکیشن مستقیماً به ایمیل support.resfinder@gmail.com ارسال کنید. آیا مایل به باز کردن برنامه ایمیل هستید؟",
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: TextStyle(fontFamily: 'Tahoma', fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("انصراف", style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff004d99),
              ),
              onPressed: () {
                Navigator.pop(context); // بستن دیالوگ
                _sendSupportEmail(); // باز کردن ایمیل
              },
              child: Text("ارسال ایمیل", style: TextStyle(color: Colors.white, fontSize: 12 * _fontScale,)),
            ),
          ],
        );
      },
    );
  }

    String? _encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

  // متد باز کردن برنامه ایمیل کاربر با متن پیش‌فرض
  Future<void> _sendSupportEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support.resfinder@gmail.com',
      query: _encodeQueryParameters({
        'subject': 'پیشنهاد یا گزارش مشکل در اپلیکیشن',
        'body': 'سلام تیم پشتیبانی،\n\nمن پیشنهاد یا مشکلی درباره اپلیکیشن داشتم که در زیر مطرح می‌کنم:\n\n',
      }),
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        _showErrorMessage('امکان باز کردن مستقیم برنامه ایمیل وجود ندارد. لطفاً به صورت دستی به ایمیل ما پیام دهید.');
      }
    } catch (e) {
      _showErrorMessage('خطایی در اجرای برنامه ایمیل رخ داد: $e');
    }
  }

  // ۲. متد تولید و ارسال خودکار اطلاعات به ایمیل شما با استفاده از url_launcher
  Future<void> _sendRestaurantProposal({
    required String cityName,
    required String restaurantName,
    required String address,
    //required String userEmail,
  }) async {
    // ساخت آدرس ایمیل با قالب استاندارد mailto
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'newrestaurant.resfinder@gmail.com',
      queryParameters: {
        'subject': 'درخواست ثبت رستوران جدید: $restaurantName',
        'body': 'سلام ،\n\nیک درخواست جدید برای ثبت رستوران/کافه در اپلیکیشن ارسال شده است:\n\n'
            '📍 شهر مورد نظر: $cityName\n'
            '🍴 نام رستوران یا کافه: $restaurantName\n'
            '🗺️ آدرس دقیق: $address\n'
           // '📧 ایمیل کاربر متقاضی: $userEmail\n\n'
            'این اطلاعات از طرف اپلیکیشن ارسال شده است. لطفاً پس از تایید و هماهنگی با فرستنده، آن را به دیتابیس اضافه کنید.',
      },
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
        _showSuccessMessage('برنامه ایمیل شما باز شد. لطفاً دکمه ارسال (Send) را بزنید تا درخواست فرستاده شود.');
      } else {
        _showErrorMessage('امکان باز کردن مستقیم برنامه ایمیل وجود ندارد. لطفاً مشخصات را به آدرس newrestaurant.resfinder@gmail.com ایمیل کنید.');
      }
    } catch (e) {
      _showErrorMessage('خطایی در اجرای برنامه ایمیل رخ داد: $e');
    }
  }

  Widget _buildLocationRequestCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(
              Icons.location_searching,
              color: Color(0xff004d99),
              size: 40,
            ),
            const SizedBox(height: 10),
            Text(
              "رستوران‌های نزدیک شما",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16 * _fontScale),
            ),
            const SizedBox(height: 5),
            Text(
              "برای نمایش دقیق رستوران‌های اطرافتان و محاسبه فاصله، نیاز به دسترسی به مکان یاب داریم.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13 * _fontScale),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                _determinePosition(); // اجرای تابع قبلی خودتان
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff004d99),
              ),
              child: Text(
                "اجازه دسترسی و جستجو",
                style: TextStyle(color: Colors.white, fontSize: 12 * _fontScale),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
