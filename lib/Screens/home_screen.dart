import 'dart:convert';
import 'package:biblo/Data/book_genre_data.dart';
import 'package:biblo/Screens/search_screen.dart';
import 'package:biblo/UI_elements/colors.dart';
import 'package:biblo/UI_elements/text_styles.dart';
import 'package:biblo/Widgets/gridview_widget.dart';
import 'package:biblo/apiKey.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _i = 0;
  String _genre = 'fiction';
  String startIndex = '0';
  String endIndex = '2';
  String bookImg = '';
  List<dynamic> _booksList = [];
  String? _apiUrl;

  getData() async {
    /// google book url for genre type search with max 10 values
    _apiUrl =
        'https://www.googleapis.com/books/v1/volumes?q=subject:$_genre&startIndex=0&maxResults=10&key=$apiKey';

    try{
      final res = await http.get(Uri.parse(_apiUrl!));

      final body = jsonDecode(res.body);

      setState(() {
        _booksList = body["items"];
      });
    }catch(e){
      print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          ///this will navigate to search screen
          Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
        },
        child: Icon(Icons.search),
      ),


      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.book,
              color: primaryColor,
            ),
            Text16Medium(text: 'Bibliophile', color: primaryColor),
          ],
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: [
              /// List View builder for Book genre
              Container(
                height: 30,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: bookGenreList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _i = index;
                          _genre = bookGenreList[index];
                        });
                        getData();
                      },
                      child: Container(
                        padding: EdgeInsets.only(right: 15),
                        child: (index == _i)
                            ? Text18Medium(
                                text: bookGenreList[index],
                                color: primaryTextColor)
                            : Text16Medium(
                                text: bookGenreList[index], color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(
                height: 10,
              ),

              /// GridView to show imgUrl
              Expanded(
                child: GridViewWidget(booksList: _booksList,),
              )
            ],
          ),
        ),
      ),
    );
  }
}
