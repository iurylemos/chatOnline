import 'package:flutter/material.dart';

class ChatModel {
  final String nome;
  final String mensagem;
  final String tempo;
  final String avatarUrl;

  ChatModel({this.nome, this.mensagem, this.tempo, this.avatarUrl});


  }

  Widget _criandoTabelaDados(BuildContext context, AsyncSnapshot snapshot) {

  }

  List<ChatModel> dadosFicticios = [
    new ChatModel(
      nome: "Bignardo",
      mensagem: "Olá Flutter",
      tempo: "15:40",
      avatarUrl: "http://3.bp.blogspot.com/-q6FU_W2OJQk/UNH5vzi4WHI/AAAAAAAAACs/zqg3IlrOqZ0/s1600/jscisbissbisdsds.JPG"
    ),
    new ChatModel(
        nome: "Bignardo Gomes",
        mensagem: "Olá. Sou o melhor",
        tempo: "15:40",
        avatarUrl: "http://3.bp.blogspot.com/-q6FU_W2OJQk/UNH5vzi4WHI/AAAAAAAAACs/zqg3IlrOqZ0/s1600/jscisbissbisdsds.JPG",
    ),
    new ChatModel(
        nome: "Grande Nardo",
        mensagem: "Olá. Bem vindos!!",
        tempo: "15:40",
        avatarUrl: "http://3.bp.blogspot.com/-q6FU_W2OJQk/UNH5vzi4WHI/AAAAAAAAACs/zqg3IlrOqZ0/s1600/jscisbissbisdsds.JPG"
    ),
    new ChatModel(
        nome: "Grande Bignardo",
        mensagem: "Olá, vou hackear o seu whatsapp",
        tempo: "15:50",
        avatarUrl: "http://3.bp.blogspot.com/-q6FU_W2OJQk/UNH5vzi4WHI/AAAAAAAAACs/zqg3IlrOqZ0/s1600/jscisbissbisdsds.JPG"
    ),
    new ChatModel(
        nome: "Gigante Nardo",
        mensagem: "Olá Flutter, já hackiei o seu",
        tempo: "1:40",
        avatarUrl: "http://3.bp.blogspot.com/-q6FU_W2OJQk/UNH5vzi4WHI/AAAAAAAAACs/zqg3IlrOqZ0/s1600/jscisbissbisdsds.JPG"
    ),
    new ChatModel(
        nome: "Bignardo",
        mensagem: "Olá Flutter. Me conheça melhor",
        tempo: "15:40",
        avatarUrl: "http://3.bp.blogspot.com/-q6FU_W2OJQk/UNH5vzi4WHI/AAAAAAAAACs/zqg3IlrOqZ0/s1600/jscisbissbisdsds.JPG"
    ),
  ];


