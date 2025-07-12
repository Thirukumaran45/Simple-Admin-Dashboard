import 'dart:async' show Timer;
import 'dart:convert' show jsonEncode;
import 'dart:developer' show log;
import 'package:admin_pannel/utils/AppException.dart' show CloudDataWriteException, PushNotificationException;

import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
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
@override
  void onInit() {
    super.onInit();
    collectionVariable = Get.find<FirebaseCollectionVariable>();
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



  static String baseUrlKey = dotenv.env['BASE_URL'] ?? '';


  Future<String> getServerKeyToekn(dynamic context)async{
   try {
 final serviceAccountJson = {
  "type": dotenv.env['TYPE'],
  "project_id": dotenv.env['PROJECT_ID'],
  "private_key_id": dotenv.env['PRIVATE_KEY_ID'],
  "private_key": dotenv.env['PRIVATE_KEY'],
  "client_email": dotenv.env['CLIENT_EMAIL'],
  "client_id": dotenv.env['CLIENT_ID'],
  "auth_uri": dotenv.env['AUTH_URI'],
  "token_uri": dotenv.env['TOKEN_URI'],
  "auth_provider_x509_cert_url": dotenv.env['AUTH_PROVIDER_CERT_URL'],
  "client_x509_cert_url": dotenv.env['CLIENT_CERT_URL'],
  "universe_domain": dotenv.env['UNIVERSE_DOMAIN'],
};
   
  final List<String> scopes = [
     dotenv.env['GOOGLE_USER_INFO']!,
     dotenv.env['FIRBASE_DATABASE']!,
     dotenv.env['FIREBASE_MESSAGING']!
   ]; 
  
   final client = await clientViaServiceAccount(ServiceAccountCredentials.fromJson(serviceAccountJson) , scopes);
   final accessServerKey = client.credentials.accessToken.data;
   return accessServerKey;
}  catch (e) {
  throw PushNotificationException("Erron in getting server key, please try again later !");
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
    String baseUrl = baseUrlKey;

    String dataNotifications = jsonEncode(payload);

    var response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverKey'
      },
      body: dataNotifications,
    );

    log("Response status: ${response.statusCode}");
    log("Response body: ${response.body}");

    return response.statusCode == 200;
  } catch (e) {
    throw PushNotificationException('Error in push notification , please try again later !');
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
    throw PushNotificationException('Error in fees push notification to all, please try again later !');
  
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
      throw PushNotificationException('Error in fees push notification to student, please try again later !');

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
      throw PushNotificationException('Error in exam update push notification to student, please try again later !');
  
}
   
}
}
