
import 'models.dart';

// Import دقیق بر اساس نام فایل‌های اعلام شده
import 'data/athens.dart';
import 'data/hannover.dart';
import 'data/brussels.dart';
import 'data/dusseldorf.dart';
import 'data/berlin.dart';
import 'data/hamburg.dart';
import 'data/koln.dart';
import 'data/munich.dart';
import 'data/frankfurt.dart';
import 'data/bonn.dart';
import 'data/paris.dart';
import 'data/amsterdam.dart';
import 'data/barcelona.dart';
import 'data/madrid.dart';
import 'data/rome.dart';
import 'data/milan.dart';
import 'data/zurich.dart';
import 'data/warsaw.dart';
import 'data/stockholm.dart';
import 'data/dubai.dart';
import 'data/new_york.dart';
import 'data/los_angeles.dart';
import 'data/lisbon.dart';
import 'data/porto.dart';
import 'data/oslo.dart';
import 'data/helsinki.dart';
import 'data/toronto.dart';
import 'data/vancouver.dart';
import 'data/sydney.dart';
import 'data/melbourne.dart';
import 'data/istanbul.dart'; // اضافه شده بر اساس دیتای قبلی
import 'data/ankara.dart';
import 'data/prag.dart';
import 'data/bremen.dart';
import 'data/restworld.dart'; // اضافه شده برای دسترسی به رستوران‌های جهانی


// حالا می‌توانید از allRestaurantsByCity استفاده کنید
final Map<String, List<Restaurant>> allRestaurantsByCity = {
  "DE Towns": DE_RESTAURANTS,
  "Restworld": RESTWORLD_RESTAURANTS,
  "Hannover": HANNOVER_RESTAURANTS,
  "Brussels": BRUSSELS_RESTAURANTS,
  "Düsseldorf": DUSSELDORF_RESTAURANTS,
  "Berlin": BERLIN_RESTAURANTS,
  "Hamburg": HAMBURG_RESTAURANTS,
  "Köln": KOLN_RESTAURANTS,
  "Munich": MUNICH_RESTAURANTS,
  "Frankfurt": FRANKFURT_RESTAURANTS,
  "Bonn": BONN_RESTAURANTS,
  "Paris": PARIS_RESTAURANTS,
  "Amsterdam": AMSTERDAM_RESTAURANTS,
  "Barcelona": BARCELONA_RESTAURANTS,
  "Madrid": MADRID_RESTAURANTS,
  "Rome": ROME_RESTAURANTS,
  "Milan": MILAN_RESTAURANTS,
  "Zurich": ZURICH_RESTAURANTS,
  "Warsaw": WARSAW_RESTAURANTS,
  "Stockholm": STOCKHOLM_RESTAURANTS,
  "Dubai": DUBAI_RESTAURANTS,
  "New York": NEW_YORK_RESTAURANTS,
  "Los Angeles": LOS_ANGELES_RESTAURANTS,
  "Lisbon": LISBON_RESTAURANTS,
  "Porto": PORTO_RESTAURANTS,
  "Oslo": OSLO_RESTAURANTS,
  "Helsinki": HELSINKI_RESTAURANTS,
  "Toronto": TORONTO_RESTAURANTS,
  "Vancouver": VANCOUVER_RESTAURANTS,
  "Sydney": SYDNEY_RESTAURANTS,
  "Melbourne": MELBOURNE_RESTAURANTS,
  "Istanbul": ISTANBUL_RESTAURANTS,
  "Ankara": ANKARA_RESTAURANTS,
  "Athens": ATHENS_RESTAURANTS,
  "Prague": PRAGUE_RESTAURANTS,
  
  "اطراف من": [],
};