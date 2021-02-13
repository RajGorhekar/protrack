import 'dart:math';

class Utils {
  static String capitalize(String s) {
    if (s.trim() == "") return "";
    return s
        .trim()
        .split(" ")
        .map((str) =>
            str[0].toString().toUpperCase() +
            str.toString().substring(1).toLowerCase())
        .join(" ");
  }

  static String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890123456789012345678901234567890123456789012345678901234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

}
