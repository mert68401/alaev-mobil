// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';

import 'package:alaev/functions/functions.dart';
import 'package:alaev/functions/requests.dart';
import 'package:alaev/data/city_select.dart';
import 'package:alaev/widgets/textfield_default.dart';
import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';

class AddNewJobAdvScreen extends StatefulWidget {
  static const routeName = "/add-new-job-advertisement";

  @override
  _AddNewJobAdvScreenState createState() => _AddNewJobAdvScreenState();
}

class _AddNewJobAdvScreenState extends State<AddNewJobAdvScreen> {
  String _jobAdImageUrl = '';
  final _jobAdTitle = TextEditingController();
  final _jobAdCompanyNumber = TextEditingController();
  final _jobAdPersonalNumber = TextEditingController();
  final _jobAdMail = TextEditingController();
  final _jobAdContent = TextEditingController();

  String _selectedItem = 'Diğer';
  String _diplomaItem = 'Hepsi';
  String _citySelectedItem;
  String _jobTypeItem;

  List<S2Choice<String>> jobTypeItems = [
    S2Choice<String>(value: 'İş Veren', title: 'İş Veren'),
    S2Choice<String>(value: 'İş Arayan', title: 'İş Arayan'),
  ];

  List<S2Choice<String>> items = [
    S2Choice<String>(value: 'Bilişim', title: 'Bilişim'),
    S2Choice<String>(value: 'Gıda', title: 'Gıda'),
    S2Choice<String>(value: 'Sağlık', title: 'Sağlık'),
    S2Choice<String>(value: 'Hizmet', title: 'Hizmet'),
    S2Choice<String>(value: 'Tekstil', title: 'Tekstil'),
    S2Choice<String>(value: 'Ticaret', title: 'Ticaret'),
    S2Choice<String>(value: 'Yapı', title: 'Yapı'),
    S2Choice<String>(value: 'Otomotiv', title: 'Otomotiv'),
    S2Choice<String>(value: 'Eğitim', title: 'Eğitim'),
    S2Choice<String>(value: 'Diğer', title: 'Diğer'),
  ];

  List<S2Choice<String>> diplomaItems = [
    S2Choice<String>(value: 'Hepsi', title: 'Hepsi'),
    S2Choice<String>(value: 'Lise', title: 'Lise'),
    S2Choice<String>(
        value: 'Önlisans - Öğrenci', title: 'Önlisans - Öğrenci'),
    S2Choice<String>(
        value: 'Önlisans - Mezun', title: 'Önlisans - Mezun'),
    S2Choice<String>(
        value: 'Üniversite - Öğrenci', title: 'Üniversite - Öğrenci'),
    S2Choice<String>(
        value: 'Üniversite - Mezun', title: 'Üniversite - Mezun'),
    S2Choice<String>(value: 'Yüksek Lisans', title: 'Yüksek Lisans'),
    S2Choice<String>(value: 'Doktora', title: 'Doktora'),
  ];

  bool _showProgress = false;

  void dispose() {
    super.dispose();
  }

  Widget smartSelectJobType(String title, List options, String value) {
    return SmartSelect<String>.single(
        placeholder: 'Seçiniz',
        title: title,
        modalType: S2ModalType.popupDialog,
        value: value,
        choiceItems: options,
        onChange: (val) => setState(() => _jobTypeItem = val.value));
  }

  Widget smartSelectKategori(String title, List options, String value) {
    return SmartSelect<String>.single(
        title: title,
        modalType: S2ModalType.popupDialog,
        value: value,
        choiceItems: options,
        onChange: (val) => setState(() => _selectedItem = val.value));
  }

  Widget smartSelectDiploma(String title, List options, String value) {
    return SmartSelect<String>.single(
        title: title,
        modalType: S2ModalType.popupDialog,
        value: value,
        choiceItems: options,
        onChange: (val) => setState(() => _diplomaItem = val.value));
  }

  Widget smartSelectCity() {
    return SmartSelect<String>.single(
        placeholder: 'Seçiniz',
        title: 'Şehir',
        modalType: S2ModalType.popupDialog,
        value: _citySelectedItem,
        choiceItems: S2Choice.listFrom<String, Map<String, String>>(
          source: cities,
          value: (index, item) => item['value'],
          title: (index, item) => item['title'],
        ),
        onChange: (val) => setState(() => _citySelectedItem = val.value));
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Bilgileri Eksiksiz Giriniz!'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Tamam'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor, //change your color here
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              "./assets/images/alaevLogoClean.png",
              scale: 11,
            ),
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: _showProgress
                ? Center(
                    heightFactor: 25,
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    child: Column(
                      children: <Widget>[
                        smartSelectJobType(
                            'İlan Tipi', jobTypeItems, _jobTypeItem),
                        SizedBox(height: 10),
                        Container(
                            child: TextFieldWidget(
                          controller: _jobAdTitle,
                          labelText: 'İlan Başlığı',
                          height: 60,
                        )),
                        SizedBox(height: 10),
                        _jobTypeItem == 'İş Veren'
                            ? Container(
                                child: TextFieldWidget(
                                keyboardType: TextInputType.number,
                                controller: _jobAdCompanyNumber,
                                labelText: 'Firma Telefon Numarası',
                                height: 60,
                                maxLength: 13,
                              ))
                            : SizedBox(),
                        SizedBox(height: 10),
                        Container(
                            child: TextFieldWidget(
                          keyboardType: TextInputType.number,
                          controller: _jobAdPersonalNumber,
                          labelText: 'Kişisel Telefon Numarası',
                          height: 60,
                          maxLength: 13,
                        )),
                        SizedBox(height: 10),
                        Container(
                            child: TextFieldWidget(
                          keyboardType: TextInputType.emailAddress,
                          controller: _jobAdMail,
                          labelText: 'Mail Adresi',
                          height: 60,
                          maxLength: 30,
                        )),
                        smartSelectCity(),
                        smartSelectKategori('Kategori', items, _selectedItem),
                        smartSelectDiploma(
                            'Öğrenim Durumu', diplomaItems, _diplomaItem),
                        Container(
                            child: TextFieldWidget(
                          controller: _jobAdContent,
                          labelText: 'İş İle İlgili Açıklama',
                          height: 200,
                          maxLines: 8,
                          maxLength: 500,
                          counterText: null,
                        )),
                        Container(
                          child: RaisedButton(
                            child: Text("İlanı Kaydet"),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            textColor: Colors.white,
                            color: Colors.green,
                            onPressed: () {
                              if (!validateEmail(_jobAdMail.text)) {
                                showToastError(
                                    "Doğru bir mail adresi girdiğinizden emin olun!");
                                return;
                              }
                              if (_jobAdTitle.text != '' &&
                                  _citySelectedItem != null &&
                                  _jobAdMail.text != '' &&
                                  _jobAdContent.text != '') {
                                setState(() {
                                  _showProgress = !_showProgress;
                                });
                                addJobAdvertisementRequest(
                                  filter: '',
                                  jobAdTitle: _jobAdTitle.text,
                                  jobAdImageUrl: _jobAdImageUrl.toString(),
                                  jobAdCompanyNumber: _jobTypeItem == 'İş Veren'
                                      ? _jobAdCompanyNumber.text
                                      : null,
                                  jobAdPersonalNumber:
                                      _jobAdPersonalNumber.text,
                                  jobAdMail: _jobAdMail.text,
                                  jobAdContent: _jobAdContent.text,
                                  jobAdType: _selectedItem,
                                  jobAdDiploma: _diplomaItem,
                                  city: _citySelectedItem,
                                  jobType: _jobTypeItem,
                                );
                                Future.delayed(
                                    const Duration(milliseconds: 2000), () {
                                  setState(() {
                                    _showProgress = !_showProgress;
                                    Navigator.pop(context);
                                  });
                                });
                              } else {
                                _showMyDialog();
                                return;
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
