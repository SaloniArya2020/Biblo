import 'dart:convert';

import 'package:biblo/UI_elements/colors.dart';
import 'package:biblo/UI_elements/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SingleBookScreen extends StatefulWidget {
  final String url;
  SingleBookScreen({required this.url});

  @override
  State<SingleBookScreen> createState() => _SingleBookScreenState();
}

class _SingleBookScreenState extends State<SingleBookScreen> {
  String _bookTitle = '';
  String _bookAuthors = '';
  String _bookDescription = '';
  String _bookPages = '';
  String _bookRating = '';
  String _bookReview = '';
  String _bookImgUrl = '';
  String _bookPreviewLink = '';

  getData() async {
    try {
      final res = await http.get(Uri.parse(widget.url));

      final body = jsonDecode(res.body);

      setState(() {
        _bookTitle = body["volumeInfo"]["title"] == null
            ? '-'
            : body["volumeInfo"]["title"];

        _bookAuthors = body["volumeInfo"]["authors"][0] == null
            ? ''
            : body["volumeInfo"]["authors"][0];

        _bookDescription = body["volumeInfo"]["description"] == null
            ? ''
            : body["volumeInfo"]["description"];

        _bookPages = body["volumeInfo"]["pageCount"].toString() == 'null'
            ? '-'
            : body["volumeInfo"]["pageCount"].toString();

        _bookRating = body["volumeInfo"]["averageRating"].toString() == 'null'
            ? '-'
            : body["volumeInfo"]["averageRating"].toString();

        _bookReview = body["volumeInfo"]["ratingsCount"].toString() == 'null'
            ? '-'
            : body["volumeInfo"]["ratingsCount"].toString();

        /// if book image is null than show a image
        body["volumeInfo"]["imageLinks"] == null
            ? _bookImgUrl =
                'https://images.unsplash.com/photo-1546521343-4eb2c01aa44b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8Ym9va3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60'
            : _bookImgUrl =
                body["volumeInfo"]["imageLinks"]["thumbnail"] == null
                    ? ''
                    : body["volumeInfo"]["imageLinks"]["thumbnail"];

        _bookPreviewLink = body["volumeInfo"]["previewLink"] == null
            ? ''
            : body["volumeInfo"]["previewLink"];
      });
    } catch (e) {
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: primaryAccentColor,
            child: Column(
              children: [
                /// if book image url is empty string than show progress indicator else show Image
                _bookImgUrl == ''
                    ? CircularProgressIndicator()

                    /// Image Container
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        decoration: BoxDecoration(
                            image: DecorationImage(

                                /// book image
                                image: NetworkImage(_bookImgUrl),
                                fit: BoxFit.contain),
                            borderRadius: BorderRadius.circular(20)),
                      ),

                /// Book title and author name
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Text16Medium(
                        text: _bookTitle,
                        color: primaryTextColor,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(_bookAuthors)
                    ],
                  ),
                ),

                /// Row for rating, review and pages
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// rating text
                          Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.amber, size: 15,),
                                  Text16Bold(
                                      text: _bookRating, color: primaryTextColor),
                                ],
                              ),
                              Text16Medium(text: 'Rating', color: primaryTextColor),
                            ],
                          ),

                          ///pages test
                          Column(
                            children: [
                              Text16Bold(text: _bookPages, color: primaryTextColor),
                              Text16Medium(text: 'Pages', color: primaryTextColor),
                            ],
                          ),


                          /// review text
                          Column(
                            children: [
                              Text16Bold(
                                  text: _bookReview, color: primaryTextColor),
                              Text16Medium(
                                  text: 'Reviews', color: primaryTextColor),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 30,
                      ),

                      Container(
                        alignment: Alignment.topLeft,
                        child: Text18Medium(
                          text: 'About',
                          color: primaryTextColor,
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      ///Book description
                      Container(child: Html(data: _bookDescription,)),

                      SizedBox(
                        height: 20,
                      ),

                      Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'For preview visit',
                          )),

                      SizedBox(
                        height: 5,
                      ),

                      GestureDetector(
                        onTap: () {
                          launchUrl(Uri.parse(_bookPreviewLink), mode: LaunchMode.externalApplication,);
                        },
                        child: Text(
                          _bookPreviewLink,
                          style: TextStyle(
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
