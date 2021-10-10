import 'dart:math';
import 'package:intl/intl.dart';

class CommonUtil {
  static DateTime getUtcNow() {
    return DateTime.now().toUtc();
  }

  static int boolToInt(bool data) {
    return data ? 1 : 0;
  }

  static bool intToBool(int data) {
    return data == 1 ? true : false;
  }

  static String dateTimeToString(DateTime data) {
    DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
    return formatter.format(data);
  }

  static double getBusinessCardWidth(double scrHeight, double scrWidth) {
    return scrHeight > scrWidth ? scrWidth : scrHeight;
  }

  static int getWeightRandomIndex(List<int> weights) {
    final int totalWeight = weights.reduce((value, element) => value + element);
    final int randomValue = Random().nextInt(totalWeight);
    int index = weights.length - 1;
    int currentWeights = 0;
    for (int i = 0; i < weights.length; i++) {
      currentWeights += weights[i];
      if (currentWeights >= randomValue) {
        index = i;
        break;
      }
    }
    return index;
  }

  static int stringLengthCheck(int minLength, int maxLength, String source) {
    if (source.length > maxLength) {
      return source.length - maxLength;
    } else if (source.length < minLength) {
      return source.length - maxLength;
    }
    return 0;
  }

  static bool stringIllegalCharCheck(List<String> illegalChars, String source) {
    for (int i = 0; i < source.length; i++) {
      if (illegalChars.contains(source[i])) {
        return false;
      }
    }
    return true;
  }

  static String encodeCsv(List<String> items) {
    final List<String> tmpItems = [];
    items.forEach((item) {
      String tmp = item.replaceAll('\"', '\"\"');
      tmpItems.add('\"$tmp\"');
    });
    return tmpItems.join(',') + '\n';
  }

  static List<String> decodeCsv(String data) {
    final List<String> tmpItems = [];
    final StringBuffer buffer = StringBuffer();
    bool isContent = false;
    int contentLength = 0;
    for (int i = 0; i < data.length; i++) {
      final String ch = data[i];
      if (ch == '\"') {
        if (isContent == false) {
          isContent = true;
          contentLength = 0;
          continue;
        }
        if (data.length > i + 1) {
          if (data[i + 1] == '\"') {
            continue;
          }
        }
        if (i > 0 && data[i - 1] == '\"') {
          if (contentLength > 0) {
            buffer.write(ch);
            continue;
          }
          buffer.write('');
        }
        isContent = false;
        tmpItems.add(buffer.toString());
        buffer.clear();
        continue;
      } else if (ch == ',') {
        if (isContent) {
          buffer.write(ch);
        }
        continue;
      } else if (ch == '\n') {
        if (isContent == false) {
          break;
        }
      }
      if (isContent) {
        buffer.write(ch);
        contentLength++;
      }
    }
    return tmpItems;
  }
}
