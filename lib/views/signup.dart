import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/helper/theme.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/chatrooms.dart';
import 'package:chatapp/widget/widget.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp(this.toggleView);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController usernameEditingController =
      new TextEditingController();

  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  signUp() async {

    if(formKey.currentState.validate()){
      setState(() {

        isLoading = true;
      });

      await authService.signUpWithEmailAndPassword(emailEditingController.text,
          passwordEditingController.text).then((result){
            if(result != null){

              Map<String,String> userDataMap = {
                "userName" : usernameEditingController.text,
                "userEmail" : emailEditingController.text
              };

              databaseMethods.addUserInfo(userDataMap);

              HelperFunctions.saveUserLoggedInSharedPreference(true);
              HelperFunctions.saveUserNameSharedPreference(usernameEditingController.text);
              HelperFunctions.saveUserEmailSharedPreference(emailEditingController.text);

              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => ChatRoom()
              ));
            }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ? Container(child: Center(child: CircularProgressIndicator(),),) :
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24,vertical: 10),
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      child: Image.asset("assets/images/chat.png",height: 150,),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 3,horizontal: 50),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        border: new Border.all(
                          color: Colors.white38,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(30),

                      ),
                      child: TextFormField(
                        validator: (val){
                          return val.isEmpty || val.length < 2 ? "Please provide a valid username" :  null;
                        },
                        controller: usernameEditingController,
                        decoration: InputDecoration(
                          hintText: "Username",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 3,horizontal: 50),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        border: new Border.all(
                          color: Colors.white38,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(30),

                      ),
                      child: TextFormField(
                        validator: (val){
                          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                          null : "Enter a valid email";
                        },
                        controller: emailEditingController,
                        decoration: InputDecoration(
                          hintText: "Email",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 3,horizontal: 50),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        border: new Border.all(
                          color: Colors.white38,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(30),

                      ),
                      child: TextFormField(
                        obscureText: true,
                        validator: (val){
                          return val.length > 5 ? null : "Please provide a 5+ character password";
                        },
                        controller: passwordEditingController,
                        decoration: InputDecoration(
                          hintText: "Password",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15,),
              Container(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                  child: Text("Forgot Password?"),
                ),
              ),
              SizedBox(height: 15,),
              GestureDetector(
                onTap: (){
                  signUp();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20,horizontal: 40),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child:
                  Text("Sign Up",style: TextStyle(
                    fontSize: 17,
                  ),),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                child: Text("Or, sign up with "),
              ),
              SizedBox(height: 14,),
              Container(
                padding:
                EdgeInsets.symmetric(horizontal: 45,vertical: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset("assets/images/google.png",height: 45,),
                      SizedBox(width: 57,),
                      Image.asset("assets/images/facebook.png",height: 45,),
                      SizedBox(width: 57,),
                      Image.asset("assets/images/microsoft.png",height: 45,),
                    ]
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Google"),
                      SizedBox(width: 51,),
                      Text("Facebook"),
                      SizedBox(width: 47,),
                      Text("Outlook"),
                    ]
                ),
              ),
              SizedBox(height: 32,),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have account ?"),
                    GestureDetector(
                      onTap: (){
                        widget.toggleView();
                      },
                      child: Text(" Login Now", style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
