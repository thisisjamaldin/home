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
    "role": "Мобильный разработчик · Flutter, iOS и Android",
    "stat": "10+ приложений выпущено с 2021 года",
    "Email": "Почта",
    "CV": "Скачать резюме",
    "About me": "О себе",
    "about":
        "Мобильный разработчик, создаю кроссплатформенные приложения с 2021 года — более 10 продуктов, опубликованных в App Store и Google Play. Работаю с Flutter, нативным Android (Kotlin/Java) и iOS (Swift). Реализовал приложения для логистики, e-commerce, CRM/ERP и маркетплейсов — от архитектуры и интеграции API до релиза. Беру функциональность под полную ответственность и выпускаю продукты, которыми пользуется реальный бизнес.",
    "Tech Stack": "Технологии",
    "Projects": "Проекты",
    "1":
        "Приложение для управления грузоперевозками: заказы, отслеживание в реальном времени и защита данных.",
    "2":
        "Приложение для магазина товаров для дома с бонусной системой, управлением заказами и уведомлениями об акциях.",
    "3":
        "Доставка грузов по СНГ с отслеживанием отправлений в реальном времени и поддержкой 24/7.",
    "4":
        "Локальная доска объявлений: работа, жильё, товары и услуги в Кыргызстане.",
    "5":
        "Поиск жилья и работы для киргизской диаспоры в Москве — умные фильтры и актуальные объявления.",
    "6":
        "Кэшбэк и бонусы: сканируйте QR-коды, копите баллы и обменивайте их на скидки в магазинах и кафе.",
    "7":
        "Приложение для управления бизнесом: заказы в реальном времени, база клиентов, аналитика продаж и уведомления.",
    "8":
        "Мобильная CRM+ERP: клиенты, продажи и склад — полное управление бизнесом в одном приложении.",
    "9":
        "Маркетплейс для заказа товаров из Кара-Суу и Оша по оптовым ценам.",
    "10":
        "Академическая соцсеть для студентов вузов Кыргызстана: профили, посты, сообщения и уведомления.",
    "11":
        "Менеджер личных финансов: учёт доходов и расходов с быстрым ручным вводом.",
  },
  "en": {
    "Dark": "Dark",
    "Light": "Light",
    "CV": "Download CV",
    "name": "Jamaldin Sabirjanov",
    "role": "Mobile Developer · Flutter, iOS & Android",
    "stat": "10+ apps shipped since 2021",
    "Email": "Email",
    "About me": "About me",
    "about":
        "Mobile developer building cross-platform apps since 2021, with 10+ products shipped to the App Store and Google Play. I work across Flutter, native Android (Kotlin/Java) and iOS (Swift), and have delivered logistics, e-commerce, CRM/ERP and marketplace apps — from architecture and API integration through to release. I own features end-to-end and ship production apps used by real businesses.",
    "Tech Stack": "Tech Stack",
    "Projects": "Projects",
    "1":
        "Logistics platform for managing cargo shipments end-to-end — orders, real-time tracking, and secure data handling.",
    "2":
        "E-commerce app for a hardware retailer with a loyalty/bonus system, order management, and promo notifications.",
    "3":
        "Cargo delivery across the CIS with real-time shipment tracking and 24/7 support.",
    "4":
        "Local classifieds marketplace for jobs, housing, goods and services in Kyrgyzstan.",
    "5":
        "Housing and job search app for the Kyrgyz community in Moscow, with smart filters and live listings.",
    "6":
        "Cashback and loyalty app — scan QR codes, collect points, and redeem them for discounts across stores and cafes.",
    "7":
        "Business management app — real-time order management, customer database, sales analytics, and notifications.",
    "8":
        "Mobile CRM + ERP that puts full business management — clients, sales, inventory — in a single app.",
    "9":
        "Marketplace for ordering goods from Kara-Suu and Osh at wholesale prices.",
    "10":
        "Academic social network for university students in Kyrgyzstan — profiles, posts, messaging and notifications.",
    "11":
        "Personal finance manager for tracking income and expenses with fast manual entry.",
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
              Text(lang['role']!, textAlign: TextAlign.center),
              SizedBox(height: 6),
              Text(
                lang['stat']!,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4),
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

  Widget project(String title, String desc, String img, String? play,
      String? store) {
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
        Text(desc, maxLines: 3, overflow: TextOverflow.ellipsis),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (play != null)
              InkWell(
                onTap: () {
                  launchUrlString(play);
                },
                child: Image.asset('assets/google_play.png', width: 100),
              ),
            if (store != null)
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
                'Intex Cargo',
                lang['1']!,
                'https://play-lh.googleusercontent.com/sGuKr4QKIIZh1dJJE7ASzVEYgLmzWfO-2b_eTfa9cFsvgOZUiSLNKAZB0unmo2jj3thEd4prRVgDiyFJVCNCmA=w240-h480-rw',
                'https://play.google.com/store/apps/details?id=com.prolab.intex_cargo',
                'https://apps.apple.com/us/app/intex-cargo/id6739423271',
              ),
              project(
                'Amanat Store',
                lang['2']!,
                'https://play-lh.googleusercontent.com/eRBglXvPc67q8lYjW93vGezjsktXLpwcxk-8czgKA8y3HkcYXyzfW555rM5IUlu5Jf9tGW7oClxkk3UYbTsLdQo=w240-h480-rw',
                'https://play.google.com/store/apps/details?id=com.prolab.amantstore',
                'https://apps.apple.com/us/app/amanat-store/id6738306157',
              ),
              project(
                'Lider Cargo Company',
                lang['3']!,
                'https://play-lh.googleusercontent.com/c5yrzEK7YH7wqjOTarNmXds4T1fWiGgv6kx9WoM_iSeAhh3AWfUngGPxFNPt5-uZJZGp3uu62x8YiI0Ab3On6g=w240-h480-rw',
                'https://play.google.com/store/apps/details?id=com.prolab.cargo_b2c',
                'https://apps.apple.com/us/app/lider-cargo-company/id6723893601',
              ),
              project(
                'AravanGo',
                lang['4']!,
                'https://play-lh.googleusercontent.com/Y1Ve5InBePnMTCMftKAuBbz92y3yOdyIEC9CcW3RPFNuL6VDZiV5VE12GUAGedpvArf8dyv2BRfNUeGlOMJFUQ=w240-h480-rw',
                'https://play.google.com/store/apps/details?id=com.prolab.aravan',
                'https://apps.apple.com/us/app/aravango/id6780416976',
              ),
              project(
                'Жердеш Москва',
                lang['5']!,
                'https://play-lh.googleusercontent.com/sWCxn52HwkxGRzN_ruhIGcQP5Ci8mkHTuUyNSAfg99CgbZ6J2klkeHzEFuiWUi5WC5076Cw15aOYXOBBft_8XGs=w240-h480-rw',
                'https://play.google.com/store/apps/details?id=com.prolab.jerdesh',
                'https://apps.apple.com/us/app/id6743311675',
              ),
              project(
                'iBonus',
                lang['6']!,
                'https://play-lh.googleusercontent.com/qIwu-2zTzp0m9P6IJz89RgPKd6o9NL3CV6eLQn2icSm0mMUKnG7vlVrTE0rRX341D5iSABm5SXmweRohBlUXrAA=w240-h480-rw',
                'https://play.google.com/store/apps/details?id=com.prolab.ibonus',
                'https://apps.apple.com/us/app/ibonus-app/id6742104481',
              ),
              project(
                'JetKir Менеджер',
                lang['7']!,
                'https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/dc/ae/26/dcae267a-64f5-95ec-086e-6eb2c449b041/AppIcon-0-0-1x_U007emarketing-0-11-0-85-220.png/512x512bb.jpg',
                'https://play.google.com/store/apps/details?id=com.prolab.jetkir_cargo',
                'https://apps.apple.com/us/app/jetkir-менеджер/id6760580327',
              ),
              project(
                'NurCrm',
                lang['8']!,
                'https://play-lh.googleusercontent.com/3Khq0IK1W7nXpamRxZ5vQvJLByKspfbmol5oJX4QxAfekF3rw59pvQQBRuFA9xTiimagh5KL0nsUQkF8y-eI=w240-h480-rw',
                'https://play.google.com/store/apps/details?id=com.dev.nurcrm',
                'https://apps.apple.com/kz/app/nurcrm/id6756206325',
              ),
              project(
                'Zamzam',
                lang['9']!,
                'https://play-lh.googleusercontent.com/IL4aQe8Tc6nNIgvjLy_ma7t66eK69TS9HebEgjKyv1W1yg0K9EgC-cU9vjXwRnnHt2BlIEpkBZABDgAUPM7Bcg=w240-h480-rw',
                'https://play.google.com/store/apps/details?id=com.thisisjamaldin.zamzam',
                null,
              ),
              project(
                'UniPulse',
                lang['10']!,
                'https://play-lh.googleusercontent.com/9Eog-n5mSlG-tAylMbrjlVpF1euy4ao_WyQkB1tut7H6-NYbkHNKzi5XUlTNUnriKr9f7v2anuwrn0c9PfmW7o4=w240-h480-rw',
                'https://play.google.com/store/apps/details?id=com.dev.uni_pulse',
                null,
              ),
              project(
                'Besh Tashta',
                lang['11']!,
                'https://play-lh.googleusercontent.com/TWznuTJ3fHgVI1FlJl165C6t6BzK2PMpRdDB1JHWMcjAsGcZh3TO4PCNzmt3wxNqYvXiWqxQgKDP5PSxG_raHA=w240-h480-rw',
                'https://play.google.com/store/apps/details?id=com.dev.besh_tashta',
                'https://apps.apple.com/kg/app/беш-ташта/id6757864681',
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
