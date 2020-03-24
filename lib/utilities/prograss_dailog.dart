import 'package:flutter/cupertino.dart';
import 'package:progress_dialog/progress_dialog.dart';

class PrograssDailog{

 
  static void showprogressDaolog(BuildContext context){
    ProgressDialog pr;
  
    pr = new ProgressDialog(context);

     pr.style(message: 'Logging..');
     pr.show();
  }

  // static void dismisprogressDaolog(BuildContext context){
  //   ProgressDialog pr;
  
  //   pr = new ProgressDialog(context);

  //    pr.style(message: 'Logging');
  //    pr.show();
  // }
  
 


}