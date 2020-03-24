import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:great_homies_chef/widgets/buttons.dart';
import 'package:great_homies_chef/widgets/dialogboxes.dart';
import 'package:great_homies_chef/widgets/form.dart';

import '../main.dart';
import '../services/auth.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => new _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //Keys
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //For Text Input
  TextEditingController _tecResName = new TextEditingController(text: userProfile["restaurant name"] ?? ""),
      _tecAddress = new TextEditingController(text: userRestaurant["address"] ?? "");

  @override
  void dispose() {
    _tecResName.dispose();
    _tecAddress.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
        ? MediaQuery.of(context).size.width
        : (!kIsWeb) ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height / 2;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: myAppTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.grey),
          elevation: 0,
          titleSpacing: 0.0,
          centerTitle: true,
          backgroundColor: myAppTheme.scaffoldBackgroundColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: myAppTheme.iconTheme.color, size: myAppTheme.iconTheme.size),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              //Title
              Text(
                userProfile.containsKey("name") ? userProfile["name"] : "Profile",
                style: myAppTheme.textTheme.bodyText2,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        //Body
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              //Profile Photo
              userProfile.containsKey("photo url")
                  ? Center(
                      child: InkWell(
                          child: Container(
                            height: size * 0.18,
                            width: size * 0.18,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(userProfile["photo url"]),
                              minRadius: 90,
                              maxRadius: 180,
                            ),
                          ),
                          onTap: () => {
                                //TODO: Change the Profile picture
                              }),
                    )
                  : Center(
                      child: IconButton(
                          icon: Icon(Icons.account_circle, color: myAppTheme.iconTheme.color),
                          iconSize: size * 0.18,
                          onPressed: () => {
                                //TODO: Change the Profile picture
                              }),
                    ),

              //Profile Name
              Card(
                  color: myAppTheme.cardColor,
                  margin: myAppTheme.cardTheme.margin,
                  shape: myAppTheme.cardTheme.shape,
                  elevation: 6,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                    //Login ID
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Your name",
                        style: myAppTheme.textTheme.caption,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        userProfile.containsKey("name") ? userProfile["name"] : "Unknown User",
                        style: myAppTheme.textTheme.bodyText2,
                      ),
                    ),
                  ])),

              //Profile Email
              Card(
                  color: myAppTheme.cardColor,
                  margin: myAppTheme.cardTheme.margin,
                  shape: myAppTheme.cardTheme.shape,
                  elevation: 6,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                    //Login ID
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Your Email",
                        style: myAppTheme.textTheme.caption,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        userProfile.containsKey("email") ? userProfile["email"] : "Unknown Email",
                        style: myAppTheme.textTheme.bodyText2,
                      ),
                    ),
                  ])),

              //Restaurant Name
              Card(
                color: myAppTheme.cardColor,
                margin: myAppTheme.cardTheme.margin,
                shape: myAppTheme.cardTheme.shape,
                elevation: 6,
                child:

                userProfile.containsKey("restaurant name")
                    ?
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //Login ID
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Your Restaurant name",
                        style: myAppTheme.textTheme.caption,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        userProfile["restaurant name"],
                        style: myAppTheme.textTheme.bodyText2,
                      ),
                    ),
                  ],
                )

                    : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: getTextFormField(
                      context: context,
                      controller: _tecResName,
                      strHintText: "Restaurant name",
                      strLabelText: "Enter your Restaurant name here",
                      keyboardType: TextInputType.text
                  ),
                ),
              ),

              //Restaurant Address
              Card(
                color: myAppTheme.cardColor,
                margin: myAppTheme.cardTheme.margin,
                shape: myAppTheme.cardTheme.shape,
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: getTextFormField(
                      context: context,
                      controller: _tecAddress,
                      strHintText: "Restaurant address",
                      strLabelText: "Enter your Restaurant address",
                      keyboardType: TextInputType.text),
                ),
              ),


              Padding(
                padding: const EdgeInsets.all(30),
                child: primaryRaisedButton(
                    context: context,
                    text: "Save",
                    color: myAppTheme.primaryColor,
                    textColor: Colors.white,
                    onPressed: () async {
                      if (_tecResName.text == null || _tecResName.text == "" || _tecAddress.text == null ||
                          _tecAddress.text == "") {
                        showAlertDialog(context, "Fields empty", "Please fill in all the fields");
                        return;
                      }


                      //Ask for confirmation
                      if (userProfile.containsKey("restaurant name") == false) {
                        bool blStart = (await showDialog(
                          context: context,
                          builder: (context) =>
                              AlertDialog(
                                title: new Text("Confirm?"),
                                content: new Text(
                                    "Do you want set this as your Restaurant name?\n This can't be changed later."),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: new Text('No'),
                                  ),
                                  FlatButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: new Text('Yes'),
                                  ),
                                ],
                              ),
                        )) ?? false;

                        if (!blStart) return;
                        userProfile["restaurant name"] = _tecResName.text;
                        await authService.setData();
                      }


                      showLoading(context);

                      //Name
                      userRestaurant["name"] = userProfile["restaurant name"];

                      //Address
                      userRestaurant["restaurant address"] = _tecAddress.text;

                      //Set the new Data
                      await authService.setRestaurantData();

                      Navigator.of(context, rootNavigator: true).pop();
                      showSnackBar(scaffoldKey: _scaffoldKey, text: "Restraunt details updated");
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
