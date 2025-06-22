import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:savourai/services/chatservice.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<Map<String, dynamic>> messages = [];

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    messages.clear();
    chatFn("Hello! Give a cooking tip");
  }

  chatFn(String chatMsg) async {
    controller.clear();
    try {
      messages.add({"role": "user", "content": chatMsg.trim()});
      setState(() {});
      var chat = await OpenRouterChatService().sendMessage(chatMsg);
      Future.delayed(Duration(seconds: 1));
      messages.add({"role": "system", "content": chat});
      setState(() {});
     
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(0, 254, 246, 236),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/chatBackground.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: const Color.fromARGB(115, 0, 0, 0),
              ),
            ),
            Column(
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
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                            0.5,
                                      ),
                                      child: Container(
                                        color: const Color.fromARGB(255, 213, 159, 79),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            messages[index]['content'],
                                            style: GoogleFonts.ptSans(
                                              // color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                : ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  child: Container(
                                    color: const Color.fromARGB(228, 241, 204, 149),

                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: MarkdownBody(
                                        data: messages[index]['content'],
                                        styleSheet: MarkdownStyleSheet(
                                          p: GoogleFonts.ptSans(
                                            color: const Color.fromARGB(
                                              255,
                                              0,
                                              0,
                                              0,
                                            ),
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                      );
                    },
                  ),
                ),

                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.white)),
                    color: const Color.fromARGB(134, 63, 42, 22),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.multiline,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      border: InputBorder.none,

                      hintStyle: TextStyle(color: Colors.white),
                      hintText: "Ask something",
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(width: 8),
                          IconButton(
                            color: const Color.fromRGBO(255, 255, 255, 1),
                            onPressed: () => chatFn(controller.text.trim()),
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
          ],
        ),
      ),
    );
  }
}
