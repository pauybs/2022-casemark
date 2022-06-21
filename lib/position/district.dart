import 'package:flutter/material.dart';

final district = ['Asmali Evler', 'Kayihan', 'Bagbasi', 'Zeytinkoy', 'Kinikli'];

final categori = [
  'Yol Kapatılması',
  'Trafik Kazası',
  'Yolda Tehlike',
  'Acil Durum',
  'Diğer (Lütfen Açıklayınız)'
];

DropdownMenuItem<String> buildMenuItem(String district) => DropdownMenuItem(
      value: district,
      child: Text(
        district,
        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
      ),
    );


//ADD PAGE DE Kİ DROP DOWN STİLLERİ BUNLAR