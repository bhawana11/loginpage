import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'package:login_page/homescreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign In',
          style: TextStyle(
            color: Color(0xff000000),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffffffff),
        elevation: 0,
        leading: Icon(
          Icons.arrow_back_ios,
          color: Color(0xff000000),
          size: 20,
        ),
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          color: Color(0xffffffff),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to the \nDizziHotel',
                  style: TextStyle(
                    color: Color(0xff000000),
                    fontSize: 40,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Enter your phone number or username \nand password to signin',
                  style: TextStyle(
                    color: Color(0xff939393),
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'USERNAME',
                  style: TextStyle(
                      color: Color(0xffa4a4a4),
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.2),
                ),
                TextField(
                  controller: usernameController,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Color(0xff000000)),
                  decoration: InputDecoration(
                    suffixIcon: usernameController.text.isNotEmpty
                        ? Icon(
                            Icons.check,
                            color: Color(0xffeda734),
                          )
                        : null,
                    labelText: 'Username',
                    labelStyle:
                        TextStyle(color: Color(0xff868686), fontSize: 18),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.white.withOpacity(0.3),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffa4a4a4),
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'PASSWORD',
                  style: TextStyle(
                      color: Color(0xffa4a4a4),
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.2),
                ),
                TextField(
                    controller: passwordController,
                    obscureText: _obscureText,
                    obscuringCharacter: '*',
                    enableSuggestions: false,
                    autocorrect: false,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Color(0xff000000)),
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(_obscureText
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                      labelText: 'Password',
                      labelStyle:
                          TextStyle(color: Color(0xff868686), fontSize: 18),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor: Colors.white.withOpacity(0.3),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffa4a4a4),
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword),
                SizedBox(
                  height: 50,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(90)),
                  child: ElevatedButton(
                    onPressed: () {
                      login();
                    },
                    child: Text(
                      'SIGN IN',
                      style: const TextStyle(
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Color(0xff868686);
                        }
                        return Color(0xffeda734);
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      elevation: MaterialStateProperty.all<double>(0.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    if (passwordController.text.isNotEmpty &&
        usernameController.text.isNotEmpty) {
      final response = await http.post(
        Uri.parse('https://test.rouund.ca/mob/staff_login/'),
        body: {
          'username': usernameController.text,
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        try {
          final jsonResponse = jsonDecode(response.body);
          final jsonStr = jsonEncode(jsonResponse);
          print(jsonStr);
          if (jsonResponse.containsKey('msg')) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(jsonResponse['msg'])));
          }
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Invalid Response: ${response.body}")));
        } catch (e) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Invalid Credentials.")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('BlankField Not Allowed')));
    }
  }
}
