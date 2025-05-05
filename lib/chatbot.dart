import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart'; // To get user info

class TogetherAiService {
  static const String apiKey = '9809da8106c5bf9793e82852994c72e8e4948acee4df25e613a2840ac23a1186';
  static const String baseUrl = 'https://api.together.xyz/v1';

  Future<String> getChatResponse(String prompt, List<Map<String, dynamic>> chatHistory) async {
    final url = Uri.parse('$baseUrl/chat/completions');
    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    // Get the current user from Firebase Auth
    User? user = FirebaseAuth.instance.currentUser;
    String userName = user?.displayName ?? 'Student';
    String userEmail = user?.email ?? 'unknown@example.com';

    // Define the messages array starting with the system message
    final messages = [
      {
        'role': 'system',
        'content': '''
          You are an educational assistant for a virtual learning platform focused on courses like B.Tech, M.Tech, and other academic programs. Your purpose is to help students with their studies, provide information about course materials (e.g., modules, syllabus, question banks), and assist with general academic queries. Be concise, helpful, and professional. If the user asks about something outside the app’s scope, gently steer them back to educational topics. The user’s name is $userName and their email is $userEmail.
        ''',
      },
    ];

    // Add the chat history (previous messages)
    for (var message in chatHistory) {
      messages.add({
        'role': message['role'] == 'user' ? 'user' : 'assistant',
        'content': message['content'],
      });
    }

    // Add the current user prompt
    messages.add({
      'role': 'user',
      'content': '''
        $prompt
        Context: I am a student using an app with resources for KTU B.Tech courses, including subjects like Computer Organization & Architecture, Database Management System, Data Structures, Operating System, and Formal Languages & Automata Theory, as well as syllabus, previous year questions, and question banks.
      ''',
    });

    final body = jsonEncode({
      'model': 'meta-llama/Llama-3.3-70B-Instruct-Turbo',
      'messages': messages,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      } else {
        throw Exception('Failed to get response: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error calling Together AI API: $e');
    }
  }
}