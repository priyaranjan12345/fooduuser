import 'package:hive/hive.dart';

Future<bool> checkFirstTime() async {
  var box = await Hive.openBox("firsttimechecker");
  var isfirsttime = false;
  if (await box.get("isFirstTime") == null) {
    isfirsttime = true;
  } else {
    isfirsttime = false;
  }
  return isfirsttime;
}

Future<bool> writeFirstTime() async {
  var box = await Hive.openBox("firsttimechecker");
  try {
    await box.put("isFirstTime", true);
    return true;
  } catch (e) {
    return false;
  }
}
