import 'package:admin_pannel/utils/AppException.dart';
import 'package:admin_pannel/views/widget/CustomDialogBox.dart';
import 'package:flutter/material.dart';

class ExceptionDialog {


Future<T?> handleExceptionDialog<T>(
  BuildContext context,
  Future<T?> Function() action,
)async
{
try{
  return await action();
}
on AppException catch(e)   
{
  await CustomDialogs().showCustomDialog(context,e.message);
}
catch(e){
  await  CustomDialogs().showCustomDialog(context, "An unexpected error occured, please try again later !");
}
return null;
}

  

}
