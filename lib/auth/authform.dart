import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Authform extends StatefulWidget {
  @override
  _AuthformState createState() => _AuthformState();
}

class _AuthformState extends State<Authform> {

  final _formkey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _username = '';
  bool isLoginPage = false;

  startauthentication()async{
    final validity = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if(validity){
      _formkey.currentState!.save();
      submitform(_email, _password, _username);
    }
  }

  submitform(String email, String password, String username)async{
    final auth = FirebaseAuth.instance;
     AuthResult authResult;
    try{
      if(isLoginPage){
        authResult = await auth.signInWithEmailAndPassword(email: email, password: password);
      }else{
        authResult = await auth.createUserWithEmailAndPassword(email: email, password: password);
        String uid = authResult.user.uid;
        await Firestore.instance.collection('users').document(uid).setData({
          'username' :username,
          'email' : email
        });
      }
    }
    catch(e){
        print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height,
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(40),
            height: 200,
            child: Image.asset('assets/todo.png'),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10 ),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:[
                    if(!isLoginPage)
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        key: ValueKey('username'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Incorrect Username';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _username = value!;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(5.0),
                              borderSide: new BorderSide()),
                          labelText: 'Enter Username',
                          labelStyle: GoogleFonts.beVietnam(),
                        ),
                      ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      key: ValueKey('email'),
                      validator: (value){
                        if(value!.isEmpty || !value.contains('@')){
                          return 'Incorrect Email';
                        }
                        return null;
                      },
                      onSaved: (value){
                        _email = value!;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(5.0),
                              borderSide: new BorderSide()),
                          labelText: 'Enter Email',
                          labelStyle: GoogleFonts.beVietnam(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      obscureText: true,
                      keyboardType: TextInputType.emailAddress,
                      key: ValueKey('password'),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Incorrect Password';
                        }
                        return null;
                      },
                      onSaved: (value){
                        _password = value!;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            borderSide: new BorderSide()),
                        labelText: 'Enter Password',
                        labelStyle: GoogleFonts.beVietnam(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                     padding: EdgeInsets.all(5),
                     width: double.infinity,
                        height: 70,
                        child:RaisedButton(
                            child: isLoginPage? Text('Login',
                                style: GoogleFonts.alegreya(fontSize: 25))
                             : Text('SignUp',style: GoogleFonts.alegreya(fontSize: 25)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            color: Theme.of(context).primaryColor,
                            onPressed: (){
                              startauthentication();
                            }
                            ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      child: TextButton(onPressed: (){
                        setState(() {
                          isLoginPage = !isLoginPage;
                        });
                      },
                        child: isLoginPage?Text('Not a Member?', style: GoogleFonts.poppins(fontSize: 20, color: Colors.black),):Text('Already a Member?', style: GoogleFonts.poppins(fontSize: 20, color: Colors.black),)
                      ),
                    ),
                  ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
