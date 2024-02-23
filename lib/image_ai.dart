// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_geminai_test/env/env.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

class ImageAI extends StatefulWidget {
  const ImageAI({super.key});

  @override
  State<ImageAI> createState() => _ImageAIState();
}

class _ImageAIState extends State<ImageAI> {
   TextEditingController textEditingController = TextEditingController();
   final ImagePicker picker = ImagePicker();


  String generatedText = "";
  bool isLoading = false;

  List<XFile?> images = [];

  final formKey =GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("AI IMAGE & TEXT"),
      ),
      body: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                  Expanded(
                    child: GridView.count(
                      shrinkWrap: true,
                        crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                            crossAxisCount: 3,

                        children: [
                          ...List.generate(
                              images.length,
                              (index) => Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                strokeAlign: BorderSide
                                                    .strokeAlignOutside),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Image.file(
                                          File(images[index]!.path),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                          top: 10,
                                          right: 10,
                                          child: InkWell(
                                            onTap: () {
                                              images.removeAt(index);
                                              setState(() {});
                                            },
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle),
                                              child: const Center(
                                                  child: Icon(
                                                Icons.close,
                                                size: 14,
                                                color: Colors.red,
                                              )),
                                            ),
                                          )),
                                    ],
                                  )),
                                  InkWell(
                                    onTap: () {
                                      showSheet();
                                    },
                                    child: Container(
                                          width: 50,
                                          height: 50,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  strokeAlign: BorderSide
                                                      .strokeAlignOutside),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: const Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.add_a_photo
                                                ),
                                                Text("Add Images")
                                              ],
                                            ),
                                          ),
                                        ),
                                  )
                        ],
                      ),
                  ),
                Expanded(
                child: SingleChildScrollView(
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(generatedText.isEmpty ? "No Data" : generatedText)),
                ),
              ),
           
                const SizedBox(height: 10,),
                TextFormField(
                  validator: (value) {
                    if(value == "" || (value?.isEmpty ??true)){
                      return "Add text data";
                    }else if(images.isEmpty){
                       return "Add images";
                    } else{
                      return null;
                    }
                  },
                  controller: textEditingController,
                  style: const TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    hintText: "Ask anything about images",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),
                  )),
                ),
                const SizedBox(height: 10,),
                ElevatedButton(
                  onPressed: () {
                    if((!formKey.currentState!.validate())){
                      return;
                    }
                    generateImageData();
                  },
                  child: const Text("Generate"),
                )
              ],
            ),
          ),
        ),);
  }

   generateImageData() async {
    final model = GenerativeModel(model: 'gemini-pro-vision', apiKey:Env.apiKey);

    List<Uint8List> byteImages = [];

    for (var element in images) {
      byteImages.add(await element!.readAsBytes());
    }

    List<DataPart> imageParts = byteImages.map((e) => DataPart('image/jpeg', e)).toList();

    final prompt = TextPart(textEditingController.text);

    try {
      setState(() {
        isLoading = true;
      });
      final response = await model.generateContent([Content.multi([prompt, ...imageParts])]);
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

  showSheet() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 25,
                      ),
                      const Icon(
                        Icons.camera,
                        size: 24,
                      ),
                      const SizedBox(width: 25),
                      InkWell(
                        onTap: () async {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera,
                              maxHeight: 500,
                              maxWidth: 500,
                              imageQuality: 50);
                          setState(() {
                            images.add(image);
                          });
                          if(image!=null) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text("Take image from camera",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.justify),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 25),
                      const Icon(
                        Icons.photo_album,
                        size: 24,
                      ),
                      const SizedBox(width: 25),
                      InkWell(
                        onTap: () async {
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery,
                              maxHeight: 500,
                              maxWidth: 500,
                              imageQuality: 50);
                          setState(() {
                            images.add(image);
                          });

                         if(image!=null) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text("Pick image from gallery",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.justify),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                ],
              )),
        );
      },
    );
  }
}

