import 'package:flutter/material.dart';
import 'package:chat_lanlink/models/chat_model.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: dadosFicticios.length,
        itemBuilder: (context, index) => new Column(
          children: <Widget>[
            new Divider(
              height: 10.0,
            ),
            new ListTile(
              leading: new CircleAvatar(
                foregroundColor: Theme.of(context).primaryColor,
                backgroundColor: Colors.grey,
                backgroundImage: new NetworkImage(dadosFicticios[index].avatarUrl),
              ),
              title: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(dadosFicticios[index].nome,
                    style: new TextStyle(fontWeight: FontWeight.bold),
                  ),
                  new Text(dadosFicticios[index].tempo,
                    style: new TextStyle(color: Colors.grey, fontSize: 14.0),
                  ),
                ],
              ),
              subtitle: new Container(
                padding: const EdgeInsets.only(top: 5.0),
                child: new Text(dadosFicticios[index].mensagem,
                  style: new TextStyle(color: Colors.grey, fontSize: 15.0),
                ),
              ),
            )
          ],
        )
    );
  }
}
