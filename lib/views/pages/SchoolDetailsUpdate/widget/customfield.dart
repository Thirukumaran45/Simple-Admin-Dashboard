
import 'package:admin_pannel/contant/CustomNavigation.dart';
import 'package:admin_pannel/views/widget/CustomeButton.dart';
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:flutter/material.dart';

class Customfield extends StatefulWidget {
 final  List<String> schoolPhotos ;
  const Customfield({super.key, required this.schoolPhotos});

  @override
  State<Customfield> createState() => _CustomfieldState();
}

class _CustomfieldState extends State<Customfield> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
              margin:const  EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: primaryRedShadeColrs,
                borderRadius: BorderRadius.circular(30),
                boxShadow:const  [
                  BoxShadow(
                    offset: Offset(4, 4),
                    blurRadius: 5,
                    color: Colors.black
                  )
                ]
              ),
            ),
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
              padding: const EdgeInsets.all(8.0),

                decoration: 
                BoxDecoration(
                color: Colors.white,
              borderRadius: BorderRadius.circular(20),
                  boxShadow:const  [

                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10,
                    )
                  ]
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount:widget. schoolPhotos.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: InkWell(
                            onTap: (){
                              customNvigation(context, '/school-details-updation/viewPhoto?assetLink=${widget.schoolPhotos[index]}');
                              
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: AssetImage(widget. schoolPhotos[index]),
                                  fit: BoxFit.cover,
                                ),
                               boxShadow:const  [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(2, 2)
                                )
                               ]
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: customIconTextButton(Colors.red, onPressed: () {
                            setState(() =>widget. schoolPhotos.removeAt(index));
                          }, icon: Icons.delete, text: "Delete", )
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
      ],
    );
  }
}