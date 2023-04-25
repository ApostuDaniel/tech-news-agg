import 'package:flutter/material.dart';
import '../models/register_request_model.dart';
import '../services/api_service.dart';

import '../config.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isApiCallProcess = false;
  bool hidePassword = true;
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF283B71),
        body: Form(
          key: globalFormKey,
          child: _registerUI(context),
        ),
      ),
    );
  }

  Widget _registerUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5.2,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.white,
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(100),
                bottomLeft: Radius.circular(100),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text(
                      "Tech News Agg",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Color(0xFF283B71),
                      ),
                    ),
                  ),
                ),
                // Align(
                //   alignment: Alignment.center,
                //   child: Image.asset(
                //     "assets/images/ShoppingAppLogo.png",
                //     fit: BoxFit.contain,
                //     width: 250,
                //   ),
                // ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, bottom: 30, top: 50),
            child: Text(
              "Register",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextFormField(
              controller: userNameController,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  prefixIconColor: Colors.white,
                  hintText: "Username",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7))),
              obscureText: false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Username can\'t be empty.';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextFormField(
              controller: emailController,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.mail),
                  prefixIconColor: Colors.white,
                  hintText: "Email",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7))),
              obscureText: false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email can\'t be empty.';
                }
                return null;
              },
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: passwordController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  prefixIconColor: Colors.white,
                  hintText: "Password",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    color: Colors.white.withOpacity(0.7),
                    icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
                obscureText: hidePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password can\'t be empty.';
                  }
                  return null;
                },
              )),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF283B71),
                  side: const BorderSide(color: Colors.white),
                  shape: const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              onPressed: () {
                if (validateAndSave()) {
                  // setState(() {
                  //   isApiCallProcess = true;
                  // });

                  RegisterRequestModel model = RegisterRequestModel(
                    username: userNameController.text,
                    password: passwordController.text,
                    email: emailController.text,
                  );

                  APIService.register(model).then(
                    (response) {
                      // setState(() {
                      //   isApiCallProcess = false;
                      // });

                      if (response == true) {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text(Config.appName),
                            content: const Text(
                                "Registration Successful. Please login to the account"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, 'OK');
                                  Navigator.pushNamed(
                                    context,
                                    '/login',
                                  );
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text(Config.appName),
                            content: const Text("Invalid registration data"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, 'OK');
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  );
                }
              },
              child: const Text("Register"),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
