
import 'package:flutter/material.dart';
import 'package:login/components/background.dart';
import 'package:login/Screens/homepage/student_home.dart';
import 'package:login/Screens/register/register.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiServices{

  Future <LoginApiResponse> apiCallLogin(Map<String,dynamic> param) async{

    var url = Uri.parse('https://reqres.in/api/login');
    var response = await http.post(url, body: param);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    final data = jsonDecode(response.body);
    return LoginApiResponse(token: data["token"], error: data["error"]);
  }
}


class LoginApiResponse{
  final String? token;
  final String? error;

  LoginApiResponse({this.token,this.error});

}

class LoginScreen extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool f=false;
  callLoginApi() {
    final service = ApiServices();

    service.apiCallLogin(
      {
        "email": nameController.text,
        "password": passwordController.text,
      },
    ).then((value){
      if(value.error != null){
        print("get data >>>>>> " + value.error!);
      }else{
        print(value.token!);
        f=true;
        //push
        //Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()),);
      }
    });

  }

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  void validate() {
    if (formkey.currentState!.validate()){
      print('valid');
    }else print('not valid');
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: Background(
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "LOGIN",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2661FA),
                      fontSize: 36
                  ),
                  textAlign: TextAlign.left,
                ),
              ),

              SizedBox(height: size.height * 0.03),

              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                      labelText: "Username"
                  ),
                  validator: (uvalue){
                    if(uvalue!.isEmpty){
                      return "Required";
                    }else return null;
                  },
                ),
              ),

              SizedBox(height: size.height * 0.03),

              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                      labelText: "Password"
                  ),
                  validator: (pvalue){
                    if(pvalue!.isEmpty){
                      return "Required";
                    }
                    //else if(pvalue.length<6) return "password should be at least 6digit";
                    else return null;
                  },
                  obscureText: true,
                ),
              ),

              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Text(
                  "Forgot your password?",
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0XFF2661FA)
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.05),

              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: RaisedButton(
                  onPressed: (){
                    if(formkey.currentState!.validate()) {
                      //login(nameController.toString(),passwordController.toString());
                      callLoginApi();
                      if(f==true){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      }
                      print('hoise');
                    }
                    else print('error');
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const HomeScreen()),
                    // );
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0)),
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    width: size.width * 0.5,
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(80.0),
                        gradient: new LinearGradient(
                            colors: [
                              Color.fromARGB(255, 255, 136, 34),
                              Color.fromARGB(255, 255, 177, 41)
                            ]
                        )
                    ),
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      "LOGIN",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()))
                  },
                  child: Text(
                    "Don't Have an Account? Sign up",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2661FA)
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// void login(String name, String pass) async {
//   try{
//     Response response=post(
//         Uri.parse('https://reqres.in/api/login/'),
//         body: {
//           'password' : pass,
//           'email' : name,
//         }
//         // Uri.parse('https://jsonplaceholder.typicode.com/posts'),
//         // body: {
//         //   'id' : pass,
//         //   'userId' : name,
//         // }
//     ) as Response;
//     if(response.statusCode==200){
//       print('response success');
//     }else print("failed");
//   }
//   catch(e){
//     print(e.toString());
//     print('errrrrrrrrrrrrrrrrrrrrrrrrror');
//   }
// }