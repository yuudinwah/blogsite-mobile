import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myblog/models/blog_model.dart';
import 'package:myblog/variables/environtment_var.dart';
// import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:http/http.dart' as http;

class FormScreen extends StatefulWidget {
  final BlogModel? value;

  const FormScreen({super.key, this.value});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  BlogModel? value;
  final QuillEditorController controller = QuillEditorController();

  @override
  void initState() {
    super.initState();
    value = widget.value;
    if (value != null) {
      try {} catch (e) {
        //
      }
      setState(() {});
    }
  }

  postData() async {
    String? html = await controller.getText();
    print(html);
    String url = "${EnvironmentVar.baseUrl}/api/blog";
    if (value != null) {
      url = "${EnvironmentVar.baseUrl}/api/blog?id=${value!.id}";
    }
    http.Response response;

    if (value != null) {
      response = await http.patch(Uri.parse(url), body: jsonEncode({"html": html}));
    } else {
      response = await http.post(Uri.parse(url), body: jsonEncode({"html": html}));
    }

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      Map<String, dynamic> data = Map<String, dynamic>.from(json['data']);
      print("berhasil simpan data");
      Navigator.pop(context);
    } else {
      print("error simpan data");
      throw "Error simpan data";
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Tulis blog"),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InkWell(
              onTap: () async {
                postData();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Simpan',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
              child: QuillHtmlEditor(
                text: value?.content ?? "",
                hintText: 'Apa idemu kali ini?',
                controller: controller,
                isEnabled: true,
                minHeight: 300,
                // textStyle: _editorTextStyle,
                // hintTextStyle: _hintTextStyle,
                hintTextAlign: TextAlign.start,
                hintTextPadding: EdgeInsets.zero,
                // backgroundColor: _backgroundColor,
                onFocusChanged: (hasFocus) => debugPrint('has focus $hasFocus'),
                onTextChanged: (text) => debugPrint('widget text change $text'),
                onEditorCreated: () => debugPrint('Editor has been loaded'),
                onEditingComplete: (s) => debugPrint('Editing completed $s'),
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
            ),
          ),
          ToolBar.scroll(
            toolBarColor: Colors.grey[100],
            activeIconColor: Colors.grey[500],
            padding: const EdgeInsets.all(8),
            iconSize: 20,
            controller: controller,
            direction: Axis.horizontal,
          ),
        ],
      ),
    );
  }
}
