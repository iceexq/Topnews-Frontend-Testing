import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/services.dart';
import 'package:flutter_application_1/states/add_news.dart';
import 'package:flutter_application_1/states/edit_news.dart';
import 'package:flutter_application_1/states/view_news.dart';
import 'package:flutter_application_1/widgets/custom_clipper.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  int rowNumber = 0;
  var itemList = [];
  bool loading = false;
  @override
  void initState() {
    super.initState();
    getListItemInfo();
  }

  Future<int> get checkLengthData async {
    return rowNumber;
  }

  Future getListItemInfo() async {
    try {
      loading = true;
      var res = await Services.getListNews();
      if (res.statusCode == 200) {
        var jsonRes = jsonDecode(res.body);
        setState(() {
          itemList = jsonRes;
          rowNumber = itemList.length;
        });
        loading = false;
      } else if (res.statusCode == 401) {
      } else {
        throw Exception('Failed to load ItemInfo');
      }
    } catch (error) {
      print(error);
      throw Exception('Failed to load ItemInfo');
    }
  }

  Future deleteNews(id) async {
    try {
      Navigator.of(context).pop();
      loading = true;
      var res = await Services.deleteNews(id);
      if (res.statusCode == 200) {
        getListItemInfo();
      }
    } catch (e) {
      print(e);
    }
  }

  void _showDialog(id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.dark(),
          child: CupertinoAlertDialog(
            content: const Text(
              "ท่านต้องการลบข้อมูลข่าวนี้ใช่หรือไม่ ?",
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Yes"),
                onPressed: () {
                  deleteNews(id);
                },
              ),
              TextButton(
                child: const Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade400,
        title: const Center(
          child: Text(
            'LISTS NEWS',
            style: TextStyle(fontSize: 18),
          ),
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
            loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const AddNews()));
                              },
                              child: const Text(
                                'Add News',
                                style: TextStyle(fontSize: 12),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.lightBlue.shade500,
                                elevation: 5,
                              ),
                            ),
                          ],
                        ),
                        FutureBuilder(
                          future: checkLengthData,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              int rowNumber = snapshot.data as int;
                              if (rowNumber > 0) {
                                return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    elevation: 8,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: dataTable(),
                                    ));
                              } else {
                                return const Center(
                                  child: Text('No data found'),
                                );
                              }
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                      ],
                    )),
                  )
          ],
        ),
      ),
    );
  }

  Widget dataTable() {
    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      columns: const [
        DataColumn2(
            label: Text('News Title',
                style: TextStyle(
                  fontSize: 16,
                ))),
        DataColumn2(
            label: Text(
          '',
          style: TextStyle(
            fontSize: 16,
          ),
        )),
      ],
      rows: List<DataRow>.generate(
        rowNumber,
        (index) => DataRow(
          cells: [
            DataCell(
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ViewNews(id: itemList[index]['id'])));
                },
                child: Text(
                  itemList[index]['title'] ?? "-",
                  style: TextStyle(
                    color: Colors.blue.shade900,
                  ),
                ),
              ),
            ),
            DataCell(Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditNews(id: itemList[index]['id'])));
                  },
                  child: const Text('Edit', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    elevation: 5,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    _showDialog(itemList[index]['id']);
                  },
                  child: const Text('Delete', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    elevation: 5,
                  ),
                )
              ],
            )),
          ],
        ),
      ),
    );
  }
}
