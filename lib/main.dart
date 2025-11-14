import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await Hive.openBox('favoritesBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(home: HomePage(), debugShowCheckedModeBanner: false);
  }
}





/* 
  final songs = [
    'Add Elly Kano.ogg',
    'Ah Habayeb.ogg',
    'Alb El Asheq Daleiloh.ogg',
    'Allam Aalby El Shoq.ogg',
    'Ana Asef.ogg',
    'Ana Msafer.ogg',
    'Ana Rady Bel Sahar.ogg',
    'Ansak.ogg',
    'Asab Firaq.ogg',
    'Ba7lam Beek.ogg',
    'Bastanna Bel Youm Wel Youmen.ogg',
    'Benfakkar Bel Nas.ogg',
    'Bism El Hob El Gameel.ogg',
    'Bye7sidouni.ogg',
    'Byetkallem Aalaya.ogg',
    'Debna Ala Ghyabak.ogg',
    'Dol Mish Habayeb.ogg',
    'El Asheq Mennna.ogg',
    'El Awazel.ogg',
    'El Ayyam Di Saaba Shwaya.ogg',
    'El Dahab Ya Habibi.ogg',
    'El Forqa Saaba.ogg',
    'El Ghali Aleina Ghali.ogg',
    'El Hob El Awalani.ogg',
    'El Hob El Kbeer.ogg',
    'El Kelma El Tayyeba.ogg',
    'El Sabr Tayeb.ogg',
    'El Zaman Dawwar.ogg',
    'Enta Gheirhom.ogg',
    'Ermi El Shabak.ogg',
    "Eta'akhart Kteer.ogg",
    'Ghadr Nas.ogg',
    'Habibi Keda.ogg',
    'Habibi W El Zaman.ogg',
    'Hadd Yensa Aalbo.ogg',
    'Hal El Garih.ogg',
    'Halaf El Qamar.ogg',
    'Haneenak Haneen.ogg',
    'Harmna Men Onsak Leh.ogg',
    'Heya El Ayyam.ogg',
    'Kalam El Nas.ogg',
    'Kalamak Ya Habibi.ogg',
    'Keda Kifaya.ogg',
    'Khadni El Haneen.ogg',
    'Khesert Koul El Nass.ogg',
    'Kol Youm.ogg',
    'Kollena Magaree7.ogg',
    'La Troo7.ogg',
    'Laab El Hawa.ogg',
    'Laabet Nazar.ogg',
    'Law Kol Asheq.ogg',
    'Law Ywaedna El Hawa.ogg',
    'Leh Tehrabi.ogg',
    'Leil El Ashekin.ogg',
    'Leilet Wadaana.ogg',
    'Lel Hawa Ahkam.ogg',
    'Lessa El Donia Bekheir.ogg',
    'Ma Taoolo Leh.ogg',
    'Maliket Gamal El Rouh.ogg',
    'Men Hena W Rayeh.ogg',
    'Meshina Ya Habibi.ogg',
    'Mestanny Menny Eih.ogg',
    'Negm Aali.ogg',
    'Noss Omry.ogg',
    'Oshaa Akher Zaman.ogg',
    'Qadari W Naseebi.ogg',
    'Qouly El Kelmetein.ogg',
    'Raksa Espani.ogg',
    "Roholo W Es'alo.ogg",
    'Rouhi Ya Nasma.ogg',
    'Sa7i El Leil.ogg',
    'Saber W Rady.ogg',
    'Salaf W Dein.ogg',
    'Seebhom.ogg',
    'Sehert El Layel.ogg',
    'Shokran.ogg',
    'Tabeeb Garah.ogg',
    'Takhsar Rehanak.ogg',
    'Ya Al Zaman.ogg',
    'Ya Bayyaeen El Hawa.ogg',
    'Ya Einy Ah Law Taarefo.ogg',
    'Ya Leil El Ashekin.ogg',
    'Yalli Gamalak.ogg',
    'Yom El Wadaa.ogg',
    'Zaman El Agayeb.ogg',
  ];
*/