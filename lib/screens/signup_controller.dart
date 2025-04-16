import 'package:flutter/material.dart';

class SignupController {
  // Controllers for the email and password text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // A GlobalKey to manage the state of the signup form (for validation)
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Dispose the controllers when they are no longer needed.
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  /// Validates the form. Returns true if the form is valid.
  bool validate() {
    final form = formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  /// Call your signup service/API from this function.
  Future<void> signUp(BuildContext context) async {
    if (!validate()) {
      return;
    }

    // Insert your signup logic here.
    // For example, using Firebase:
    //
    // try {
    //   final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //     email: emailController.text.trim(),
    //     password: passwordController.text,
    //   );
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("Signup successful")),
    //   );
    //   // Navigate to the next screen or perform further actions.
    // } catch (error) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("Signup failed: $error")),
    //   );
    // }

    // For demonstration, we show a simple snack bar indicating success.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Signup successful (stub)")),
    );
  }
}
