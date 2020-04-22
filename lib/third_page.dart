import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klovid/Icons/custom_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'generated/l10n.dart';

class ThirdPage extends StatefulWidget {
  ThirdPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {

  static Future<void> vibrate() async {
    await SystemChannels.platform.invokeMethod<void>('HapticFeedback.vibrate');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).berDieApp,textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: Colors.amber[800],
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(CustomIcons.amazingrolliconv1, color: Colors.black26,size: 35,),
            Text(
              '\n',
              style: TextStyle(
                color: Colors.black26,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
            widgetUnten(context),
            Container(  //End Text
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Text(
                    S.of(context).duBistAmEndeAngelangtN,
                    style: TextStyle(
                      color: Colors.black26,
                      letterSpacing: 0.5,
                      fontSize: 10,
                    ),
                  ),
                  Icon(CustomIcons.toilet_roll, color: Colors.black26,),
                  Text(''),
                ],
              ),
            ),],
        ),
      ),
    );
   }

   Widget widgetUnten(context) {
    return new Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
              S.of(context).inZeitenVonHamsterkufenUndLeerenKlopapierregalenHilftDieseApp,
            style: TextStyle(fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
                wordSpacing: 1,
                fontSize: 16,
              height: 1.3
            ),
            textAlign: TextAlign.justify,
          ),
          Divider(),
          RaisedButton(
            onPressed: launchURL,
            child: Text(S.of(context).ffneUmfrage, style:
              TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),),
            color: Colors.amber[800],
          ),
          Divider(),
          SelectableText(
            'https://docs.google.com/forms/d/e/1FAIpQLSdF6NZyyiQ1aGL7aqMpWAD_A0lyMDFtdklF3h6cM0jH0MEQaw/viewform?usp=sf_link',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w300,
              fontFamily: 'Roboto',
              letterSpacing: -0.5,
              fontSize: 12,
            ),textAlign: TextAlign.center,
          ),
        ],
      ),
    );
   }

   void launchURL() async {
    const url = 'https://docs.google.com/forms/d/e/1FAIpQLSdF6NZyyiQ1aGL7aqMpWAD_A0lyMDFtdklF3h6cM0jH0MEQaw/viewform?usp=sf_link';
    if (await canLaunch(url)) {
      await launch(url);
      vibrate();
    }
    else {
      throw 'Error cant start $url';
    }
  }


}
