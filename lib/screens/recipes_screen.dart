import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipesScreen extends StatefulWidget {
  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {

  Map data = {};

  var ref;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      ref = FirebaseFirestore.instance.collection('Recipes');
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    // String imageUrl = 'https://thumbor.forbes.com/thumbor/fit-in/1200x0/filters%3Aformat%28jpg%29/https%3A%2F%2Fblogs-images.forbes.com%2Fjvchamary%2Ffiles%2F2016%2F03%2Fman_of_steel-1200x800.jpg';
    // String recipeId = '1534';
    // String name = 'superman';
    // String time = '40';


    data = ModalRoute
        .of(context)
        .settings
        .arguments;

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          title: Text(
            data['name'], style: GoogleFonts.roboto(color: Colors.black),),
          centerTitle: true,
          elevation: 0,
        ),
        body: StreamBuilder(
            stream: ref.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return FutureBuilder(future: Firebase.initializeApp(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('unable to load data');
                    }
                    // Once complete, show your application
                    if (snapshot.connectionState == ConnectionState.done) {
                      return StreamBuilder(
                        stream: ref.snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          return GridView.count(
                            physics: ScrollPhysics(),
                            childAspectRatio: (MediaQuery.of(context).size.width /MediaQuery.of(context).size.width/0.53 ),
                            shrinkWrap: true,
                            crossAxisCount: 1,
                            children: List.generate(snapshot.hasData ? snapshot
                                .data.docs.length : 0, (index) {
                              return RecipesCard(name: snapshot.data
                                  .docs[index]['strMeal'],
                                  imageUrl: snapshot.data
                                      .docs[index]['strMealThumb'],
                                  recipeId: snapshot.data.docs[index].id,categoryId: data['categoryId'],category: snapshot.data
                                      .docs[index]['category']);
                            }),
                          );
                        },
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  });
            }));
  }
}

class RecipesCard extends StatelessWidget {

  final String name,imageUrl,recipeId,categoryId,category;
  RecipesCard({this.name, this.imageUrl, this.recipeId,this.categoryId,this.category});
  @override
  Widget build(BuildContext context) {
    print(recipeId);
    print(categoryId);
    return Visibility(
      visible: category == categoryId ? true: false,
      child: GestureDetector(
        onTap: (){
          Navigator.pushNamed(context, '/recipe_detail_screen',arguments: {
            // 'recipeId': recipeId,
            // 'name': name,
            // 'imageUrl': imageUrl,
            // 'time': time,
          });
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey)),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width / 2.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 4,),
                  Text(name,style: GoogleFonts.roboto(fontSize: 18),),
                  SizedBox(height: 4,),
                ],
              ),
              Align(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.bookmark_border,size: 25,color: Colors.grey,)
              ),
            ],
          ),
        ),
      ),
    );
  }
}

