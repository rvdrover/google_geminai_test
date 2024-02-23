import 'package:flutter/material.dart';
import 'package:google_geminai_test/image_ai.dart';
import 'package:google_geminai_test/text_ai.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FLUTTER AI TEST',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 
int currentIndex = 0;
List<Widget> pages = [
const TextAI(),
const ImageAI(),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        useLegacyColorScheme: false,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex =value;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.text_decrease), label: "Text"),
          BottomNavigationBarItem(
              icon: Icon(Icons.image_aspect_ratio), label: "Image"),
        ], 
      ),
      body: pages[currentIndex],
    );
  }


}
