// common_appbar.dart 파일의 코드
import 'package:flutter/material.dart';

enum NavigationPages {
  home,
  projects,
  contact,
}

// context를 추가적인 인자로 받아옴
AppBar buildCommonAppBar(BuildContext context, NavigationPages selectedPage) {
  return AppBar(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 클릭하면 홈 페이지로 이동
        GestureDetector(
          onTap: () { Navigator.of(context).pushNamed("/"); },
          child: Text(
            "홈",
            style: TextStyle(
              color: selectedPage == NavigationPages.home ? Colors.purple : Colors.grey,
              fontSize: 16,
              fontWeight: selectedPage == NavigationPages.home ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        SizedBox(width: 37),
        // 클릭하면 프로젝트 페이지로 이동
        GestureDetector(
          onTap: () { Navigator.of(context).pushNamed("/projects"); },
          child: Text(
            "프로젝트",
            style: TextStyle(
              color: selectedPage == NavigationPages.projects ? Colors.purple : Colors.grey,
              fontSize: 16,
              fontWeight: selectedPage == NavigationPages.projects ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        SizedBox(width: 37),
        // 클릭하면 연락처 페이지로 이동
        GestureDetector(
          onTap: () { Navigator.of(context).pushNamed("/contact"); },
          child: Text(
            "연락처",
            style: TextStyle(
              color: selectedPage == NavigationPages.contact ? Colors.purple : Colors.grey,
              fontSize: 16,
              fontWeight: selectedPage == NavigationPages.contact ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    ),
  );
}