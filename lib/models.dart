// lib/models.dart
// --- ایمپورت فایل‌های دیتا (اینجا بماند برای دسترسی سریع در کل پروژه) ---
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
import 'data/istanbul.dart';
import 'data/ankara.dart';
import 'data/athens.dart';
import 'data/prag.dart';
import 'data/vienna.dart'; // اضافه شده
import 'data/dallas.dart';
import 'data/miami.dart';
import 'data/aachen.dart';
import 'data/antwerp.dart';
import 'data/tokyo.dart';
import 'data/strasbourg.dart';
import 'data/nice.dart';
import 'data/stuttgart.dart';
import 'data/marseille.dart';
import 'data/manchester.dart';
import 'data/lyon.dart';
import 'data/glasgow.dart';
import 'data/geneva.dart';
import 'data/edinburgh.dart';
import 'data/dublin.dart';
import 'data/basel.dart';
import 'data/malaga.dart';
import 'data/bremen.dart';
import 'data/restworld.dart'; // اضافه شده برای دسترسی به رستوران‌های جهانی







const String WEATHER_API_KEY = "8ecea89fafb957ea20ff6dff7c6c1b6e";

// --- ثابت‌های برنامه‌ریزی سفر ---
const double MAX_DISTANCE_KM = 50;
const double AVERAGE_SPEED_KMH = 50;
const int BUFFER_TIME_MINUTES = 10;
const int PARKING_BUFFER_MINUTES = 10; 
const double WALKING_SPEED_KMH = 5; 
const double WALKING_DISTANCE_THRESHOLD_KM = 1.0; 

const int DAY_END_HOUR = 20; 
const int NEXT_DAY_START_HOUR = 10; 
const int LUNCH_START_HOUR = 12; 
const int LUNCH_END_HOUR = 15; 
const int LUNCH_DURATION_MINUTES = 60; 
const int CLOSING_ALARM_MINUTES = 30;

// --- مدل رستوران ---
class Restaurant {
  final String name;
  final String name_map;
  final double lat;
  final double lon;
  final String description;
  final String parkingInfo;
  final String city; // اضافه کردن علامت سوال برای اختیاری شدن
  final String? price;        // فیلد جدید اختیاری
  final String? rating;       // فیلد جدید اختیاری
  final String? workingHours; // فیلد جدید اختیاری
  final String? address;     // فیلد جدید اختیاری
  final String? phone;  
  final String? website;  

  Restaurant({
    required this.name,
    required this.name_map,
    required this.lat,
    required this.lon,
    required this.description,
    required this.parkingInfo,
    required this.city, // حذف کلمه required
    this.price,              // اختیاری
    this.rating,             // اختیاری
    this.workingHours,       // اختیاری
    this.address,
    this.phone,
    this.website,
  });
}

// --- مدل دیدنی‌ها (Poi) ---
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

  factory Poi.fromJson(Map<String, dynamic> json) {
    return Poi(
      name: json['name'] as String,
      name_map: json['name_map'] as String,
      lat: json['lat'] as double,
      lon: json['lon'] as double,
      rating: json['rating'] as double,
      description: json['description'] as String,
      duration: json['duration'] as String,
      best_season: json['best_season'] as String,
      suitable_age: json['suitable_age'] as String,
      unsuitable_age: json['unsuitable_age'] as String,
      opening_hours: json['opening_hours'] as String,
      ticket_price: json['ticket_price'] as String,
      ticket_link: json['ticket_link'] as String,
    );
  }
}



// --- نقشه جامع که در کل برنامه استفاده خواهید کرد ---
final Map<String, List<Restaurant>> RESTAURANTS_DATA = {
  "DE Towns": DE_RESTAURANTS,
  "Restworld": RESTWORLD_RESTAURANTS,
  "Hannover": HANNOVER_RESTAURANTS,
  "Aachen": AACHEN_MAASTRICHT_RESTAURANTS,
  "Antwerp": ANTWERP_RESTAURANTS,
  "Brussels": BRUSSELS_RESTAURANTS,
  "Dusseldorf": DUSSELDORF_RESTAURANTS,
  "Berlin": BERLIN_RESTAURANTS,
  "Hamburg": HAMBURG_RESTAURANTS,
  "Koln": KOLN_RESTAURANTS,
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
  "Vienna": VIENNA_RESTAURANTS,
  "Miami": MIAMI_RESTAURANTS,  
  "Dallas": DALLAS_RESTAURANTS,
  "Tokyo": TOKYO_RESTAURANTS,
  "Strasbourg": STRASBOURG_RESTAURANTS,
  "Nice": NICE_RESTAURANTS,
  "Stuttgart": STUTTGART_RESTAURANTS,
  "Marseille": MARSEILLE_RESTAURANTS,
  "Manchester": MANCHESTER_RESTAURANTS,
  "Lyon": LYON_RESTAURANTS,
  "Glasgow": GLASGOW_RESTAURANTS,
  "Geneva": GENEVA_RESTAURANTS,
  "Edinburgh": EDINBURGH_RESTAURANTS,
  "Dublin": DUBLIN_RESTAURANTS,
  "Basel": BASEL_AREA_RESTAURANTS,
  "Malaga": malagaRestaurants,
  "Bremen": bremenRestaurants,  
  "اطراف من": [],
};