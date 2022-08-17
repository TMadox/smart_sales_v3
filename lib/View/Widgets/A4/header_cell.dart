import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:smart_sales/App/Resources/values_manager.dart';

headerCell({
  required receipt,
  required Font arabic,
  double width = 70,
  required String key,
  required String name,
  bool visible = true,
}) =>
    Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
          ),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(border: Border.all(color: PdfColors.black)),
          child: Text(
            ValuesManager.doubleToString(receipt[key]),
            style: TextStyle(
              font: arabic,
            ),
          ),
        ),
        visible
            ? Container(
                width: width,
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(1),
                  ),
                  border: Border.all(
                    color: PdfColors.black,
                  ),
                ),
                child: Text(
                  name,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    font: arabic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : SizedBox(
                width: width,
              ),
      ],
    );
