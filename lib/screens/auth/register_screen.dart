import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../home/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final nameController = TextEditingController();

  bool hide1 = true;
  bool hide2 = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        confirmController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }
    if (passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password must be at least 6 characters"),
        ),
      );
      return;
    }
    if (passwordController.text != confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    final auth = context.read<AuthProvider>();

    final ok = await auth.register(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (!mounted) return;

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration failed")),
      );
      return;
    }

    final firebaseUser = auth.currentUser;
    if (firebaseUser != null) {
      final model = UserModel(
        uid: firebaseUser.uid,
        name: nameController.text.trim(),
        email: firebaseUser.email ?? emailController.text.trim(),

        photoUrl: "",

        bio: "",
        country: "",

        favoriteTeam: "",
        favoritePlayer: "",

        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await context.read<UserProvider>().saveUser(model);
    }

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
          (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xff0F172A),
      appBar: AppBar(backgroundColor: const Color(0xff111827), title: const Text("Register")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: "Full Name"),
            ),
            const SizedBox(height:16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(hintText: "Email"),
            ),
            const SizedBox(height:16),
            TextField(
              controller: passwordController,
              obscureText: hide1,
              decoration: InputDecoration(
                hintText: "Password",
                suffixIcon: IconButton(
                  onPressed: ()=>setState(()=>hide1=!hide1),
                  icon: Icon(hide1?Icons.visibility:Icons.visibility_off),
                ),
              ),
            ),
            const SizedBox(height:16),
            TextField(
              controller: confirmController,
              obscureText: hide2,
              decoration: InputDecoration(
                hintText: "Confirm Password",
                suffixIcon: IconButton(
                  onPressed: ()=>setState(()=>hide2=!hide2),
                  icon: Icon(hide2?Icons.visibility:Icons.visibility_off),
                ),
              ),
            ),
            const SizedBox(height:24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: auth.isLoading?null:register,
                child: auth.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("REGISTER"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
