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
    "select_printer": "???????? ??????????????",
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
    "document created successfully": "???? ?????????? ?????????? ??????????",
    "error with the login attempt": "?????? ???? ???????????? ??????????????",
    "server connection error": "?????? ???? ?????????????? ??????????????",
    "do you really want to move this operation out of recycle pin":
        "???? ?????? ?????? ?????????? ???????????????? ???? ?????? ???????????????? ??",
    "recycle bin": "?????? ????????????????",
    "do you really want to move this operation to recylce pin":
        "???? ?????? ?????? ?????? ?????? ?????????????? ??????????????",
    "this quantity is bigger than allowed": "?????? ???????????? ???????? ???? ???????????? ??????????????",
    "seizure from": "?????????????? ????",
    "payment from": "?????????? ????",
    "employee id": "?????? ????????????",
    "employee payment document": "?????? ?????? ????????",
    "employee seizure document": "?????? ?????? ????????",
    "use shifts": "?????????????? ??????????????",
    "cashier settings": "?????????????? ??????????????",
    "default length is 1": "?????????? ?????????????????? 1",
    "show offers": "?????????? ????????????",
    "product tile height": "?????? ???????? ????????????",
    "products grid count": "?????? ???????????????? ?????????? ????????????",
    "address": "??????????????",
    "phone": "????????????",
    "add product": "?????????? ????????",
    "stor id": "?????? ????????????",
    "offers": "????????????",
    "types": "??????????????",
    "receipt is bending":
        '???????? ???????????? ?????? ?????????????? ?????????? ???? ????????????, ???? ?????? ??????????????',
    "SocketException: Failed host lookup: 'sky3m.duckdns.org' (OS Error: No address associated with hostname, errno = 7)":
        "???? ?????????? ??????  ???????????? ?????????????? ???? ???????? ????????????",
    "repeated": "??????????",
    "cancel": "??????????",
    "allow shift": "?????????????? ???????????? ??????",
    "banking": "??????????",
    "shift start time": "?????? ?????????? ????????????",
    "shift end time": "?????? ?????????? ????????????",

    "records": "??????????",
    "new_rec": "?????? ????????",
    "allow_stor_transfer": "???????????? ???????? ?????????? ??????????",
    "stor_transfer": "?????????? ????????",
    "general_settings": "?????????????? ???????????? ????????????",
    "allow_new_rec": "???????????? ???????? ?????? ????????",
    "info_settings": "?????????????? ??????????????????",
    "allow_view_kinds": "???????????? ?????????????? ??????????????",
    "allow_view_mows": "???????????? ?????????????? ????????????????",
    "allow_view_expenses": "???????????? ?????????????? ??????????????????",
    "allow_view_clients": "???????????? ?????????????? ??????????????",
    "allow_view_items": "???????????? ?????????????? ??????????????",
    "allow_view_operations": "???????????? ?????????????? ????????????????",
    "allow_view_groups": "???????????? ?????????????? ??????????????????",
    "allow_view_stors": "???????????? ?????????????? ??????????????",
    "allow_expenses_seizure_document": "???????????? ???????? ?????? ?????? ??????????????",
    "allow_expenses_document": "???????????? ???????? ?????? ?????? ??????????????",
    "allow_purchase_return_receipt": "???????????? ???????? ???????????? ?????????? ????????",
    "allow_purchase_receipt": "???????????? ???????? ???????????? ????????",
    "allow_mow_payment_document": "???????????? ???????? ?????? ?????? ????????",
    "allow_mow_seizure_document": "???????????? ???????? ?????? ?????? ????????",
    "allow_purchase_order": "???????????? ???????? ?????? ????????",
    "group_code": "?????? ????????????????",
    "mow_seizure_document": "?????? ?????? ????????????????",
    "mow_payment_document": "?????? ?????? ????????????????",
    "purchase_order": "?????? ????????",
    "expenses_seizure_document": "?????? ?????? ??????????????",
    'kind_code': "?????? ??????????",
    "stor_code": " ?????? ????????????",
    "groups": "??????????????",
    "stors": "??????????",
    "kinds": "??????????",
    "mows": "????????????",
    "expenses": "??????????????",
    "purchase": '????????',
    "purchase_return": "?????????? ????????",
    "purchase_return_receipt": "???????????? ?????????? ??????????????",
    "purchase_receipt": "???????????? ??????????????",
    "receipts": "????????????????",
    "reports": "????????????",
    "documents": "??????????????",
    "choose_stor": "???????? ????????????",
    "general": "??????",
    "paid_expenses": "?????????????????? ????????????????",
    "expenses_document": "?????? ??????????????",
    "position_instructions":
        "(???????? ?????????? ?????? ???????????? ?????????????? ?? ???????? ???????????? ???????? ??????????)",
    "postion_elements": "?????????? ?????????? ??????????????",
    "a4_settings": "?????????????? ?????? a4",
    "connecting_error": "?????? ???? ?????????????? ????????????????",
    "select_printer": "???????? ??????????????",
    "cashier_details_space": "?????????? ?????????????? ????????????????",
    "categories_space": "?????????? ??????????????",
    "cashier_receipt_spaces": "???????????? ???????? ???????????? ??????????????",
    "products_space": "?????????? ???????????????? ????????????????",
    "cashier_receipt_settings": "?????????????? ???????????? ??????????????",
    "show_cashier_details": "?????????? ?????????????? ????????????????",
    "allow_cashier_receipt": "???????????? ?????????????? ??????????",
    "options": "????????????????",
    "language": "??????????",
    "cashier_receipt": "???????????? ??????????",
    "customer": "????????????",
    "employee": "????????????",
    "tax_number": "?????????? ??????????????",
    "receipt": "????????????",
    "sales_receipt_name": "?????? ???????????? ????????????????",
    "return_receipt_name": "?????? ???????????? ??????????????",
    "seizure_doc_name": "?????? ?????? ??????????",
    "payment_doc_name": "?????? ?????? ??????????",
    "custom_names": "?????????????? ???????????? ???????????? ??????????????????",
    "box_name": "?????? ??????????",
    "enter_name": "???????? ??????????",
    "doc_number": "?????? ??????????",
    "bank_name": "?????? ??????????",
    "enter_amount": "???????? ????????????",
    "doc_history": "?????????? ??????????",
    "doc_paid_amount": "???????????? ??????????????",
    "doc_received_amount": "???????????? ??????????????",
    "new_document": "?????????? ?????? ????????",
    "enter_notes": "???????? ????????????????",
    "english": "????????????????????",
    "arabic": "??????????????",
    "amount_more_than": "???????? ???????? ????",
    "amount_less_than": "???????? ?????? ????",
    "no_items_found": "???? ???????? ?????????? ?????????? ?????? ????????????",
    "last_items_update": "?????????? ?????? ?????????????? ??????????????",
    "last_clients_update": "?????????? ?????? ?????????????? ??????????????",
    "total_discounts": "?? ??????????????",
    "total_additions": "?? ??????????????",
    "total_tax": "?? ??????????????",
    "total_value": "?? ????????????",
    "total_cash": "?? ????????????",
    "all": "????????",
    "last_upload_date": "?????????? ?????? ??????????",
    "quantity_before": "???????????? ??????",
    "quantity_remaining": "???????????? ????????????????",
    "ok": "????",
    "can't_get_yet": "?????? ?????????? ???????????????????? ??????",
    "no_request_found": "???? ?????? ?????? ?????? ??????",
    "update_successful": "???? ?????????? ?????????????? ?? ?????????????? ??????????",
    "operations_deleted": "???? ?????? ???????????????? ??????????",
    "operations_not_exported_yet": "?????? ???????????????? ???? ?????? ?????????? ?????? ????????????",
    "reload_successful": "???? ?????????????? ?????????????? ?? ?????????????? ?? ?????? ???????????????? ??????????",
    "operations_not_uploaded_yet":
        "?????? ???????????????? ???? ?????? ??????????????, ???????? ???? ?????????????? ?? ???????? ??????????",
    "operations_removed_request_made":
        "???? ?????? ???????????????? ?? ?????????? ?????? ???????? ?? ???????? ??????????????",
    "wait": "????????",
    "avg_selling_price": "?????????? ?????? ????????????",
    "last_selling_price": "?????? ?????? ????????",
    "qty_error": "???? ???????? ???????????? ???????????? ???????? ?????????? ?????? ???? ??????",
    "employee_number": "?????? ????????????",
    "seizure_method": "?????????? ??????????",
    "payment_method": "?????????? ??????????",
    "choose_customer": "???????? ????????????",
    "bank_transfer": "?????????? ????????",
    "finish": "??????????",
    "max_debt": "???????? ??????????????",
    "sales": "????????????",
    "visit": "??????????",
    "return": "??????????",
    "inventory": "??????",
    "total": "????????",
    "final_value": "????????????????",
    "operation_type": "?????? ??????????????",
    "uploaded": "???? ??????????????",
    "paid_by": "?????????? ???? ????????????",
    "received_from": "?????????????? ???? ????????????",
    "cst_code": "?????? ????????????",
    "remaining_qty": "???????????? ????????????????",
    "back": "??????????",
    "price_less_than_least":
        "?????? ???????? ?????????????? ???????????? ?????????? ?????? ?????? ???? ???????? ????????????",
    "not_items_to_discard": "???? ???????? ???????????? ???????????? ??????????",
    "discard_confirm": "???????? ?????? ???????????????? ????????????????, ???? ?????? ????????????????",
    "total_credit": "?????????? ??????????????",
    //Settings translation
    "enter": "????????",
    "account": "????????????",
    "settings": "??????????????????",
    "forgot_password": "???????? ???????? ????????",
    "enter_username": "???????? ?????? ????????????????",
    "enter_password": "???????? ???????? ???????? ???????????? ????",
    "enter_api_password": "???????? ???????????? ????API",
    "api_address": "?????????? ????API",
    "api_password": "???????? ???? ????API",
    "user_id": "?????????? ???????????????? ????????????????",
    "device_id": "?????? ????????????",
    "account_settings": "?????????????? ????????????",
    "settings_warning":
        "?????????? ?????? ???????????????? ?????? ?????????? ???????????? ?? ?????? ?????????? ????????????????",
    "receipt_settings": "?????????????? ????????????????",
    "receipts_naming": "???????????? ????????????????",
    "company_elements": "?????????? ????????????",
    "company_name": "??????",
    "company_address": "?????????? ????????????",
    "company_tax": "?????? ???????????? ??????????????",
    "operation_elements": "?????????? ??????????????",
    "receipt_number": "?????? ????????????????",
    "receipt_date": "?????????? ????????????????",
    "employee_name": "?????? ????????????",
    "customer_name": "?????? ????????????",
    "customer_tax": "?????? ???????????? ??????????????",
    "paid_amount": "???????????? ????????????",
    "remaining_amount": "???????????? ????????????",
    "credit_before": "???????????? ??????",
    "credit_after": "???????????? ??????",
    "doc_elements": "?????????? ??????????????",
    "ask_visit": "?????? ?????????? ?????????? ?????? ???????????? ???? ???? ?????????? ???? ???????? ?????? ??????????????",
    "allow_sales_receipt": "???????????? ???????? ???????????? ????????????",
    "allow_return_receipt": "???????????? ???????? ???????????? ??????????",
    "allow_payment_doc": "???????????? ???????? ?????? ??????",
    "allow_collection_doc": "???????????? ???????? ?????? ??????",
    "allow_inventory_doc": "???????????? ???????? ??????",
    "allow_selling_order": "???????????? ???????? ?????? ??????",
    "printing_settings_head": "???????? ???????????? ???? ?????????? ?????????? ???? ??????????????",
    "printing_elements": "?????????? ??????????????",
    "click_to_change": "???????? ??????????????",
    "app_settings": "?????????????? ????????????????",
    "server_options": "?????????????? ??????????????",
    "operations_settings": "?????????????? ????????????????",
    "operations_settings_head": "(?????????? ???????????? ?????????? ????????????)",
    "must_login": "?????? ?????????????? ???????? ??????????????",
    "settings_back_warning": "(???????? ?????? ?????????????????? ?????????????? ?????? ????????????)",
    "seizure_document": "?????? ??????",
    "payment_document": "?????? ??????",
    "return_receipt": "???????????? ??????????",
    "sales_receipt": "???????????? ????????????",
    "selling_order": "?????? ??????",
    "inventory_receipt": "???????????? ??????",
    "clients": "??????????????",
    "operations": "????????????????",
    "items": "??????????????",
    "view_operations": "?????? ????????????????",
    "request_reload": "?????? ?????????? ?????????? ???????? ?? ?????? ????????????????",
    "update_items_accounts": "?????????? ?????????????? ?? ????????????????  ",
    "update_items_accounts_with_amount":
        "?????????? ?????????????? ?? ???????????????? ???? ?????????????? ?? ??????????????    ",
    "exit": "????????",
    //Receipt translation
    //?????? ???????? ?????????????? ???????????? ?????? ???????????? ?????? ???????? ?????? ???? ?????? ?????? ??????
    "price_less_than_selling_price":
        "?????? ???????? ?????????????? ???????????? ?????? ???????????? ?????? ???????? ?????? ???? ?????? ?????? ??????",
    "bad_barcode": "???? ???????? ???????? ???????? ??????????",
    "search_barcode": "?????? ??????????????????",
    "loading": "??????????",
    "date": "??????????????",
    "time": "??????????",
    "number": "??????",
    "cash": "????????",
    "instant": "??????",
    "unit": "????????",
    "item": "??????????",
    "qty": "????????????",
    "price": "??????????",
    "discount": "??????????",
    "value": "????????????",
    "free_qty": "?? ????????????",
    "previous_credit": "???????????? ????????????",
    "receipt_total": "?? ????????????????",
    "addition": "??????????????",
    "tax": "??????????????",
    "receipt_value": "?? ????????????????",
    "remaining": "??????????????",
    "current_credit": "???????????? ????????????",
    "barcode_search": "?????? ????????????????",
    "notes": "??????????????????",
    "name": "??????????",
    "cst_number": "?????? ????????????",
    "max_credit": "???????? ????????",
    "user_number": "?????? ????????????????",
    "search": "??????????",
    "barcode": "????????????????",
    "sectoral_price": "?????? ??????????????",
    "normal_price": "?????????? ??????????????",
    "total_items": "???????????? ??????????????",
    "total_items_quantity": "???????????? ???????? ??????????????",
    "total_quantity": "?????? ??????????",
    "total_free_qty": "?????? ?????????? ????????????????",
    "error": "??????",
    "no_items": "???? ???????? ?????????? ???? ??????????????",
    //Errors
    "incompatible_id_with_receipts":
        "?????? ???????????????? ???? ???????????? ???? ?????? ???? ???? ???????????????? ????????????????.",
    "auto_upload_error": "?????? ???? ?????????? ????????????????",
    //Dialogs translation
    "warning": "??????????",
    "receipt_still_inprogress":
        "???????? ???????????? ?????? ?????????????? ?????????? ???? ????????????, ???? ?????? ????????????????",
    "stay": "????????????",
    "exit_message": "???? ????????, ???? ?????? ??????????????",
    "leaving_reason": "?????? ??????????????",
    "confirm": "??????????",
    "common_button_title": "??????????????",
    // done_dialog
    "done_dialog_title": "???? ??????????!",
    "done_dialog_desc": "?????? ?????????????? ??????????",
    "done_dialog_btn": "????????",
    // exit dialog
    "exit_dialog_title": "??????????!",
    "exit_dialog_text": " ???????????? ?????????? ?????? ?????????? ?????????????? ????????????????",
    "exit_dialog_hint": "?????? ??????????????",
    "exit_dialog_btn_cancel": "??????????",
    "exit_dialog_btn_ok": "??????????",
    // options column
    "options_column_alert_text": "???? ???????? ?????????? ???? ??????????????",
    "options_column_btn_ok_text": "??????????",
    "options_column_btn_cancel_text": "??????????",
    "options_column_warning_text":
        "???????? ?????? ???????????????? ????????????????, ???? ?????? ????????????????",
    "options_column_alert_text_2": "???? ???????? ???????????? ???????????? ??????????",
    // save dialog
    "save_dialog_title": "?????????? ?????????? ?????????? ??????????",
    "save_dialog_desc":
        "???????? ?????????? ?????????? ?????????? ?? ???????????????? ???? ???????? ???????? ?????????? ??????????????????",
    "save_dialog_first_common_button": "??????",
    "save_dialog_second_common_button": "?????? ?? ????????????",
    "save_dialog_third_common_button": "?????? ?? ??????????",
    "save_dialog_fourth_common_button": "??????????",
    // warning dialog
    "warning_dialog_title": "??????????!",
    // edit price dialog and error dialog
    "edit_price_dialog_title": "?????????? ??????????",
    "edit_price_dialog_first_text": "?????? ?????? ??????",
    "edit_price_dialog_second_text": "?????? ????????????",
    "edit_price_dialog_third_text": "?????????? ????????????",
    "edit_price_dialog_error": "??????",
    "edit_price_dialog_done": "????",
    // forgot password dialog
    "forgot_password_dialog_alert_text": "?????????? ???????? ???????? ????????",
    "forgot_password_dialog_first_hint_text": "???????? ????ip ?????????? ????",
    "forgot_password_dialog_second_hint_text": "???????? ?????? ?????????????? ?????????? ????",
    "forgot_password_dialog_third_hint_text": "???????? ???????? ???????? ????????????????",
    "forgot_password_dialog_exit_btn": "????????",
    "loading_dialog_alert_text": "???????? ????????????????",
    //  return dialog
    "return_dialog_title": "?????? ??????????????",
    "return_dialog_first_type": "?????????? ????????",
    "return_dialog_second_type": "?????????? ???????????????? ??????????????",
    "return_dialog_third_type": "?????????? ???????????????? ?? ?????? ???????????? ??????????",
    "return_dialog_close": "??????????",
    "part_return_text": "???? ???????? ???????????? ??????????????",
    "full_return_text": "???? ?????? ???????????? ??????????",
    // select receipt dialog
    "select_receipt_dialog_hint_text": "??????",
    "select_receipt_dialog_number": "??????????",
    "select_receipt_dialog_name": "?????? ????????????",
    "select_receipt_dialog_net": "???????? ????????????????",
    "select_receipt_dialog_date": "??????????????",
    "select_receipt_dialog_time": "??????????",
    "select_receipt_dialog_Pay": "????????????",
    "select_receipt_dialog_type": "?????? ????????????????",
    "select_receipt_dialog_deported": "???? ??????????????",
    "select_receipt_dialog_yes": "??????",
    "select_receipt_dialog_No": "????",
    "select_receipt_dialog_data_row_text":
        "???? ???????? ???????? ???????????????? ???? ?????? ??????????????????",
  };

  @override
  Map<String, Map<String, String>> get keys => {'en': english, 'ar': arabic};
}
