import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationManager extends Translations {
  static final List<Locale> locales = [
    const Locale('en'),
    const Locale('ar'),
  ];
  final Map<String, String> english = {
    "enter": "Enter",
    "settings": "Settings",
    "forgot_password": "Forgot password",
    "enter_username": "Enter your username",
    "enter_password": "Enter your password",
    "enter_api_password": "Enter your API's password",
    "api_address": "API address",
    "api_password": "API password",
    "user_id": "User id",
    "account": "Account",
    "device_id": "Device id",
    "account_settings": "Account settings",
    "company_elements": "Company elements",
    "company_name": "Company name",
    "company_address": "Company address",
    "company_tax": "Company tax number",
    "operation_elements": "Operation elements",
    "receipt_number": "Receipt number",
    "receipt_date": "Receipt date",
    "employee_name": "Employee name",
    "customer_name": "Customer name",
    "customer_tax": "Customer tax number",
    "paid_amount": "Paid amount",
    "remaining_amount": "Remaining amount",
    "credit_before": "Money credit before",
    "credit_after": "Money credit after",
    "doc_elements": "Documents elements",
    "ask_visit": "Confirm leaving reason when exiting any unfinished operation",
    "allow_sales_receipt": "Allow sales receipts",
    "allow_return_receipt": "Allow return receipts",
    "allow_payment_doc": "Allow payment documents",
    "allow_collection_doc": "Allow collection documents",
    "allow_inventory_doc": "Allow inventory documents",
    "allow_selling_order": "Allow selling orders",
    "printing_settings_head":
        "Control what to show and what to not in a printing",
    "settings_warning":
        "Changing some of the following settings might affect some of the app's functionalities",
    "receipt_settings": "Receipts settings",
    "receipts_naming": "Receipts naming",
    "printing_elements": "Printing elements",
    "click_to_change": "Click to change",
    "app_settings": "Application settings",
    "server_options": "Server permissions and options",
    "operations_settings": "Operations settings",
    "must_login": "You must login to view this section",
    "settings_back_warning": "All changes will be saved on going back",
    "seizure_document": "Seizure document",
    "payment_document": "Payment document",
    "return_receipt": "Return receipt",
    "sales_receipt": "Sales receipt",
    "selling_order": "Payment order",
    "inventory_receipt": "Inventory receipt",
    "clients": "Clients",
    "items": "Items",
    "view_operations": "View operations",
    "operations": "Operations",
    "operations_settings_head": "Choose what operations to allow",
    "request_reload": "Request delete operations and full reload",
    "update_items_accounts": "Update items and accounts",
    "update_items_accounts_with_amount":
        "Update items and accounts with amounts and credits",
    "exit": "Exit",
    //Receipt translation
    "price_less_than_selling_price":
        "You don't have the permission to add this product because the price is lower than the selling price",
    "bad_barcode": "No product found with this barcode",
    "search_barcode": "Barcode search",
    "date": "Date",
    "loading": "Loading",
    "time": "Time",
    "number": "number",
    "cash": "Cash",
    "instant": "Instant",
    "unit": "Unit",
    "item": "Item",
    "qty": "Quantity",
    "price": "Price",
    "discount": "Discount",
    "value": "Value",
    "free_qty": "Free qty",
    "previous_credit": "Previous credit",
    "receipt_total": "Receipt total",
    "addition": "Addition",
    "tax": "Tax",
    "receipt_value": "Receipt value",
    "remaining": "Remaining",
    "current_credit": "Current credit",
    "barcode_search": "Barcode search",
    "notes": "Notes",
    "name": "Name",
    "cst_number": "Customer code",
    "max_credit": "Max credit",
    "employee_number": "Employee number",
    "user_number": "User number",
    "search": "Search",
    "barcode": "Barcode",
    "sectoral_price": "Sectoral price",
    "normal_price": "Normal price",
    "total_items": "Total items",
    "total_items_quantity": "Total items quantity",
    "total_quantity": "Total quantity",
    "total_free_qty": "Total free quantity",
    "no_items": "No items ",
    //Errors
    "error": "Error",
    "back": "Back",
    "incompatible_id_with_receipts":
        "This user id does not match the one in the saved receipts",
    "auto_upload_error": "Error with auto uploading",
    //Dialogs translation
    "warning": "Warning",
    "receipt_still_inprogress":
        "There is a receipt in making, do you still want to exit ?",
    "stay": "Stay",
    "exit_message": "Kindly, state the reason of leaving.",
    "leaving_reason": "Leaving reason",
    "confirm": "Confirm",
    "discard_confirm":
        "The selected items will be discarded, do you want to continue?",
    "not_items_to_discard": "No items selected to discard",
    "price_less_than_least":
        "You don't have the permission to alter the price to less than the least selling price.",
    "remaining_qty": "Remaining quantity",
    "cst_code": "Customer code",
    "finish": "Finish",
    "sales": "Sales",
    "visit": "Visit",
    "return": "Return",
    "inventory": "Inventory",
    "total": "total",
    "operation_type": "Operation type",
    "uploaded": "Uploaded",
    "paid_by": "Paid by",
    "received_from": "Received from",
    "bank_transfer": "Bank transfer",
    "choose_customer": "Choose the customer",
    "seizure_method": "Seizure method",
    "payment_method": "Payment method",
    "max_debt": "Max debt",
    "qty_error":
        "You have no permission to add any item with quantity less than zero",
    "avg_selling_price": "Average selling price",
    "last_selling_price": "last selling price",
    "wait": "Wait",
    "reload_successful": "Reload operation successful. Operations deleted.",
    "operations_not_uploaded_yet":
        "Some operations haven't been uploaded yet. make sure you upload them first and try again.",
    "can't_get_yet": "Not allowed to retrieve data, yet.",
    "no_request_found": "No request found, yet.",
    "update_successful": "Successfully updated items and prices.",
    "operations_not_exported_yet": "Operations not exported to servers, yet.",
    "operations_deleted": "Operations deleted successfully.",
    "ok": "Ok",
    "operations_removed_request_made":
        "Operations removed and a new request was made.",
    "common_button_title": "Title",
    // done_dialog
    "done_dialog_title": "done successfully!",
    "done_dialog_desc": "operation accomplished successfully!",
    "done_dialog_btn": "Thanks",
    // exit dialog
    "exit_dialog_title": "Confirm!",
    "exit_dialog_text":
        "Please indicate the reason for canceling the operation",
    "exit_dialog_hint": "Reason for cancellation",
    "exit_dialog_btn_cancel": "Cancel",
    "exit_dialog_btn_ok": "completion",
    // options column
    "options_column_alert_text": "There are no products in the list",
    "options_column_btn_ok_text": "Cancel",
    "options_column_btn_cancel_text": "Confirm",
    "options_column_warning_text":
        "The selected products will be erased, Do you want to continue!",
    "options_column_alert_text_2":
        "There are no selected products to be erased",
    // save dialog
    "save_dialog_title": "Confirm creation of a new process",
    "save_dialog_desc":
        "A new process will be created and carried over if there is an internet connection",
    "save_dialog_first_common_button": "Save",
    "save_dialog_second_common_button": "Save and share",
    "save_dialog_third_common_button": "Save and print",
    "save_dialog_fourth_common_button": "Cancel",
    // warning dialog
    "warning_dialog_title": "Warning!",
    // edit price dialog
    "edit_price_dialog_title": "Adjust the price",
    "edit_price_dialog_first_text": "Lowest selling price",
    "edit_price_dialog_second_text": "Product price",
    "edit_price_dialog_third_text": "New price",
    "edit_price_dialog_error": "Error",
    "edit_price_dialog_done": "Done",
    // forgot password dialog
    "forgot_password_dialog_alert_text": "Reset the password",
    "forgot_password_dialog_first_hint_text": "Enter Your API",
    "forgot_password_dialog_second_hint_text":
        "Enter your identification number",
    "forgot_password_dialog_third_hint_text": "Enter the master password",
    "forgot_password_dialog_exit_btn": "Enter",
    // loading dialog
    "loading_dialog_alert_text": "Processing",
    //  return dialog
    "return_dialog_title": "Return type",
    "return_dialog_first_type": "Partial return",
    "return_dialog_second_type": "Full invoice refund",
    "return_dialog_third_type": "Return the invoice and create a new invoice",
    "return_dialog_close": "Close",
    "part_return_text": "There are products to return",
    "full_return_text": "A return invoice has been made",
    // select receipt dialog
    "select_receipt_dialog_hint_text": "Search",
    "select_receipt_dialog_number": "Number",
    "select_receipt_dialog_name": "Customer Name",
    "select_receipt_dialog_net": "Net invoice",
    "select_receipt_dialog_date": "Date",
    "select_receipt_dialog_time": "Time",
    "select_receipt_dialog_Pay": "Pay",
    "select_receipt_dialog_type": "Invoice Type",
    "select_receipt_dialog_deported": "Deported",
    "select_receipt_dialog_yes": "Yes",
    "select_receipt_dialog_No": "No",
    "select_receipt_dialog_data_row_text":
        "Would you like to fill in the products from this invoice?",
    "quantity_before": "Quantity before",
    "quantity_remaining": "Quantity after",
    "all": "All",
    "last_upload_date": "Last upload date",
    "final_value": "Final value",
    "total_discounts": "Total discounts",
    "total_additions": "Total additions",
    "total_tax": "Total tax",
    "total_value": "Total value",
    "total_cash": "Total cash",
    "last_items_update": "Last items update",
    "last_clients_update": "Last clients update",
    "no_items_found": "No items found with the given conditions",
    "amount_more_than": "Amount more than",
    "amount_less_than": "Amount less than",
    "english": "English",
    "arabic": "Arabic",
    "enter_notes": "Enter your notes",
    "new_document": "New document",
    "doc_paid_amount": "Paid amount",
    "doc_received_amount": "Received amount",
    "doc_history": "Document history",
    "enter_amount": "Enter the amount",
    "box_name": "Box name",
    "bank_name": "Bank name",
    "doc_number": "Document number",
    "enter_name": "Enter a name",
    "custom_names": "Use a custom name for operations",
    "sales_receipt_name": "Sales receipt name",
    "return_receipt_name": "Return receipt name",
    "seizure_doc_name": "Seizure document name",
    "payment_doc_name": "Payment document name",
    "receipt": "Receipt",
    "tax_number": "Tax number",
    "employee": "Employee",
    "customer": "Client",
    "cashier_receipt": "Cashier receipt",
    "language": "Language",
    "options": "Options",
    "allow_cashier_receipt": "Allow chashier receipt",
    "show_cashier_details": "Show cashier receipt detals",
    "cashier_receipt_settings": "Cashier receipt settings",
    "products_space": "Show products space",
    "cashier_receipt_spaces": "Cashier receipt spaces",
    "categories_space": "Categories space",
    "cashier_details_space": "Cashier details space",
    "select_printer": "اختر الطابعة",
    "connecting_error": "Error with connecting",
    "a4_settings": "A4 paper settings",
    "position_instructions":
        "Press and hold on the item to change it's location and position",
    "postion_elements": "Position printing elements",
    "expenses_document": "Expenses document",
    "expenses_paid": "Paid expenses",
    "general": "General",
    "choose_stor": "Choose store",
    "documents": "Documents",
    "reports": "Reports",
    "receipts": "Receipts",
    "purchase_receipt": "Purchase receipt",
    "purchase_return_receipt": "Purchase return receipt",
    "purchase_return": "Purchase return",
    "purchase": 'Purchase',
    "groups": "Groups",
    "stors": "Storages",
    "kinds": "Kinds",
    "mows": "Suppliers",
    "expenses": "Expenses",
    "stor_code": " Store code",
    'kind_code': "Kind code",
    "expenses_seizure_document": "Expenses seizure document",
    "purchase_order": "Purchase order",
    "mow_payment_document": "Suppliers payment document",
    "mow_seizure_document": "Suppliers seizure document",
    "group_code": "Group code",
    "allow_expenses_seizure_document": "Allow expenses seizure document",
    "allow_expenses_document": "Allow expenses document",
    "allow_purchase_return_receipt": "Allow purchase return receipt",
    "allow_purchase_receipt": "Allow purchase receipt",
    "allow_mow_payment_document": "Allow suppliers payment document",
    "allow_mow_seizure_document": "Allow suppliers seizure document",
    "allow_purchase_order": "Allow purchase order",
    "allow_view_kinds": "Allow viewing kinds",
    "allow_view_mows": "Allow viewing suppliers",
    "allow_view_expenses": "Allow viewing expenses",
    "allow_view_clients": "Allow viewing clients",
    "allow_view_items": "Allow viewing items",
    "allow_view_operations": "Allow viewing operations",
    "allow_view_groups": "Allow viewing groups",
    "allow_view_stors": "Allow viewing stores",
    "info_settings": "Info settings",
    "general_settings": "General page settings",
    "total_credit": "Total credit",
    "stor_transfer": "Store transfer",
    "allow_stor_transfer": "Allow store transfer",
    "new_rec": "New record",
    "allow_new_rec": "Allow creating new record",
    "records": "Records",
    "shift start time": "Shift Start Time",
    "shift end time": "Shift End Time",
    "banking": "Banking",
    "use shifts": "Use Shifts",
    "repeated": "Repeated",
    "SocketException: Failed host lookup: 'sky3m.duckdns.org' (OS Error: No address associated with hostname, errno = 7)":
        "SocketException: Failed host lookup: 'sky3m.duckdns.org' (OS Error: No address associated with hostname, errno = 7)",
    "receipt is bending": "A receipt is still bending, do you want to exit?",
    "types": "Types",
    "offers": "Offers",
    "stor id": "Store Number",
    "add product": "Add Product",
    "address": "Address",
    "phone": "Phone",
    "products grid count": "Products Grid Count",
    "product tile height": "Product Tile Height",
    "show offers": "Show Offers",
    "default length is 1": "Default length is 1",
    "cashier settings": "Cashier Settings",
    "employee payment document": "Employee Payment Document",
    "employee seizure document": "Employee Seizure Document",
    "employee id": "Employee ID",
    "seizure from": "Seizure From",
    "payment from": "Payment From",
    "this quantity is bigger than allowed":
        "This qunatity is bigger than allowed",
    "do you really want to move this operation to recylce pin":
        "Do you really want to move this operation to recylce pin ?",
    "recycle bin": "Recycle Bin",
    "do you really want to move this operation out of recycle pin":
        "Do you really want to move this operation out of recycle pin?",
    "server connection error": "Server Conntection Error",
    "error with the login attempt": "Error with the login attempt",
    "document created successfully": "Document Created Successfully!",
    "": "",
    "": "",
    "": "",
    "": "",
    "": "",
    "": "",
    "": "",
    "": "",
    "": "",
  };

  final Map<String, String> arabic = {
    "document created successfully": "تم انشاء السند بنجاح",
    "error with the login attempt": "خطأ في محاولة التسجيل",
    "server connection error": "خطأ في الاتصال بالسرفر",
    "do you really want to move this operation out of recycle pin":
        "هل حقا تود اخراج الفاتورة من سلة المهملات ؟",
    "recycle bin": "سلة المهملات",
    "do you really want to move this operation to recylce pin":
        "هل حقا تود وضع هذه العملية فالسلة؟",
    "this quantity is bigger than allowed": "هذه الكمية اكبر من الكمية المتاحة",
    "seizure from": "استلمنا من",
    "payment from": "الدفع من",
    "employee id": "رقم الموظف",
    "employee payment document": "سند دفع موظف",
    "employee seizure document": "سند قبض موظف",
    "use shifts": "استخدام الشفتات",
    "cashier settings": "اعدادات الكاشير",
    "default length is 1": "الطول الافتراضي 1",
    "show offers": "اظهار العروض",
    "product tile height": "طول مربع المنتج",
    "products grid count": "عدد المنتجات فالصف الواحد",
    "address": "العنوان",
    "phone": "الهاتف",
    "add product": "اضافة منتج",
    "stor id": "رقم المخزن",
    "offers": "العروض",
    "types": "الانواع",
    "receipt is bending":
        'هناك فاتورة قيد الانشاء ستمسح ان تراجعت, هل تود الخروج؟',
    "SocketException: Failed host lookup: 'sky3m.duckdns.org' (OS Error: No address associated with hostname, errno = 7)":
        "لم يتعثر علي  الهوست المطلوب من رابط الدخول",
    "repeated": "مكررة",
    "cancel": "الغاء",
    "allow shift": "استخدام مواقيت عمل",
    "banking": "مصرفي",
    "shift start time": "وقت بداية الشيفت",
    "shift end time": "وقت نهاية الشيفت",

    "records": "سجلات",
    "new_rec": "سجل جديد",
    "allow_stor_transfer": "السماح بعمل تحويل مخازن",
    "stor_transfer": "تحويل مخزن",
    "general_settings": "اعدادات الصفحة العامة",
    "allow_new_rec": "السماح بعمل سجل جديد",
    "info_settings": "اعدادات المعلومات",
    "allow_view_kinds": "السماح بمشاهدة الانواع",
    "allow_view_mows": "السماح بمشاهدة الموردين",
    "allow_view_expenses": "السماح بمشاهدة المصروفات",
    "allow_view_clients": "السماح بمشاهدة العملاء",
    "allow_view_items": "السماح بمشاهدة الاصناف",
    "allow_view_operations": "السماح بمشاهدة العمليات",
    "allow_view_groups": "السماح بمشاهدة المجموعات",
    "allow_view_stors": "السماح بمشاهدة المخازن",
    "allow_expenses_seizure_document": "السماح بعمل سند قبض مصروفات",
    "allow_expenses_document": "السماح بعمل سند دفع مصروفات",
    "allow_purchase_return_receipt": "السماح بعمل فاتورة مردود شراء",
    "allow_purchase_receipt": "السماح بعمل فاتروة شراء",
    "allow_mow_payment_document": "السماح بعمل سند دفع مورد",
    "allow_mow_seizure_document": "السماح بعمل سند قبض مورد",
    "allow_purchase_order": "السماح بعمل امر شراء",
    "group_code": "كود المجموعة",
    "mow_seizure_document": "سند قبض للموردين",
    "mow_payment_document": "سند دفع للموردين",
    "purchase_order": "امر شراء",
    "expenses_seizure_document": "سند قبض مصروفات",
    'kind_code': "كود النوع",
    "stor_code": " كود المخزن",
    "groups": "مجموعات",
    "stors": "مخازن",
    "kinds": "انواع",
    "mows": "موردين",
    "expenses": "مصروفات",
    "purchase": 'شراء',
    "purchase_return": "مردود شراء",
    "purchase_return_receipt": "فاتورة مردود مشتريات",
    "purchase_receipt": "فاتورة مشتريات",
    "receipts": "الفواتير",
    "reports": "تقارير",
    "documents": "السندات",
    "choose_stor": "اختر المخزن",
    "general": "عام",
    "paid_expenses": "المصروفات المدفوعة",
    "expenses_document": "سند مصروفات",
    "position_instructions":
        "(اضغط مطولا علي العنصر المطلوب و حركه للمكان الذي تريده)",
    "postion_elements": "ترتيب عناصر الطباعة",
    "a4_settings": "اعدادات ورق a4",
    "connecting_error": "خطا في الاتصال بالطابعة",
    "select_printer": "اختر الطابعة",
    "cashier_details_space": "مساحة معلومات الفاتورة",
    "categories_space": "مساحة الانواع",
    "cashier_receipt_spaces": "مساحات شاشة فاتورة الكاشير",
    "products_space": "مساحة المنتجات المعروضة",
    "cashier_receipt_settings": "اعدادات فاتورة الكاشير",
    "show_cashier_details": "اظهار معلومات الفاتورة",
    "allow_cashier_receipt": "السماح بفاتورة كاشير",
    "options": "الخيارات",
    "language": "اللغة",
    "cashier_receipt": "فاتورة كاشير",
    "customer": "العميل",
    "employee": "الموظف",
    "tax_number": "الرقم الضريبي",
    "receipt": "فاتورة",
    "sales_receipt_name": "اسم فاتورة المبيعات",
    "return_receipt_name": "اسم فاتورة المردود",
    "seizure_doc_name": "اسم سند القبض",
    "payment_doc_name": "اسم سند الدفع",
    "custom_names": "استخدام مسميات مختلفة للعمليات؟",
    "box_name": "اسم البنك",
    "enter_name": "ادخل الاسم",
    "doc_number": "رقم السند",
    "bank_name": "اسم البنك",
    "enter_amount": "ادخل المبلغ",
    "doc_history": "تاريخ السند",
    "doc_paid_amount": "المبلغ المدفوع",
    "doc_received_amount": "المبلغ المستلم",
    "new_document": "انشاء سند جديد",
    "enter_notes": "ادخل ملاحظاتك",
    "english": "الانجليزية",
    "arabic": "العربية",
    "amount_more_than": "كمية اكثر من",
    "amount_less_than": "كمية اقل من",
    "no_items_found": "لا يوجد نتائج توافق تلك الشروط",
    "last_items_update": "تاريخ اخر استحضار للاصناف",
    "last_clients_update": "تاريخ اخر استحضار للعملاء",
    "total_discounts": "ج الخصمات",
    "total_additions": "ج الاضافي",
    "total_tax": "ج الضريبة",
    "total_value": "ج الصافي",
    "total_cash": "ج السداد",
    "all": "الكل",
    "last_upload_date": "تاريخ اخر تحويل",
    "quantity_before": "الكمية قبل",
    "quantity_remaining": "الكمية المتبقية",
    "ok": "تم",
    "can't_get_yet": "غير مسموح بالاستحضار بعد",
    "no_request_found": "لم يتم عمل طلب بعد",
    "update_successful": "تم تحديث الاصناف و الاسعار بنجاح",
    "operations_deleted": "تم مسح الفواتير بنجاح",
    "operations_not_exported_yet": "بعض الفواتير لم يتم رفعها علي السرفر",
    "reload_successful": "تم استحضار الارصدة و الكميات و مسح العمليات بنجاح",
    "operations_not_uploaded_yet":
        "بعض العمليات لم يتم ترحيلها, تاكد من ترحيلها و حاول مجددا",
    "operations_removed_request_made":
        "تم مسح الفواتير و انشاء طلب جديد و جاري معالجته",
    "wait": "مهلا",
    "avg_selling_price": "متوسط سعر الشراء",
    "last_selling_price": "اخر سعر شراء",
    "qty_error": "لا يوجد صلاحية لاضافة منتج بكمية اقل من صفر",
    "employee_number": "رقم الموظف",
    "seizure_method": "طريقة القبض",
    "payment_method": "طريقة الدفع",
    "choose_customer": "اختر العميل",
    "bank_transfer": "تحويل بنكي",
    "finish": "اتمام",
    "max_debt": "اقصي مديونية",
    "sales": "مبيعات",
    "visit": "زيارة",
    "return": "مردود",
    "inventory": "جرد",
    "total": "صافي",
    "final_value": "الاجمالي",
    "operation_type": "نوع العملية",
    "uploaded": "تم الترحيل",
    "paid_by": "الدفع من العميل",
    "received_from": "استلمنا من العميل",
    "cst_code": "كود العميل",
    "remaining_qty": "الكمية المتبقية",
    "back": "تراجع",
    "price_less_than_least":
        "ليس لديك صلاحيات لتقليل السعر الي اقل من الحد الادني",
    "not_items_to_discard": "لا يوجد منتجات مختارة للمسح",
    "discard_confirm": "سيتم مسح المنتجات المختارة, هل تود الاكمال؟",
    "total_credit": "جمالي الارصدة",
    //Settings translation
    "enter": "دخول",
    "account": "الحساب",
    "settings": "الاعدادات",
    "forgot_password": "نسيت كلمة السر",
    "enter_username": "ادخل اسم المتسخدم",
    "enter_password": "ادخل كلمة السر الخاصة بك",
    "enter_api_password": "ادخل باسورد الAPI",
    "api_address": "عنوان الAPI",
    "api_password": "كلمة سر الAPI",
    "user_id": "الرقم التعريفي للمستخدم",
    "device_id": "رقم الجهاز",
    "account_settings": "اعدادات الحساب",
    "settings_warning":
        "ستؤثر بعض التغيرات علي تسجيل الدخول و بعض خصائص البرنامج",
    "receipt_settings": "اعدادات الفاتورة",
    "receipts_naming": "مسميات الفواتير",
    "company_elements": "عناصر الشركة",
    "company_name": "اسم",
    "company_address": "عنوان الشركة",
    "company_tax": "رقم الشركة الضريبي",
    "operation_elements": "عناصر العملية",
    "receipt_number": "رقم الفاتورة",
    "receipt_date": "تاريخ الفاتورة",
    "employee_name": "اسم الموظف",
    "customer_name": "اسم العميل",
    "customer_tax": "رقم العميل الضريبي",
    "paid_amount": "المبلغ المسدد",
    "remaining_amount": "المبلغ الباقي",
    "credit_before": "الرصيد قبل",
    "credit_after": "الرصيد بعد",
    "doc_elements": "عناصر السندات",
    "ask_visit": "طلب تاكيد زيارة عند الخروج من اي عملية في حالة عدم الاكمال",
    "allow_sales_receipt": "السماح بعمل فاتورة مبيعات",
    "allow_return_receipt": "السماح بعمل فاتورة مردود",
    "allow_payment_doc": "السماح بعمل سند دفع",
    "allow_collection_doc": "السماح بعمل سند قبض",
    "allow_inventory_doc": "السماح بعمل جرد",
    "allow_selling_order": "السماح بعمل امر بيع",
    "printing_settings_head": "تحكم باظهار او اخفاء عناصر من الطباعة",
    "printing_elements": "عناصر الطباعة",
    "click_to_change": "اضغط للتغيير",
    "app_settings": "اعدادات البرنامج",
    "server_options": "اعدادات الخوادم",
    "operations_settings": "اعدادات العمليات",
    "operations_settings_head": "(تعديل سماحية انشاء عمليات)",
    "must_login": "يجب التسجيل اولا للتعديل",
    "settings_back_warning": "(سيتم حفظ التعديلات تلقائيا عند الرجوع)",
    "seizure_document": "سند قبض",
    "payment_document": "سند دفع",
    "return_receipt": "فانورة مردود",
    "sales_receipt": "فاتورة مبيعات",
    "selling_order": "امر بيع",
    "inventory_receipt": "فاتورة جرد",
    "clients": "العملاء",
    "operations": "العمليات",
    "items": "الاصناف",
    "view_operations": "عرض العمليات",
    "request_reload": "طلب اعادة تحميل جديد و مسح الفواتير",
    "update_items_accounts": "تحديث الأصناف و الحسابات  ",
    "update_items_accounts_with_amount":
        "تحديث الاصناف و الحسابات مع الارصدة و الكميات    ",
    "exit": "خروج",
    //Receipt translation
    //ليس لديك صلاحيات لاضافة هذا المنتج لان سعره اقل من اقل سعر بيع
    "price_less_than_selling_price":
        "ليس لديك صلاحيات لاضافة هذا المنتج لان سعره اقل من اقل سعر بيع",
    "bad_barcode": "لا يوجد منتج بهذا الكود",
    "search_barcode": "بحث بالباركود",
    "loading": "تحميل",
    "date": "التاريخ",
    "time": "الوقت",
    "number": "رقم",
    "cash": "نقدي",
    "instant": "اجل",
    "unit": "وحدة",
    "item": "الصنف",
    "qty": "الكمية",
    "price": "السعر",
    "discount": "الخصم",
    "value": "القيمة",
    "free_qty": "ك مجانية",
    "previous_credit": "الرصيد السابق",
    "receipt_total": "ص الفاتورة",
    "addition": "الاضافي",
    "tax": "الضريبة",
    "receipt_value": "ج الفاتورة",
    "remaining": "المتبقي",
    "current_credit": "الرصيد الحالي",
    "barcode_search": "بحث الباركود",
    "notes": "الملاحظات",
    "name": "ألاسم",
    "cst_number": "كود العميل",
    "max_credit": "اقصي رصيد",
    "user_number": "رقم المستخدم",
    "search": "البحث",
    "barcode": "الباركود",
    "sectoral_price": "سعر القطاعي",
    "normal_price": "السعر بالجملة",
    "total_items": "اجمالي الاصناف",
    "total_items_quantity": "اجمالي كمية الاصناف",
    "total_quantity": "عدد القطع",
    "total_free_qty": "عدد القطع المجانية",
    "error": "خطأ",
    "no_items": "لا يوجد منجات في القائمة",
    //Errors
    "incompatible_id_with_receipts":
        "رقم المستخدم لا يتوافق مع بعض او كل الفواتير الموجودة.",
    "auto_upload_error": "خطا في الرفع التلقائي",
    //Dialogs translation
    "warning": "تحذير",
    "receipt_still_inprogress":
        "هناك فاتورة قيد الانشاء ستمسح ان تراجعت, هل تود الاكمال؟",
    "stay": "البقاء",
    "exit_message": "من فضلك, ضع سبب الالغاء",
    "leaving_reason": "سبب التراجع",
    "confirm": "تاكيد",
    "common_button_title": "العنوان",
    // done_dialog
    "done_dialog_title": "تم بنجاح!",
    "done_dialog_desc": "تمت العملية بنجاح",
    "done_dialog_btn": "شكرا",
    // exit dialog
    "exit_dialog_title": "تأكيد!",
    "exit_dialog_text": " الرجاء ادخال سبب الغاء العملية بالتوضيح",
    "exit_dialog_hint": "سبب الالغاء",
    "exit_dialog_btn_cancel": "الغاء",
    "exit_dialog_btn_ok": "اتمام",
    // options column
    "options_column_alert_text": "لا يوجد منجات في القائمة",
    "options_column_btn_ok_text": "تراجع",
    "options_column_btn_cancel_text": "تاكيد",
    "options_column_warning_text":
        "سيتم مسح المنتجات المختارة, هل تود الاكمال؟",
    "options_column_alert_text_2": "لا يوجد منتجات مختارة للمسح",
    // save dialog
    "save_dialog_title": "تاكيد انشاء عملية جديدة",
    "save_dialog_desc":
        "سيتم انشاء عملية جديدة و وترحيلها في حالة وجود اتصال بالانترنت",
    "save_dialog_first_common_button": "حفظ",
    "save_dialog_second_common_button": "حفظ و مشاركة",
    "save_dialog_third_common_button": "حفظ و طباعة",
    "save_dialog_fourth_common_button": "الغاء",
    // warning dialog
    "warning_dialog_title": "انتبه!",
    // edit price dialog and error dialog
    "edit_price_dialog_title": "تعديل السعر",
    "edit_price_dialog_first_text": "اقل سعر بيع",
    "edit_price_dialog_second_text": "سعر المنتج",
    "edit_price_dialog_third_text": "السعر الجديد",
    "edit_price_dialog_error": "خطا",
    "edit_price_dialog_done": "تم",
    // forgot password dialog
    "forgot_password_dialog_alert_text": "اعادة تعين كلمة السر",
    "forgot_password_dialog_first_hint_text": "ادخل الip الخاص بك",
    "forgot_password_dialog_second_hint_text": "ادخل رقم التعريف الخاص بك",
    "forgot_password_dialog_third_hint_text": "ادخل كلمة السر الرئيسية",
    "forgot_password_dialog_exit_btn": "دخول",
    "loading_dialog_alert_text": "جاري المعالجة",
    //  return dialog
    "return_dialog_title": "نوع المرتجع",
    "return_dialog_first_type": "مرتجع جزئي",
    "return_dialog_second_type": "مرتجع الفاتورة بالكامل",
    "return_dialog_third_type": "مرتجع الفاتورة و عمل فاتورة جديدة",
    "return_dialog_close": "اغلاق",
    "part_return_text": "لا يوجد منتجات للارجاع",
    "full_return_text": "تم عمل فاتورة مرتجع",
    // select receipt dialog
    "select_receipt_dialog_hint_text": "بحث",
    "select_receipt_dialog_number": "الرقم",
    "select_receipt_dialog_name": "اسم العميل",
    "select_receipt_dialog_net": "صافي الفاتورة",
    "select_receipt_dialog_date": "التاريخ",
    "select_receipt_dialog_time": "الوقت",
    "select_receipt_dialog_Pay": "السداد",
    "select_receipt_dialog_type": "نوع الفاتورة",
    "select_receipt_dialog_deported": "تم الترحيل",
    "select_receipt_dialog_yes": "نعم",
    "select_receipt_dialog_No": "لا",
    "select_receipt_dialog_data_row_text":
        "هل ترغب بملئ المنتجات من هذه الفاتورة؟",
  };

  @override
  Map<String, Map<String, String>> get keys => {'en': english, 'ar': arabic};
}
