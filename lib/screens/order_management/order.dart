import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:great_homies_chef/services/auth.dart';
import 'package:great_homies_chef/widgets/buttons.dart';
import 'package:great_homies_chef/widgets/shapes.dart';
import '../../main.dart';
import '../../widgets/appbar.dart';

//==================This is the Menu for the app==================
class OrderScreen extends StatefulWidget {
  Map mapOrder;

  OrderScreen(this.mapOrder);

  @override
  _OrderScreenState createState() => new _OrderScreenState(mapOrder);
}

class _OrderScreenState extends State<OrderScreen> {
  Map mapOrder;
  List lstItems;
  _OrderScreenState(this.mapOrder);

  //Keys
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    lstItems = mapOrder["Items"];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: scaffoldKey,
          backgroundColor: myAppTheme.scaffoldBackgroundColor,
          appBar:
              getAppBar(scaffoldKey: scaffoldKey, context: context, strAppBarTitle: "Your Order", showBackButton: true),

          //Body
          body: ListView(
            padding: EdgeInsets.all(8),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  mapOrder["restaurant"],
                  style: myAppTheme.textTheme.headline2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Order ID: " + mapOrder["timestamp"],
                  style: myAppTheme.textTheme.bodyText1,
                ),
              ),

              //Ordered Items
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Ordered items", style: myAppTheme.textTheme.caption),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 40,
                height: 200,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: lstItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map mapItem = lstItems[index];

                      return Card(
                        shape: roundedShape(),
                        color: myAppTheme.cardColor,
                        margin: EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            //Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                height: 80,
                                width: 100,
                                child: Image.network(
                                  mapItem["photo"],
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),

                            //Content
                            Container(
                              height: 70,
                              width: 120,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  //Food Place Name
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    height: 40,
                                    width: 100,
                                    child: Text(
                                      mapItem["name"],
                                      style: myAppTheme.textTheme.caption,
                                    ),
                                  ),

                                  //Price
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                                    child:
                                        Text("₹" + mapItem["price"].toString(), style: myAppTheme.textTheme.bodyText2),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),

              //Total Price
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Total Price: ", style: myAppTheme.textTheme.caption),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("₹" + mapOrder["total"].toString(), style: myAppTheme.textTheme.bodyText1),
              ),

              //Tracking
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Tracking: ", style: myAppTheme.textTheme.caption),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Status: " + mapOrder["status description"], style: myAppTheme.textTheme.bodyText1),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    //Preparing order
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FilterChip(
                        backgroundColor: myAppTheme.cardColor,
                        label: Text("Preparing Order", style: myAppTheme.textTheme.bodyText2),
                        selected: mapOrder["status description"] == "Preparing Order" ? true : false,
                        onSelected: (val) async {
                          //Update the order Status
                          setState(() {
                            mapOrder["status description"] = "Preparing Order";
                            mapOrder["status value"] = 10.0;
                          });

                          await Firestore.instance.collection("Users").document(mapOrder["user email"])
                              .collection("Orders")
                              .document(mapOrder["timestamp"])
                              .setData(mapOrder);
                        },
                      ),
                    ),

                    //In Transit
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FilterChip(
                        backgroundColor: myAppTheme.cardColor,
                        label: Text("In Transit", style: myAppTheme.textTheme.bodyText2),
                        selected: mapOrder["status description"] == "In Transit" ? true : false,
                        onSelected: (val) async {
                          //Update the order Status
                          setState(() {
                            mapOrder["status description"] = "In Transit";
                            mapOrder["status value"] = 50.0;
                          });

                          await Firestore.instance.collection("Users").document(mapOrder["user email"])
                              .collection("Orders")
                              .document(mapOrder["timestamp"])
                              .setData(mapOrder);
                        },
                      ),
                    ),

                    //Delivered
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FilterChip(
                        backgroundColor: myAppTheme.cardColor,
                        label: Text("Delivered", style: myAppTheme.textTheme.bodyText2),
                        selected: mapOrder["status description"] == "Delivered" ? true : false,
                        onSelected: (val) async {
                          //Update the order Status
                          setState(() {
                            mapOrder["status description"] = "Delivered";
                            mapOrder["status value"] = 100.0;
                          });

                          await Firestore.instance.collection("Users").document(mapOrder["user email"])
                              .collection("Orders")
                              .document(mapOrder["timestamp"])
                              .setData(mapOrder);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              RoundedProgressBar(
                  childLeft: Icon(Icons.restaurant, color: Colors.white),
                  percent: mapOrder["status value"] + 0.0,
                  theme: RoundedProgressBarTheme.red),

              //Back
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: primaryRaisedIconButton(
                    context: context,
                    text: "Back",
                    color: myAppTheme.primaryColor,
                    textColor: Colors.white,
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    }),
              ),
            ],
          )),
    );
  }
}
