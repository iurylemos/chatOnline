import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {

  /** Tenho uma coleção teste, e estou colocando um documento teste dentro.
  Firestore.instance.collection("teste").document("teste").setData({"teste" : "teste"}); */

  /**
   * Setando os dados no BD,
   * o primeiro parametro é sempre um KEY e o conteudo ao lado. Depois do :
   * Quando não especificamos um nome pro documento, ele gera automaticamente
   * Um nome único e aleatório.
   *
   * Dentro do meu documento eu tenho os campos e as coleções
   *
   * Para ler os dados basta colocar a coleção o documento e o get
   * Para ler todos os documentos da coleção utiliza o getDocument do tipo QuerySnapshot colocar o await
   *
   * snapshot = fotografia dos dados no momento.
   *
   * Para imprimir os dados coloca snpashot.data, printando os documentos cooloca .document
   *
   * Função para exibir quando houver alguma alteração do BD. (OBSERVANDO O BD)
   * Firestore.instance.collection("mensagens").snapshots().listen((snapshot) {});
   */
  Firestore.instance.collection("usuarios").document().collection("arqmidia").document().setData(data)
  
  runApp(MyApp(

  ));
}

//Declarando o tema.

final ThemeData kIOSTheme = ThemeData(
  primarySwatch: Colors.purple,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light
);

final ThemeData kDefaultTheme = ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat Nós",
      debugShowCheckedModeBanner: false,
      //SE O TEMA FOR IOS, ELE EXECUTA EM IOS, SE FOR ANDROID ELE EXECUTA O OUTRO.
      theme: Theme.of(context).platform == TargetPlatform.iOS ?
       kIOSTheme : kDefaultTheme,
      home: ChatScreen() ,
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      //O SafeArea vai servir para ignorar o NOT do IPHONE e barra abaixo.
      bottom: false,
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Chat Nós"),
          centerTitle: true,
          //Modificar a elevação, no Android tem, mas no IOS não tem.
          //Utilizei a plataforma novamente para definir os parametros
          elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: Column(
          
        ),
      ),
    );
  }
}
