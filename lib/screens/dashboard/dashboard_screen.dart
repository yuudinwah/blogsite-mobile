import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myblog/extensions/int_ext.dart';
import 'package:myblog/models/blog_model.dart';
import 'package:http/http.dart' as http;
import 'package:myblog/screens/form/form_screen.dart';
import 'package:myblog/utils/date_time_util.dart';
import 'package:myblog/variables/environtment_var.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<BlogModel> contents = [];
  bool loading = false;
  int viewers = 0;
  int posts = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Fecth data from server backend
  fetchData() async {
    try {
      // print("${EnvironmentVar.baseUrl}/api/blog");
      http.Response response =
          await http.get(Uri.parse("${EnvironmentVar.baseUrl}/api/blog"));

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(json['data']);
        contents = data.map((value) {
          return BlogModel.fromMap(value);
        }).toList();
        posts = contents.length;
        viewers =
            contents.map((value) => value.clickTimes).reduce((a, b) => a + b);
        setState(() {});
        print("berhasil parsing data");
      } else {
        print("error parsing data");
        throw "Error parsing data";
      }
    } catch (e) {
      print(e);
    }
  }

  moreDetail(BlogModel value) async {
    bool? delete = await showDialog<bool?>(
      context: context,
      builder: (_) {
        return SimpleDialog(
          backgroundColor: Colors.white,
          title: Text('Pilih Opsi'),
          children: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FormScreen(
                      value: value,
                    ),
                  ),
                );
              },
              child: Text('Edit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (delete == true) {
      await showDialog<bool?>(
        context: context,
        builder: (_) {
          return SimpleDialog(
            backgroundColor: Colors.white,
            title: Text('Hapus post'),
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(
                  "Hapus",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Batal"),
              ),
            ],
          );
        },
      ).then((_) async {
        if (_ == true) {
          http.Response response =
              await http.delete(Uri.parse("${EnvironmentVar.baseUrl}/api/blog?id=${value.id}"));

          if (response.statusCode == 200) {
            setState(() {});
            fetchData();
            print("berhasil hapus data");
          } else {
            print("error hapus data");
            throw "Error hapus data";
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [
          IconButton(
            onPressed: () {
              fetchData();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              height: 80,
              width: width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        "assets/images/user.webp",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Void Tortellini",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                              color: Colors.deepOrange[900],
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "Writer",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Divider(),
            Container(
              width: width,
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: width / 2 - 32,
                    height: 75,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        SizedBox(
                          width: width,
                          child: Text("Viewers"),
                        ),
                        Expanded(
                          child: Container(
                            width: width,
                            alignment: Alignment.center,
                            child: Text(
                              viewers.format(),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: width / 2 - 32,
                    height: 75,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        SizedBox(
                          width: width,
                          child: Text("Posts"),
                        ),
                        Expanded(
                          child: Container(
                            width: width,
                            alignment: Alignment.center,
                            child: Text(
                              posts.format(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Column(
                children: contents.map((content) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FormScreen(
                            value: content,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      width: width,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateTimeUtil().format(content.createdAt,
                                      format: "MMMM dd, yyyy"),
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  content.title ?? "-",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Container(
                                  width: width,
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.graphic_eq,
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        content.clickTimes.format(),
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Icon(
                                        Icons.thumb_up,
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        content.likes.format(),
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Icon(
                                        Icons.comment,
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        0.format(),
                                      ),
                                    ],
                                  ),
                                ),
                                // Text(
                                //   content.shortContent ?? "-",
                                //   style:
                                //       TextStyle(fontSize: 12, color: Colors.grey[700]!
                                //           // fontWeight: FontWeight.w600,
                                //           ),
                                // ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              moreDetail(content);
                            },
                            child: Icon(Icons.more_vert),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
