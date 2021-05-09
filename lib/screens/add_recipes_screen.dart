import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_explorer/models/category_list.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddRecipesScreen extends StatefulWidget {
  @override
  _AddRecipesScreenState createState() => _AddRecipesScreenState();
}

class _AddRecipesScreenState extends State<AddRecipesScreen> {

  String imageUrl,categoryId,time;
  List<CategoryList> categoryList = [CategoryList(name: 'Starter',id: '3TTIdIq53SjGJ0nMVl1q'),
    CategoryList(name: 'Vegetarian',id: '6ZQ1MZCmOn4nuCKrCWVa'),CategoryList(name: 'Breakfast',id: 'N8hTon0MF3ohPwRli6dX'),
    CategoryList(name: 'Vegan',id: 'SKkyb8Q6BRaQQ0JNbwoo')];
  TextEditingController _recipeIdController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _recipeNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text('Add Recipe',style: GoogleFonts.roboto(color: Colors.black),),
        elevation: 1,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20,),
          // imageUrl != null ?
          //     Image.network(imageUrl)
          //     : Placeholder(fallbackHeight: 200,fallbackWidth: double.infinity,),
          Text('*Select Category and Fill Time required to cook',style: GoogleFonts.roboto(fontSize: 16,color: Colors.blue),),
          SizedBox(height: 20,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _recipeIdController,
              readOnly: true,
              enabled: true,
              autofocus: false,
              showCursor: false,
              enableInteractiveSelection: false,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.fastfood,
                  color: Theme.of(context).primaryColor,
                ),
                border: OutlineInputBorder(),
                labelText: 'Select Category',
                labelStyle: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600]),
              ),
              onTap: (){
                _displayDialogPersons(context);
              },
            ),
          ),
          SizedBox(height: 10,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _timeController,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.timelapse,
                  color: Theme.of(context).primaryColor,
                ),
                border: OutlineInputBorder(),
                labelText: 'Enter Time required to cook',
                labelStyle: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600]),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _recipeNameController,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.emoji_food_beverage,
                  color: Theme.of(context).primaryColor,
                ),
                border: OutlineInputBorder(),
                labelText: 'Enter Recipe name',
                labelStyle: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600]),
              ),
            ),
          ),
          SizedBox(height: 20,),
          ElevatedButton(
            child: Text('Select Image and Upload'),
            onPressed: () {
              if(_recipeIdController.text.isEmpty){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Select Category',
                      style: GoogleFonts.roboto(color: Colors.white),
                    )));
              }
              else if(_timeController.text.isEmpty){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Enter time',
                      style: GoogleFonts.roboto(color: Colors.white),
                    )));
              }
              else if(_recipeNameController.text.isEmpty){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Enter Recipe Name',
                      style: GoogleFonts.roboto(color: Colors.white),
                    )));
              }
              else{
                uploadImage();
              }

            },
            style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
  uploadImage() async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;
    //check permission
    await Permission.phone.request();

    var permissionStatus = await Permission.photos.status;

    if(permissionStatus.isGranted){
      //select image
      image = await _picker.getImage(source: ImageSource.gallery);
      var file = File(image.path);

      if(image != null){

        //6 digit random number
        var rng = new Random();
        var code = rng.nextInt(900000) + 100000;
        //upload to firebase
        var snapshot = await _storage.ref().child('recipeImage/$code').putFile(file).whenComplete(() {

        });

        var downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrl = downloadUrl;
        await _saveRecipeToFireStore();



        Navigator.pushNamedAndRemoveUntil(context, '/dashboard_screen', (route) => false);
        setState(() {
          imageUrl = downloadUrl;

        });

      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'No image available',
              style: GoogleFonts.roboto(color: Colors.white),
            )));
      }
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Permission Denied',
            style: GoogleFonts.roboto(color: Colors.white),
          )));
    }
  }

  _saveRecipeToFireStore() async{
    FirebaseFirestore.instance.collection('Recipes').add({
      'category': categoryId,
      'strMealThumb': imageUrl,
      'strMeal': _recipeNameController.text,
      'time':_timeController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Recipe Uploaded Successfully',
          style: GoogleFonts.roboto(color: Colors.white),
        )));
  }

  _displayDialogPersons(BuildContext context) async {
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select Category'),
            content: Container(
              width: double.minPositive,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categoryList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(categoryList[index].name.toString()),
                    onTap: () {
                      Navigator.of(context).pop(true);

                      _recipeIdController.text = categoryList[index].name;
                      categoryId = categoryList[index].id;
                    },
                  );
                },
              ),
            ),
          );
        });
  }

}










/*
* TextFormField(
                              autovalidateMode: AutovalidateMode.always,
                              controller: _fathersNameController,
                              textInputAction: TextInputAction.next,
                              validator: MultiValidator(
                                  [RequiredValidator(errorText: 'required *')]),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Theme.of(context).primaryColor,
                                ),
                                border: OutlineInputBorder(),
                                labelText: 'Enter Father\'s Name',
                                labelStyle: GoogleFonts.roboto(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[600]),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                              ),
                            ),
*
* */