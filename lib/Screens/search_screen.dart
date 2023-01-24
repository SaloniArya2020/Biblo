import 'dart:convert';

import 'package:biblo/UI_elements/colors.dart';
import 'package:biblo/Widgets/gridview_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../apiKey.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _key = GlobalKey<FormState>();
  TextEditingController _queryController = TextEditingController();
  List<dynamic> _bookList = [];

  searchSubmit(String query) async{

    if(_key.currentState!.validate()){
      try{

        String apiUrl ='https://www.googleapis.com/books/v1/volumes?q=$query&startIndex=0&maxResults=10&key=$apiKey';

        /// getting res
        final res = await http.get(Uri.parse(apiUrl));

        final body = jsonDecode(res.body);

        setState(() {
          _bookList =body['items'];
        });

        /// clear text field
        _queryController.clear();

        /// dismissing the keyboard
        FocusManager.instance.primaryFocus?.unfocus();

      }catch(e){
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20),
          child: Form(
            key: _key,
            child: Column(
              children: [
                /// text form field for search
                TextFormField(
                  validator: (val)=>val!.isEmpty?'Please fill the field':null,
                  controller: _queryController,
                  decoration: InputDecoration(
                      hintText: 'Search here...',
                      suffixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      )),
                ),

                SizedBox(
                  height: 20,
                ),

                /// button for Search
                GestureDetector(
                  onTap: (){
                    searchSubmit(_queryController.text.trim());
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: primaryColor
                    ),
                    child: Text('Search'),
                  ),
                ),

                Divider(
                  height: 20,
                ),


                /// if book list is empty show empty container
                _bookList ==[]? Container(): Expanded(child: GridViewWidget(booksList: _bookList)),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
