import 'package:admin_pannel/FireBaseServices/CollectionVariable.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;

class SchooldetailsModels {
    final  String schoolName;
  final  String chatbotApi;
  final  String studentPassKey;
  final  String teacherPassKey;
  final  String higherOfficialPassKey;
  final  String staffPassKey;
    const SchooldetailsModels({
    required this. schoolName,
  required this. chatbotApi,
  required this. studentPassKey,
  required this. teacherPassKey,
  required this. higherOfficialPassKey,
  required this. staffPassKey,
  });
  SchooldetailsModels.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot)
      : 
        schoolName = snapshot.data()?["schoolName"]?? "",
        chatbotApi = snapshot.data()?["chatBotApi"]?? "",
        studentPassKey = snapshot.data()?[studentPasskeyField]?? "",
        teacherPassKey = snapshot.data()?[teacherPasskeyField]?? "",
        higherOfficialPassKey = snapshot.data()?[principalPasskeyField]?? "",
        staffPassKey = snapshot.data()?[staffPassKeyField]?? "";
}