import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OpenRouterChatService {
  final String apiKey = "${dotenv.env['CHAT_API_KEY']}";

  Future<String> sendMessage(String message) async {
    final url = "${dotenv.env['CHAT_URL']}";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'HTTP-Referer': 'https://savourAI.com',
        'X-Title': 'Cooking Assistant',
      },
      body: jsonEncode({
        "model": "mistralai/ministral-8b",
        "messages": [
          {
            "role": "system",
            "content":
                "You are an AI cooking assistant named ChefBot. You help users cook meals by suggesting recipes, guiding them step by step through preparation, offering substitutions for ingredients, estimating cooking times, and adapting recipes for dietary needs. you always try to engage with user by giving usefull cooking tips.",
          },
          {"role": "user", "content": message},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      return "Oops! Something went wrong on our end. Please try again later. Possible reason could be ${response.reasonPhrase}";
    }
  }
}
