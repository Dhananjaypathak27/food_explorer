import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_explorer/util/shared_preference.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {




  bool _isLogin = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FacebookLogin _faceBookLogin = FacebookLogin();

  void inti() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inti();
  }
  User _user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFEFF5FF),
      appBar: AppBar(
        backgroundColor: Color(0XFFEFF5FF),
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor, //change your color here
        ),
        title: Text('User Login',style: GoogleFonts.roboto(color: Theme.of(context).primaryColor),),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
          'assets/svg/login_screen_svg.svg',
      ),
          OutlineButton(onPressed: ()
            {  _handelLogin();}
            ,child: Text('Login with FaceBook',style: GoogleFonts.roboto(fontSize: 20),),)
        ],
      ),
    );
  }

  Future _handelLogin() async{
    FacebookLoginResult _result = await _faceBookLogin.logIn(['email']);
    switch (_result.status){
      case FacebookLoginStatus.cancelledByUser:
        print('cancelled by user');
        break;
      case FacebookLoginStatus.error:
        print('error');
        break;
      case FacebookLoginStatus.loggedIn:
        await _loginWithFacebook(_result);
      break;
    }
  }

  Future _loginWithFacebook(FacebookLoginResult _result) async{
    FacebookAccessToken _accessToken = _result.accessToken;
    AuthCredential _credential = FacebookAuthProvider.credential(_accessToken.token);
    var a = await _auth.signInWithCredential(_credential);
    setState(() {
      _isLogin = true;
      _user = a.user;
      print(_user.displayName);
      print(_user.email);
      print(_user.photoURL);
      // print(_user.phoneNumber);



      _setUserDetails();
    });
  }

  void _setUserDetails() async{
    SharedPrefrence.setUserLogIn(true);
    SharedPrefrence.setDisplayName(_user.displayName);
    SharedPrefrence.setEmail(_user.email);
    SharedPrefrence.setProfileImage(_user.photoURL);
    // SharedPrefrence.setMobileNumber(_user.phoneNumber);

    bool isExists = await doesEmailAlreadyExist(_user.email);
    print('is email avialble $isExists');

    if(!isExists){
      FirebaseFirestore.instance.collection('user').add({
        'email': _user.email,
        'name': _user.displayName
      });
    }



    Navigator.pushNamedAndRemoveUntil(context, '/dashboard_screen', (route) => false);

  }

  Future<bool> doesEmailAlreadyExist(String email) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  Future _signOut() async{
    await _auth.signOut().then((value){
      setState(() {
        _faceBookLogin.logOut();
        _isLogin = false;
      });
    });
  }

}
