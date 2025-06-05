import 'package:fitness_app/authenticate.dart';
import 'package:fitness_app/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final confirmpasswordcontroller = TextEditingController();
  bool isVisible=true;
   showPass() {
    setState(() {
      isVisible = !isVisible;
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
    confirmpasswordcontroller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "sign up",
              style: GoogleFonts.bebasNeue(
                  fontSize: 40, color: const Color.fromARGB(255, 38, 255, 0)),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextField(
                controller: emailcontroller,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.email_rounded),
                    labelText: 'Email', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextField(
               obscureText: isVisible,
                controller: passwordcontroller,
                
                decoration: InputDecoration(
                   suffixIcon: IconButton(
                    onPressed: showPass,
                    icon:
                        isVisible
                            ? Icon(Icons.visibility_off_rounded)
                            : Icon(Icons.visibility_rounded),
                  ),
                    labelText: 'Password', border: const OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding:  EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextField(
              obscureText: isVisible,
                controller: confirmpasswordcontroller,
                decoration:  InputDecoration(
                   
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Spacer(),
                const Text('Already have an account?'),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => const Loginpage()));
                    },
                    child: const Text("Sign In here")),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () async {
                  if (passwordcontroller.text ==
                      confirmpasswordcontroller.text) {
                    await Authserve().register(
                        email: emailcontroller.text,
                        password: passwordcontroller.text,
                        context: context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('passwords do not match')));
                  }
                  // await Authserve().register(email: emailcontroller.text, password: passwordcontroller.text,context: context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(37, 90, 255, 60),
                    fixedSize: const Size(double.maxFinite, 60)),
                child: Text(
                  "Sign Up",
                  style: GoogleFonts.ptSansNarrow(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ),
    );
  }
}
