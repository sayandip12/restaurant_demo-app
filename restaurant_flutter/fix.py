import os, re

def fix_file(filepath):
    if not os.path.exists(filepath): return
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    new_content = re.sub(r'\bprint\(', 'debugPrint(', content)
    new_content = new_content.replace('anonKey:', 'publishableKey:')
    
    if new_content != content:
        if 'debugPrint(' in new_content and 'package:flutter/foundation.dart' not in new_content:
            new_content = "import 'package:flutter/foundation.dart';\n" + new_content
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Fixed {filepath}")

fix_file('integration_test/verify_app_test.dart')
fix_file('lib/core/utils/receipt_generator.dart')
fix_file('lib/presentation/providers/order_provider.dart')
