import 'dart:convert';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:telegram/telegram.dart';

Map<String, Map<String, String>> trans = {
  "ru": {
    "Dark": "Темный",
    "Light": "Светлый",
    "name": "Жамалдин Сабиржанов",
    "Email": "Почта",
    "CV": "Скачать резюме",
    "About me": "О себе",
    "about":
        "Самоучка-разработчик мобильных приложений с опытом работы в Unity (C#), Django REST API, Android (Android Studio), Swift и Flutter — специализируется на создании высокопроизводительных кроссплатформенных приложений.",
    "Tech Stack": "Технологии",
    "Projects": "Проекты",
    "1":
        "Amanat Store — это удобный магазин товаров для дома, который предлагает пользователям бонусную систему за покупки.",
    "2":
        'Intex Cargo — это современное приложение для управления грузоперевозками и логистикой.',
    "3":
        'Jerdesh Москва — это современное приложение, которое объединяет поиск жилья и работы в одном месте.',
    "4":
        'Это приложение представляет собой цифровой инструмент, который помогает частным лицам и компаниям управлять своими финансовыми записями и выполнять различные бухгалтерские задачи.',
    "5": 'SindbadCity — маркетплейс товаров из Азии с молниеносной доставкой!',
  },
  "en": {
    "Dark": "Dark",
    "Light": "Light",
    "CV": "Download CV",
    "name": "Jamaldin Sabirjanov",
    "Email": "Email",
    "About me": "About me",
    "about":
        "Self-taught mobile developer with experience in Unity (C#), Django REST APIs, Android (Android Studio), Swift, and Flutter — focused on building performant, cross-platform apps.",
    "Tech Stack": "Tech Stack",
    "Projects": "Projects",
    "1":
        "Amanat Store is a convenient hardware store that offers users a bonus system for purchases.",
    "2":
        'Intex Cargo is a modern application for managing cargo transportation and logistics.',
    "3":
        'Jerdesh Moskva is a modern application that combines search for housing and work in one place.',
    "4":
        'This app is a digital tool that helps individuals and businesses manage their financial records and perform various accounting tasks.',
    "5":
        'SindbadCity — a marketplace for goods from Asia with lightning-fast delivery!',
  },
};

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<StatefulWidget> createState() => _MainApState();
}

class _MainApState extends State<MainApp> {
  bool light = true;
  bool ru = false;
  late double width;
  late Map<String, String> lang;
  final ScrollController _scrollController = ScrollController();
  bool showDownload = false;

  @override
  void initState() {
    super.initState();
    sendMsg();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    lang = trans[ru ? 'ru' : 'en']!;
    return MaterialApp(
      checkerboardOffscreenLayers: false,
      theme: ThemeData(
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: light ? Colors.black : Colors.white),
        ),
      ),
      home: Scaffold(
        backgroundColor: light ? Colors.white : Colors.black,
        body: ListView(
          controller: _scrollController,
          padding: EdgeInsetsGeometry.all(12),
          children: [width > 625 ? desktopView() : mobileView()],
        ),
        floatingActionButton: mContainer(
          padding: EdgeInsets.all(0),
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(light ? lang['Dark']! : lang['Light']!),
                        Switch(
                          activeThumbColor: Colors.grey,
                          value: light,
                          onChanged: (v) {
                            setState(() {
                              light = !light;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(ru ? 'Русский' : 'English'),
                        Switch(
                          activeThumbColor: Colors.grey,
                          value: ru,
                          onChanged: (v) {
                            setState(() {
                              ru = !ru;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  sendMsg() async {
    final pd = WidgetsBinding.instance.platformDispatcher;
    final brightness = pd.platformBrightness;
    setState(() {
      light = brightness == Brightness.light;
    });
    Telegram.setBotToken('7089981734:AAHIl29EclmOW8QAcjejeIrePE_D_agdNrY');
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
    setState(() {
      ru = webInfo.language?.toLowerCase().contains('ru') == true;
    });
    final r = await http.get(Uri.parse('https://api.ipify.org?format=json'));
    final json = jsonDecode(r.body) as Map<String, dynamic>;
    // Send a text message
    Telegram.sendMessage(
      chatId: '@thisisjamaldinchannel',
      text:
          'Someone entered your website\nIp address: ${json['ip']?.toString() ?? 'unknown'}\ndeviceMemory: ${webInfo.deviceMemory}\nuserAgent: ${webInfo.userAgent}\nlanguage: ${webInfo.language}\nvendor: ${webInfo.vendor}',
    );
  }

  Widget desktopView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(children: [me(), tech()]),
        Expanded(child: Column(children: [about(), projects()])),
      ],
    );
  }

  Widget mobileView() {
    return Column(children: [me(), tech(), about(), projects(mobile: true)]);
  }

  Widget me() {
    return mContainer(
      width: 310,
      Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: Image.asset('assets/self.jpg', width: 100, height: 100),
              ),
              SizedBox(height: 12),
              Text(lang['name']!, style: titleStyle()),
              SizedBox(height: 6),
              Text('Flutter developer'),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    child: mContainer(
                      Text('Telegram', textAlign: TextAlign.center),
                      width: 90,
                      padding: EdgeInsets.all(8),
                    ),
                  ),
                  InkWell(
                    child: mContainer(
                      Text(lang['Email']!, textAlign: TextAlign.center),
                      width: 90,
                      padding: EdgeInsets.all(8),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 204,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        launchUrlString(
                          'https://www.linkedin.com/in/thisisjamaldin/',
                        );
                      },
                      child: Image.asset(
                        'assets/ic_linkedin.png',
                        width: 30,
                        color: light ? Colors.black : null,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        launchUrlString('https://github.com/thisisjamaldin/');
                      },
                      child: Image.asset(
                        'assets/ic_git.png',
                        width: 30,
                        color: light ? Colors.black : null,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        launchUrlString(
                          'https://play.google.com/store/apps/dev?id=8970769377791896090/',
                        );
                      },
                      child: Image.asset(
                        'assets/ic_play.png',
                        width: 30,
                        color: light ? Colors.black : null,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        launchUrlString(
                          'https://apps.apple.com/us/developer/zhamoldin-sabirzhanov/id1812576196/',
                        );
                      },
                      child: Image.asset(
                        'assets/ic_apple.png',
                        width: 30,
                        color: light ? Colors.black : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              onHover: (value) {
                if (value != showDownload) {
                  setState(() {
                    showDownload = value;
                  });
                }
              },
              onPressed: downloadResume,
              icon: Icon(
                Icons.download,
                color: light ? Colors.black : Colors.white,
              ),
            ),
          ),
          if (showDownload)
            Positioned(right: -24, top: -20, child: Text(lang['CV']!)),
        ],
      ),
    );
  }

  void downloadResume() {
    final url = ru
        ? 'https://github.com/thisisjamaldin/home/blob/master/cv_ru.pdf?raw=1'
        : 'https://github.com/thisisjamaldin/home/blob/master/cv.pdf?raw=1';
    launchUrlString(url, webOnlyWindowName: '_blank');
  }

  Widget about() {
    return mContainer(
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lang['About me']!, style: titleStyle()),
          SizedBox(height: 12),
          Text(
            lang['about']!,
            // style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget tech() {
    return mContainer(
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lang['Tech Stack']!, style: titleStyle()),
          SizedBox(height: 12),
          SizedBox(
            width: 270,
            child: GridView(
              controller: _scrollController,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
              ),
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/android.png', height: 40),
                    SizedBox(height: 6),
                    Text('Android'),
                  ],
                ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/ios.png', height: 40),
                    SizedBox(height: 6),
                    Text('iOS'),
                  ],
                ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/flutter.png', height: 40),
                    SizedBox(height: 6),
                    Text('Flutter'),
                  ],
                ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/bloc.png', height: 40),
                    SizedBox(height: 6),
                    Text('BLoC'),
                  ],
                ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/git.png', height: 40),
                    SizedBox(height: 6),
                    Text('Git'),
                  ],
                ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/fb.png', height: 40),
                    SizedBox(height: 6),
                    Text('Firebase'),
                  ],
                ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/figma.png', height: 40),
                    SizedBox(height: 6),
                    Text('Figma'),
                  ],
                ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/pm.png', height: 40),
                    SizedBox(height: 6),
                    Text('Postman'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget project(title, desc, img, play, store) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(12),
          child: Image.network(img, height: 100),
        ),
        SizedBox(height: 4),
        Text(title, style: titleStyle()),
        SizedBox(height: 4),
        Text(desc, maxLines: 2, overflow: TextOverflow.ellipsis),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                launchUrlString(play);
              },
              child: Image.asset('assets/google_play.png', width: 100),
            ),
            InkWell(
              onTap: () {
                launchUrlString(store);
              },
              child: Image.asset('assets/app_store.png', width: 100),
            ),
          ],
        ),
      ],
    );
  }

  Widget projects({bool mobile = false}) {
    return mContainer(
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lang['Projects']!, style: titleStyle()),
          SizedBox(height: 12),
          GridView(
            controller: _scrollController,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: width > 1200
                  ? 3
                  : width > 1000
                  ? 2
                  : 1,
              childAspectRatio: mobile
                  ? 1.2
                  : width > 1200
                  ? width / 1100
                  : width > 1000
                  ? width / 800
                  : width > 810
                  ? width / 450
                  : width / 700,
              crossAxisSpacing: 24,
            ),
            children: [
              project(
                'Amanat Store',
                lang['1']!,
                'https://raw.githubusercontent.com/thisisjamaldin/apps-icons/refs/heads/main/1.webp',
                'https://play.google.com/store/apps/details?id=com.prolab.amantstore',
                'https://apps.apple.com/us/app/amanat-store/id6738306157',
              ),
              project(
                'Intex Cargo',
                lang['2']!,
                'https://raw.githubusercontent.com/thisisjamaldin/apps-icons/refs/heads/main/2.webp',
                'https://play.google.com/store/apps/details?id=com.prolab.intex_cargo',
                'https://apps.apple.com/us/app/intex-cargo/id6739423271',
              ),
              project(
                'Jerdesh Moskva',
                lang['3']!,
                'https://raw.githubusercontent.com/thisisjamaldin/apps-icons/refs/heads/main/3.webp',
                'https://play.google.com/store/apps/details?id=com.prolab.jerdesh',
                'https://apps.apple.com/us/app/id6743311675',
              ),
              project(
                'Cella',
                lang['4']!,
                'https://raw.githubusercontent.com/thisisjamaldin/apps-icons/refs/heads/main/4.webp',
                'https://play.google.com/store/apps/details?id=com.thisisjamaldin.cella',
                'https://apps.apple.com/us/app/cella/id6745497749',
              ),
              project(
                'SindbadCity',
                lang['5']!,
                'https://raw.githubusercontent.com/thisisjamaldin/apps-icons/refs/heads/main/5.webp',
                'https://play.google.com/store/apps/details?id=com.sindbadcity',
                'https://apps.apple.com/ru/app/sindbadcity/id6444826905',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget mContainer(Widget child, {double? width, EdgeInsets? padding}) {
    return Container(
      width: width,
      padding: padding ?? EdgeInsets.all(20),
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: light ? Colors.black.withAlpha(20) : Colors.white.withAlpha(20),
        border: Border.all(
          color: light
              ? Colors.black.withAlpha(70)
              : Colors.white.withAlpha(70),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  TextStyle titleStyle() {
    return TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  }
}
