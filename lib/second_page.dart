import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'graphs.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'global.dart' as global;
import 'Icons/custom_icons.dart';
import 'generated/l10n.dart';

class SecondPage extends StatefulWidget {
  SecondPage({Key key, this.data,}) : super(key: key);
  final Data data; //variablen + datenübergabe (oben als this.data)

  @override
  SecondPageState createState() => SecondPageState();
}

class SecondPageState extends State<SecondPage> {
  int testvariable = global.testvariable;
  int shitcounter=0;
  double papercounterdouble = 0;
  double dayscalculateddouble = 0;
  int dayscalculated = 0;
  int wipecounter = 0;
  int avgshitcounter = 0;
  int pisscounter = 0;
  int avgpisscounter = 0;
  int papercounter = 0;
  double verbrauch = 0; //Klopapier "blätter" pro Tag
  double verbrauch_shit = 0;
  int verbrauch_piss = 0;

  //nur hier:
  int verbrauch_piss_30 = 0;
  int verbrauch_shit_30 = 0;

  static Future<void> vibrate() async {
    await SystemChannels.platform.invokeMethod<void>('HapticFeedback.vibrate');
  }

  void _updatevariable() {
    setState(() {
      testvariable=testvariable +1;
      //startvariablen hier einfüllen so dass die grafen live gezeichnet werden
      wipecounter=global.wipecounter;
      shitcounter=global.shitcounter;
      verbrauch_piss=global.verbrauch_piss; //später mit global ersetzen
      verbrauch_shit=global.verbrauch_shit; // mit global ersetzen
      verbrauch_piss_30=global.verbrauch_piss*30;
      verbrauch_shit_30=global.verbrauch_shit.ceil()*30;
      dayscalculated=global.dayscalculated;
    });
  }

  Widget renderTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 15,1,5),
        child: Text(
          title,
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 20, color: Colors.black54),
        ),
      ),
    );
  }
  Widget renderTitleSmall(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0,1,5),
        child: Text(
          title,
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ),
    );
  }
  Widget shadowline(String title) {
    return SliverToBoxAdapter(
      child: new Container(height: 2.0,
        margin: new EdgeInsets.all(0.0),
        decoration: new BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 0.0, // has the effect of softening the shadow
              spreadRadius: 0.0, // has the effect of extending the shadow
              offset: Offset(
                00.0, // horizontal, move right 10
                00.0, // vertical, move down 10
              ),
            )
          ],
        ),)
    );
  }
  Widget dividerTitle(String title) {
    return SliverToBoxAdapter(
      child: new Divider(thickness: 3.0,color: Colors.amber[800],)
    );
  } //leider gibt weißer rand unten

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              elevation: 4.0,
              forceElevated: true,
              pinned: true,
              floating: false,
              snap: false,
              expandedHeight: 160.0,
              backgroundColor: Colors.amber[800],
              stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Column (
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      S.of(context).grafikenUndStatistiken,)
                    ,
                  ],
                ),
                centerTitle: true,
                background: Image.asset(
                  'res/images/jpg/8.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                  [Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(S.of(context).zumStartenUndUpdatenDenButtonRechtsUntenKlicken,style: TextStyle(color: Colors.black54, fontSize: 12),textAlign: TextAlign.center,),
                  ),]
              ),
            ),
            //SliverList(delegate: SliverChildListDelegate([Text(global.amTesten)]),),  //Text input
            //SliverList(delegate: SliverChildListDelegate([Testbutton(context),]),), //Button
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return Testbutton(context);
                },
                childCount: 0,
              ),
            ), // ausgeblendet

            shadowline("divider"),  //wochen
            SliverPersistentHeader(
                pinned: true,
                floating: false,
                delegate: Header(title: S.of(context).verbrauchProWoche, subtitle: S.of(context).inBlttern),

            ),
            SliverList(
              delegate:
              SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  var data = [
                    ClicksPerYear(S.of(context).kleineGeschfte, verbrauch_piss * 7, Colors.amber[800]),
                    ClicksPerYear(S.of(context).groeGeschfte, (verbrauch_shit*7).toInt(), Colors.lightBlue),
                    //ClicksPerYear('(Platzhalter)', testvariable, Colors.purple[500]),
                  ];

                  var series = [
                    charts.Series(
                      domainFn: (ClicksPerYear clickData, _) => clickData.year,
                      measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
                      colorFn: (ClicksPerYear clickData, _) => clickData.color,
                      id: 'Clicks',
                      data: data,
                    ),
                  ];

                  var chart = charts.BarChart(
                    series,
                    animate: true,
                  );

                  var chartWidget = Padding(
                    padding: EdgeInsets.all(32.0),
                    child: SizedBox(
                      height: 225.0,
                      child: chart,
                    ),
                  );

                  return chartWidget;
                },
                childCount: 1,


              ),
            ),

            shadowline("divider"), //monat
            SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: Header(title: S.of(context).verbrauchProMonat, subtitle: S.of(context).imVergleichZumDurchschnitt),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  var data = [
                    ClicksPerYear(S.of(context).du, verbrauch_piss_30+verbrauch_shit_30, Colors.amber[800]),
                    ClicksPerYear(S.of(context).usa, 1896, Colors.lightBlue),
                    ClicksPerYear(S.of(context).durchschnittInDeutschland, 1792, Colors.lightBlue),
                    ClicksPerYear(S.of(context).uk, 1688, Colors.lightBlue),
                    ClicksPerYear(S.of(context).denmark, 1600, Colors.lightBlue),
                    ClicksPerYear(S.of(context).spain, 1083, Colors.lightBlue),
                    ClicksPerYear(S.of(context).brazil, 500, Colors.lightBlue),
                  ];

                  var series = [
                    charts.Series(
                      domainFn: (ClicksPerYear clickData, _) => clickData.year,
                      measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
                      colorFn: (ClicksPerYear clickData, _) => clickData.color,
                      id: 'Clicks',
                      data: data,
                    ),
                  ];

                  var chart = charts.BarChart(
                    series,
                    animate: true,
                  );

                  var chartWidget = Padding(
                    padding: EdgeInsets.all(32.0),
                    child: SizedBox(
                      height: 225.0,
                      child: chart,
                    ),
                  );

                  return chartWidget;
                },
                childCount: 1,

              ),
            ),

            shadowline("divider"),  //hier durchschnitt von 15 Tagen Vorrat festgelegt
            SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: Header(title: S.of(context).soLangeHltDeinVorrat, subtitle: S.of(context).imVergleichZumDurchschnitt),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  var data = [
                    ClicksPerYear(S.of(context).deinVorratInTagen, dayscalculated, Colors.amber[800]),
                    ClicksPerYear(S.of(context).durchschnittNumfrage, 40, Colors.lightBlue),
                  ];

                  var series = [
                    charts.Series(
                      domainFn: (ClicksPerYear clickData, _) => clickData.year,
                      measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
                      colorFn: (ClicksPerYear clickData, _) => clickData.color,
                      id: 'Clicks',
                      data: data,
                    ),
                  ];

                  var chart = charts.BarChart(
                    series,
                    animate: true,
                    vertical: false,
                  );

                  var chartWidget = Padding(
                    padding: EdgeInsets.all(32.0),
                    child: SizedBox(
                      height: 225.0,
                      child: chart,
                    ),
                  );

                  return chartWidget;
                },
                childCount: 1,

              ),
            ),

            SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: Header(title: S.of(context).vorratAufgegliedert, subtitle: S.of(context).inTop10UndNiedrigste10),
            ),
            shadowline("divider"),                //hier top 10%  bottom 10%
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  var data = [
                    ClicksPerYear(S.of(context).top10, 150, Colors.amber[800]),
                    ClicksPerYear(S.of(context).du, dayscalculated, Colors.lightBlue),
                    ClicksPerYear(S.of(context).unterste10, 4, Colors.purple[500]),
                  ];

                  var series = [
                    charts.Series(
                      domainFn: (ClicksPerYear clickData, _) => clickData.year,
                      measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
                      colorFn: (ClicksPerYear clickData, _) => clickData.color,
                      id: 'Clicks',
                      data: data,
                    ),
                  ];

                  var chart = charts.BarChart(
                    series,
                    animate: true,
                  );

                  var chartWidget = Padding(
                    padding: EdgeInsets.all(32.0),
                    child: SizedBox(
                      height: 225.0,
                      child: chart,
                    ),
                  );

                  return chartWidget;
                },
                childCount: 1,

              ),
            ),

            shadowline("divider"),
            SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: Header(title: S.of(context).deinVerbrauchImVergleich, subtitle: S.of(context).orangekleinesGeschftBlaugroesGeschlft),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  var olidata1 = [
                      oli(-verbrauch_shit.toInt(), S.of(context).du,Colors.amber[800]),
                      oli(-20, S.of(context).kommtNoch,Colors.amber[800]),
                      oli(-10, 'z.B Personengruppe A',Colors.yellow),
                    ];
                  var olidata2 = [
                      oli(verbrauch_piss, S.of(context).du,Colors.amber[800]),
                      oli(5, S.of(context).kommtNoch,Colors.amber[800]),
                      oli(30, 'z.B Personengruppe A',Colors.yellow),
                    ];
                  //var olidata = new List.from(olidata1)..addAll(olidata2);

                  var series1 = [
                    charts.Series(
                      domainFn: (oli yAchse, _) => yAchse.xAchse,
                      measureFn: (oli yAchse , _) => yAchse.yAchse,
                      colorFn: (_, __)=>charts.MaterialPalette.blue.shadeDefault,
                      data: olidata1,
                      id: "id1"
                    ),
                  ];
                  var series2 = [
                    charts.Series(
                      domainFn: (oli yAchse, _) => yAchse.xAchse,
                      measureFn: (oli yAchse , _) => yAchse.yAchse,
                      colorFn: (_, __)=> charts.ColorUtil.fromDartColor(Colors.amber[800]),
                      data: olidata2,
                      id: "id2"
                    ),
                  ];
                  var series = series1 + series2;

                  var chart = charts.BarChart(
                    series,
                    animate: true,
                    barGroupingType: charts.BarGroupingType.stacked,
                  );

                  var chartWidget = Padding(
                    padding: EdgeInsets.all(32.0),
                    child: SizedBox(
                      height: 225.0,
                      child: chart,
                    ),
                  );

                  return chartWidget;
                },
                childCount: 1,

              ),
            ),

            shadowline("divider"),
            SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: Header(title: S.of(context).verbrauchsanalyse, subtitle: S.of(context).orangewischhufigkeitBlauanzahlBltter),
            ),
            SliverGrid.count(
              crossAxisCount: 2,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  //width: 180.0,
                  height: 180.0,
                  //color: Colors.white,
                  child: new Stack(
                    alignment: AlignmentDirectional.topCenter,

                    children: <Widget>[
                    new Container(
                      //width: 160,
                      height: 160,
                      child: new DonutPieChart.withSampleData(),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          new BoxShadow(
                            color: Colors.black12,
                            offset: new Offset(3.0, 2.0),
                            blurRadius: 6.0,
                          )
                        ],
                      ),
                    ),
                    new Container(
                      //width: 160,
                      height: 160,
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(S.of(context).durchschnitt,style: TextStyle(color: Colors.black54),)),
                    ),
                  ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(5),
                    //width: 180.0,
                    height: 180.0,
                    color: Colors.white12,
                    child: Column(
                      children: <Widget>[
                        new Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: <Widget>[
                          new Container(
                            //width: 160,
                            height: 160,
                            child: new DonutPieChart.withSampleData2(),
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.black12,
                                  offset: new Offset(3.0, 2.0),
                                  blurRadius: 6.0,
                                )
                              ],
                            ),
                          ),
                          new Container(
                            //width: 160,
                            height: 160,
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(S.of(context).du,style: TextStyle(color: Colors.black54))),
                          ),
                        ],
                        ),
                      ],
                    )
                ),
              ],
            ),

            renderTitle(S.of(context).platzFrWeitereGrafiken),
            shadowline("divider"),
            SliverFixedExtentList(
              itemExtent: 225.0,
              delegate: SliverChildListDelegate(
                [
                  Container(color: Colors.lightBlue),
                  Container(color: Colors.orange),
                  Container(color: Colors.purple[500]),
                ],
              ),
            ),


            SliverFillRemaining( //füllt den restlichen Platz aus
              child: Center(child: Icon(CustomIcons.toilet_roll, color: Colors.black26,),),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed:() {
          vibrate();
          _updatevariable();
        },
        child: GestureDetector(
          child: Icon(CustomIcons.chart_bar,),
          onDoubleTap: (){
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text("Info"),
                content: Text(S.of(context).jedesMalWennDuDieDatenAktualisierstMusstDuDie),
                  contentTextStyle: TextStyle(
                    color: Colors.black54,
                    height: 1.8,
                    fontSize: 18
                  ),
              ),
            );
          },
        ),
          backgroundColor: Colors.amber[800],
      ),
    );
  }
}

class Header extends SliverPersistentHeaderDelegate {
  Header({this.title, this.subtitle});
  final title;
  final subtitle;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    //=> Container(color: Colors.black12);
    return Stack(
      fit: StackFit.expand,
      children: [
      Container(
          height: 60.0,
          //margin: new EdgeInsets.all(10.0),
          decoration: new BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black54.withOpacity(titleOpacity(shrinkOffset)),
                blurRadius: 5.0, // has the effect of softening the shadow
                spreadRadius: -5.0, // has the effect of extending the shadow
                offset: Offset(
                  1.0, // horizontal, move right 10
                  4.0, // vertical, move down 10
                ),
              ),
            ],
          ),
     ),
        Positioned(
          left: 16.0,
          right: 16.0,
          bottom: 20.0,
          child: Text(
            '$title',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black54,
              ),
            ),
          ),
        Positioned(
          left: 16.0,
          right: 16.0,
          bottom: 6.0,
          child: Text(
            '$subtitle',
            style: TextStyle(
                fontSize: 12.0,
                color: Colors.black54
            ),
          ),
        ),
      ],
    );
  }

  double titleOpacity(double shrinkOffset) {
    // simple formula: fade out text as soon as shrinkOffset > 0
    if (shrinkOffset<= 10){
      return 1.0-max(0.0,(shrinkOffset / 10));
    }
    else return 0;
    // more complex formula: starts fading out text when shrinkOffset > minExtent
    //return 1.0 - max(0.0, (shrinkOffset - minExtent)) / (maxExtent - minExtent);
  }

   @override
    double get maxExtent =>    50;
    @override
    double get minExtent => 00;
    @override
    bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}