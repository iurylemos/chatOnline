import 'package:chat_lanlink/pages/call_screen.dart';
import 'package:chat_lanlink/pages/camera_screen.dart';
import 'package:chat_lanlink/pages/chat_screen.dart';
import 'package:chat_lanlink/pages/status_screen.dart';
import 'package:flutter/material.dart';


class WhatNosHome extends StatefulWidget {
  @override
  _WhatNosHomeState createState() => _WhatNosHomeState();
}

class _WhatNosHomeState extends State<WhatNosHome>
    with SingleTickerProviderStateMixin {

      TabController _tabController;

      @override
      void initState() {
        // TODO: implement initState
        super.initState();
        _tabController = new TabController(length: 4, vsync: this, initialIndex: 1);
      }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("WhatNós"),
        elevation: 0.7,
        bottom: new TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            tabs: <Widget>[
              new Tab(icon: new Icon(Icons.camera_alt)),
              new Tab(text: "CHATS"),
              new Tab(text: "STATUS",),
              new Tab(text: "CALLS",),
            ],
        ),
        //Animações
        actions: <Widget>[
          new Icon(Icons.search),
          new Padding(padding: const EdgeInsets.symmetric(horizontal: 5.0)) ,
          new Icon(Icons.more_vert)
        ],
      ),
      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          new CameraScreen(),
          new ChatScreen(),
          new StatusScreen(),
          new CallsScreen(),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
          backgroundColor: Theme.of(context).accentColor,
          //Botão flutuante abaixo de acordo com a cor do thema
          child: new Icon(Icons.message, color: Colors.white,),
          onPressed: () => print("Abrir chats"),
      ),
    );
  }
}

