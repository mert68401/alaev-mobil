import 'dart:ui';

import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  static const routeName = '/about';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ALAEV Hakkında'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Image.asset('assets/images/IMG_hakkinda.jpeg'),
            SizedBox(height: 20),
            Text('ALA\'lı olmak, bir ömür boyu beraber olmaktır.', style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
            SizedBox(height: 20),
            Text('Adana Anadolu Lisesinin bir eğitim kurumu kimliği ile devamlılığını, gelişimini sağlayarak, mezunlar, öğrenciler ve mezun olmasalar dahi Adana Anadolu Lisesi’nde öğrenim görmüş tüm kişilerin sosyal dayanışmasını geliştirmek ve insanımızın kültürel, bilimsel ve sosyal gelişimine yüksek kalitede, etkin ve çağdaş eğitim hizmetleri ile katkıda bulunmak amacıyla kurulmuş bir vakıftır.', style: TextStyle(fontSize: 17),)
          ],
        ),
      ),
    );
  }
}
