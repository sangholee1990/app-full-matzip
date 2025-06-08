import 'package:flutter/material.dart';
import '20250118_resume-comAppBar.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: buildCommonAppBar(),
      // appBar: buildCommonAppBar(NavigationPages.contact),
      appBar: buildCommonAppBar(context, NavigationPages.contact),
      body: Center(
        child: Text("연락처 페이지"),
      ),
    );
  }
}