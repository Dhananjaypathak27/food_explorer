import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:food_explorer/util/shared_preference.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  FirebaseAuth _auth = FirebaseAuth.instance;
  FacebookLogin _faceBookLogin = FacebookLogin();
  String profileImage ='',userName = '',email = '';

  bool isUserLoginIn = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }
  void init() async {

    bool bol =await SharedPrefrence.isUserLogIn();
    bol = bol == null ? false: bol;

    userName = await SharedPrefrence.getDisplayName();
    print("user name " +userName);

    if(bol){
      profileImage = await SharedPrefrence.getProfileImage();
      userName = await SharedPrefrence.getDisplayName();
      email = await SharedPrefrence.getEmail();
    }

    setState(() {
      isUserLoginIn = bol;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text(''),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: !isUserLoginIn ? Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                'Your Profile',
                style: GoogleFonts.roboto(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                'Login or Sign up to view your complete profile',
                style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Colors.black),
              ),
            ),
            SizedBox(height:10),
            Container(
              width: MediaQuery.of(context).size.width,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  side: BorderSide(width: 2, color: Theme.of(context).primaryColor),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/login_screen');
                },
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 13),
                    child: Text('Continue',style: GoogleFonts.roboto(fontSize: 18,color: Theme.of(context).primaryColor),)),
              )
            ),



          ],
        ): Column(
          children: [
            Text(''+ userName),
            Text(''+ email),
            GestureDetector(
                onTap: (){
                  _logoutUser();
                },
                child: Text('logout')),
          ],
        ),
      ),
    );
  }
  void _logoutUser() async{
    await _auth.signOut().then((value){
      setState(() {
        _faceBookLogin.logOut();
        SharedPrefrence.logoutUser();
      });
    });
  }
}
