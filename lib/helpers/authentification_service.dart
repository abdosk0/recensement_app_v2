import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthenticationService {
  Future<void> signIn(
      String username, String password, BuildContext context) async {
    const String apiUrl =
        'http://173.249.11.251:8080/recensement-1/api/auth/authenticate';

    final Map<String, dynamic> postData = {
      'username': username,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey('token') &&
            responseData['token'] != null) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil("menu", (route) => false);
          showSuccessMessage(context, 'Bienvenue', 'Bonjour, Mr $username');
        } else {
          showErrorMessage(context, 'Authentication failed',
              'Please check your credentials');
        }
      }
    } catch (error) {
      showErrorMessage(
          context, 'Error', 'Error during authentication. Please try again.');
    }
  }

  void showErrorMessage(BuildContext context, String title, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: title,
          message: message,
          contentType: ContentType.failure,
        ),
      ),
    );
  }

  void showSuccessMessage(BuildContext context, String title, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: title,
          message: message,
          contentType: ContentType.success,
        ),
      ),
    );
  }
}
