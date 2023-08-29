import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialfirebase/constants.dart';
import 'package:socialfirebase/view/auth_page.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
      //  backgroundColor: Colors.white,
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                height: deviceheight * 0.33,
                color: const Color(0xff4252B5),
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Image.asset(
                        'assets/images/firebaseicon.png',
                        height: deviceheight * 0.1,
                      ),
                    )),
              ),
              Positioned(
                  right: devicewidth * 0.08,
                  left: devicewidth * 0.08,
                  top: deviceheight * 0.21,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      height: deviceheight * 0.64,
                      child: (
                          Column(
                         children: [
                          SizedBox(
                            height: deviceheight * 0.58,
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 60.0),
                                  child: Text(
                                    "SignUp",
                                    style: TextStyle(fontSize: 22, color: Color(0xff4252B5)),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),

                                _buildTextFormField(
                                    hintText: 'Name',
                                    prefixIcon: CupertinoIcons.person),
                                const SizedBox(
                                  height: 20,
                                ),
                                _buildTextFormField(
                                    hintText: 'Email',
                                    prefixIcon: CupertinoIcons.mail),
                                const SizedBox(
                                  height: 20,
                                ),
                                _buildTextFormField(
                                    hintText: "Password",
                                    obscureText: true ,
                                    prefixIcon: CupertinoIcons.padlock,
                                    suffixIcon: Icons.visibility),

                                const SizedBox(height: 16,),


                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                        //color: Colors.green,

                                    border: Border.all(color: Colors.grey)
                                    ),
                                   // height: deviceheight * 0.20,

                                    child: const Align(alignment: Alignment.center, child: Text("Select an Image")),
                                  ),
                                )

                              ],
                            ),
                          ),



                          Expanded(
                              child: ElevatedButton(

                                  style: ElevatedButton.styleFrom(

                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15)
                                      ), // <-- Radius
                                    ),


                                    backgroundColor: const Color(0xff4252B5),
                                    minimumSize: const Size(double.infinity, 0),
                                  ),
                                  onPressed: () {},
                                  child: const Text("Submit")))
                        ],
                      )),
                    ),
                  )),


              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already Have an Account?",
                          style: TextStyle(fontSize: 18),
                        ),
                        TextButton(
                            onPressed: () {
                              Get.off(() =>  AuthPage(), transition: Transition.leftToRight);
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(fontSize: 18),
                            ))
                      ],
                    ),
                  )),
            ],
          )
      ),
    );
  }

  Widget _buildTextFormField({required IconData prefixIcon, IconData? suffixIcon, bool? obscureText, required String hintText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          hintText: hintText,
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.black,
          ),
          suffixIcon: Icon(
            suffixIcon,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
