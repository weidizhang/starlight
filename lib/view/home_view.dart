import 'package:flutter/material.dart';
import 'package:starlight_credits/core/app_constants.dart';
import 'package:starlight_credits/controller/home_controller.dart';

class HomeViewStateful extends StatefulWidget {
  const HomeViewStateful({Key? key}) : super(key: key);

  @override
  State<HomeViewStateful> createState() => HomeView();
}

class HomeView extends State<HomeViewStateful> {
  final HomeController controller = HomeController();

  @override
  Widget build(BuildContext context) {
    controller.updateContext(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Image.asset(
                AppConstants.imageLogoPath,
                width: 125,
                height: 125,
              ),
            ),
            /* Header */
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                AppConstants.appName,
                style: TextStyle(
                  fontSize: 40.0,
                  fontFamily: 'RobotoSlab',
                ),
              ),
            ),
            /* Login Form */
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
                    controller: controller.passwordController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(elevation: 2),
              onPressed: controller.handleLoginClick,
              child: const Text('Login'),
            ),
            /* Sign Up Form Launcher */
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text('Don\'t have an account already?'),
                  GestureDetector(
                    child: const Text(
                      'Join today.',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                      ),
                    ),
                    onTap: controller.handleRegisterClick,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
