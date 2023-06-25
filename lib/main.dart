import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'V2Pack',
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fade,
      theme: ThemeData(
        fontFamily: 'Ubuntu',
        scaffoldBackgroundColor: const Color(0xfff5f5f5),
        useMaterial3: true
      ),
        getPages: [
        GetPage(
          name: '/home',
          page: () => const HomePage(),
          binding: HomeBinding(),
        ),
      ],
      initialRoute: '/home',
    );
  }
}
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
          () => HomeController(),
    );
  }
}

class HomeController extends GetxController {
  final RxString v2raybase64 = 'Test Text'.obs;
  
  Future<void> openUrl(String url) async {
    final Uri u = Uri.parse(url);
    if (!await launchUrl(u,mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $u');
    }
  }
  Future<bool> getV2ray() async {
    final dio = Dio();
    try{
      final response = await dio.get('https://raw.githubusercontent.com/yebekhe/TelegramV2rayCollector/main/sub/mix_base64');
      v2raybase64.value = response.data;
      if(v2raybase64.value.isNotEmpty || v2raybase64.value != ''){
        Clipboard.setData(ClipboardData(text: v2raybase64.value));
        return true;
      }
      return false;
    }catch(e){
      return false;
    }
  }
}

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('V2Pack', style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5,),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height * 0.2,
            child: Column(
              children: [
                Text('This is an android app for', style: TextStyle(fontSize: size.width * 0.075,fontWeight: FontWeight.normal),textAlign: TextAlign.center),
                TextButton(
                  child: Text('TelegramV2rayCollector', style: TextStyle(color: Colors.blueAccent,fontSize: size.width * 0.07,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                  onPressed: () => controller.openUrl('https://github.com/yebekhe/TelegramV2rayCollector'),
                ),
              ]
            ),
          ),
          SizedBox(
            height: size.height * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Click the button below to get the links and add them to the V2RayNG App', style: TextStyle(fontSize: size.width * 0.06,fontWeight: FontWeight.normal),textAlign: TextAlign.center),
                  Container(
                    width: size.width * 0.25,
                    height: size.width * 0.25,
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.all(Radius.circular(50))
                    ),
                    child: IconButton(onPressed: () async {
                      if(await controller.getV2ray()){
                        Get.snackbar('Data received successfully', 'Import the data into the V2RayNG App',backgroundColor: Colors.amber,snackPosition:SnackPosition.BOTTOM,duration: const Duration(seconds: 5));
                      }
                      Get.snackbar('Data not received', 'Check your internet',backgroundColor: Colors.amber,snackPosition:SnackPosition.BOTTOM,duration: const Duration(seconds: 5));
                    }, icon: const FaIcon(FontAwesomeIcons.copy,color: Colors.white)),
                  )

                ]
            ),
          ),
          TextButton(
            child: Text('Source App', style: TextStyle(fontSize: size.width * 0.06,fontWeight: FontWeight.w300),textAlign: TextAlign.center),
            onPressed: () => controller.openUrl('https://github.com/hossienhunta'),
          ),

        ],
      ),),
    ));
    throw UnimplementedError();
  }
}
