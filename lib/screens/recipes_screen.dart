import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipesScreen extends StatefulWidget {
  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {

  Map data = {};


  @override
  Widget build(BuildContext context) {

    data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text(data['name'],style: GoogleFonts.roboto(color: Colors.black),),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return ListTile(
            title: Container(
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
                            data['imageUrl'],
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width / 2.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 4,),
                      Text(data['name'],style: GoogleFonts.roboto(fontSize: 18),),
                      SizedBox(height: 4,),
                    ],
                  ),
                  Align(
                      alignment: Alignment.topRight,
                      child: Icon(Icons.bookmark_border,size: 25,color: Colors.grey,)
                  ),
                ],
              ),
            )
          );
        },
      ),
    );
  }
}
