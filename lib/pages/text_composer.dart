import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

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