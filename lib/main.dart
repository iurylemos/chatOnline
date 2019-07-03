import 'dart:io';

import 'package:chat_lanlink/principal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

//Função pegar um texto que digitamos e enviar para o banco

_pegandoTexto(String text) async {
  //Certificar que o usuário está logado
  await _certificarLogin();
  _enviarMensagem(text: text);
}

void _enviarMensagem({String text, String imgUrl}) {
  //Pegar o dado da mensagem e enviar para o fireBase
  Firestore.instance.collection("mensagens").add(
    {
      //Aqui dentro temos que passar um mapa
      "text" : text,
      "imgUrl" : imgUrl,
      "nomeUsuario" : googleSignIn.currentUser.displayName,
      "fotoUsuario" : googleSignIn.currentUser.photoUrl
    }
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "WhatNós",
      debugShowCheckedModeBanner: false,
      //SE O TEMA FOR IOS, ELE EXECUTA EM IOS, SE FOR ANDROID ELE EXECUTA O OUTRO.
      theme: Theme.of(context).platform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: WhatNosHome(),
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
          title: Image.network("https://nos.lanlink.com.br/content/uploads/photos/2018/06/nos_bd6da394537859f0467ebd24e2e1810b.png"),
          centerTitle: true,
          //Modificar a elevação, no Android tem, mas no IOS não tem.
          //Utilizei a plataforma novamente para definir os parametros
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                /**
                 * Para ler os dados do firebase de forma que ele sempre atualize
                 * quando um dado novo vier. Utilizamos um Stream
                 * E por isso vou utilizar o StreamBuilder pois com ele
                 * vou especificar um stream, e sempre que um dado novo aparecer
                 * ele vai refazer a minha arvore de widget.
                 */
                    //Esse comando do snapshot me retorna um STREAM
                    //E esse Stream é responsável por ficar observando o meu BD
                    //e notificar sempre que alguma coisa nova aparecer.
                    stream: Firestore.instance.collection("mensagens").snapshots(),
                    builder: (context, snapshot) {
                      //Essa função vai me retornar o que eu quero botar aqui na tela
                      //Dependendo do dado que vier do banco
                      switch(snapshot.connectionState) {
                        case ConnectionState.none :
                        case ConnectionState.waiting :
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        default:
                          return ListView.builder(
                              /**Esse ListView vai conter os balões com as mensagens
                               * Porém esse ListView eu quero uma lista reversa
                               * Pois as mensagens mais recenter vão aparecer em baixo das antigas
                              */
                              reverse: true,
                              //Como eu peguei lá no stream que é a coleção
                              //Ele retorna uma lista de documentos, e por isso eu atribuio
                              //Ao itemCount
                              //Quantidade de itens
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                /**Vou declar uma lista que vai conter os mesmo conteudos
                                 * Da outra lista, só que invertido, para que a mensagem
                                 * Que eu inserir vá aparecer em baixo e não em cima.
                                //E aqui eu retorno o item que eu quero para a lista */
                                List reverso = snapshot.data.documents.reversed.toList();
                                return ChatMensagem(reverso[index].data);
                              }
                          );
                      }

                    }
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
  //Controllador para pegar a mensagem do texto
  final _textController = TextEditingController();


  //Variavel para controlar se estou inserindo um texto ou não
  bool _isComposing = false;

  //Função para resetar o controller depois que for executado.
  void _reset() {
    setState(() {
      _textController.clear();
    });
  }


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
                  IconButton(icon: Icon(Icons.photo_camera),
                      onPressed: () async {
                        //Ao apertar o botão da camêra, vou certificar que o usuário tá logado
                        await _certificarLogin();
                        //Agora vou pegar a imagem, dentro boto a fonte é a camera
                        //E atribuindo ao imgFile
                         File imgFile = await ImagePicker.pickImage(source: ImageSource.camera);
                         if(imgFile == null) return;
                         //caso contrário faço o upload
                        //Um grande sistema utiliza child
                        //Para que o nome do arquivo seja único
                        //Coloco dentro do child
                        //Transformo um ID em uma STRING
                        //E Concateno com o Tempo em Milisegundos
                        /**
                         * Pegamos a referencia do Storage
                         * Demos um child
                         * Dentro do child passando o nome do nosso arquivo
                         * Nesse nome estou pegando o ID do usuário e o tempo em que enviou
                         * E assim o nome da imagem fica único!!
                         *
                         * Se eu quiser amazenar em uma pasta basta eu colocar
                         * depois do ref, um child("fotos"). e assim vou navegando
                         * Como se fosse em um sistema de arquivos
                         *
                         * E como o putFile me retorna do tipo StorageUploadTask, coloquei
                         * para isso me retornar para a variavel task do mesmo tipo
                         */
                         StorageUploadTask task = FirebaseStorage.instance.ref().
                          child(googleSignIn.currentUser.id.toString() +
                             DateTime.now().millisecondsSinceEpoch.toString()).putFile(imgFile);
                        StorageTaskSnapshot taskSnapshot = await task.onComplete;
                        String url = await taskSnapshot.ref.getDownloadURL();
                        _enviarMensagem(imgUrl: url);
                      }),
            ),
            Expanded(
              child: TextField(
                controller: _textController,
                decoration:
                    InputDecoration.collapsed(hintText: "Enviar uma mensagem"),
                onChanged: (text) {
                  //Se o texto for maior que zero vai está compondo, se não tiver não vai está
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                //Estou colocando o onSubmitted aqui pois podemos enviar a mensagem
                //Tanto pelo botão, quanto pelo botão no teclado.
                onSubmitted: (text) {
                  _pegandoTexto(text);
                  _reset();
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
                        onPressed: _isComposing ? () {
                          _pegandoTexto(_textController.text);
                          _reset();
                        } : null,
                      )
                    //Caso seja ANDROID ele vai retornar um botão
                    : IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _isComposing ? () {
                          _pegandoTexto(_textController.text);
                          _reset();
                        } : null,
                      ))
          ],
        ),
      ),
    );
  }
}

//Widget para os balões das mensagens

class ChatMensagem extends StatelessWidget {

  final Map<String, dynamic> dados;

  //Construtor do ChatMensagem ele recebe um dado, e vou amazenar esse dado em um Mapa
  //Esse dado vai ser, os dados de cada mensagem
  ChatMensagem(this.dados);


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
                  dados["fotoUsuario"]),
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
                  dados["nomeUsuario"],
                  //Pegando o tema padrão para texto (TEXTTHEME)
                  style: Theme.of(context).textTheme.subhead,
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  //Se os dados imgUrl for diferente de nulo,
                  //Ou seja se eu tiver uma imagem aqui
                    //Apenas para não invadir a minha tela inteira
                    //Quero especificar que ela ocupe só uma parte especifica da tela
                    //Caso contrário ai sim eu retorno um texto
                  child: dados["imgUrl"] != null ?
                      Image.network(dados["imgUrl"], width: 250.0,) :
                      Text(dados["text"])
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
