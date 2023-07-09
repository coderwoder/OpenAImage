import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:openai_img_gen/colors.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'fetching.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var sizes = ["Smull", "Big", "Extra Big"];
  var values = ["256x256", "512x512", "1024x1024"];
  String? dropvalue;
  var textcontroller = TextEditingController();
  String img = '';
  var isloaded = false;
  var istapped = false;
  var isdownloaded = true;
  ScreenshotController scrcontroller = ScreenshotController();
  var errorshare = "Please Provide an Image to Capture!";
  String directory = '';

  shareimg() async {
    await scrcontroller
        .capture(
      delay: const Duration(milliseconds: 50),
      pixelRatio: 1.0,
    )
        .then(
      (Uint8List? image) async {
        if (image != null) {
          directory = (await getApplicationDocumentsDirectory()).path;
          const filename = "bitvh.png";
          final imgpath = await File("$directory/$filename").create();
          await imgpath.writeAsBytes(image);
          Share.shareFiles([imgpath.path], text: "Generate by AI:");
          return null;
        } else {
          return errorshare;
        }
      },
    );
  }

  saveToGallery(Uint8List imagebyte) async {
    final filepath = await ImageGallerySaver.saveImage(imagebyte);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Image saved in Gallery")));
  }

  downloadimga() async {
    var result = await Permission.storage.request();
    if (result.isGranted) {
      final imagebytes = await scrcontroller
          .capture(delay: const Duration(milliseconds: 100), pixelRatio: 1.0)
          .then(
        (Uint8List? image) {
          if (image != null) {
            saveToGallery(image);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Failed to Save Capture "),
              ),
            );
          }
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Saved in your Gallery")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Okay, Understood!"),
        ),
      );
    }
  }

  FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: gradientbtn,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(5.0),
                  elevation: 0.0,
                  backgroundColor: Colors.transparent,
                ),
                onPressed: (() {}),
                child: const Text(
                  "Saves",
                  style: TextStyle(color: Color.fromARGB(182, 0, 0, 0)),
                ),
              ),
            ),
          ),
        ],
        centerTitle: true,
        title: const Text(
          "Ai Image Generator",
          style: TextStyle(
              fontFamily: "rowdy_bold",
              color: Color.fromARGB(214, 255, 255, 255)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      //
                      //
                      //TextField
                      //
                      //

                      Expanded(
                        child: GestureDetector(
                          onTap: () => _focusNode.unfocus(),
                          child: Container(
                            height: 45,
                            padding: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(249, 255, 255, 255),
                              borderRadius: BorderRadius.circular(13.0),
                              border: Border.all(
                                color:
                                    istapped ? Colors.pink : Colors.transparent,
                                width: 2.0,
                              ),
                            ),
                            child: TextFormField(
                              focusNode: _focusNode,
                              controller: textcontroller,
                              decoration: const InputDecoration(
                                isDense: true,
                                hintText: "eg. :- Headless Man with Knife",
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 189, 185, 185),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  istapped = !istapped;
                                });
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      Container(
                        height: 45,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 0,
                        ),
                        decoration: BoxDecoration(
                          gradient: gradientbtn,
                          borderRadius: BorderRadius.circular(13.0),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            hint: const Text(
                              "Sizes?",
                            ),
                            icon: const Icon(
                              Icons.border_all,
                              size: 20,
                              color: Colors.black87,
                            ),

                            value: dropvalue, //Need to Supply
                            items: List.generate(
                              sizes.length,
                              (index) => DropdownMenuItem(
                                value: values[index],
                                child: Text(sizes[index]),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                dropvalue = value.toString();
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  //
                  //
                  //  GENERATE! Button
                  //
                  //

                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    width: 300,
                    height: 45,
                    decoration: BoxDecoration(
                      gradient: gradientbtn,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                      onPressed: () async {
                        if (textcontroller.text.isNotEmpty &&
                            dropvalue!.isNotEmpty) {
                          setState(() {
                            isloaded = false;
                          });
                          img = await Api.generateImage(
                              textcontroller.text, dropvalue!);
                          setState(() {
                            isloaded = true;
                          });
                        } else if (textcontroller.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please Pass Query to Generate"),
                            ),
                          );
                        } else if (dropvalue!.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please Select a Size"),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Generate!",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: isloaded
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Screenshot(
                              controller: scrcontroller,
                              child: Image.network(
                                img,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: const Color.fromARGB(255, 251, 220, 228),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Image.network(
                          "https://media.tenor.com/G98e-mpzOiMAAAAC/cat-paw.gif",
                        ),
                      ),
                    ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //
                  //
                  //Download Button
                  //
                  //

                  Expanded(
                    child: Container(
                      // width: 300,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: gradientbtn,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton.icon(
                        icon: Icon(
                          isdownloaded
                              ? Icons.download_for_offline_outlined
                              : Icons.download_for_offline_rounded,
                          color: Colors.black54,
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(15.0),
                          elevation: 0.0,
                          backgroundColor: Colors.transparent,
                        ),
                        onPressed: (() {
                          if (!isdownloaded) {
                            // downloadimage();
                            isdownloaded = true;
                          }
                          downloadimga();
                        }),
                        label: Text(
                          isdownloaded ? "Download" : "Already downloaded",
                          style: const TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),

                  //
                  //

                  const SizedBox(
                    width: 10,
                  ),

                  //
                  //
                  //Share Button
                  //
                  //

                  Container(
                    // width: 300,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: gradientbtn,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton.icon(
                      icon: const Icon(
                        Icons.share_outlined,
                        color: Colors.black54,
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15.0),
                        elevation: 0.0,
                        backgroundColor: Colors.transparent,
                      ),
                      onPressed: () async {
                        var errormsg = await shareimg();
                        // print(errormsg);
                        if (errormsg == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(errorshare)));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Image Shared")));
                        }
                      },
                      label: const Text(
                        "Share?",
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: DefaultTextStyle(
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Playfair',
                    fontSize: 10,
                    letterSpacing: 1.5),
                child: Column(
                  children: const [
                    Text("Just A Practice Project ,"),
                    Text("Have Fun!"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
