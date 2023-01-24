import 'package:flutter/material.dart';

import '../UI_elements/colors.dart';

class GridViewTileWidget extends StatelessWidget {
  final String imgUrl;
  GridViewTileWidget({required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.fill,
            image:  NetworkImage(imgUrl)
        ),
        color: primaryAccentColor,
        borderRadius: BorderRadius.circular(15),
      ),

    );
  }
}
