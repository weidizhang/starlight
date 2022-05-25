import 'package:flutter/material.dart';
import 'package:starlight_credits/controller/register_controller.dart';

class RegisterViewStateful extends StatefulWidget {
  const RegisterViewStateful({Key? key}) : super(key: key);

  @override
  State<RegisterViewStateful> createState() => RegisterView();
}

class RegisterView extends State<RegisterViewStateful> {
  final RegisterController controller = RegisterController();

  @override
  Widget build(BuildContext context) {
    controller.updateContext(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /* Header */
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontFamily: 'RobotoSlab',
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
                child: Text(
                  'Please enter your basic info to get started.',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'RobotoSlab',
                  ),
                ),
              ),
              /* Register Form */
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.emailController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                    TextFormField(
                      controller: controller.usernameController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Username',
                      ),
                    ),
                    TextFormField(
                      controller: controller.passwordController,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                    TextFormField(
                      controller: controller.confirmPasswordController,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Confirm Password',
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 2),
                onPressed: controller.handleJoinClick,
                child: const Text('Join'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
