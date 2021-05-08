import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  QuerySnapshot snapshotData;
  bool isExecuted = false;

  @override
  Widget build(BuildContext context) {
    Widget searchData() {
      print('data is here');
      print( snapshotData.docs.length);
      return ListView.builder(
          itemCount: snapshotData.docs.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    NetworkImage(snapshotData.docs[index]['strMealThumb']),
              ),
              title: Text(
                snapshotData.docs[index]['strMeal'],
                style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
            );
          });
    }

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          actions: [
            IconButton(icon: Icon(Icons.search), onPressed: () {
              print('search clicked');
              queryData(searchController.text).then((value) {
                snapshotData = value;
                setState(() {
                  isExecuted = true;
                  print('isExecuted $isExecuted');
                });
              });

            })
          ],
          title: TextField(
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: 'search recipe',
              hintStyle: TextStyle(color: Colors.grey[400]),
            ),
            controller: searchController,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: isExecuted
            ? searchData()
            : Container(
                child: Center(
                  child: Text(
                    'Search any Recipe',
                    style: GoogleFonts.roboto(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ));
  }

  Future queryData(String queryString) async {
    return FirebaseFirestore.instance
        .collection('Recipes')
        .where('strMeal', isGreaterThanOrEqualTo: queryString)
        .get();
  }
}
