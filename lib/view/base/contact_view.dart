import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:six_cash/controller/transaction_controller.dart';
import 'package:six_cash/util/color_resources.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';
import 'package:six_cash/util/styles.dart';
import 'package:six_cash/view/base/contact_shimmer.dart';
import 'package:six_cash/view/screens/transaction_money/widget/contact_tile.dart';

import 'custom_ink_well.dart';

class ContactView extends StatelessWidget{
  final String transactionType;
  ContactView({ Key key, this.transactionType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransactionMoneyController>(builder: (contactController) {
      if(contactController.getContactPermissionStatus) {
        return SliverToBoxAdapter(
          child: Column( children: [
            InkWell(
              onTap: () async => await contactController.fetchContact(),
              child: Lottie.asset(
                  Images.contact_permission_deni_animation,
                  width: Dimensions.SUCCESS_ANIMATION_WIDTH,
                  fit: BoxFit.contain,
                  alignment: Alignment.center),
            ),
            SizedBox(height: 50, child: Text('please_allow_permission'.tr))
          ]),
        );
      }

      if(contactController.permissionStatus == PermissionStatus.permanentlyDenied) {
        return SliverToBoxAdapter(child: Column(children: [
          Lottie.asset(
            Images.contact_permission_deni_animation,
            width: Dimensions.SUCCESS_ANIMATION_WIDTH,
            fit: BoxFit.contain,
            alignment: Alignment.center,
          ),

          TextButton(
            onPressed: () => openAppSettings(),
            child: Text('you_have_to_grand_permission_to_see_contact'.tr),
          ),

        ]));
      }
      if(contactController.contactIsLoading) {
        return SliverToBoxAdapter(child: ContactShimmer());
      }
      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) => contactController.filterdContacts[index] == null ? SizedBox() : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if(index == 0) Container(
              margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('phone_book'.tr, style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),),
                ],
              ),
            ),

            Padding( padding: contactController.filterdContacts[index].isShowSuspension ?
            EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_SMALL) :
            const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
              child: Offstage(offstage: !contactController.filterdContacts[index].isShowSuspension,
                child: Text(
                  contactController.filterdContacts[index].getSuspensionTag(),
                  style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: ColorResources.getGreyBaseGray1()),
                ),
              ),
            ),

            CustomInkWell(
              highlightColor: Theme.of(context).textTheme.titleLarge.color.withOpacity(0.3),
              onTap:() => contactController.isButtonClick
                  ? null : contactController.contactOnTap(index, transactionType),
              child: ContactTile(transactionMoneyController: contactController, index: index),
            ),

            Padding(
              padding: const EdgeInsets.only(left: Dimensions.CONTACT_TILE_LEFT_PADDING,right:  Dimensions.CONTACT_TILE_RIGHT_PADDING),
              child: Divider(color: Theme.of(context).dividerColor, height: Dimensions.DIVIDER_SIZE_EXTRA_SMALL),
            ),
          ],
        ),
          childCount: contactController.filterdContacts.length,
        ),
      );
    });
  }
}