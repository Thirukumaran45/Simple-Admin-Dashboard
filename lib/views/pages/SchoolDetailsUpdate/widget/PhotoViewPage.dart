
import 'package:admin_pannel/provider/CustomNavigation.dart';
import 'package:admin_pannel/views/widget/CustomeButton.dart';
import 'package:flutter/material.dart';

class Photoviewpage extends StatelessWidget {
  final String assetLink;
  const Photoviewpage({super.key, required this.assetLink,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
 backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: double.infinity,
        leading: Row(
          children: [
            IconButton(
              onPressed: () =>customNvigation(context, '/school-details-updation'),
              icon: const Icon(Icons.arrow_back),
            ),
            const Spacer(),
            Row(
              children: [
                customIconTextButton(Colors.red, onPressed: (){}, icon: Icons.delete_rounded, text: "Delete"),
                const SizedBox(width: 40,),
                customIconTextButton(Colors.blue, onPressed: (){}, icon: Icons.add_a_photo_rounded, text: assetLink== ''?"Add":"Update")
              ],
            )
          ],
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(assetLink),
        ),
      ),
    );
  }
}