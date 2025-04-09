import 'package:e_ellenki/authlobby.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool eye = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Stack(
                children: [
                  Image.asset(
                    'assets/Vector.png',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                    child: Image.asset(
                      'assets/people.png',
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.mail_outline_outlined),
                    labelText: 'Email',
                    border: OutlineInputBorder()),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextField(
                controller: passwordController,
                obscureText: eye,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          if (eye == true) {
                            setState(() {
                              eye = false;
                            });
                          } else {
                            setState(() {
                              eye = true;
                            });
                          }
                        },
                        icon: Icon(Icons.remove_red_eye_rounded)),
                    labelText: 'Password',
                    border: OutlineInputBorder()),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                          const Color.fromARGB(255, 19, 45, 145))),
                  onPressed: () async {
                    print(emailController.text + passwordController.text);

                    await Authlobby().loginmethod(
                        email: emailController.text,
                        password: passwordController.text,
                        context: context);
                    print(emailController.text + passwordController.text);
                  },
                  child: Text("Sign In",
                      style: TextStyle(color: Colors.white, fontSize: 25))),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Spacer(),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.g_mobiledata,
                    size: 50,
                  ),
                  label: Text(""),
                ),
                Spacer(),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.facebook,
                    size: 40,
                  ),
                  label: Text(""),
                ),
                Spacer(),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.apple,
                    size: 40,
                  ),
                  label: Text(""),
                ),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
