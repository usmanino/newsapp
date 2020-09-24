import 'package:flutter/material.dart';
import 'package:news_app/business.dart';
import 'package:news_app/headlines.dart';
import 'package:news_app/sports.dart';
import 'package:news_app/technology.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:firebase_admob/firebase_admob.dart';

const String testDevice = 'B4C322FFB67557B1EA5365C0CAF7375D';

class NewsHome extends StatefulWidget {
  @override
  NewsHomeState createState() {
    return new NewsHomeState();
  }
}

class NewsHomeState extends State<NewsHome> with AutomaticKeepAliveClientMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  LinearGradient gradient = LinearGradient(
      colors: [Colors.black, Colors.grey, Colors.blueGrey],
      begin: Alignment.bottomRight,
      end: Alignment.topLeft);

  final _pages = [
    HeadlinesPage(),
    SportsPage(),
    TechnologyPage(),
    BusinessPage()
  ];
  int _currentPage = 0;
  //GlobalKey bottomNavigationKey = GlobalKey();

  void changePage(int i) {
    setState(() {
      _currentPage = i;
      updateKeepAlive();
    });
  }

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    nonPersonalizedAds: true,
    keywords: <String>['Game', 'Mario'],
  );

  // MobileAdTargetingInfo targetingInfo;
  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  BannerAd createBannerAd() {
    return BannerAd(
        adUnitId: 'ca-app-pub-1958243021759092/2511996625',
        size: AdSize.smartBanner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("BannerAd event is $event");
        });
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        adUnitId: 'ca-app-pub-1958243021759092/2320424934',
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("InterstitialAd event is $event");
        });
  }

  @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: BannerAd.testAdUnitId);
    _bannerAd = createBannerAd()
      ..load()
      ..show();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    _interstitialAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return showDialog(
          context: context,
          child: AlertDialog(
            content: Text("Are you you want to exit ?"),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('yes'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('no'),
              ),
            ],
          ),
        );
      },
      child: Material(
        child: Scaffold(
          key: _scaffoldKey,
          body: _pages[_currentPage],
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              createInterstitialAd()
                ..load()
                ..show();
            },
            child: Icon(Icons.add),
          ),
          bottomNavigationBar: FluidNavBar(
            icons: [
              FluidNavBarIcon(
                  iconPath: "assets/fire.svg",
                  selectedForegroundColor: Colors.red,
                  unselectedForegroundColor: Colors.red),
              FluidNavBarIcon(
                iconPath: "assets/fast.svg",
                selectedForegroundColor: Colors.blue[600],
                unselectedForegroundColor: Colors.blue[600],
              ),
              FluidNavBarIcon(
                iconPath: "assets/phone.svg",
                selectedForegroundColor: Colors.yellow[600],
                unselectedForegroundColor: Colors.yellow[600],
              ),
              FluidNavBarIcon(
                iconPath: "assets/money.svg",
                selectedForegroundColor: Colors.green[600],
                unselectedForegroundColor: Colors.green[600],
              ),
            ],
            onChange: (int index) => changePage(index),
            style: FluidNavBarStyle(
              iconBackgroundColor: Colors.grey[100],
              barBackgroundColor: Colors.grey[200],
            ),
            //scaleFactor: 1,
            // itemBuilder: (icon, item) => Semantics(
            //   child: item,
            // ),
          ),
        ),
      ),
    );
  }

  @override
  // ignore: todo
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
