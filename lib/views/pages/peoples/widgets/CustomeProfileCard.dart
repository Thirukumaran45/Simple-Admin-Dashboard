import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;


Widget customProfileCard(bool needSpace, {required String title ,required String assetLink,required VoidCallback onpresee}) {
  return InkWell(
    onTap: onpresee ,
    child: Container(
      height: 380,
      width: 300,
      // padding:const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const  [
          BoxShadow(
            offset: Offset(4, 4),
            blurRadius: 10,
            color: Colors.grey
          )
        ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
                 Container(
  height: 300,
  width: 300,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.white, width: 2),
  ),
  child: SvgPicture.asset(
    assetLink,
    fit: needSpace ? BoxFit.contain : BoxFit.cover,
  ),
),

           
                
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                
                Text(
                overflow: TextOverflow.clip,
                  title,
                  style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),
                ),
            const    Icon(Icons.arrow_forward,size: 27,color: Colors.black,)
              ],
            ),
          ),

          
        ],
      ),
    ),
  );
}
