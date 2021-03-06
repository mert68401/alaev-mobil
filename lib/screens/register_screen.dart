import 'package:alaev/data/faculties.dart';
import 'package:alaev/data/jobs.dart';
import 'package:alaev/functions/functions.dart';
import 'package:alaev/providers/auth.dart';
import 'package:alaev/data/city_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register-page';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _password2Controller = TextEditingController();
  final _graduateYearController = TextEditingController();
  final _universityController = TextEditingController();
  final _phoneController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _companyAdressController = TextEditingController();
  final _companyPhoneController = TextEditingController();

  String _selectedItem;
  String _selectedJobItem;
  String _citySelectedItem;
  String _facultySelectedItem;

  List<S2Choice<String>> items = [
    S2Choice<String>(value: 'Kurumsal', title: 'Evet'),
    S2Choice<String>(value: 'Bireysel', title: 'Hayır'),
  ];

  List<S2Choice<String>> jobs = [
    S2Choice<String>(value: 'TEST1', title: 'TEST1'),
    S2Choice<String>(value: 'TEST2', title: 'TEST2'),
  ];

  bool _isLoading;

  Widget smartSelect(String title, List options, String value) {
    return SmartSelect<String>.single(
        placeholder: "Şeçiniz",
        title: title,
        modalType: S2ModalType.popupDialog,
        value: value,
        choiceItems: options,
        onChange: (val) {
          setState(() => _selectedItem = val.value);
        });
  }

  Widget smartSelectJob() {
    return SmartSelect<String>.single(
        placeholder: "Şeçiniz",
        title: "Meslek",
        modalType: S2ModalType.popupDialog,
        modalFilter: true,
        value: _selectedJobItem,
        choiceItems: S2Choice.listFrom<String, Map<String, String>>(
          source: jobsList,
          value: (index, item) => item['value'],
          title: (index, item) => item['title'],
        ),
        onChange: (val) {
          setState(() => _selectedJobItem = val.value);
        });
  }

  Widget smartSelectFaculty(String title, String value) {
    return SmartSelect<String>.single(
        placeholder: "Şeçiniz",
        title: title,
        modalType: S2ModalType.popupDialog,
        modalFilter: true,
        value: value,
        choiceItems: S2Choice.listFrom<String, Map<String, String>>(
          source: facultiesList,
          value: (index, item) => item['value'],
          title: (index, item) => item['title'],
        ),
        onChange: (val) => setState(() => _facultySelectedItem = val.value));
  }

  Widget smartSelectCity() {
    return SmartSelect<String>.single(
        placeholder: "Şeçiniz",
        title: 'Şehir*',
        modalType: S2ModalType.popupDialog,
        modalFilter: true,
        value: _citySelectedItem,
        choiceItems: S2Choice.listFrom<String, Map<String, String>>(
          source: citiesWithoutAll,
          value: (index, item) => item['value'],
          title: (index, item) => item['title'],
        ),
        onChange: (val) => setState(() => _citySelectedItem = val.value));
  }

  @override
  Widget build(BuildContext context) {
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
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(height: 8),
                    Text(
                      'Kayıt Ol',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 60,
                      child: TextField(
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        controller: _fullNameController,
                        decoration: InputDecoration(
                          labelText: 'Ad Soyad*',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 10),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 60,
                      child: TextField(
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email*',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 10),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 60,
                      child: TextField(
                        obscureText: true,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        controller:
                            _passwordController, //--------------------------------
                        decoration: InputDecoration(
                          labelText: 'Şifre*',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 10),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 60,
                      child: TextField(
                        obscureText: true,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        controller:
                            _password2Controller, //--------------------------------
                        decoration: InputDecoration(
                          labelText: 'Şifre Tekrar*',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 10),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    smartSelectCity(),
                    SizedBox(height: 10),
                    Container(
                      height: 60,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: _graduateYearController,
                        decoration: InputDecoration(
                          counterText: "",
                          labelText: 'Mezuniyet Yılı*',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 10),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 60,
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        obscureText: false,
                        textAlign: TextAlign.start,
                        maxLength: 11,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        controller:
                            _phoneController, //--------------------------------
                        decoration: InputDecoration(
                          counterText: '',
                          labelText: 'Telefon Numarası',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 10),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 60,
                      child: TextField(
                        obscureText: false,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        controller:
                            _universityController, //--------------------------------
                        decoration: InputDecoration(
                          labelText: 'Üniversite',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 10),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    smartSelectFaculty("Bölüm", _facultySelectedItem),
                    SizedBox(height: 10),
                    smartSelectJob(),
                    // Container(
                    //   height: 60,
                    //   child: TextField(
                    //     obscureText: false,
                    //     textAlign: TextAlign.start,
                    //     style: TextStyle(
                    //       fontSize: 14,
                    //     ),
                    //     controller:
                    //         _jobController, //--------------------------------
                    //     decoration: InputDecoration(
                    //       labelText: 'Mesleğiniz',
                    //       border: OutlineInputBorder(
                    //         borderSide: BorderSide(width: 10),
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //       filled: true,
                    //       fillColor: Colors.white,
                    //     ),
                    //   ),
                    // ),
                    smartSelect('Kendinize ait bir firma bulunmakta mı?', items,
                        _selectedItem),

                    SizedBox(height: 10),
                    _selectedItem == 'Kurumsal'
                        ? Container(
                            height: 60,
                            child: TextField(
                              obscureText: false,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                              controller:
                                  _companyNameController, //--------------------------------
                              decoration: InputDecoration(
                                labelText: 'Firma Adı*',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 10),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          )
                        : SizedBox(),
                    SizedBox(height: 10),
                    _selectedItem != 'Kurumsal'
                        ? SizedBox()
                        : Container(
                            height: 60,
                            child: TextField(
                              obscureText: false,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                              controller:
                                  _companyAdressController, //--------------------------------
                              decoration: InputDecoration(
                                labelText: 'Firma Adresi*',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 10),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                    SizedBox(height: 10),
                    _selectedItem != 'Kurumsal'
                        ? SizedBox()
                        : Container(
                            height: 60,
                            child: TextField(
                              keyboardType: TextInputType.phone,
                              obscureText: false,
                              textAlign: TextAlign.start,
                              maxLength: 11,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                              controller:
                                  _companyPhoneController, //--------------------------------
                              decoration: InputDecoration(
                                counterText: '',
                                labelText: 'Firma Telefon Numarası',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 10),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.only(left: 40, right: 40),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _isLoading = true;
                          });
                          if (_fullNameController.text == '' ||
                              _emailController.text == '' ||
                              _selectedItem == '' ||
                              _selectedItem == null ||
                              _citySelectedItem == '' ||
                              _citySelectedItem == null ||
                              _graduateYearController.text == '' ||
                              _graduateYearController.text == null ||
                              _phoneController.text == '') {
                            showToastError("Bilgiler eksiksiz girilmelidir!");
                            return;
                          }
                          if (!validateEmail(_emailController.text)) {
                            showToastError(
                                "Doğru bir mail adresi girdiğinizden emin olun!");
                            return;
                          }
                          if (_phoneController.text == '') {
                            showToastError(
                                "Lütfen bir telefon numarası giriniz!");
                            return;
                          }
                          if (_passwordController.text.length < 5) {
                            showToastError(
                                "Şifreniz en az 6 karakter olmalıdır!");
                            return;
                          }
                          if (_selectedItem == 'Kurumsal' &&
                              _companyNameController.text == '' &&
                              _companyAdressController.text == '') {
                            showToastError("Lütfen firma ayrıntısını giriniz!");
                            return;
                          }
                          if (_passwordController.text ==
                              _password2Controller.text) {
                            Provider.of<Auth>(context, listen: false)
                                .signup(
                                    _fullNameController.text,
                                    _emailController.text,
                                    _passwordController.text,
                                    _selectedItem,
                                    _graduateYearController.text,
                                    _universityController.text,
                                    _facultySelectedItem,
                                    _phoneController.text,
                                    _citySelectedItem,
                                    _selectedJobItem,
                                    _companyNameController.text,
                                    _companyAdressController.text,
                                    _companyPhoneController.text)
                                .then((value) {
                              if (value) {
                                Navigator.pop(context);
                              }
                            });
                          } else {
                            showToastError("Şifreler eşleşmemektedir!");
                          }
                          setState(() {
                            _isLoading = false;
                          });
                        }, // ----
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          color: Colors.green,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "Kayıt Ol",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
