import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

Widget photoButtons({String? title,required IconData icon,required VoidCallback onPressed}){
  return Expanded(
    child: Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: CupertinoColors.systemGrey3,
              blurRadius: 7,
              spreadRadius: 4,
            ),
          ]
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          )
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(icon,color: Colors.black,),
            10.widthBox,
            Text(title!,style: const TextStyle(fontFamily: 'alk',fontSize: 16,color: Colors.black,overflow: TextOverflow.ellipsis),)
          ],
        ),
      ),
    ),
  );
}