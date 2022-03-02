import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/services.dart';
import 'package:flutter_application_1/widgets/custom_clipper.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

class ViewNews extends StatefulWidget {
  String id;
  ViewNews({Key? key, required this.id}) : super(key: key);

  @override
  _ViewNewsState createState() => _ViewNewsState();
}

class _ViewNewsState extends State<ViewNews> {
  var itemList;
  List categoriesList = [];
  var _items;
  bool isSelect = false;
  bool loading = false;
  List _selectedCategories = [];
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  var category;

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
        throw Exception('Failed to load ItemInfo');
      } else {
        throw Exception('Failed to load ItemInfo');
      }
    } catch (error) {
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
        category = _selectedCategories.map((e) => categoriesList).toList();
        _items = categoriesList
            .map((c) => MultiSelectItem(c['id'], c['name']))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade400,
        title: const Text(
          'VIEW NEWS',
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
                    child: SingleChildScrollView(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 8,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                titleController.text,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  for (var i = 0; i < category.length; i++)
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      color: Colors.lightBlue.shade400
                                          .withOpacity(0.8),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            13, 3, 13, 3),
                                        child: Text(
                                          category[i][i]['name'],
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const Divider(
                                height: 25,
                                color: Colors.grey,
                              ),
                              Row(
                                children: const [
                                  Text('รายละเอียดข่าว',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Text(descriptionController.text),
                            ],
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
