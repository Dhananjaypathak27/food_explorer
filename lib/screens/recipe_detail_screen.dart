import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeDetailScreen extends StatefulWidget {
  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {

  Map data = {};

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: SafeArea(
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
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: 25,
                    color: Colors.grey[400],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    data['name'],style: GoogleFonts.roboto(fontSize: 25,color: Colors.grey[400]),
                  ),
                )
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Time Required to Cook:- ',style: GoogleFonts.roboto(color: Colors.black,fontSize: 20),),
                Text(data['time']+ ' mins',style: GoogleFonts.roboto(color: Theme.of(context).primaryColor,fontSize: 20),),
              ],
            )
          ],
        ),
      ),
    );
  }
}
