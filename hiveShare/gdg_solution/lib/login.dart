import 'package:flutter/material.dart';
import 'package:gdg_solution/authgate.dart';
import 'package:google_fonts/google_fonts.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "E-Mail", border: OutlineInputBorder()),
                controller: email,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "Password", border: OutlineInputBorder()),
                controller: password,
              ),
            ),
            Visibility(
              visible: isloggedin,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                    ? Text("Already have an account ? ")
                    : Text("Does'nt have an account? "),
                isloggedin
                    ? TextButton(
                        onPressed: () => change(), child: Text("Login here"))
                    : TextButton(
                        onPressed: () => change(), child: Text("Register here"))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 70,
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 46, 46, 46),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  label: isloggedin
                      ? Text("Register",
                          style: TextStyle(
                            fontSize: 20,
                          ))
                      : Text("Login",
                          style: TextStyle(
                            fontSize: 20,
                          )),
                  icon:
                      isloggedin ? Icon(Icons.edit) : Icon(Icons.login_rounded),
                  onPressed: () async {
                    if (isloggedin == false) {
                      await Authgate()
                          .loginWithEmail(email.text, password.text, context);
                      // cleanFields();
                    } else {
                      if (password.text == confirmPassword.text) {
                        await Authgate().signUpWithEmail(
                            email.text, password.text, context);
                        // cleanFields();
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
                            content: Text("Passwords did'nt match")));
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
