import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadowchat/authlobby.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isloggedin = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  void change() {
    if (isloggedin == false) {
      setState(() {
        isloggedin = true;
      });
    } else {
      setState(() {
        isloggedin = false;
      });
    }
  }

  void cleanFields() {
    email.clear();
    password.clear();
    confirmPassword.clear();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? const Color.fromARGB(255, 213, 229, 255)
          : const Color.fromARGB(255, 45, 45, 45),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: isloggedin
                  ? Text(
                      "Create an Account",
                      style: GoogleFonts.arvo(fontSize: 40),
                    )
                  : Text("Welcome Back", style: GoogleFonts.arvo(fontSize: 40)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "E-Mail", border: OutlineInputBorder()),
                controller: email,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "Password", border: OutlineInputBorder()),
                controller: password,
              ),
            ),
            Visibility(
              visible: isloggedin,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: TextField(
                  decoration: InputDecoration(
                      labelText: "Confirm Password",
                      border: OutlineInputBorder()),
                  controller: confirmPassword,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isloggedin
                    ? Text(
                        "Already have an Account ? ",
                        style: GoogleFonts.ptSans(),
                      )
                    : Text(
                        "Doesn't have an Account ? ",
                        style: GoogleFonts.ptSans(),
                      ),
                isloggedin
                    ? TextButton(
                        onPressed: () => change(), child: Text("Login here"))
                    : TextButton(
                        onPressed: () => change(), child: Text("Register here"))
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Container(
                height: 70,
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.light
                            ? const Color.fromARGB(255, 139, 184, 255)
                            : const Color.fromARGB(255, 27, 27, 27),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  label: isloggedin
                      ? Text(
                          "Register",
                          style: GoogleFonts.ptSans(fontSize: 25),
                        )
                      : Text("Login", style: GoogleFonts.ptSans(fontSize: 25)),
                  icon:
                      isloggedin ? Icon(Icons.edit) : Icon(Icons.login_rounded),
                  onPressed: () async {
                    if (isloggedin == false) {
                      showDialog(context: context, builder: (context){
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      });
                      await AuthLobby().loginWithEmail(
                        email: email.text.trim(),
                        password: password.text.trim(),
                      );
                    } else {
                      if (password.text.trim() == confirmPassword.text.trim()) {
                         showDialog(context: context, builder: (context){
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      });
                        await AuthLobby().registerWithEmail(
                          email: email.text.trim(),
                          password: password.text.trim(),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            action: SnackBarAction(
                              label: "OK",
                              onPressed: () {},
                            ),
                            content: Text("Passwords didn't match")));
                      }
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
