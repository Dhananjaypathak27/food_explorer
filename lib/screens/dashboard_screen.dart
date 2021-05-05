import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Food',style: GoogleFonts.roboto(color: Theme.of(context).primaryColor,fontWeight: FontWeight.w700),),
            Text(' Explorer',style: GoogleFonts.roboto(color: Colors.black,fontWeight: FontWeight.w700),),
          ],
        ),
        centerTitle: true,
        actions: [
          Container(
            padding: EdgeInsets.all(5),
            child: Icon(
                Icons.view_headline,
              color: Colors.black,
              size: 30,
            )
            ),

        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey)
            ),
            child: Row(
              children: [
                Icon(
                    Icons.search_outlined,color: Colors.grey,
                ),
                SizedBox(width: 10,),
                Text('Panner Tikka',style: GoogleFonts.roboto(fontSize: 18,color: Colors.grey),),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            width: MediaQuery.of(context).size.width,
              child: Text(
                'Eat what makes you happy',style: GoogleFonts.roboto(fontSize: 16),)
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}
