import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/services.dart';
import 'package:flutter_application_1/states/list.dart';
import 'package:flutter_application_1/widgets/custom_clipper.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class EditNews extends StatefulWidget {
  String id;
  EditNews({Key? key, required this.id}) : super(key: key);

  @override
  _EditNewsState createState() => _EditNewsState();
}

class _EditNewsState extends State<EditNews> {
  var itemList;
  List categoriesList = [];
  var _items;
  bool isSelect = false;
  bool loading = false;
  List _selectedCategories = [];
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getNewsById(widget.id);
    Future.delayed(const Duration(milliseconds: 300), () {
      getCategoriesList();
    });
  }

  Future getNewsById(id) async {
    try {
      loading = true;
      var res = await Services.getNewsbyId(id);
      if (res.statusCode == 200) {
        var jsonRes = jsonDecode(res.body);
        setState(() {
          titleController.text = jsonRes['title'];
          descriptionController.text = jsonRes['description'];
          _selectedCategories = jsonRes['categories'];
        });
        loading = false;
      } else if (res.statusCode == 401) {
        loading = false;
        throw Exception('Failed to load ItemInfo');
      } else {
        loading = false;
        throw Exception('Failed to load ItemInfo');
      }
    } catch (error) {
      loading = false;
      print(error);
      throw Exception('Failed to load ItemInfo');
    }
  }

  Future getCategoriesList() async {
    var res = await Services.getCategoriesList();
    if (res.statusCode == 200) {
      var jsonRes = jsonDecode(res.body);
      setState(() {
        categoriesList = jsonRes;
        _items = categoriesList
            .map((c) => MultiSelectItem(c['id'], c['name']))
            .toList();
      });
    }
  }

  Future onSubmit() async {
    try {
      loading = true;
      var res = await Services.editNews(widget.id, titleController.text,
          descriptionController.text, _selectedCategories);
      if (res.statusCode == 200) {
        loading = false;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ListPage()),
            (route) => false);
      } else {
        loading = false;
        print("EDIT_NEWS_PAGE :: add news errors");
      }
    } catch (e) {
      loading = false;
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade400,
        title: const Text(
          'EDIT NEWS',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: SizedBox(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: Transform.rotate(
                angle: -pi / 3.5,
                child: ClipPath(
                  clipper: ClipPainter(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .5,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xffE6E6E6),
                          Colors.lightBlue.shade400,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _items == null
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    width: MediaQuery.of(context).size.width,
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 8,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                TextFormField(
                                    controller: titleController,
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey.withOpacity(0.2),
                                      filled: true,
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      hintText: 'Title News',
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter Title News!";
                                      }
                                    }),
                                const SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                    controller: descriptionController,
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey.withOpacity(0.2),
                                      filled: true,
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 2),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      hintText: 'Description News',
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline,
                                    minLines: 6,
                                    maxLines: 12,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter Description News!";
                                      }
                                    }),
                                const SizedBox(
                                  height: 15,
                                ),
                                MultiSelectDialogField(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                                  items: _items,
                                  listType: MultiSelectListType.CHIP,
                                  title: const Text('Categories News'),
                                  buttonText: const Text(
                                    "Select Categories News",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  onConfirm: (values) {
                                    _selectedCategories = values;
                                  },
                                  initialValue: _selectedCategories,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    isSelect = false;
                                    if (value == null || value.isEmpty) {
                                      return "Please Select Categories News!";
                                    }
                                  },
                                  chipDisplay: MultiSelectChipDisplay(
                                    onTap: (value) {
                                      setState(() {
                                        _selectedCategories.remove(value);
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        final form = _formKey.currentState;
                                        if (form!.validate()) {
                                          onSubmit();
                                        } else {
                                          return;
                                        }
                                      },
                                      child: const Text(
                                        'SAVE',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'CANCEL',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
