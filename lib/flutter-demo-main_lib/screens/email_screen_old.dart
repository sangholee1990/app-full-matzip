import 'package:devcoean_flutter/controller/email_controller.dart';
import 'package:devcoean_flutter/models/email_model.dart';
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
            // mainAxisSize: MainAxisSize.max,
            children: [
              TextField(
                controller: _emailTextCtrl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Email",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _titleTextCtrl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "title",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _contentTextCtrl,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Contents",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
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
