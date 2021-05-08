import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeDetailScreen extends StatefulWidget {
  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  Map data = {};
  QuerySnapshot snapshotData;

  init() async{

    await Future.delayed(Duration(milliseconds: 200), () {});

    QuerySnapshot snapshotData1 =await queryData(data['recipeId']);
    setState(() {
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
                      margin: EdgeInsets.only(top: 10,left: 5),
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
                    style: GoogleFonts.roboto(color: Colors.black, fontSize: 20),
                  ),
                  Text(
                    data['time'] + ' mins',
                    style: GoogleFonts.roboto(
                        color: Theme.of(context).primaryColor, fontSize: 20),
                  ),
                ],
              ),

              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.only(right: 20),
                  width: 200,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      side: BorderSide(width: 2, color: Colors.blueAccent),
                    ),
                    onPressed: () {},
                    child: Text('Button'),
                  ),
                ),
              ),

              snapshotData != null ?

              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshotData.docs.length == null ? 0: snapshotData.docs.length  ,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      // leading: CircleAvatar(
                      //   backgroundImage:
                      //   NetworkImage(snapshotData.docs[index]['strMealThumb']),
                      // ),
                      title: Text(
                        snapshotData.docs[index]['comment'],
                        style: GoogleFonts.roboto(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w700),
                      ),
                    );
                  }): Text(''),
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
}
