import 'dart:ui';
import 'package:fitness_app/chatservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:logger/logger.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<Map<String, dynamic>> messages = [];
  var logger = Logger();
  late stt.SpeechToText speech;
  bool listening = false;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatFn("Hello");
    speech = stt.SpeechToText();
  }

  chatFn(String chatMsg) async {
    try {
      messages.add({"role": "user", "content": chatMsg.trim()});
      setState(() {});
      var chat = await OpenRouterChatService().sendMessage(chatMsg);
      Future.delayed(Duration(seconds: 1));
      messages.add({"role": "system", "content": chat});
      setState(() {});
      logger.i(chat);
      if (controller.text.isNotEmpty) {
        controller.clear();
      }
    } catch (e) {
      logger.e(e);
    }
  }

  void listen() async {
    if (!listening) {
      bool available = await speech.initialize();
      if (available) {
        setState(() => listening = true);
        speech.listen(
          onResult: (val) {
            setState(() {
              controller.text = val.recognizedWords;
            });

            logger.i(val.recognizedWords);
          },
        );
      }
    } else {
      setState(() => listening = false);
      speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title:
                        messages[index]['role'] == "user"
                            ? Align(
                              alignment: Alignment.bottomRight,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                                child: Container(
                                  color: const Color.fromARGB(140, 7, 255, 11),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(messages[index]['content']),
                                  ),
                                ),
                              ),
                            )
                            : MarkdownBody(data: messages[index]['content']),
                  );
                },
              ),
            ),
            listening
                ? Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    child: Image.asset(
                      "assets/listening.gif",
                      height: 200,
                      errorBuilder: (context, error, stackTrace) {
                        return Text(error.toString());
                      },
                    ),
                  ),
                )
                : SizedBox.shrink(),

            Container(
              height: 100,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 41, 41, 41),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: TextField(
                keyboardType: TextInputType.multiline,

                decoration: InputDecoration(
                  border: InputBorder.none,

                  hintText: "Ask something",
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => listen(),
                        icon: Icon(Icons.mic_rounded),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        onPressed: () => chatFn(controller.text),
                        icon: Icon(Icons.send_rounded, size: 30),
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                  contentPadding: EdgeInsets.only(left: 20, top: 15),
                ),
                controller: controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
