import 'dart:io';

import 'package:chat_lanlink/pages/text_composer.dart';
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



