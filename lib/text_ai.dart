import 'package:flutter/material.dart';
import 'package:google_geminai_test/env/env.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class TextAI extends StatefulWidget {
  const TextAI({super.key});

  @override
  State<TextAI> createState() => _TextAIState();
}

class _TextAIState extends State<TextAI> {
   TextEditingController textEditingController = TextEditingController();

  String generatedText = "";
  bool isLoading = false;

  final formKey =GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("AI TEXT"),
      ),
      body: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child:isLoading?const CircularProgressIndicator(): Text(generatedText.isEmpty ? "No Data" : generatedText),
                  ),
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  validator: (value) {
                    if(value == "" || (value?.isEmpty ??true)){
                      return "Add text data";
                    }else{
                      return null;
                    }
                  },
                  controller: textEditingController,
                  decoration: InputDecoration(
                    hintText: "Add text data",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),
                  )),
                ),
                ElevatedButton(
                  onPressed: () {
                    if((!formKey.currentState!.validate())){
                      return;
                    }
                    generateTextData();
                  },
                  child: const Text("Generate"),
                )
              ],
            ),
          ),
        ),);
  }

   generateTextData() async {
    final model = GenerativeModel(model: 'gemini-pro', apiKey:Env.apiKey);

    final content = [Content.text(textEditingController.text)];

    try {
      setState(() {
        isLoading = true;
      });
      final response = await model.generateContent(content);
      setState(() {
        generatedText = response.text ?? "";
        isLoading = false;
      });
    } on GenerativeAIException catch (e) {
      setState(() {
        generatedText = e.message;
        isLoading = false;
      });
    }
  }
}