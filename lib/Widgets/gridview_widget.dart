import 'package:biblo/Screens/single_book_screen.dart';
import 'package:biblo/Widgets/gridviewTile_widget.dart';
import 'package:flutter/material.dart';
import '../UI_elements/colors.dart';

class GridViewWidget extends StatefulWidget {
  final List<dynamic> booksList;
  GridViewWidget({required this.booksList});

  @override
  State<GridViewWidget> createState() => _GridViewWidgetState();
}

class _GridViewWidgetState extends State<GridViewWidget> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        itemCount: widget.booksList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.65,
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: ((context, index) {
          return GestureDetector(
              onTap: () {
                ///passing the self link to singleBookScreen
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SingleBookScreen(
                              url: widget.booksList[index]['selfLink'],
                            )));
              },
              /// if book img is null than just show the name else show gridViewTileWidget
              child: widget.booksList[index]['volumeInfo']['imageLinks'] == null
                  ? Container(
                      decoration: BoxDecoration(
                          color: primaryAccentColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                          child: Text(
                              widget.booksList[index]['volumeInfo']["title"])),
                    )
                  : GridViewTileWidget(
                      imgUrl: widget.booksList[index]['volumeInfo']
                          ['imageLinks']['thumbnail'],
                    ));
        }));
  }
}
