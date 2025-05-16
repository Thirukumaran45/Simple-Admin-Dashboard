import 'dart:convert' show jsonEncode;
import 'dart:developer' show log;
import '../../../FireBaseServices/CollectionVariable.dart';
import '../../../contant/ConstantVariable.dart' show feesStatusField, fcmTokenId;
import 'package:get/get.dart' show GetxController, Get,Inst;
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' show clientViaServiceAccount, ServiceAccountCredentials;

class PushNotificationControlelr extends GetxController{

final FirebaseCollectionVariable collectionVariable = Get.find();

  static const String baseUrlKey = "https://fcm.googleapis.com/v1/projects/school-5b7f0/messages:send";


  Future<String> getServerKeyToekn()async{
   try {
  final serviceAccountJson = {
    "type": "service_account",
    "project_id": "school-5b7f0",
    "private_key_id": "de4d2e572f196d11e5af4a80df87aa4b4c514c1c",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCOZyacFlJQycIP\ndIq6RzV1SsyusLH0umCP+4b5EBD2lgTx39GmutL70rrLMjkjr4mqIbAUofjWCInF\n/QPYIwdeBPCsfgMDPrfj6tXXOJKqycGuUOAkuYnuk8G9P/vqp95pEJMdbWOo2VrM\n/dt/TnYuQWGqJqsIJ9MoMhc0WrtU+ASXX62IrhvmuCIGd1h37dnpa8DthJq/iPEH\nsP+upDVnU6LKvBxmdONNNjrG8TBrKmsiTB9TBKloepK2e5AG0Fx9c+JaaxYoe1Wn\nKweDVXsxvczs4EHDFxqr4uTyP2rKR7WK6L3+rmezqN2fj6WeYpSawbHVTydhbWgX\nkzaA0xevAgMBAAECggEAOBTjncEktfBfXtrU77uvj/vfVET+MJVeBhZW96ueIp6+\nX8t3s6QMB2Tcb73dxvIQ01HlGJsZdqFyMOkOJIbXFe34ItaVtSd0IGyRvurmyCAh\nCNeNDqmLaswCFtgmDCoEa3g9l+9Gum6vVd/8G8z4ugrBvdLwtIuKm1/ux42cDT/x\nmsnXrUKjyyubdAO6DKVWs37IsOi6jTNy2uGAs1SL/wzLQbTK2HvKEslXtkGWgQKJ\n/aoqdN8m7o+un+2aHmiVMMIS6A+crDJEi10xVAo7GUmp8mXL9w5cl4zAryEkjNO5\n/atVKZ1O6g4gwxvwaAd7+SH/OyPGTbN99UvRBMdZIQKBgQC/3CF4rj6S4qjfTe0a\nhGJg6fyIZOOulZsnAC2/qPnrQ2dLDWH1+bvCW3bMwwYDZe1+NeFhKlpzwcYw4OKX\n9CvrIkrGIxY8jBmbQAfTHMKBOU5hwM7x1vyQBaJepmCclcc2U4pSeo3Zfwx2xyLm\nsjjRnMsIJ3hGI8d3R5CN7ar8RwKBgQC+Al13I3Qbb8gtcHCNVh9OdVoxBLdsX24T\nhe6dEg0V/fyL91sYyKmhWGRAsO0sALl+Xk0azvbxLP8yU/VuGr+0BA/6zw/E9lCK\nrZUQUwTZ1r51OqF3T4ZcVIx/wFEcbHrf9/nB5eaBoo8A4692nbAemC3EY3qzmbcL\nNUgqSOwFWQKBgC82/QW127BKF0Tc6HyeF5fB/WOTcHSGXKg8YwXHj7lV3RWbNYBS\n9OHfoFzDobc0Xj2xBMXkpl3WUe+1aA39CNHUnpIkEFTWJXcPSt2pNjSW5bMov8TE\nI2NN/6dLSns+YMf9xwyFHGNp4KdaWjxrn4/2BgD7tZ2NMIkqE2jaFDoBAoGAdRQD\n/2srGdTQ5Z7I223bsH6C6n1bgD11GDaIhuQeiBSOTrhFu4m5bB+I9ouOOHTh10nH\n/OLWKlltjddJ/WQiB4wRRJvdvaGAk1LN7NcawBegF5/e6iNoSPAX+ofH8tmtBOBJ\nVv6QAAToVMX20gHsCY3/dWlOq+flb9SO+O8h71ECgYACpC0mjgCIdZCQUxk+f/9y\nMt8ynAnfDWU+0DbjgiJtYvuhHVnK2tGvVhbCv0QjOmxtayKKiI3/9B3r1pgNV8F/\nZIrCgQAS85+i8BO/i6nMznm3mdUx16/u027u1ob3vPhylqlgJb7ucspVHwcSu90n\npf5eSAPJuRqKWE0RhdxUWA==\n-----END PRIVATE KEY-----\n",
    "client_email": "firebase-adminsdk-672xw@school-5b7f0.iam.gserviceaccount.com",
    "client_id": "100107440736848407216",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-672xw%40school-5b7f0.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  };
   
  final List<String> scopes = [
     "https://www.googleapis.com/auth/userinfo.email",
     "https://www.googleapis.com/auth/firebase.database",
     "https://www.googleapis.com/auth/firebase.messaging"
   ]; 
  
   final client = await clientViaServiceAccount(ServiceAccountCredentials.fromJson(serviceAccountJson) , scopes);
   final accessServerKey = client.credentials.accessToken.data;
   return accessServerKey;
}  catch (e) {
  log('error in getting acces toekn $e');
}
return '';
  }



Future<bool> pushNotifications({
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
        },
      }
    };

    final String serverKey = await getServerKeyToekn();
    const String baseUrl = baseUrlKey;

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
    log("error in pushing notification $e");
    return false;
  }
}

Future<void> feeUpdationPushNotificationToAll() async {
  final docs = await collectionVariable.studentLoginCollection.get();

  for (var doc in docs.docs) {
    final data = doc.data() as Map<String,dynamic>;

    if (data[feesStatusField] == 'Pending') {
      final token = data[fcmTokenId]; // assuming each student doc has a token field

      if (token != null && token.isNotEmpty) {
        await pushNotifications(
          title: 'School Fees Updated',
          body: 'Hurry up! please pay you pending fees',
          token: token,
        );
      }
    }
  }
}

Future<void> feeUpdationPushNotificationToSpecific({required String id}) async {
  final docs = await collectionVariable.studentLoginCollection.doc(id).get();

    final data = docs.data() as Map<String,dynamic>;

      final token = data[fcmTokenId]; // assuming each student doc has a token field

      if (token != null && token.isNotEmpty) {
        await pushNotifications(
          title: 'School Fees Updated',
          body: 'Hurry up ! please pay you pending fees',
          token: token,
        );
      }
}

Future<void> examFeesUpdationPushNotification({required String id}) async {
    final docs = await collectionVariable.studentLoginCollection.doc(id).get();

    final data = docs.data() as Map<String,dynamic>;

      final token = data[fcmTokenId]; // assuming each student doc has a token field

      if (token != null && token.isNotEmpty) {
        await pushNotifications(
          title: 'Exam Result Published',
          body: 'Congrates ! Your Hard Work Has Paid Off Check Your Results',
          token: token,
        );
      }
   
}
}
