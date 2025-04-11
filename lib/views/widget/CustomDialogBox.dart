import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:flutter/material.dart';

void showLoadingDialogInSec(BuildContext context, int seconds) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      // Capture the context inside the builder
      Future.delayed(Duration(seconds: seconds), () {
        if(!context.mounted)return;
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      });

      return  const  AlertDialog(
        backgroundColor: Colors.white,
        content: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children:  [
              CircularProgressIndicator(color: Colors.green),
              SizedBox(width: 16),
              Text("On progress, please wait a moment...",style: TextStyle(color: Colors.black,fontSize: 16),),
            ],
          ),
        ),
      );
    },
  );
}


Future<void> showCustomDialog(BuildContext context, String text) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), // Circular Border Radius
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FutureBuilder(
                      future: Future.delayed(const Duration(seconds: 3)), // 3-second delay
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                             return const Row(
                            mainAxisSize: MainAxisSize.min, // Ensures minimal space usage
                            mainAxisAlignment: MainAxisAlignment.center, // Center alignment
                            children: [
                              Text("Please wait a moment... ",
                          style:  TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                              ),
                              SizedBox(width: 8), // Space between text and loader
                              SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(strokeWidth: 2,color: Colors.green,),
                              ),
                            ],
                          );// Show loader instead of text
                        }
                        return Column(
                          children: [
                            Text(
                          text,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                        ) ,const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: primaryGreenColors,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text("Ok"),
                  ),
                          ],
                        );
                      },
                    ),
                  ),
                 
                  const SizedBox(height: 10),
                ],
              ),
              Positioned(
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}


Future<bool> showCustomConfirmDialog({
  required BuildContext context,
  required String text,
}) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), // Circular Border Radius
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FutureBuilder(
                      future: Future.delayed(const Duration(seconds: 3)), // 3-second delay
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const Row(
                            mainAxisSize: MainAxisSize.min, // Ensures minimal space usage
                            mainAxisAlignment: MainAxisAlignment.center, // Center alignment
                            children: [
                              Text(
                                "Please wait a moment... ",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                              ),
                              SizedBox(width: 8), // Space between text and loader
                              SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(strokeWidth: 2,color: Colors.green,),
                              ),
                            ],
                          ); // Show loader instead of text
                        }
                        return SizedBox(
                          width: 300,
                          child: Column(
                            children: [
                              Text(
                                text,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: ()=>Navigator.of(context).pop(false),
                                    child: const Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: primaryGreenColors,
                                    ),
                                    onPressed: ()=>Navigator.of(context).pop(true),
                          
                                    child: const Text("Ok"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              Positioned(
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: ()=>Navigator.of(context).pop(false),

                ),
              ),
            ],
          ),
        ),
      );
    },
  )
.then((value) => value ?? false);
}

