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

  // --- متغیرهای وضعیت ---
  Position? currentUserPosition;
  bool _hasPaid = false;
  bool _isPurchased = false;
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
  late StreamSubscription<List<PurchaseDetails>> _subscription;

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
    _initializePurchase();
    _checkTrialAndInit();
  }

  @override
  void dispose() {
    _restaurantScrollController.removeListener(_handleRestaurantScroll);
    _restaurantScrollController.dispose();
    _subscription.cancel();
    _tabController.dispose();
    _alertTimer?.cancel();
    super.dispose();
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
  Future<void> _initializePurchase() async {
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) return;

    _subscription = _inAppPurchase.purchaseStream.listen(
      (List<PurchaseDetails> purchaseDetailsList) async {
        // اضافه شدن async
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
            _showErrorMessage(
              "خطا در پرداخت: ${purchaseDetails.error?.message}",
            );
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

  // Widget _buildCitySelector() {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Row(
  //       children: _allCities.map((city) {
  //         final isSelected = _selectedCity == city;
  //         return Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 4.0),
  //           child: ChoiceChip(
  //             label: Text(city),
  //             selected: isSelected,
  //             onSelected: (selected) {
  //               setState(() => _selectedCity = city);
  //             },
  //           ),
  //         );
  //       }).toList(),
  //     ),
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
                      child: Text(value, overflow: TextOverflow.ellipsis),
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
                          child: Text(value, overflow: TextOverflow.ellipsis),
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
    final ProductDetailsResponse response = await _inAppPurchase
        .queryProductDetails(kIds);

    if (response.productDetails.isEmpty) {
      // اصلاح پیام برای عیب‌یابی دقیق‌تر
      _showErrorMessage(
        "محصول یافت نشد. شناسه‌ای که کد جستجو کرد: $_premiumId",
      );
      print(
        "Not found IDs: ${response.notFoundIDs}",
      ); // این را در ترمینال چک کنید
      setState(() => _isProcessingPayment = false);
      return;
    }

    final ProductDetails productDetails = response.productDetails.first;
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: productDetails,
    );

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
    final ProductDetailsResponse response = await _inAppPurchase
        .queryProductDetails(kIds);

    if (response.productDetails.isNotEmpty) {
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: response.productDetails.first,
      );
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

  Future<void> _checkTrialAndInit() async {
    if (kIsWeb) {
      setState(() {
        _hasPaid = true;
        _isPurchased = true;
        _remainingDays = 0;
      });
      // _startWeatherAlertSystem(); // فعال‌سازی سیستم آب و هوا
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
        var userDoc = await FirebaseFirestore.instance
            .collection('trial_users')
            .doc(deviceId)
            .get();

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
                _remainingDays = (_trialDays - daysPassed) > 0
                    ? (_trialDays - daysPassed)
                    : 0;
              });
            }
          }
        } else {
          // کاربر جدید
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
      }
    } catch (e) {
      print("Error in _checkTrialAndInit: $e");
      setState(() {
        _hasPaid = false;
        _remainingDays = 0;
      });
    }
    // _startWeatherAlertSystem();
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
        const SnackBar(
          content: Text(
            "وضعیت به 'پرداخت نشده' تغییر یافت. حالا دکمه خرید را تست کنید.",
          ),
        ),
      );
    }
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
    ).showSnackBar(SnackBar(content: Text(message)));
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

    // بررسی اشتراک
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
        _buildCountryCitySelectors(),

        if (!_hasPaid)
          _buildInfoBanner(
            _remainingDays > 0
                ? "🎁 دوره تست ($_trialDays روزه): فقط ۳ رستوران نمایش داده می‌شود. ($_remainingDays روز باقی‌مانده)"
                : "⚠️ مهلت تست $_trialDays روزه شما تمام شده است. برای مشاهده لیست، اشتراک تهیه کنید.",
          ),

        if (filteredRestaurants.isEmpty)
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "رستورانی برای این شهر یافت نشد.",
              style: TextStyle(fontWeight: FontWeight.bold),
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
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
      ),
    );
  }

  Widget _buildPaymentPrompt() {
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
            const Text(
              'دسترسی به لیست کامل (Premium)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'با پرداخت ۵ یورو، تمامی رستوران‌های اطراف را بدون محدودیت ببینید.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: _isProcessingPayment
                  ? null
                  : _makePayment, //_processPayment,simulation
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
              ),
              child: _isProcessingPayment
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'فعالسازی آنی - ۵ یورو',
                      style: TextStyle(color: Colors.white),
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
                      fontSize: 13,
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 12,
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
                fontSize: 14,
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

            // 💰 بخش دکمه‌های درآمدزایی افیلیت مارکتینگ (سفارش آنلاین و رزرو میز) 💰
            // Row(
            //   children: [
            //     // دکمه رزرو میز با افیلیت OpenTable/Yelp
            //     Expanded(
            //       child: OutlinedButton.icon(
            //         onPressed: () {
            //           final cleanName = Uri.encodeComponent(restaurant.name_map);
            //           // ساخت لینک جستجوی افیلیت برای رزرو میز در ایالت متحده یا اروپا
            //           final reserveUrl = "https://www.opentable.com/s?keyword=$cleanName&affiliateId=$myAffiliateId";
            //           launchUrlish(reserveUrl);
            //         },
            //         icon: const Icon(Icons.event_seat, size: 18),
            //         label: const Text('رزرو میز آنلاین', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            //         style: OutlinedButton.styleFrom(
            //           foregroundColor: Colors.red.shade700,
            //           side: BorderSide(color: Colors.red.shade400),
            //           padding: const EdgeInsets.symmetric(vertical: 10),
            //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            //         ),
            //       ),
            //     ),
            //     const SizedBox(width: 10),

            //     // دکمه سفارش آنلاین غذا با افیلیت Yelp/UberEats/Grubhub
            //     Expanded(
            //       child: OutlinedButton.icon(
            //         onPressed: () {
            //           final cleanName = Uri.encodeComponent(restaurant.name_map);
            //           // ساخت لینک افیلیت پلتفرم Yelp جهت بیشترین نرخ تبدیل سفارش آنلاین
            //           final orderUrl = "https://www.yelp.com/search?find_desc=$cleanName&utm_source=$myAffiliateId";
            //           launchUrlish(orderUrl);
            //         },
            //         icon: const Icon(Icons.delivery_dining, size: 18),
            //         label: const Text('سفارش آنلاین غذا', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            //         style: OutlinedButton.styleFrom(
            //           foregroundColor: Colors.orange.shade800,
            //           side: BorderSide(color: Colors.orange.shade400),
            //           padding: const EdgeInsets.symmetric(vertical: 10),
            //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 12),

            // دکمه اصلی مسیریابی روی گوگل مپ
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openDirections(restaurant),
                icon: const Icon(Icons.map_outlined, color: Colors.white),
                label: const Text(
                  'مسیریابی روی نقشه گوگل',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 14,
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
                fontSize: 12,
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

  Future<void> _openDirections(Restaurant restaurant) async {
    await _determinePosition();
    if (currentUserPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لطفاً ابتدا موقعیت مکانی خود را فعال کنید.'),
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
    final String destination = "${restaurant.name_map}, ${restaurant.city}";

    // ساخت لینک با استفاده از dir برای مسیریابی و travelmode برای حالت رانندگی
    final Uri url = Uri.https('www.google.com', '/maps/dir/', {
      'api': '1',
      'origin': origin,
      'destination': destination,
      'travelmode': 'driving', // نقشه را مستقیماً به حالت رانندگی می‌برد
    });

    // If working hours format is invalid or missing, proceed silently.
    if (wh['valid'] != true) {
      try {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطا در باز کردن مسیر: ${e.toString()}')),
        );
      }
      return;
    }
    // final String destination = "${restaurant.lat},${restaurant.lon}";
    // final Uri url = Uri.https('www.google.com', '/maps/dir/', {
    //   'api': '1',
    //   'origin': origin,
    //   'destination': destination,
    //   'travelmode': 'driving',
    // });

    // // If working hours format is invalid or missing, proceed silently.
    // if (wh['valid'] != true) {
    //   try {
    //     await launchUrl(url, mode: LaunchMode.externalApplication);
    //   } catch (e) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('خطا در باز کردن مسیر: ${e.toString()}')),
    //     );
    //   }
    //   return;
    // }

    // final String searchQuery = Uri.encodeComponent("${restaurant.name_map}, ${restaurant.city}");

    // // استفاده از کلمه کلیدی search به جای dir برای جستجوی دقیق نام مکان
    // final Uri url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$searchQuery");

    // // If working hours format is invalid or missing, proceed silently.
    // if (wh['valid'] != true) {
    //   try {
    //     await launchUrl(url, mode: LaunchMode.externalApplication);
    //   } catch (e) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('خطا در باز کردن مسیر: ${e.toString()}')),
    //     );
    //   }
    //   return;
    //}

    // If restaurant is open and will close within 60 minutes, show a prominent alert
    // (no confirmation required) then open maps automatically.
    final minutes = wh['minutesUntilClose'] as int?;
    if (minutes != null && minutes > 0 && minutes <= 60) {
      // show blocking dialog for a short moment
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('توجه'),
          content: Text('این رستوران ظرف ${minutes} دقیقه بسته می‌شود.'),
        ),
      );

      // wait briefly then pop and open map
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) Navigator.of(context).pop();

      try {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطا در باز کردن مسیر: ${e.toString()}')),
        );
      }
      return;
    }

    // Default: open maps
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا در باز کردن مسیر: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('راهنمای رستوران‌ وطنی'),
        backgroundColor: const Color(0xff004d99),
        foregroundColor: Colors.white,
        // actions: [
        //   // اصلاح نام آیکون و استفاده از kDebugMode
        //   if (kDebugMode)
        //     IconButton(
        //       icon: const Icon(Icons.restart_alt, color: Colors.orange),
        //       onPressed: _resetPaymentStatusForTesting,
        //       tooltip: 'تست: ریست وضعیت پرداخت',
        //     ),
        // ],
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
          TabBarView(
            controller: _tabController,
            children: [
              RefreshIndicator(
                onRefresh: _checkTrialAndInit,
                child: SingleChildScrollView(
                  controller: _restaurantScrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      if (kDebugMode)
                        Container(
                          width: double.infinity,
                          color: _hasPaid
                              ? Colors.green.withOpacity(0.2)
                              : Colors.red.withOpacity(0.2),
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            _hasPaid
                                ? "وضعیت: نسخه کامل (Paid)"
                                : "وضعیت: نسخه آزمایشی (Trial)",
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
                    Text(
                      'در حال برقراری ارتباط با گوگل‌پلی...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: _showScrollToTopButton
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              backgroundColor: const Color(0xff004d99),
              child: const Icon(Icons.arrow_upward, color: Colors.white),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
            const Icon(
              Icons.location_searching,
              color: Color(0xff004d99),
              size: 40,
            ),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff004d99),
              ),
              child: const Text(
                "اجازه دسترسی و جستجو",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
