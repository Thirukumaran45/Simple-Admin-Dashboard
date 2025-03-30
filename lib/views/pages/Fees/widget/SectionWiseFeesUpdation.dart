import 'package:admin_pannel/contant/CustomNavigation.dart';
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:flutter/material.dart';

class SectionWiseFeesUpdation extends StatelessWidget {
  const SectionWiseFeesUpdation({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [customIconNavigation(context, '/fees-updation'),
              
              ],
            ), 
            Column(
              children: List.generate(12, (index) => classRow(index + 1,context)),
            )
          ],
        ),
      ),
    );
  }

  Widget numberOfPaidUnpaidRow(String text, String values)
  {
    return Container(
      margin:const  EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
            Text('Fee $text Student', style:const TextStyle(
              fontSize: 16,
                      color: Colors.black
                    ),), 
                     const Icon(Icons.arrow_forward),

                    Text(values, style: TextStyle(
                      fontSize: 20,
                      color: text=='Paid'? primaryGreenColors:Colors.red
                    ),),
                    
        ],
      ),
    );
  }

  Widget classRow(int index , BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:  8.0,vertical: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow:const [
          BoxShadow(
            blurRadius: 5,
            color:Colors.grey
          )
        ]
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  const  Text(
                      "Update Student Fees - ",
                      style:  TextStyle(
                        letterSpacing: 1,

                          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    Text(
                      "Class $index",
                      style: const TextStyle(
                        letterSpacing: 1,
                          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),

                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              children: List.generate(4, (i) => classSectionExpanded(i,context,index.toString())),
            ),
            const SizedBox(height: 35),
           
          ],
        ),
      ),
    );
  }

  Widget classSectionExpanded(int index, BuildContext context,String stuClass) {
    List<String> sections = ["A", "B", "C", "D"];

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:  18),
        child: InkWell(
          onTap: (){
            customNvigation(context, '/fees-updation/sectionWiseFeesUpdation/studentFeesList?classNumber=$stuClass&sectionName=${sections[index]}');
          },
          child: Container(
             decoration: 
             BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border:const Border.symmetric(
                vertical: BorderSide(

                color: Colors.blueGrey
                ),
              )
             ),
          height: 200,
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
           numberOfPaidUnpaidRow("Paid",'49'),
           numberOfPaidUnpaidRow("UnPaid",'30'),
          
             Padding(
               padding: const EdgeInsets.all(10),
               child: Container(
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: primaryBlueShadeColrs,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const[
                    BoxShadow(
                      offset: Offset(4, 4),
                      color: Colors.grey
                    )
                  ]
                ),
                child: Text(
                  "Section ${sections[index]}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                           ),
             ),
             ],
          ),
          ),
        ),
      ),
    );
  }
}
