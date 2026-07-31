import os

# لیست شهرها
cities = [
    "hannover", "brussels", "dusseldorf", "berlin", "hamburg", "koln", 
    "munich", "frankfurt", "bonn", "paris", "amsterdam", "barcelona", 
    "madrid", "rome", "milan", "zurich", "warsaw", "stockholm", "dubai", 
    "new_york", "los_angeles", "lisbon", "porto", "oslo", "helsinki", 
    "toronto", "vancouver", "sydney", "melbourne"
]

path = "lib/data"

# ایجاد پوشه اگر وجود ندارد
if not os.path.exists(path):
    os.makedirs(path)

for city in cities:
    file_path = os.path.join(path, f"{city}.dart")
    # تبدیل نام شهر به فرمت متغیر (مثلاً los_angeles -> LOS_ANGELES_RESTAURANTS)
    var_name = f"{city.upper()}_RESTAURANTS"
    
    content = f"""import '../models.dart';

// @formatter:off
const List<Restaurant> {var_name} = [
  // دیتای رستوران‌های {city} را اینجا کپی کنید
];
// @formatter:on
"""
    with open(file_path, "w", encoding="utf-8") as f:
        f.write(content)

print(f"✅ موفقیت: {len(cities)} فایل در مسیر {path} ساخته و آماده‌سازی شدند.")