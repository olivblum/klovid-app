import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'first_page.dart';
import 'second_page.dart';
import 'third_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Klopapier Hamsterkauf App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: [
        S.delegate,
        //AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        //GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      //[const Locale('en'),const Locale('de'),],
      home: MyHomePage(title: 'Klopapier Hamsterkauf App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _selectedPage = 0;
  List<Widget> pageList = List<Widget>();

  @override
  void initState() {
    pageList.add(FirstPage());
    pageList.add(SecondPage());
    pageList.add(ThirdPage());
    super.initState();
  }

  static Future<void> vibrate() async {
    await SystemChannels.platform.invokeMethod<void>('HapticFeedback.vibrate');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).klopapierHamsterkaufApp),
        elevation: 4.0,
      ),
      body: IndexedStack(
        index: _selectedPage,
        children: pageList,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 4)]
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text(S.of(context).bottomnavbarTextHome),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.poll),
              title: Text(S.of(context).statistiken),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.scatter_plot),
              title: Text(S.of(context).beitragen, //style:TextStyle(
                //fontWeight: FontWeight.w800,
          //      fontFamily: 'Roboto',
           //     letterSpacing: 0.5,
             //   fontSize: 14,),
              ),
            ),
          ],
          currentIndex: _selectedPage,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
      vibrate();
    });
  }
}