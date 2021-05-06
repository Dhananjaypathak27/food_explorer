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
    String imageUrl = 'https://thumbor.forbes.com/thumbor/fit-in/1200x0/filters%3Aformat%28jpg%29/https%3A%2F%2Fblogs-images.forbes.com%2Fjvchamary%2Ffiles%2F2016%2F03%2Fman_of_steel-1200x800.jpg';
    String recipeId = '1534';
    String name = 'superman';
    String time = '40';
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
            title: GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, '/recipe_detail_screen',arguments: {
                  'recipeId': recipeId,
                  'name': name,
                  'imageUrl': imageUrl,
                  'time': time,
                });
              },
              child: Container(
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
            )
          );
        },
      ),
    );
  }
}
