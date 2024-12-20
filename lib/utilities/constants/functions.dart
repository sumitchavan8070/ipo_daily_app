import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ipodaily/utilities/constants/assets_path.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

var logger = Logger();

String getLogoPath(String word) {
  String firstLetter = word[0].toUpperCase();
  switch (firstLetter) {
    case 'A':
      return AssetPath.aLogo;
    case 'B':
      return AssetPath.bLogo;
    case 'D':
      return AssetPath.dLogo;
    case 'E':
      return AssetPath.eLogo;
    case 'F':
      return AssetPath.fLogo;
    case 'G':
      return AssetPath.gLogo;
    case 'H':
      return AssetPath.hLogo;
    case 'I':
      return AssetPath.iLogo;
    case 'J':
      return AssetPath.jLogo;
    case 'K':
      return AssetPath.kLogo;
    case 'L':
      return AssetPath.lLogo;
    case 'M':
      return AssetPath.mLogo;
    case 'N':
      return AssetPath.nLogo;
    case 'O':
      return AssetPath.oLogo;
    case 'P':
      return AssetPath.pLogo;
    case 'Q':
      return AssetPath.qLogo;
    case 'R':
      return AssetPath.rLogo;
    case 'S':
      return AssetPath.sLogo;
    case 'T':
      return AssetPath.tLogo;
    case 'U':
      return AssetPath.uLogo;
    case 'V':
      return AssetPath.vLogo;
    case 'W':
      return AssetPath.wLogo;
    default:
      return AssetPath.wLogo;
  }
}

String getDrawerLogo(String title) {
  switch (title) {
    case 'IPO GMP':
      return AssetPath.gmp;
    case 'IPO Subscription':
      return AssetPath.subs;
    case 'Upcoming IPO':
      return AssetPath.mainBoard;
    case 'SME IPO':
      return AssetPath.sme;
    case 'BuyBack IPO':
      return AssetPath.buyBack;
    case 'IPO Forms':
      return AssetPath.forms;
    case 'Terms & Conditions':
      return AssetPath.terms;
    case 'Privacy Policy':
      return AssetPath.policy;
    case 'Contact Us':
      return AssetPath.call;
    default:
      return AssetPath.mainBoard;
  }
}

String convertDate(String dateString, {bool showYear = true}) {
  try {
    DateTime date;

    if (dateString.contains('T')) {
      date = DateTime.parse(dateString);
    } else {
      date = DateTime.parse(dateString);
    }

    DateFormat outputFormat = showYear ? DateFormat('MMM d, yyyy') : DateFormat('MMM d');
    String formattedDate = outputFormat.format(date);

    return formattedDate;
  } catch (e) {
    return 'Invalid date format';
  }
}

class TextOnlyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final filteredText = newValue.text.replaceAll(RegExp('[^a-zA-Z]'), '');
    return newValue.copyWith(
      text: filteredText,
      selection: newValue.selection,
    );
  }
}

String format2INR(dynamic amount, {bool removeAllAfterDecimal = true}) {
  final numericAmt = double.tryParse('$amount');
  if (amount == null || amount == '') {
    return "-";
  }

  String formattedAmount = NumberFormat.currency(locale: 'en_IN', symbol: '₹')
      .format(numericAmt)
      .eliminateLast(removeLength: 3);

  if (removeAllAfterDecimal) {
    formattedAmount = formattedAmount.split('.').first;
  }

  return formattedAmount;
}

String formatNumber(num number) {
  if (number >= 10000000) {
    return '${(number / 10000000).toStringAsFixed(2)} Crore'; // Crores
  } else if (number >= 100000) {
    return '${(number / 100000).toStringAsFixed(2)} Lacs'; // Lacs
  } else if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(2)}k'; // Thousands
  } else {
    return number.toString(); // No formatting
  }
}

extension StringExtendion on String? {
  String eliminateLast({required int removeLength}) {
    if (this != null && this?.isNotEmpty == true) {
      return '$this';
    }
    return this!.substring(0, this!.length - removeLength);
  }

  String toPercent({bool removeDecimal = false}) {
    try {
      if (this != null) {
        String originalString = '$this';

        if (originalString.contains('%')) {
          return originalString;
        }

        if (originalString.contains('.')) {
          List<String> parts = originalString.split('.');

          if (removeDecimal) {
            return '${parts[0]}%';
          }
          if (parts.length == 2) {
            String decimalPart =
                parts[1].length >= 2 ? parts[1].substring(0, 2) : parts[1].padRight(2, '0');
            return '${parts[0]}.$decimalPart%';
          }
        }

        return '$originalString%';
      } else {
        return '-';
      }
    } catch (e) {
      debugPrint("Error: Input is not a valid number");
      return '-';
    }
  }
}

String getBuyBackName(String name) {
  String modifiedString = name.replaceAll('_', ' ');
  String finalString = "${modifiedString.split('BUYBACK')[0].trim()} BUYBACK";
  return finalString;
}

launchEmail({String? email}) async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: email,
    query: Uri.encodeFull(
        'subject=Request for Assistance&body=Hello Team,\n\nI hope this message finds you well. I would like to request assistance with the following:\n\n'),
  );

  if (await launchUrl(emailLaunchUri, mode: LaunchMode.externalApplication)) {
    await canLaunchUrl(
      emailLaunchUri,
    );
  } else {
    debugPrint("Could not launch email");
  }
}
