import 'package:flutter/material.dart';

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