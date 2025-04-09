import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class Chat extends StatefulWidget {
  final dynamic snapshot;
  const Chat({super.key, required this.snapshot});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();
  late final sender;

  final keyString = 'YOU 32 BIT KEY';
  late final encrypt.Key key;

  @override
  void initState() {
    super.initState();
    key = encrypt.Key.fromUtf8(keyString);
    getUsername();
  }

  String encryptMessage(String message) {
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(message, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }

  String decryptMessage(String encryptedMsg) {
    try {
      final parts = encryptedMsg.split(':');
      final iv = encrypt.IV.fromBase64(parts[0]);
      final cipherText = parts[1];
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      return encrypter.decrypt64(cipherText, iv: iv);
    } catch (e) {
      debugPrint("Decryption failed: $e");
      return "[Could not decrypt]";
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  getUsername() async {
    try {
      final supabase = Supabase.instance.client;
      final mail = await supabase.auth.currentUser!.email!;

      final userRow =
          await supabase.from('users').select().eq('email', mail).single();

      sender = userRow['username'];
    } catch (e) {
      debugPrint("failed to fetch username");
    }
  }

  Future<void> sendMessage() async {
    final supabase = Supabase.instance.client;
    // late String sender;

    final receiver = widget.snapshot['username'];
    final encryptedMsg = encryptMessage(messageController.text.trim());
    final expiry = DateTime.now().toUtc().add(Duration(minutes: 1));

    if (messageController.text.isNotEmpty) {
      try {
        await supabase.from('messages').insert({
          'sender': sender,
          'reciever': receiver,
          'message': encryptedMsg,
          'expire_at': expiry.toIso8601String()
        });

        messageController.clear();
        await Future.delayed(Duration(milliseconds: 100));
        _scrollToBottom();
      } catch (e) {
        debugPrint("Send error: $e");
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final receiver = widget.snapshot['username'];

    return Scaffold(
         backgroundColor: Theme.of(context).brightness == Brightness.light
              ? const Color.fromARGB(255, 199, 220, 255)
              : const Color.fromARGB(255, 34, 34, 34),
      appBar: AppBar(
         backgroundColor: Theme.of(context).brightness == Brightness.light
            ? const Color.fromARGB(255, 148, 186, 253)
            : const Color.fromARGB(255, 49, 49, 49),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.snapshot['username'],
            ),
            widget.snapshot['online']
                ? Text("Online", style: GoogleFonts.roboto(fontSize: 10))
                : Text("Offline", style: GoogleFonts.roboto(fontSize: 10)),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: Supabase.instance.client
                    .from('messages')
                    .stream(primaryKey: ['id'])
                    .order('created_at', ascending: true)
                    .map((allmsg) => allmsg
                        .where((msg) =>
                            (msg['sender'] == sender &&
                                msg['reciever'] == receiver) ||
                            (msg['sender'] == receiver &&
                                msg['reciever'] == sender))
                        .toList()),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data!;

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    padding: EdgeInsets.only(bottom: 70),
                    itemBuilder: (context, index) {
                      final isMe = messages[index]['sender'] == sender;
                      final decryptedMsg =
                          decryptMessage(messages[index]['message']);
                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue : Colors.blueGrey,
                            borderRadius: BorderRadiusDirectional.only(
                              topEnd:Radius.circular(15),
                              topStart: Radius.circular(15),
                              bottomStart:isMe? Radius.circular(15):Radius.circular(0),
                              bottomEnd: isMe? Radius.circular(0):Radius.circular(15),

                            )
                          ),
                          child: Text(
                            decryptedMsg,
                            style: TextStyle(
                              color:  Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onSubmitted: (_) => sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.send_rounded,
                      color: Colors.blue,
                      size: 45,
                    ),
                    onPressed: sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
