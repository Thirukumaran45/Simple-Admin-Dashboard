import 'package:admin_pannel/provider/CustomNavigation.dart';
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:flutter/material.dart';

class BankAccountDetails extends StatefulWidget {
  const BankAccountDetails({super.key});

  @override
  State<BankAccountDetails> createState() => _BankAccountDetailsState();
}

class _BankAccountDetailsState extends State<BankAccountDetails> {
  final List<Map<String, String>> bankDetails = [
    {'bankName': 'Bank A', 'apiKey': '12345ABCDE', 'classRange': 'Class 1 to 3'},
    {'bankName': 'Bank B', 'apiKey': '67890FGHIJ', 'classRange': 'Class 4 to 6'},
    {'bankName': 'Bank C', 'apiKey': '13579KLMNO', 'classRange': 'Class 7 to 8'},
    {'bankName': 'Bank D', 'apiKey': '24680PQRST', 'classRange': 'Class 9 to 10'},
    {'bankName': 'Bank E', 'apiKey': '11223UVWXY', 'classRange': 'Class 11 to 12'},
  ];

  late List<TextEditingController> bankControllers;
  late List<TextEditingController> apiControllers;
  late List<bool> obscureTextList;
  bool isChanged = false;

  @override
  void initState() {
    super.initState();
    bankControllers = bankDetails.map((e) => TextEditingController(text: e['bankName'])).toList();
    apiControllers = bankDetails.map((e) => TextEditingController(text: e['apiKey'])).toList();
    obscureTextList = List.generate(bankDetails.length, (index) => true);

    for (var controller in [...bankControllers, ...apiControllers]) {
      controller.addListener(() => checkIfChanged());
    }
  }

  void checkIfChanged() {
    for (int i = 0; i < bankDetails.length; i++) {
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

  void saveChanges() {
    for (int i = 0; i < bankDetails.length; i++) {
      print("Bank: ${bankControllers[i].text}, API Key: ${apiControllers[i].text}");
    }
    setState(() => isChanged = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
                  onPressed: isChanged ?saveChanges:(){},
                  style: ElevatedButton.styleFrom(
                    
                    foregroundColor: Colors.white,
                    backgroundColor:isChanged? Colors.blue :Colors.grey,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(Icons.upload_sharp , color: Colors.white,size: 20,),
                      ),
                       Text("Save", style: TextStyle(color: Colors.white, fontSize: 17,)),
                    ],
                  ),
                ),
              ),
              ],
            ),
            const SizedBox(height: 20),

            Column(
              children: List.generate(bankDetails.length, (index) {
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
