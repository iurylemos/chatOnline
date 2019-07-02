import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart'

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
  //Firestore.instance.collection("usuarios").document().collection("arqmidia").document().setData(data)

  runApp(MyApp());
}

//Declarando o tema.

final ThemeData kIOSTheme = ThemeData(
    primarySwatch: Colors.purple,
    primaryColor: Colors.grey[100],
    primaryColorBrightness: Brightness.light);

final ThemeData kDefaultTheme = ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

//Declarando o login
final googleSignIn = GoogleSignIn();
final auth = FirebaseAuth.instance;

/**
 * Função para certificar que o usuário está logado
 */
Future<Null> _certificarLogin() async {
  GoogleSignInAccount usuario = googleSignIn.currentUser;
  if(usuario == null)
    //Se o usuário já tiver logado uma vez, se ele tiver
    //Vou fazer um login silencioso, para não incomodar o usuário
    usuario = await googleSignIn.signInSilently();
    //Se ele não conseguiu logar, ou seja se tiver nulo ainda
  if(usuario == null)
    usuario = await googleSignIn.signIn();
  //Depois que ele pegou o usuário autenticado no Google, ele vai autenticar no FireBase
  if(await auth.currentUser() == null) {
    //Se o usuário no Firebase é nulo
    //Pegamos as credeciais do usuário no google
    GoogleSignInAuthentication credenciais = await googleSignIn.currentUser.authentication;

    await auth.signInWithCredential(GoogleAuthProvider.getCredential(
        idToken: credenciais.idToken, accessToken: credenciais.accessToken));
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat Nós",
      debugShowCheckedModeBanner: false,
      //SE O TEMA FOR IOS, ELE EXECUTA EM IOS, SE FOR ANDROID ELE EXECUTA O OUTRO.
      theme: Theme.of(context).platform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: ChatScreen(),
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
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  ChatMensagem(),
                  ChatMensagem(),
                  ChatMensagem(),
                ],
              ),
            ),
            //Colocar um Divider
            Divider(
              height: 1.0,
            ),
            Container(
              //Container q vai ser um retangulo branco onde vai ter o campo de texto
              decoration: BoxDecoration(
                //Cor
                color: Theme.of(context).cardColor,
              ),
              child: TextComposer(),
            )
          ],
        ),
      ),
    );
  }
}

class TextComposer extends StatefulWidget {
  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  //Variavel para controlar se estou inserindo um texto ou não
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    //Especificando as cores dos meus icones
    return IconTheme(
      /**
       * Quando eu quiser que uma cor seja aplicada apenas em uma parte
       * do meu app, eu tenho que utilizar o Theme, especificar o tema logo nele
       *
       * Todos que são filhos do meu IconTheme terão a cor do meu accentColor
       * Que especifiquei a cima.
       *
       * Margin é fora do objeto, e margin é dentro do OBJETO
       */
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        //Margin, coloquei como const pois ele não vai mudar.
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        //Decoração caso for IOS
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[200])))
            : null,
        //Coloquei um filho para poder colocar o icone da camera do texto
        //E o botão enviar.
        child: Row(
          children: <Widget>[
            Container(
              child:
                  IconButton(icon: Icon(Icons.photo_camera), onPressed: () {}),
            ),
            Expanded(
              child: TextField(
                decoration:
                    InputDecoration.collapsed(hintText: "Enviar uma mensagem"),
                onChanged: (text) {
                  //Se o texto for maior que zero vai está compondo, se não tiver não vai está
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
              ),
            ),
            //Colocando um container para botar o icone de ENVIAR
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoButton(
                        child: Text("Enviar"),
                        //Estou botando como nulo, pois se não tiver mensagem
                        //E ele clique em enviar, vai está desabilidado
                        onPressed: _isComposing ? () {} : null,
                      )
                    //Caso seja ANDROID ele vai retornar um botão
                    : IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _isComposing ? () {} : null,
                      ))
          ],
        ),
      ),
    );
  }
}

//Widget para os balões das mensagens

class ChatMensagem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //Não quero que as mensagens fiquem coladas uma na outra.
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      //Vou colocar uma linha, pois do lado esquerdo vou colocar a imagem
      //Do lado direito o conteudo da mensagem
      child: Row(
        //se a mensagem tiver muitas linhas ele vai manter a foto alinhada no topo
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            //Para que a imagem da pessoa não fique colada na mensagem
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  "data:image/png;base64,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"),
            ),
          ),
          //Em baixo do container, ou seja do lado dieito do Container, já que estamos em linha
          //Expanded para que ocupe o maior espaço possível
          Expanded(
            child: Column(
              //Coluna por que vamos colocar em cima o nome da pessoa e em baixo a msg
              //Alinhamento do nome que estava lá no meio. Para do lado da imagem
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Iury",
                  //Pegando o tema padrão para texto (TEXTTHEME)
                  style: Theme.of(context).textTheme.subhead,
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  //Filho pode ser uma imagem ou texto.
                  child: Text("Teste"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
