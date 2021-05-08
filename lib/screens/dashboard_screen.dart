import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_explorer/util/shared_preference.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  var ref;
  bool isUserLoginIn = false;
  void init() async{
    bool bol =await SharedPrefrence.isUserLogIn();
    bol = bol == null ? false: bol;

    setState(() {
      isUserLoginIn = bol;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp().whenComplete(() {

      init();
      ref = FirebaseFirestore.instance.collection('category');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Food',
              style: GoogleFonts.roboto(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              ' Explorer',
              style: GoogleFonts.roboto(
                  color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Container(
              padding: EdgeInsets.all(5),
              child: GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/profile_screen');
                },
                child: Icon(
                  Icons.view_headline,
                  color: Colors.black,
                  size: 30,
                ),
              )),
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, '/search_screen');
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey)),
                child: Row(
                  children: [
                    Icon(
                      Icons.search_outlined,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Panner Tikka',
                      style: GoogleFonts.roboto(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: 20),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'Eat what makes you happy',
                  style: GoogleFonts.roboto(fontSize: 22),
                )),
            SizedBox(height: 10,),
            FutureBuilder(future: Firebase.initializeApp(),
                builder: (context,snapshot){
              if(snapshot.hasError){
                return Text('unable to load data');
              }
              // Once complete, show your application
              if (snapshot.connectionState == ConnectionState.done) {
                return StreamBuilder(
                  stream: ref.snapshots(),
                  builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                    return GridView.count(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      children: List.generate(snapshot.hasData? snapshot.data.docs.length:0, (index) {
                        return CategoryCard(name: snapshot.data.docs[index]['strCategory'],imageUrl: snapshot.data.docs[index]['strCategoryThumb'],categoryId: snapshot.data.docs[index].id);
                      }),
                    );
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            }),


          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {

  final String name;
  final String imageUrl;
  final String categoryId;
  CategoryCard({this.name, this.imageUrl,this.categoryId});

  @override
  Widget build(BuildContext context) {
  print(''+ categoryId);

    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, '/recipes_screen',arguments: {
          'name': name,
          'imageUrl': imageUrl,
          'categoryId': categoryId,
        });
      },
      child: Container(
        margin: EdgeInsets.all(5),
        width: MediaQuery.of(context).size.width / 3.2,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey)),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width /4.2,
                      height: MediaQuery.of(context).size.width / 4.2,
                    ),
                  ),
                ),
                SizedBox(height: 2,),
                Text(name,style: GoogleFonts.roboto(fontSize: 15),)
              ],
            ),
            Align(
                alignment: Alignment.topRight,
                child: Icon(Icons.bookmark_border,size: 25,color: Colors.grey,)
            )
          ],
        ),
      ),
    );
  }
}


