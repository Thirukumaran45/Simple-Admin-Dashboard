import 'package:admin_pannel/contant/CustomNavigation.dart';
import 'package:admin_pannel/controller/classControllers/pageControllers/FessController.dart';
import 'package:admin_pannel/views/widget/CustomDialogBox.dart';
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show  Get, Inst;

class BankAccountDetails extends StatefulWidget {
  const BankAccountDetails({super.key});

  @override
  State<BankAccountDetails> createState() => _BankAccountDetailsState();
}

class _BankAccountDetailsState extends State<BankAccountDetails> {
   List<Map<String, String>> bankDetails = [];

  late List<TextEditingController> bankControllers;
  late List<TextEditingController> apiControllers;
  late List<bool> obscureTextList;
  late FeesController controller;
  bool isChanged = false;

@override
void initState() {
  super.initState();
  controller = Get.find();
  loadAllBankData();
}


void loadAllBankData() async {
  final list = await controller.fetchAllBankDetails();
  setState(() {
    isChanged = false;
    bankDetails = list;

    // Initialize controllers after getting bank details
    bankControllers = bankDetails.map((e) => TextEditingController(text: e['bankName'])).toList();
    apiControllers = bankDetails.map((e) => TextEditingController(text: e['apiKey'])).toList();
    obscureTextList = List.generate(bankDetails.length, (index) => true);

    // Add listeners after initialization
    for (var controller in [...bankControllers, ...apiControllers]) {
      controller.addListener(() => checkIfChanged());
    }
  });

}



  void checkIfChanged() {
    for (int i = 0; i < 5; i++) {
      if (bankControllers[i].text != bankDetails[i]['bankName'] ||
          apiControllers[i].text != bankDetails[i]['apiKey']) {
        setState(() => isChanged = true);
        return;
      }
    }
    setState(() => isChanged = false);
  }

  void toggleObscureText(int index) {
    setState(() => obscureTextList[index] = !obscureTextList[index]);
  }

  void saveChanges()async {
    
    await controller.addAndUpdateBankDetailsToFirestore(
      apiControllers: apiControllers,
      bankControllers: bankControllers,
    );
    setState(() => isChanged = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: bankDetails.isEmpty
        ? const Center(child: CircularProgressIndicator(color: Colors.green,)) // Loading state
        : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [customIconNavigation(context, '/fees-updation'),
            const  Text("Bank Details and Class Eligibility Link for Fees Payment",  style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          ),),
                           // Save Button (Visible only if changes occur)
            
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: ()async{
                    isChanged? await showCustomDialog(context, "Bank Transaction details Updated Succecfully"):null;
                    saveChanges();
                  },
                 style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: isChanged?Colors.blue:Colors.grey,
                                   // Button background color
                              elevation: 10, // Elevation for shadow effect
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12), // Button padding
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(20), // Rounded corners
                              ),
                            ),
                  child: const Padding(
                    padding:  EdgeInsets.symmetric(vertical:  8.0),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.upload_sharp , color: Colors.white,size: 20,),
                         SizedBox(width: 5,),
                         Text("Save", style: TextStyle(color: Colors.white, fontSize: 17,)),
                      ],
                    ),
                  ),
                ),
              ),
              ],
            ),
            const SizedBox(height: 20),

            Column(
              children: List.generate(5, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    children: [
                      // Eligible Class Label (Before Bank Field)
                      SizedBox(
                        width: 100,
                        child: Text(
                          bankDetails[index]['classRange']!,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Bank Name Field
                      Expanded(
                        child: TextField(
                          style:const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                          ),
                          controller: bankControllers[index],
                          decoration:  InputDecoration(
                  labelText: "Bank Name",
                  labelStyle:const TextStyle(color: Colors.black) ,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: primaryGreenColors),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreenColors),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreenColors),
                  ),
                ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // API Key Field with Eye Icon
                      Expanded(
                        child: TextField(
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                          ),
                          controller: apiControllers[index],
                          obscureText: obscureTextList[index],
                          decoration: InputDecoration(
                             labelStyle:const TextStyle(color: Colors.black) ,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: primaryGreenColors),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreenColors),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreenColors),
                  ),
                   
                            labelText: "API Key",
                            suffixIcon: IconButton(
                              icon: Icon(obscureTextList[index]
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                                  color: obscureTextList[index]?Colors.black:Colors.blue,
                                  ),
                              onPressed: () => toggleObscureText(index),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
           

           
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in [...bankControllers, ...apiControllers]) {
      controller.dispose();
    }
    super.dispose();
  }
}
