import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenRouterChatService {
  final String apiKey =
      "YOUR API KEY";

  Future<String> sendMessage(String message) async {
    const url = 'YOUR URL';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'HTTP-Referer': 'https://fitnessapp.com',
        'X-Title': 'Fitness Assistant',
      },
      body: jsonEncode({
        "model": "mistralai/ministral-8b",
        "messages": [
          {
            "role": "system",
            "content":
                "You are a smart, friendly, and highly knowledgeable virtual fitness coach. Always provide concise, high-quality advice. Keep your tone supportive, and motivating.",
          },
          {"role": "user", "content": message},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      return "Error: ${response.reasonPhrase}";
    }
  }
}
