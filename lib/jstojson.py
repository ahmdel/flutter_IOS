import os
import re
import json

# مسیر پوشه‌ای که فایل‌های JS در آن قرار دارند
# مطمئن شوید که این مسیر را به پوشه فایل‌های خود تغییر دهید
FOLDER_PATH = '/media/ahmad/Ahmad/Ahmads_disk_23062025/Docs/projects/positioning/positioning_project5_planner_kheilishahrha_intelligent/js/alljs' 

def extract_js_array_to_json(js_content):
    """
    محتوای فایل JS را می‌خواند و متن آرایه را استخراج و به JSON تبدیل می‌کند.
    """
    
    # 1. حذف تمام خطوطی که با کامنت JS شروع می‌شوند (//)
    content_no_comments = re.sub(r'^\s*//.*\$', '', js_content, flags=re.MULTILINE)
    
    # 2. استخراج متن آرایه [] که بعد از const NAME = آمده است
    match = re.search(r'const\s+[A-Z_]+\s*=\s*(\[[^;]*\])\s*;', content_no_comments, re.DOTALL)
    
    if not match:
        print("Error: Could not find the const array definition in the file.")
        return None
        
    json_string = match.group(1).strip()
    
    # 3. حذف ویرگول‌های اضافی (Trailing Commas) که در JSON مجاز نیستند
    # این خط ویرگول‌هایی را حذف می‌کند که بلافاصله بعد از آن‌ها ] یا } و سپس فضای خالی یا کاراکتر جدید می‌آید.
    json_string = re.sub(r',\s*([\]}])', r'\1', json_string)
    
    # ----------------------------------------------------------------------
    # 4. **جدید و اصلاحی:** اضافه کردن دابل کوتیشن به کلیدهای Object در JS
    # این Regex هر کلمه (شامل حروف، اعداد و آندرلاین) را که بعد از آن : و قبل از آن { یا , می‌آید، پیدا کرده و در "" قرار می‌دهد.
    json_string = re.sub(r'([{,]\s*)(\w+):', r'\1"\2":', json_string)
    # ----------------------------------------------------------------------
    
    try:
        # 5. تبدیل نهایی رشته تمیز شده به شیء JSON پایتون
        data = json.loads(json_string)
        return data
    except json.JSONDecodeError as e:
        print(f"Error during JSON decoding: {e}")
        # برای عیب‌یابی بیشتر، می‌توانید خطی را که خطا داده پرینت کنید:
        # print(f"Problematic line: {json_string.splitlines()[e.lineno - 1]}")
        return None

# بقیه کد (تابع process_js_files و اجرای اصلی) بدون تغییر باقی می‌ماند.
# ----------------------------------------------------------------------

def process_js_files(folder_path):
    """
    تمام فایل‌های JS را در مسیر مشخص شده پردازش کرده و آن‌ها را به JSON تبدیل می‌کند.
    """
    if not os.path.exists(folder_path):
        print(f"Error: Directory not found at {folder_path}")
        return

    for filename in os.listdir(folder_path):
        if filename.endswith(".js"):
            js_filepath = os.path.join(folder_path, filename)
            json_filename = filename.replace(".js", ".json")
            json_filepath = os.path.join(folder_path, json_filename)
            
            print(f"Processing: {filename}...")
            
            try:
                with open(js_filepath, 'r', encoding='utf-8') as f:
                    js_content = f.read()
                
                json_data = extract_js_array_to_json(js_content)
                
                if json_data is not None:
                    # ذخیره داده‌های تبدیل شده در فایل JSON
                    with open(json_filepath, 'w', encoding='utf-8') as f:
                        # ensure_ascii=False برای حفظ حروف فارسی ضروری است
                        json.dump(json_data, f, indent=4, ensure_ascii=False)
                    
                    print(f"SUCCESS: Saved to {json_filename}")
                else:
                    print(f"FAILURE: Skipping {filename}")
                    
            except Exception as e:
                print(f"An unexpected error occurred while processing {filename}: {e}")

# اجرای تابع اصلی
if __name__ == "__main__":
    process_js_files(FOLDER_PATH)