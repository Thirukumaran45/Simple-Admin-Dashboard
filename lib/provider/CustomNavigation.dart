import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

Widget customIconNavigation(BuildContext context, String uri)
{
  return  IconButton(onPressed: (){
                Beamer.of(context).beamToNamed(uri);

              }, icon: const Icon( Icons.arrow_back, size: 28,color: Colors.black,));
}


void customNvigation(BuildContext context, String uri)
{
   return  Beamer.of(context).beamToNamed(uri); 
}

void customPopNavigation(BuildContext context, String uri)
{
   return  Beamer.of(context).popToNamed(uri); 
}