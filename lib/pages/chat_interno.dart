import 'package:chat_lanlink/pages/chat_mensagem.dart';
import 'package:chat_lanlink/pages/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatInterno extends StatefulWidget {
  @override
  ChatInternoState createState() => ChatInternoState();
}

class ChatInternoState extends State<ChatInterno> {
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