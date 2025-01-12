import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myblog/models/blog_model.dart';
import 'package:myblog/variables/environtment_var.dart';
// import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:http/http.dart' as http;

class DetailScreen extends StatefulWidget {
  final BlogModel value;

  const DetailScreen({super.key, required this.value});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late BlogModel value;
  final QuillEditorController controller = QuillEditorController();

  @override
  void initState() {
    super.initState();
    value = widget.value;
    // controller.isEnable = false;
    controller.enableEditor(false);
    fetchData();
  }

  fetchData() async {
    http.Response response = await http
        .get(Uri.parse("${EnvironmentVar.baseUrl}/api/blog?id=${value.id}"));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      Map<String, dynamic> data = Map<String, dynamic>.from(json['data']);
      value = BlogModel.fromMap(data);

      setState(() {});
      print("berhasil parsing data");
    } else {
      print("error parsing data");
      throw "Error parsing data";
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
              child: Column(
                children: [
                  QuillHtmlEditor(
                    text: value.content ?? "",
                    hintText: 'Hint text goes here',
                    controller: controller,
                    isEnabled: false,
                    minHeight: 300,
                    hintTextAlign: TextAlign.start,
                    hintTextPadding: EdgeInsets.zero,
                    // backgroundColor: _backgroundColor,
                    onFocusChanged: (hasFocus) =>
                        debugPrint('has focus $hasFocus'),
                    onTextChanged: (text) =>
                        debugPrint('widget text change $text'),
                    onEditorCreated: () => debugPrint('Editor has been loaded'),
                    onEditingComplete: (s) =>
                        debugPrint('Editing completed $s'),
                    onEditorResized: (height) =>
                        debugPrint('Editor resized $height'),
                    onSelectionChanged: (sel) =>
                        debugPrint('${sel.index},${sel.length}'),
                    loadingBuilder: (context) {
                      return const Center(
                          child: CircularProgressIndicator(
                        strokeWidth: 0.4,
                      ));
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
