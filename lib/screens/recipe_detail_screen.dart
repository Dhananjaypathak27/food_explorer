import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_explorer/util/shared_preference.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeDetailScreen extends StatefulWidget {
  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  Map data = {};
  QuerySnapshot snapshotData;
  bool isLogin = false;
  String userName = '';
  TextEditingController _commentController = TextEditingController();

  init() async {
    await Future.delayed(Duration(milliseconds: 200), () {});
    bool isLogin1 = await SharedPrefrence.isUserLogIn();
    String userName1 = await SharedPrefrence.getDisplayName();
    QuerySnapshot snapshotData1 = await queryData(data['recipeId']);
    setState(() {
      userName = userName1;
      isLogin = isLogin1;
      snapshotData = snapshotData1;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Image.network(
                    data['imageUrl'],
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width / 1.5,
                  ),
                  Container(
                    color: Color(0xFF000000).withOpacity(0.5),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width / 1.5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10, left: 5),
                      child: Icon(
                        Icons.arrow_back,
                        size: 25,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        data['name'],
                        style: GoogleFonts.roboto(
                            fontSize: 25, color: Colors.grey[400]),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Time Required to Cook:- ',
                    style:
                        GoogleFonts.roboto(color: Colors.black, fontSize: 20),
                  ),
                  Text(
                    data['time'] + ' mins',
                    style: GoogleFonts.roboto(
                        color: Theme.of(context).primaryColor, fontSize: 20),
                  ),
                ],
              ),
              Visibility(
                visible: isLogin,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.only(right: 20, top: 10, bottom: 10),
                    width: 200,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        side: BorderSide(width: 2, color: Colors.blueAccent),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text("Add Comment to recipe"),
                            content: TextField(
                              controller: _commentController,
                              textInputAction: TextInputAction.go,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(hintText: "Loved the food",hintStyle: GoogleFonts.roboto(color: Colors.grey[300])),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                  // Navigator.pop(context);
                                },
                                child: Text("cancel"),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                    _addComment();


                                    // Navigator.of(context).pushNamedAndRemoveUntil(
                                    //     '/dashboard_screen',
                                    //         (Route<dynamic> route) => false);
                                  },
                                  child: Text('Add'))
                            ],
                          ),
                        );
                      },
                      child: Text('Add Comment'),
                    ),
                  ),
                ),
              ),
              snapshotData != null
                  ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshotData.docs.length == null
                          ? 0
                          : snapshotData.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            children: [
                              Text(
                                snapshotData.docs[index]['comment'],
                                style: GoogleFonts.roboto(fontSize: 14),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                      margin: EdgeInsets.only(right: 5),
                                      child: Text(
                                    '-' + snapshotData.docs[index]['userName'],
                                    style: GoogleFonts.roboto(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ))),
                            ],
                          ),
                        );
                      })
                  : Text(''),
            ],
          ),
        ),
      ),
    );
  }

  Future queryData(String recipeId) async {
    print('recipe id  $recipeId');
    return FirebaseFirestore.instance
        .collection('Commets')
        .where('Recipes', isEqualTo: recipeId)
        .get();
  }

  Future _addComment() async{

    if(_commentController.text.isNotEmpty){

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Comment added Successfully',
            style: GoogleFonts.roboto(color: Colors.white),
          )));

      FirebaseFirestore.instance.collection('Commets').add({
        'Recipes': data['recipeId'],
        'comment': _commentController.text,
        'userName': userName,
      }).then((value) async{
        QuerySnapshot snapshotData1 = await queryData(data['recipeId']);
       setState(() {
         snapshotData = snapshotData1;
       });
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Please Enter your comment',
            style: GoogleFonts.roboto(color: Colors.white),
          )));
    }


  }

}
