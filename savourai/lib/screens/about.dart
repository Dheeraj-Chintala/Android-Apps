import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _appVersion = "";

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = "${info.version}+${info.buildNumber}";
    });
  }

  void _launchURL(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 167, 198, 163),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Image.asset(
                "assets/transparentApplogo.png",
                height: 250,
              ).animate().fade(),
              const SizedBox(height: 8),
              Text(
                "Version: $_appVersion",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Divider(height: 32, color: Colors.black),
              Text(
                "This app is intended for Showcase, informational and educational purposes only. \n \nAll recipe data, including ingredients, instructions, and meal images, are sourced from TheMealDB, a free and open recipe API. I do not own or claim responsibility for the accuracy, completeness, or nutritional value of the recipes provided. Users are advised to verify ingredients and cooking methods based on their personal dietary needs or allergies. \n \nThis App is not affiliated with, endorsed by, or sponsored by TheMealDB. All trademarks and content belong to their respective owners.",
                style: GoogleFonts.ptSans(),
              ).animate().fade(),
              const Divider(height: 30, color: Colors.black),
              const SizedBox(height: 12),

              Container(
                height: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/appcreator.png",
                      height: 170,
                    ).animate().fade(),
                    Container(
                      child: Text(
                        "App Created By",
                        style: TextStyle(
                          color: const Color.fromARGB(137, 0, 0, 0),
                        ),
                      ),
                    ),
                    Text(
                      "D H E E R A J \t C H I N T A L A",
                      style: GoogleFonts.ptSans(fontSize: 20),
                    ).animate().fade(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap:
                              () => _launchURL(
                                "https://github.com/Dheeraj-Chintala",
                              ),
                          child: Image.asset("assets/github.png", height: 60),
                        ).animate().shake(),
                        GestureDetector(
                          onTap:
                              () => _launchURL(
                                "https://www.linkedin.com/in/dheeraj-kumar-a34066250/",
                              ),
                          child: Image.asset("assets/linkedin.png", height: 60),
                        ).animate().shake(),

                        GestureDetector(
                          onTap:
                              () => _launchURL(
                                "https://www.instagram.com/dheeraj_chinthala/",
                              ),
                          child: Image.asset("assets/instapng.png", height: 50),
                        ).animate().shake(),
                      ],
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
