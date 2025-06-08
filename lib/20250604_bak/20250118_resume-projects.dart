import 'package:flutter/material.dart';
import '20250118_resume-comAppBar.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: buildCommonAppBar(),
      // appBar: buildCommonAppBar(NavigationPages.projects),
      appBar: buildCommonAppBar(context, NavigationPages.projects),
      body: Center(
        child: Text("프로젝트 페이지"),
      ),
    );
  }
}