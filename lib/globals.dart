// import "package:flutter/services.dart";

// Future getIp() async => await rootBundle.loadString("assets/ip.txt");
// late String ip;
// final urlApi = "http://$ip/latihan_crud/alumni.php";
// final urlGambar = "http://$ip/latihan_crud/foto/";

// globals.dart
import "package:flutter/services.dart";

late String ip;

Future<void> initIp() async {
  ip = (await rootBundle.loadString("assets/ip.txt")).trim();
}

String get urlApi => "http://$ip/latihan_crud/alumni.php";
String get urlGambar => "http://$ip/latihan_crud/foto";
