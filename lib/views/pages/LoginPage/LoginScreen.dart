
import '../../../FireBaseServices/CollectionVariable.dart';
import '../../../FireBaseServices/FirebaseAuth.dart';
import '../../../contant/CustomNavigation.dart';
import '../../widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:get/get.dart' show Get, Inst;
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 8),
       child:const Column(
         children:  [
          SizedBox(height: 60,),
           Body(),
         ],
       ) ,
      ),
    );
  }
}



class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  
  bool isObsecure = true;
  late final TextEditingController emailController ;
  late final TextEditingController passwordController ;

  String? emailError;
  String? passwordError;
 late FirebaseAuthUser controller ;
 late FirebaseCollectionVariable collectioncontrolelr;
  // Function to validate email format
  bool isValidEmail(String email) {
    final RegExp emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(email);
  }


  @override
  void initState() {
    super.initState();
    controller = Get.find<FirebaseAuthUser>();
    collectioncontrolelr = Get.find<FirebaseCollectionVariable>();
     emailController = TextEditingController();
  passwordController = TextEditingController();
  
  }

@override
  void dispose() {
    controller.dispose();
    collectioncontrolelr.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 65.0),
          child: SizedBox(
            
            width: 360,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sign In to \n Admin Role',
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text.rich(
                  TextSpan(
                    text: "The admin role ensures seamless management of users, data, and operations, creating a smarter and more efficient ",
                    style: const TextStyle(
                      letterSpacing: 1,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: "Education System",
                        style: TextStyle(
                          letterSpacing: 1,
                          color: primaryGreenColors,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SvgPicture.asset(
                  'images/admin1.svg',
                  width: 300,
                ),
              ],
            ),
          ),
        ),
        SvgPicture.asset(
          'images/admin2.svg',
          width: 300,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 6),
          child: SizedBox(
            width: 320,
            child: Column(children: [
              TextField(
                controller: emailController,
                cursorColor: primaryGreenColors,
                decoration: InputDecoration(
                  hintText: 'Enter email address',
                  labelStyle: const TextStyle(fontSize: 12),
                  contentPadding: const EdgeInsets.only(left: 30),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreenColors),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreenColors),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  errorText: emailError, // Display email error if any
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: passwordController,
                style: const TextStyle(fontSize: 17, color: Colors.black),
                cursorColor: primaryGreenColors,
                obscureText: isObsecure, // Hide/show password
                decoration: InputDecoration(
                  hintText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      isObsecure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        isObsecure = !isObsecure;
                      });
                    },
                  ),
                  labelStyle: const TextStyle(fontSize: 12),
                  contentPadding: const EdgeInsets.only(left: 30),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreenColors),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreenColors),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  errorText: passwordError, // Display password error if any
                ),
              ),
              const SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: primaryGreenColors,
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () async{
                    setState(() {
                      // Validate email field
                      if (emailController.text.isEmpty) {
                        emailError = "Email cannot be empty";
                      } else if (!isValidEmail(emailController.text)) {
                        emailError = "Enter a valid email";
                      } else {
                        emailError = null;
                      }

                      // Validate password field
                      if (passwordController.text.isEmpty) {
                        passwordError = "Password cannot be empty";
                      } else {
                        passwordError = null;
                      }
                    });

                    // Proceed if no errors
                    if (emailError == null && passwordError == null) {
                      await controller.signinUser(email: emailController.text,password: passwordController.text, context: context);
                       customNvigation(context, '/home');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: primaryGreenColors,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Center(
                          child: Text(
                        "Sign In",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ))),
                ),
              ),
              const SizedBox(height: 40),
            ]),
          ),
        )
      ],
    );
  }
}
