import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meme_generator/screen/meme_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String textfieldvalue;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  XFile? _image;

  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future getImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    print(image);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Memes app'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width / 1.5,
                      height: MediaQuery.sizeOf(context).height / 4,
                      child: ListView(
                        children: [
                          TextFormField(
                            controller: _textEditingController,
                            decoration: const InputDecoration(
                              labelText: 'Впишите вашу ссылку на мем',
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2.0),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Поле не может быть пустым';
                              } else {
                                textfieldvalue = value;
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            child: const Text('Открыть картинку по ссылке'),
                            onPressed: _submitForm,
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green),
                              textStyle: MaterialStateProperty.all(
                                const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            child: const Text('Открыть картинку из галереи'),
                            onPressed: () {
                              getImage();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MemeScreen(
                                    textimage: '',
                                    image: _image,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    child: Column(children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text('Выбрать готовый шаблон'),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        width: MediaQuery.sizeOf(context).width / 1.05,
                        height: MediaQuery.sizeOf(context).height / 10,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              width: 100,
                              height: 100,
                              child: Image.asset(
                                'assets/cat.jpg',
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              width: 100,
                              height: 100,
                              child: Image.asset(
                                'assets/cow.png',
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              width: 100,
                              height: 100,
                              child: Image.asset(
                                'assets/doggy.png',
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              width: 100,
                              height: 100,
                              child: Image.asset(
                                'assets/doggy1.jpg',
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              width: 100,
                              height: 100,
                              child: Image.asset(
                                'assets/guys.jpg',
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MemeScreen(
            textimage: textfieldvalue,
            image: _image,
          ),
        ),
      );
    }
  }
}
