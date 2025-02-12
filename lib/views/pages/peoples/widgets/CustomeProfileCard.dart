import 'package:flutter/material.dart';


Widget customProfileCard({required String title , required Color color, required String assetLink,required VoidCallback onpresee}) {
  return InkWell(
    onTap: onpresee ,
    child: Container(
      height: 300,
      width: 250,
      // padding:const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:color,
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
                   CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage(assetLink),
                ),
              const   SizedBox(
                  height: 20,
                )
                ,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),
              ),
          const    Icon(Icons.arrow_forward,size: 27,color: Colors.black,)
            ],
          ),
        ],
      ),
    ),
  );
}
