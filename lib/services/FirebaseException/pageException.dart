
abstract class AppException implements Exception {
  final String message;
  AppException(this.message);
}


class ServerException extends AppException {
  ServerException([super.message = "Error in the server"]);
}

class PushNotificationException extends AppException {
  PushNotificationException([super.message = "Error in push notification"]);
}
class CloudDataReadException extends AppException {
  CloudDataReadException([super.message = " Fetching error, please try again later !"]);
}

class CloudDataWriteException extends AppException {
  CloudDataWriteException([super.message = "Error in creating the data, please try again later !"]);
}



class CloudDataUpdateException extends AppException {
  CloudDataUpdateException([super.message = "Error in updating the data, please try again later !"]);
}

class CloudDataDeleteException extends AppException {
  CloudDataDeleteException([super.message = "Error in deleting the data, please try agian later !"]);
}
