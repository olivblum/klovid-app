import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'global.dart' as global;
import 'Icons/custom_icons.dart';
import 'dart:math' as math;
import 'package:share/share.dart';
import 'dart:async';
import 'generated/l10n.dart';

class FirstPage extends StatefulWidget {
  FirstPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> with SingleTickerProviderStateMixin {

  AnimationController animationController; //für Animation des Buttons
  Animation<double> animation;
  Animation<double> sizeAnimation;
  int currentState = 0;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: Duration(milliseconds: 500),vsync: this);
    animation = Tween<double>(begin: 0,end: 60).animate(animationController)..addListener((){
      setState(() {
      });
    });
    sizeAnimation = Tween<double>(begin: 0,end: 1).animate(CurvedAnimation(parent: animationController,curve: Curves.easeInOutExpo))..addListener((){
      setState(() {
      });
    });
  } //für Animation des Buttons

  bool selected = false; // für Tage Ausgabe
  bool selected2 = false; // für HAMSTER
  bool selected3 = false;  //für anzahl rollen
  bool selected4 = false; //für Personen
  bool hamsterbool = false;
  bool isSwitched = false;
  int haushaltaktuell = 1;
  int haushaltpersonen = 1;
  Color haushaltcolor = Colors.grey;
  double haushaltverbrauch =0;
  double haushaltverbrauchfinal=0;
  String rollcountershow = " 0";
  String teilen = "empty";
  String teilensubject = "empty";
  String teilenhamster = "empty";
  double opacityFAB = 1;

  static Future<void> vibrate() async {
    await SystemChannels.platform.invokeMethod<void>('HapticFeedback.vibrate');
  }

  void initializeStrings(){
    teilensubject = S.of(context).verbleibendeKlopapiertageHamsterkauftest;
    teilenhamster = S.of(context).fehler;
  }

  void _edited(){  //wenn etwas editiert wird dann ispressed=0 um für Seite 2 zu checken
    // und die Box unten wird wieder eingefahren
    //und das Icon verändert sich?
    setState(() {
      selected = false;
      selected2 = false;
      global.ispressed = false;
      if (!isSwitched) {
        animationController.reverse();
      }
    });
  }

  void _shitCountUp() {
    setState(() {
      global.shitcounter++;
      checkCalculation();
    });
  }
  void _shitCountDown() {
    setState(() {
      global.ispressed = false;
      if (global.shitcounter == 0) {
        vibrate();
        global.shitcounter++;
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).wennDasNegativIstSolltestDuZumArztGehen),
            duration: Duration(milliseconds: 1000),
            elevation: 6.0,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      global.shitcounter--;
      checkCalculation();
    });
  }

  void _wipeCountDown() {
    setState(() {
      global.ispressed = false;
      if (global.wipecounter == 0) {
        global.wipecounter ++;
        vibrate();
      }
      global.wipecounter--;
      checkCalculation();
    });
  }
  void _wipeCountUp() {
    setState(() {
      global.wipecounter++;
      checkCalculation();
      global.ispressed = false;
    });
  }

  void _avgShitCountDown() {
    setState(() {
      global.ispressed = false;
      if (global.avgshitcounter == 0) {
        global.avgshitcounter ++;
        vibrate();
      }
      global.avgshitcounter--;
      checkCalculation();
    });
  }
  void _avgShitCountUp() {
    setState(() {
      global.ispressed = false;
      global.avgshitcounter++;
      checkCalculation();
    });
  }

  void _pissCountDown() {
    setState(() {
      global.ispressed = false;
      if (global.pisscounter == 0) {
        global.pisscounter ++;
        vibrate();
      }
      global.pisscounter--;
      checkCalculation();
    });
  }
  void _pissCountUp() {
    setState(() {
      global.ispressed = false;
      global.pisscounter++;
      checkCalculation();
    });
  }

  void _avgPissCountDown() {
    setState(() {
      global.ispressed = false;
      if (global.avgpisscounter == 0) {
        global.avgpisscounter ++;
        vibrate();
      }
      global.avgpisscounter--;
      checkCalculation();
    });
  }
  void _avgPissCountUp() {
    setState(() {
      global.ispressed = false;
      global.avgpisscounter++;
      checkCalculation();
    });
  }

  void _peopleCountDown() {
    setState(() {
      global.ispressed = false;
      if (global.peoplecounter == 1) {
        global.peoplecounter ++;
        vibrate();
      }
      global.peoplecounter--;
      checkCalculation();
      isSwitched=false;
      haushalt_FAB_aktivieren();
      haushaltcolor=Colors.grey;
    });
  }
  void _peopleCountUp() {
    setState(() {
      global.ispressed = false;
      global.peoplecounter++;
      checkCalculation();
      isSwitched=false;
      haushalt_FAB_aktivieren();
      haushaltcolor=Colors.grey;
    });
  }

  void _paperten() {
    setState(() {
      global.ispressed = false;
      global.rollcounter = global.rollcounter + 10;
      if (global.rollcounter <= 48) {
        global.rollcounterdouble = global.rollcounter.toDouble();
      }
      rollcountershow=global.rollcounter.toString();
      checkCalculation();
    });
  }

  void _changeBlatter(int value){
    setState(() {
      global.blatter=value;
      global.ispressed = false;
      checkCalculation();
    });
  }

  void checkCalculation() {
    setState(() {
      _edited();
      global.calculationpossible =
          global.shitcounter * global.wipecounter * global.avgshitcounter *
              global.rollcounter;
      if (global.calculationpossible == 0 ) {
        global.buttoncolors = Colors.grey;
      }
      else {
        global.ispossible = false;
        global.buttoncolors = Colors.amber[800];
      }
    });
  }
  void _calculateDays() {
    setState(() {
      vibrate();
      //papercounter = papercounterdouble.round();
      global.verbrauch_shit =
          global.shitcounter * global.wipecounter * global.avgshitcounter /
              7; //täglicher Verbrauch
      global.verbrauch_piss = global.pisscounter * global.avgpisscounter;
      global.verbrauch =
          global.verbrauch_piss.toDouble() + global.verbrauch_shit;
      global.dayscalculateddouble =
          global.rollcounter.toDouble() * global.blatter / global.verbrauch /
              global.peoplecounter;
      global.dayscalculated = global.dayscalculateddouble.floor();
      if (global.dayscalculated > 60 && global.rollcounter>10) {hamsterbool = true;}
      else {hamsterbool = false;}
    }
    );
  }

  void haushalt_FAB_deaktivieren(){
    animationController.forward();
    setState(() {
      opacityFAB=0;
    });
  }
  Future<void> haushalt_FAB_aktivieren() async {
    animationController.reverse();
    await Future.delayed(const Duration(milliseconds: 330));      //wenn nicht 330 milisec gewartet wird, sieht man noch den lila hamster
    setState(() {
      opacityFAB=1;
    });
  }
  void _haushaltIndividuell(){
    setState(() {
      global.verbrauch=haushaltverbrauchfinal;
      global.dayscalculateddouble =
          global.rollcounter.toDouble() * global.blatter / global.verbrauch;
      global.dayscalculated = global.dayscalculateddouble.floor();
      if (global.dayscalculated > 60) {hamsterbool = true;}
      else {hamsterbool = false;}
    });
  }
  void resethaushalt(){
    haushaltaktuell=1;
    haushaltverbrauch=0;
  }
  void resetvalues(){
    setState(() {
      global.shitcounter=1;
      global.wipecounter=1;
      global.avgshitcounter=1;
      global.pisscounter=1;
      global.avgpisscounter=1;
    });
  }

  void teilenupdate(){
    initializeStrings();
    if (hamsterbool){
      teilenhamster = S.of(context).einHamsterkufer;
    }
    else{teilenhamster=S.of(context).keinHamsterkufer;}
    teilen=S.of(context).ichHabeAusgerechnetDassMeinKlopapierNoch+"${global.dayscalculated} "+S.of(context).tageReichtIchBinAlso+" $teilenhamster"+" \n"+
        S.of(context).willstDuAuchWissenWieLangeDeinVorratNochReicht+" "+S.of(context).ichHabeEsMitDieserAppAusgerechnet+" https://play.google.com/store/apps/details?id=de.blumgroup.klovid";
  }

  @override //Rechnungen
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Flexible(child: Opacity(opacity: 0, child: Transform.rotate(angle: 180, child: Icon(CustomIcons.amazingrolliconv1, size: 30,)))),
            Text(
              S.of(context).wieLangReichtDeinKlopapier, textAlign: TextAlign.center,
            ),
            Expanded(
              child: GestureDetector(
                onTap: (){
                  animationController.forward();
                  global.ispressed = true;
                  _calculateDays();
                  global.opacityTage = 0.0;
                  setState(() {
                    selected = true;
                    selected2 = false;
                    selected3 = false;
                  });
                },
                  child: Icon(CustomIcons.amazingrolliconv1, size: 30,)
              ),
            )
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.amber[800],
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              CustomIcons.amazingrolliconv1, color: Colors.black26, size: 35,),
            Text(S.of(context).gibDeineWerteEinUndDrckDenButtonRechtsUntenn,
              style: TextStyle(color: Colors.black54, fontSize: 12),
              textAlign: TextAlign.end,),
            //Divider(color: Colors.amber[800],thickness: 2,),
            Card(
              elevation: 3,
              child: Column(
                children: <Widget>[
                  ListTile(
                    //leading: Icon(CustomIcons.poop, size: 46,),
                    title: Text(S.of(context).grosseGeschafte,
                      style: TextStyle(fontWeight: FontWeight.w800),),
                    subtitle: Row(
                      children: <Widget>[
                        Text("${S.of(context).pro} "),
                        Text(S.of(context).woche, style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),)
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      //spacing: 20, // space between two icons
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: _shitCountDown,
                          tooltip: 'Less',
                        ),
                        Text(' ${global.shitcounter} ',
                          style: TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                              color: Colors.blue),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: _shitCountUp,
                          tooltip: 'More',
                        ),
                      ],
                    ),
                  ),
                  ListTile( //wipes per shit
                    title: Text(
                      S.of(context).abwischhufigkeit,
                    ),
                    subtitle: Text(S.of(context).proToilettengang),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: _wipeCountDown,
                          tooltip: 'Less',
                        ),
                        Text(
                          ' ${global.wipecounter} ',
                          style: TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                              color: Colors.blue),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: _wipeCountUp,
                          tooltip: 'More',
                        ),
                      ],
                    ),
                  ),
                  ListTile( //paper per wipe
                    title: Text(
                      S.of(context).bltterProAbwischen,
                    ),
                    subtitle: Text(S.of(context).imDurchschnitt),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: _avgShitCountDown,
                          tooltip: 'Riskier',
                        ),
                        Text(
                          ' ${global.avgshitcounter} ',
                          style: TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                              color: Colors.blue),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: _avgShitCountUp,
                          tooltip: 'Softer & Saver',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //Divider(color: Colors.amber[800],),
            new Card( //Piss per day
              elevation: 3,
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      S.of(context).kleineGeschfte,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                      ),),
                    subtitle: Row(
                      children: <Widget>[
                        Text('${S.of(context).pro} '),
                        Text(S.of(context).tag, style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),)
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: _pissCountDown,
                          tooltip: 'less',
                        ),
                        Text(
                          ' ${global.pisscounter} ',
                          style: TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                              color: Colors.blue),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: _pissCountUp,
                          tooltip: 'more',
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      S.of(context).papierverbrauch,),
                    subtitle: Text(S.of(context).proKleinesGeschft),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: _avgPissCountDown,
                          tooltip: 'no need',
                        ),
                        Text(
                          ' ${global.avgpisscounter} ',
                          style: TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                              color: Colors.blue),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: _avgPissCountUp,
                          tooltip: 'more',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //Divider(color: Colors.amber[800],),
            AnimatedContainer(                              //personen im haushalt
              width: selected4 ? 500.0 : 500.0,
              height: selected4 ? 290.0 : 96.0,
              color: selected4 ? Colors.white : Colors.white,
              alignment: selected4 ? Alignment.topCenter : AlignmentDirectional.topCenter,
              duration: Duration(milliseconds: 1500),
              curve: Curves.fastOutSlowIn,
              child: Container(
                height: 290,
                child: new Card( //Menschen im Haushalt
                  elevation: 3,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: GestureDetector(
                          child: Text(
                            S.of(context).personenImHaushalt, style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onTap:(){
                            setState(() {
                              selected4 = true;
                              resethaushalt();
                            });}, //expand height
                        ),
                        subtitle: GestureDetector(
                          child: Text(S.of(context).optionalHierKlickenUmIndividuelleWerteFrJedePersonEinzugeben),
                          onTap:(){
                            setState(() {
                              selected4 = true;
                              resethaushalt();
                            });}, //expand height
                        ),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove_circle_outline),
                              onPressed: _peopleCountDown,
                              tooltip: 'less',
                            ),
                            Text(
                              ' ${global.peoplecounter} ',
                              style: TextStyle(fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                  color: Colors.blue),
                            ),
                            IconButton(
                              icon: Icon(Icons.add_circle_outline),
                              onPressed: _peopleCountUp,
                              tooltip: 'more',
                            ),
                          ],
                        ),
                        onLongPress: (){
                          setState(() {
                            selected4 = true;
                            resethaushalt();
                          });},
                      ),
                      Expanded(
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: ListTile(
                                  title: Text(S.of(context).normalerweiseWerdenDeineWerteAufAllePersonenHochgerechnetFallsDu,
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,color: Colors.black54),textAlign: TextAlign.justify,),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(S.of(context).spezifiziereDazuDieAnzahlAnPersonenObenUndKlickeDanach,
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,color: Colors.black54),),
                                  trailing:
                                      IconButton(icon: Icon(Icons.people_outline),color:haushaltcolor, onPressed: (){
                                        setState(() {
                                          isSwitched= isSwitched ? false : true;
                                          vibrate();
                                          haushalt_FAB_deaktivieren();
                                          haushaltpersonen=global.peoplecounter;
                                          haushaltcolor =Colors.lightBlue;
                                          if (!isSwitched){ //deaktiviert
                                            selected4=false;
                                            haushalt_FAB_aktivieren();
                                            haushaltcolor=Colors.grey;
                                          }
                                        });
                                      },)
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  //dense: true,
                                    title:Text(S.of(context).sobaldDuMitEingebenFertigBistKlickeAufDasHkchen,style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,color: Colors.black54),),
                                    trailing:
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(S.of(context).person+" ${haushaltaktuell}/$haushaltpersonen:", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),),
                                        IconButton(icon: Icon(Icons.check_circle, size:30,),color: haushaltcolor,
                                          onPressed: (){
                                            setState(() {
                                              _calculateDays(); //berechnet die Tage, aber auch den Zwischenschritt ->
                                              // global.verbrauch jeder individuellen person ->
                                              // dieser Wert kann auf addiert werden und muss am Ende zurück gegeben werden ->
                                              //
                                              // am Ende wird ja durch die Anzahl von Personen geteilt ->
                                              // addieren gleicht sich wieder aus
                                              haushaltverbrauch=haushaltverbrauch+global.verbrauch;  //dies ist nur zur Zwischenspeicherung und wird am Ende als global.verbrauch zurückgegeben
                                              resetvalues();
                                              if (haushaltaktuell<=haushaltpersonen-1){
                                                haushaltaktuell++;
                                                Scaffold.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text(S.of(context).erfolgreichGibDasHandyJetztDerNchstenPerson),
                                                    duration: Duration(milliseconds: 3000),
                                                    elevation: 6.0,
                                                    behavior: SnackBarBehavior.floating,
                                                  ),
                                                );}
                                              else{
                                                showDialog<String>(
                                                  context: context,
                                                  builder: (BuildContext context) => AlertDialog(
                                                    title: Text(S.of(context).eingabeKomplett),
                                                    content: Text(S.of(context).fahreJetztGanzNormalFortMitDerEingabeDerVorhandenen),
                                                    contentTextStyle: TextStyle(
                                                        color: Colors.black54,
                                                        height: 1.6,
                                                        fontSize: 18
                                                    ),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        child: Text('OK'),
                                                        onPressed: (){
                                                          Navigator.of(context).pop();
                                                          setState(() {
                                                            selected4=false;
                                                            haushalt_FAB_aktivieren();
                                                            haushaltverbrauchfinal=haushaltverbrauch;   // hier wird finaler haushalt festgelegt.
                                                          });
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }
                                            });
                                          },)
                                      ],
                                    )

                                ),
                              )
                            ],
                          )
                      )
                    ],
                  ),
                ),
              ),
            ),
            //Divider(color: Colors.amber[800],thickness: 2,),
            AnimatedContainer(
              width: selected3 ? 500.0 : 500.0,
              height: selected3 ? 200.0 : 96.0,
              color: selected3 ? Colors.white : Colors.white,
              alignment: selected3 ? Alignment.topCenter : AlignmentDirectional.topCenter,
              duration: Duration(milliseconds: 1500),
              curve: Curves.fastOutSlowIn,
              child: Container(
                height: 200,
                child: new Card( //Klopapierrollen
                  elevation: 3,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: GestureDetector(
                          child: Text(S.of(context).rollenvorrat,style: TextStyle(fontWeight: FontWeight.bold),),
                          onTap:(){
                          setState(() {
                            selected3 = true;
                            selected4 = false;
                          });}, //expand height
                        ),
                        subtitle: Container(
                          child: GestureDetector(
                            child: Text(S.of(context).frMehrOptionenHierKlicken),
                            onTap:(){
                              setState(() {
                                selected3 = true;
                                selected4 = false;
                              });}, //expand height
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Transform.scale(scale: 1.2,
                              child: Slider(
                                value: global.rollcounterdouble,
                                min: 0,
                                max: 48,
                                divisions: 49,
                                label: '${global.rollcounterdouble.round()}',
                                onChanged: (double value) {
                                  setState(() => global.rollcounterdouble = value);
                                  checkCalculation();
                                  global.rollcounter = global.rollcounterdouble
                                      .round();
                                  if (global.rollcounter>=10){
                                    rollcountershow = global.rollcounter.toString();
                                  }
                                  else {rollcountershow ="  ${global.rollcounter.toString()}";}   //Leerzeichen wenn kleiner 10    //Leerzeichen wenn <10 der wert
                                },
                              ),
                            ),
                            Text(' $rollcountershow',
                                  style: TextStyle(fontWeight: FontWeight.bold,
                                                    fontSize: 25.0,
                                                    color: Colors.blue),
                                )
                          ],
                        ),
                        isThreeLine: true,
                        onLongPress: (){
                          setState(() {
                            selected3 = true;
                            selected4 = false;
                          });},
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: ListTile(
                                dense: true,
                                title: Text(S.of(context).mehrAls48DieserButtonIstFrDich, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,color: Colors.black54),),
                                trailing: IconButton(icon: Icon(Icons.library_add),onPressed: _paperten,tooltip: '10 Rollen drauf',),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                dense: true,
                                title:Text(S.of(context).bltterProRolle,style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,color: Colors.black54),),
                                trailing:
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text("150:"),
                                        new Radio(value: 150, groupValue: global.blatter, onChanged: _changeBlatter),
                                        Text("  200:"),
                                        new Radio(value: 180, groupValue: global.blatter, onChanged: _changeBlatter),
                                        Text("  250:"),
                                        new Radio(value: 250, groupValue: global.blatter, onChanged: _changeBlatter)
                                      ],
                                    )

                              ),
                            )
                          ],
                        )
                      )
                    ],
                  ),
                ),
              ),
            ),
            //Divider(thickness: 2, color: Colors.amber[800],),
            AnimatedContainer (
              width: selected ? 500.0 : 500.0,
              height: selected ? 150.0 : 70.0,
              color: selected ? Colors.white : Colors.white,
              alignment: selected ? Alignment.topCenter : AlignmentDirectional.topCenter,
              duration: Duration(milliseconds: 1500),
              curve: Curves.fastOutSlowIn,
              child: Container(
                height: 150,
                child: new Card( //Vorrat
                  elevation: 3,
                  color: Colors.amber[800],
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          S.of(context).soLangeReichtDeinVorrat,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        //trailing: Row(mainAxisSize: MainAxisSize.min, children: [Text(' ${global.dayscalculated} ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35.0, color: Colors.white.withOpacity(global.opacityTage)), textAlign: TextAlign.center,),
                          //  Text(' Tage ', style: TextStyle(color: Colors.white.withOpacity(global.opacityTage), fontWeight: FontWeight.w800, fontSize: 18,),),],),
                      ),
                      Expanded(
                        child: ListTile(
                          //title: Text("Hiii", style: TextStyle(fontSize: 100),),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                ' ${global.dayscalculated} ',
                                style: TextStyle(fontWeight: FontWeight.bold,
                                    fontSize: 48.0,
                                    color: Colors.white), textAlign: TextAlign.end,
                              ),
                              Text(
                                S.of(context).tage,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 44,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: selected ? 1.0 : 1.0,
              child: AnimatedContainer (
                width: selected2 ? 500.0 : 500.0,
                height: selected2 ? 200.0 : 00.0,
                color: selected2 ? Colors.white : Colors.white,
                alignment: selected2 ? Alignment.topCenter : AlignmentDirectional.topCenter,
                duration: Duration(milliseconds: 1500),
                curve: Curves.fastOutSlowIn,
                child: new Card( //Vorrat
                  elevation: 3,
                  color: Colors.purple[500],
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: Text(
                            S.of(context).zhlstDuZuDenHamsterkufern,       //nur das hier expanden und den rest mit neuem Icon?
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          //trailing: Row(mainAxisSize: MainAxisSize.min, children: [Text(' ${global.dayscalculated} ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35.0, color: Colors.white.withOpacity(global.opacityTage)), textAlign: TextAlign.center,),
                            //  Text(' Tage ', style: TextStyle(color: Colors.white.withOpacity(global.opacityTage), fontWeight: FontWeight.w800, fontSize: 18,),),],),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          trailing:
                          Transform.scale(scale: 2,
                            child: Opacity(
                              opacity: selected2 ? 1.0 : 0.0,
                              child: Opacity(
                                opacity: 1,
                                child: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Image.asset('res/images/hamster.png', fit: BoxFit.cover,),
                                ),
                              ),
                            ),
                          ),
                          title:
                              Text(hamsterbool ?
                              S.of(context).ja+'           ':S.of(context).nein+'        ',
                                style: TextStyle(fontWeight: FontWeight.bold,
                                    fontSize: 50.0,
                                    color: Colors.white), textAlign: TextAlign.start,
                              ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            new Container( //End Text
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    child: Builder(
                        builder: (BuildContext context) {
                        return FlatButton.icon(
                            onPressed: (){
                                  teilenupdate();
                                  final RenderBox box = context.findRenderObject();
                                  Share.share(teilen,
                                      subject: teilensubject,
                                      sharePositionOrigin:
                                        box.localToGlobal(Offset.zero)&
                                          box.size);
                                 },
                            icon: Icon(Icons.share, color: Colors.black38,),
                            splashColor: Colors.lightBlue,
                            label: Text(S.of(context).ergebnisTeilen,style: TextStyle(color: Colors.black38),)
                        );
                      }
                    ),
                  ),
                  Text(
                    '.\n.\n.',
                    style: TextStyle(
                      color: Colors.black26,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Roboto',
                      letterSpacing: 0.5,
                      fontSize: 32,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    S.of(context).welcheEinstellungFehltDirNochnSchickMirDeinenVorschlagN,
                    style: TextStyle(
                      color: Colors.black26,
                      letterSpacing: 0.5,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Positioned( //braucht man glaub nicht
              child: Transform.scale(
                scale: sizeAnimation.value,
                child: Opacity(
                  opacity: opacityFAB,
                  child: FloatingActionButton(
                    onPressed: () {
                    },
                  ),
                ),
              ),
        ),
          Positioned(
            child: Transform.scale(
              scale: sizeAnimation.value,
              child: Opacity(
                opacity: opacityFAB,
                child: FloatingActionButton(
                  onPressed: () {
                    animationController.reverse();
                    global.ispressed = true;
                    vibrate();
                    //_calculateDays();
                    global.opacityTage = 1.0;
                    setState(() {
                      selected2 = true;
                      selected3 = false;
                      selected4 = false;
                    });
                  },
                  tooltip: "Starte Hamsterüberprüfung",

                  child: Align(
                      alignment: Alignment.lerp(Alignment.center, Alignment.bottomCenter, 0.4),
                      child: Icon(CustomIcons.noun_hamster_912734,size: 40,)),

                  backgroundColor: Colors.purple[500],
                ),
              ),
            ),
          ),
          Positioned(
            child: Transform.scale(
              scale: sizeAnimation.value -1,
              child: FloatingActionButton(
                  onPressed: (){
                    animationController.forward();
                    global.ispressed = true;
                    vibrate();
                    //_calculateDays();
                    global.opacityTage = 0.0;
                    setState(() {
                      selected = true;
                      selected2 = false;
                      selected3 = false;
                      selected4 = false;
                    });
                    if(isSwitched==true){
                      _haushaltIndividuell();
                    }
                    else {_calculateDays();}
                  },
                  tooltip: "Starte Tage-Berechnung",
                  child: Transform.rotate(
                    angle: 180*math.pi/180,
                      child: Icon(CustomIcons.amazingrolliconv1,  size: 30,)),
                  backgroundColor: global.buttoncolors,
              ),
            ),
          )
      ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}


