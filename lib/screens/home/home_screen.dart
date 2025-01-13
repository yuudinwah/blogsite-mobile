import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myblog/models/blog_model.dart';
import 'package:http/http.dart' as http;
import 'package:myblog/screens/dashboard/dashboard_screen.dart';
import 'package:myblog/screens/detail/detail_screen.dart';
import 'package:myblog/screens/form/form_screen.dart';
import 'package:myblog/utils/date_time_util.dart';
import 'package:myblog/variables/environtment_var.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<BlogModel> contents = [];
  bool loading = false;

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

  int navIndex = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: [
        SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Search bar
                Container(
                  height: 80,
                  width: width,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Center(
                    child: Container(
                      height: 50,
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.grey[200],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Cari..."),
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.sort,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                // Contents
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    children: contents.map((content) {
                      return InkWell(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (_) => FormScreen(
                          //       value: content,
                          //     ),
                          //   ),
                          // );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(
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
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                content.shortContent ?? "-",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[700]!
                                    // fontWeight: FontWeight.w600,
                                    ),
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
        ),
        DashboardScreen(),
      ].elementAt(navIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets_rounded),
            label: 'Dashboard',
          ),
        ],
        currentIndex: navIndex,
        // selectedItemColor: Colors.blue,
        onTap: (index) {
          navIndex = index;
          setState(() {});
          if (navIndex == 0 && index == 0) {
            fetchData();
          }
        },
      ),
    );
  }
}
