import 'dart:async' show Timer;
import 'dart:convert' show jsonDecode, jsonEncode;
import 'package:admin_pannel/utils/AppException.dart' show CloudDataWriteException, PushNotificationException;
import 'package:flutter/services.dart' show rootBundle;
import '../../../services/FireBaseServices/CollectionVariable.dart';
import '../../../contant/ConstantVariable.dart' show feesStatusField, fcmTokenId;
import 'package:get/get.dart' show BoolExtension, Get, GetxController, Inst, RxT;
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' show clientViaServiceAccount, ServiceAccountCredentials;

class PushNotificationControlelr extends GetxController{

var isCooldown = false.obs;
var remainingTime = const Duration(minutes: 5).obs;
Timer? _timer;
late FirebaseCollectionVariable collectionVariable ;
late Map<String, dynamic> config;
@override
  void onInit() {
    super.onInit();
     initApiKey();
    collectionVariable = Get.find<FirebaseCollectionVariable>();
  }


  void initApiKey()async{
     final configString = await rootBundle.loadString('assets/config.json');
     config = jsonDecode(configString);
  }

  void startCooldown(dynamic context) {
    try {
  if (isCooldown.value) return; // prevent restarting if already on cooldown
  
  isCooldown.value = true;
  remainingTime.value = const Duration(minutes: 5);
  
  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (remainingTime.value.inSeconds <= 1) {
      timer.cancel();
      isCooldown.value = false;
    } else {
      remainingTime.value -= const Duration(seconds: 1);
    }
  });
}  catch (e) {
   throw CloudDataWriteException("Error in starting the timer, please try again later !");
}
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }





  Future<String> getServerKeyToekn(dynamic context)async{
   try {
 final serviceAccountJson = {
  "type":config['TYPE'],
  "project_id":config['PROJECT_ID'],
  "private_key_id":config['PRIVATE_KEY_ID'],
  "private_key":config['PRIVATE_KEY'],
  "client_email":config['CLIENT_EMAIL'],
  "client_id":config['CLIENT_ID'],
  "auth_uri":config['AUTH_URI'],
  "token_uri":config['TOKEN_URI'],
  "auth_provider_x509_cert_url":config['AUTH_PROVIDER_CERT_URL'],
  "client_x509_cert_url":config['CLIENT_CERT_URL'],
  "universe_domain":config['UNIVERSE_DOMAIN'],
};
   
  final List<String> scopes = [
    config['GOOGLE_USER_INFO']!,
    config['FIREBASE_DATABASE']!,
    config['FIREBASE_MESSAGING']!
   ]; 
  
   final client = await clientViaServiceAccount(ServiceAccountCredentials.fromJson(serviceAccountJson) , scopes);
   final accessServerKey = client.credentials.accessToken.data;
   return accessServerKey;
}  catch (e) {
  throw PushNotificationException(" Erron in getting server key, please try again later !");
}
  }



Future<bool> pushNotifications(dynamic context,{
  required String title,
  required body,
  required token,
}) async {
  try {
Map<String, dynamic> payload = {
  "message": {
    "token": token,
    "notification": {
      "title": title,
      "body": body,
    },
    "android": {
      "priority": "HIGH",
      "notification": {
        "sound": "default", // This triggers the default notification sound
        "channel_id": "high_importance_channel", // This must match your app's NotificationChannel ID
      },
    },
  }
};


    final String serverKey = await getServerKeyToekn(context);
     String baseUrl = config['BASE_URL'] ?? '';

    String dataNotifications = jsonEncode(payload);

    var response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverKey'
      },
      body: dataNotifications,
    );


    return response.statusCode == 200;
  } catch (e) {
    throw PushNotificationException(' Error in push notification , please try again later !');
  }
}

Future<void> feeUpdationPushNotificationToAll(dynamic context) async {
  try {
  final docs = await collectionVariable.studentLoginCollection.get();
  
  for (var doc in docs.docs) {
    final data = doc.data() as Map<String,dynamic>;
  
    if (data[feesStatusField] == 'Pending') {
      final token = data[fcmTokenId]; // assuming each student doc has a token field
  
      if (token != null && token.isNotEmpty) {
        if(!context.mounted)return;
        await pushNotifications(context,
          title: 'School Fees Updated',
          body: 'Hurry up! please pay your pending school fees',
          token: token,
        );
      }
    }
  }
}  catch (e) {
    throw PushNotificationException(' Error in fees push notification to all, please try again later !');
  
}
}

Future<void> feeUpdationPushNotificationToSpecific(dynamic context,{required String id}) async {
  try {
  final docs = await collectionVariable.studentLoginCollection.doc(id).get();
  
    final data = docs.data() as Map<String,dynamic>;
  
      final token = data[fcmTokenId]; // assuming each student doc has a token field
  
      if (token != null && token.isNotEmpty) {
        if(!context.mounted)return;
        await pushNotifications(context,
          title: 'School Fees Updated',
          body: 'Hurry up ! please pay your pending school fees',
          token: token,
        );
      }
}  catch (e) {
      throw PushNotificationException(' Error in fees push notification to student, please try again later !');

}
}

Future<void> examFeesUpdationPushNotification(dynamic context,{required String id}) async {
    try {
  final docs = await collectionVariable.studentLoginCollection.doc(id).get();
  
  final data = docs.data() as Map<String,dynamic>;
  
    final token = data[fcmTokenId]; // assuming each student doc has a token field
  
    if (token != null && token.isNotEmpty) {
      if(!context.mounted)return;
      await pushNotifications(context,
        title: 'Exam Result Published',
        body: 'Congrates ! Your Hard Work Has Paid Off Check Your Results',
        token: token,
      );
    } 
}  catch (e) {
      throw PushNotificationException(' Error in exam update push notification to student, please try again later !');
  
}
   
}
}