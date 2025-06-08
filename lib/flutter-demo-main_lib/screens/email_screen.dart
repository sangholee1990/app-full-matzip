import 'package:devcoean_flutter/controller/email_controller.dart';

import 'package:devcoean_flutter/models/email_model.dart';
import 'package:devcoean_flutter/widgets/dev_textfield_widget.dart';
import 'package:flutter/material.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({Key? key}) : super(key: key);

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final TextEditingController _emailTextCtrl = TextEditingController();
  final TextEditingController _titleTextCtrl = TextEditingController();
  final TextEditingController _contentTextCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DevTextFieldWidget(TextCtrl: _emailTextCtrl, hint: "Email"),
              const SizedBox(height: 10),
              DevTextFieldWidget(TextCtrl: _titleTextCtrl, hint: "title"),
              const SizedBox(height: 10),
              DevTextFieldWidget(
                  TextCtrl: _contentTextCtrl, hint: "Context", maxLine: 5),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    EmailModel note = EmailModel(
                        email_address: _emailTextCtrl.text,
                        title: _titleTextCtrl.text,
                        content: _contentTextCtrl.text);

                    await EmailController()
                        .sendEmail(note)
                        .then((value) => setState(() {
                              _emailTextCtrl.text = "";
                              _titleTextCtrl.text = "";
                              _contentTextCtrl.text = "";
                            }));
                  },
                  child: Text("Email 전송"))
            ],
          ),
        ),
      ),
    );
  }
}
