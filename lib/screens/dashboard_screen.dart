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
              child: Icon(
                Icons.view_headline,
                color: Colors.black,
                size: 30,
              )),
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
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
            Container(
                padding: EdgeInsets.only(left: 20),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'Eat what makes you happy',
                  style: GoogleFonts.roboto(fontSize: 22),
                )),
            SizedBox(height: 10,),
            GridView.count(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 3,
              children: List.generate(10, (index) {
                return CategoryCard(name: 'batman',imageUrl: 'https://i.ytimg.com/vi/NLOp_6uPccQ/maxresdefault.jpg',categoryId: '1121212');
              }),
            )
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
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, '/recipes_screen',arguments: {
          'name': name,
          'imageUrl': imageUrl,
          'categoryId': categoryId
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
