import 'package:flutter/material.dart';
import 'package:six_cash/data/model/response/contact_model.dart';
import 'package:six_cash/util/color_resources.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/styles.dart';

class PreviewContactTile extends StatelessWidget {
  final ContactModel contactModel;
  const PreviewContactTile({Key key, @required this.contactModel,}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    String phoneNumber = contactModel.phoneNumber;
    if(phoneNumber.contains('-')) {
      phoneNumber.replaceAll('-', '');
    }


    return ListTile(
        title:  Text(contactModel.name==null?phoneNumber: contactModel.name, style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
        subtitle:phoneNumber.length<=0? SizedBox():
          Text(phoneNumber, style: rubikLight.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: ColorResources.getGreyBaseGray1()),),
      );
  }
}



