import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Family Intro 2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        fontFamily: 'MalgunGothic',
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    MemberListPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Members',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/family-back.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "4인 가족",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MalgunGothic',
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFamilyMember(
                    context,
                    '아버지',
                    'images/free-icon-father.png',
                    '가족을 이끄는 든든한 리더입니다.',
                    'images/father-back.png',
                  ),
                  const SizedBox(width: 20),
                  _buildFamilyMember(
                    context,
                    '어머니',
                    'images/free-icon-mother.png',
                    '가족을 따뜻하게 보살피는 분입니다.',
                    'images/mother-back.png',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFamilyMember(
                    context,
                    '첫째 누나',
                    'images/free-icon-woman.png',
                    '밝고 활기찬 에너지를 가진 분입니다.',
                    'images/woman-back.png',
                  ),
                  const SizedBox(width: 20),
                  _buildFamilyMember(
                    context,
                    '둘째 나',
                    'images/free-icon-man.png',
                    '모험을 좋아하는 가족의 막내입니다.',
                    'images/man-back.png',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFamilyMember(
      BuildContext context, String name, String imageUrl, String desc, String backUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MemberDetailPage(
              name: name,
              imageUrl: imageUrl,
              desc: desc,
              backUrl: backUrl,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Hero(
            tag: name,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(imageUrl),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontFamily: 'MalgunGothic',
            ),
          ),
        ],
      ),
    );
  }
}

class MemberListPage extends StatelessWidget {
  const MemberListPage({super.key});

  final List<Map<String, String>> members = const [
    {
      'name': '아버지',
      'image': 'images/free-icon-father.png',
      'desc': '가족을 이끄는 든든한 리더입니다.',
      'back': 'images/father-back.png',
    },
    {
      'name': '어머니',
      'image': 'images/free-icon-mother.png',
      'desc': '가족을 따뜻하게 보살피는 분입니다.',
      'back': 'images/mother-back.png',
    },
    {
      'name': '첫째 누나',
      'image': 'images/free-icon-woman.png',
      'desc': '밝고 활기찬 에너지를 가진 분입니다.',
      'back': 'images/woman-back.png',
    },
    {
      'name': '둘째 나',
      'image': 'images/free-icon-man.png',
      'desc': '모험을 좋아하는 가족의 막내입니다.',
      'back': 'images/man-back.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Members', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: members.length,
        itemBuilder: (context, index) {
          final member = members[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(member['image']!),
              ),
              title: Text(
                member['name']!,
                style: const TextStyle(fontFamily: 'MalgunGothic', fontSize: 18),
              ),
              subtitle: Text(member['desc']!, style: const TextStyle(fontSize: 14)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MemberDetailPage(
                      name: member['name']!,
                      imageUrl: member['image']!,
                      desc: member['desc']!,
                      backUrl: member['back']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class MemberDetailPage extends StatelessWidget {
  const MemberDetailPage({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.desc,
    required this.backUrl,
  });

  final String name;
  final String imageUrl;
  final String desc;
  final String backUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: name,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(imageUrl),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
