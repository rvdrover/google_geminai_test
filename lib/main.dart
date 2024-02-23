
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:google_geminai_test/image_ai.dart';
import 'package:google_geminai_test/storage_service.dart';
import 'package:google_geminai_test/text_ai.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BetterFeedback(
      theme: FeedbackThemeData(
        background: Colors.grey,
        feedbackSheetColor: Colors.grey[50]!,
        drawColors: [
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.yellow,
        ],
      ),
      darkTheme: FeedbackThemeData.dark(),
      mode: FeedbackMode.draw,
      pixelRatio: 1,
      child: const MaterialApp(
       title: 'FLUTTER AI TEST',
       
        home: MyHomePage(),
      ),
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
      appBar: AppBar(actions: [
        IconButton(onPressed: (){
          BetterFeedback.of(context).show(
                  (feedback) async {
                    await StorageService(directoryName: 'AIGOOGLE').storeFile(
                      fileName: feedback.hashCode.toString(),
                      fileExtension: 'png',
                      fileData: feedback.screenshot,
                      onComplete: (file) async {
                        Share.shareXFiles([file], text: feedback.text);
                      },
                    );
                  },
                );
              },
              icon: const Icon(Icons.feedback) )],),
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
