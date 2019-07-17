import 'package:flutter/material.dart';
import 'package:flutter_app/utils/app_constant.dart';
import 'package:flutter_app/utils/app_util.dart';

class AboutUsScreen extends StatefulWidget {
  State<StatefulWidget> createState() => _AboutUsScreen();
}

class _AboutUsScreen extends State<AboutUsScreen> {

  List<String> _locations = ['None', '0 minutes', '5 minutes', '10 minutes', '15 minutes', '30 minutes', '1 hour', '2 hours', '1 day', '1 week']; // Option 2
  String _selectedLocation; // Option 2

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                      child: Text("Notifications",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: FONT_MEDIUM)),
                    ),
                    ListTile(
                        leading: Icon(Icons.notifications, color: Colors.black),
                        title: Text("Reminder"),
                        subtitle: DropdownButton(
                          hint: Text('Please choose a time'),
                          // Not necessary for Option 1
                          value: _selectedLocation,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedLocation = newValue;
                            });
                          },
                          items: _locations.map((location) {
                            return DropdownMenuItem(
                              child: new Text(location),
                              value: location,
                            );
                          }).toList(),
                        ),
                        onTap: () => launchURL(EMAIL_URL)),
                  ],
                ),
              ),

              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                      child: Text("Authors",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: FONT_MEDIUM)),
                    ),
                    ListTile(
                      leading: Icon(Icons.perm_identity, color: Colors.black),
                      title: Text("Felix Schöllhammer"),
                    ),
                    ListTile(
                      leading: Icon(Icons.perm_identity, color: Colors.black),
                      title: Text("Frederic Ipach"),
                    ),
                    ListTile(
                      leading: Icon(Icons.perm_identity, color: Colors.black),
                      title: Text("Luca Sauer"),
                    ),
                    ListTile(
                        leading: Icon(Icons.email, color: Colors.black),
                        title: Text("Send an Email"),
                        subtitle: Text("maintain@me.com"),
                        onTap: () => launchURL(EMAIL_URL)),
                  ],
                ),
              ),
//              Card(
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Padding(
//                      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
//                      child: Text("Ask Question ?",
//                          style: TextStyle(
//                              color: Colors.black,
//                              fontWeight: FontWeight.bold,
//                              fontSize: FONT_MEDIUM)),
//                    ),
//                    Padding(
//                      padding: const EdgeInsets.all(16.0),
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        children: <Widget>[
//                          IconButton(
//                            icon: Image.asset(
//                              "assets/twitter_logo.png",
//                              scale: 8.75,
//                            ),
//                            onPressed: () => launchURL(TWITTER_URL),
//                          ),
//                          IconButton(
//                            icon: Image.asset("assets/facebook_logo.png"),
//                            onPressed: () => launchURL(FACEBOOK_URL),
//                          )
//                        ],
//                      ),
//                    ),
//                  ],
//                ),
//              ),
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                      child: Text("Apache Licenese",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: FONT_MEDIUM)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListTile(
                        subtitle: Text(
                            'Licensed under the Apache License, Version 2.0 (the "License") you may not use this file except in compliance with the License. You may obtain a copy of the License at'
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
