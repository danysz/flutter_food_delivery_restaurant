import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:great_homies_chef/screens/order_management/order.dart';
import 'package:great_homies_chef/services/auth.dart';
import 'package:great_homies_chef/widgets/appbar.dart';

import '../../main.dart';

class PastOrderScreen extends StatefulWidget {
  @override
  _PastOrderScreenState createState() => new _PastOrderScreenState();
}

class _PastOrderScreenState extends State<PastOrderScreen> with TickerProviderStateMixin {
  //Keys
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
        ? MediaQuery.of(context).size.width
        : (!kIsWeb) ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height / 2;

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: myAppTheme.scaffoldBackgroundColor,
        appBar: getAppBar(scaffoldKey: scaffoldKey, context: context, strAppBarTitle: "Your Past Orders", showBackButton: true),

        //Body
        body: getOrders(size),
      ),
    );
  }

  //
  //
  //
  //
  //
  //
  //
  //
  //
  //
  //
  //
  //
  //
  //
  //Get all the Past Orders done in this restaurant
  getOrders(double size) {
    return StreamBuilder(
      stream: Firestore.instance
          .collectionGroup("Orders")
          .where("restaurant", isEqualTo: userRestaurant["name"]).where("status value", isEqualTo: 100)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot == null || snapshot.data == null || snapshot.hasData == false) {
          return Center(
            child: Container(
              width: 300,
              height: 300,
              child: FlareActor("assets/animations/pizza-loading.flr",
                  isPaused: false, alignment: Alignment.center, fit: BoxFit.contain, animation: "animate"),
            ),
          );
        } else {
          QuerySnapshot _qs = snapshot.data;
          return ListView.builder(
              padding: EdgeInsets.all(8),
              scrollDirection: MediaQuery.of(context).size.height > MediaQuery.of(context).size.width
                  ? Axis.vertical
                  : Axis.horizontal,
              itemCount: _qs.documents.length,
              itemBuilder: (context, index) {
                //Data
                DateTime stOrder = DateTime.parse(_qs.documents[index].data["timestamp"].toString());

                return ListTile(
                  title: Text("Order from: " + _qs.documents[index].data["address"]),
                  subtitle: Text("Ordered on: " +
                      stOrder.hour.toString() +
                      ":" +
                      stOrder.minute.toString() +
                      ", " +
                      stOrder.day.toString() +
                      "/" +
                      stOrder.month.toString() +
                      "/" +
                      stOrder.year.toString()),
                  trailing: Text("₹" + _qs.documents[index].data["total"].toString()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OrderScreen(_qs.documents[index].data)),
                    );
                  },
                );
              });
        }
      },
    );
  }
}
