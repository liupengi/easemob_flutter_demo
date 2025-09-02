import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'home_page.dart';

// Import MVI components
import 'features/login/login_bloc.dart';
import 'features/login/login_intent.dart';
import 'features/login/login_state.dart';
import 'features/login/login_event.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // Initialize login
    context.read<LoginBloc>().add(const LoginInitializedIntent());
    
    // Listen to login events
    context.read<LoginBloc>().eventStream.listen((event) {
      if (event is NavigateToHomeEvent) {
        _navigateToHome();
      } else if (event is ShowLoginErrorEvent) {
        _showErrorMessage(event.message);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 100),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Enter username"),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Enter password"),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: state is LoginLoadingState ? null : _signIn,
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.lightBlue),
                        ),
                        child: state is LoginLoadingState
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text("登录"),
                      ),
                    ),
                  ],
                ),
                if (state is LoginFailureState)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      state.errorMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }


  void _signIn() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    
    context.read<LoginBloc>().add(
      LoginSubmittedIntent(username: username, password: password),
    );
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
