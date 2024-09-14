import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_select_relay_page.dart';
import 'package:ox_wallet/page/wallet_backup_funds_page.dart';
import 'package:ox_wallet/page/wallet_mints_page.dart';
import 'package:ox_wallet/page/wallet_pubkey_page.dart';

import '../utils/widget_tool.dart';

class WalletOptionPage extends StatefulWidget {
  const WalletOptionPage({super.key});

  @override
  State<WalletOptionPage> createState() => WalletOptionPageState();
}

class WalletOptionPageState extends State<WalletOptionPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ThemeColor.color190,
        appBar: CommonAppBar(
          title: 'Options',
          centerTitle: true,
          useLargeTitle: false,
        ),
        body: Container(
          child: Column(
            children: [
              _infoWidget(),
              _generalWidget(),
              CommonButton(
                height: 48.px,
                width: double.infinity,
                cornerRadius: 12,
                content: 'Change to Nip60',
                onPressed: checkChangeWalletTips,
                backgroundColor: ThemeColor.color180,
                fontWeight: FontWeight.w600,
              ).setPadding(EdgeInsets.symmetric(vertical: 12.px)),
              CommonButton(
                height: 48.px,
                width: double.infinity,
                cornerRadius: 12,
                content: 'Backup Funds',
                onPressed: () {
                  OXNavigator.pushPage(context, (context) => WalletBackupFundsPage(mint: null,));
                },
                backgroundColor: ThemeColor.color180,
                fontWeight: FontWeight.w600,
              ).setPaddingOnly(bottom: 12.px),
              CommonButton(
                height: 48.px,
                width: double.infinity,
                cornerRadius: 12,
                content: 'Log out',
                onPressed: checkLogOutTips,
                backgroundColor: ThemeColor.color180,
                fontColor: ThemeColor.red,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ).setPadding(EdgeInsets.symmetric(horizontal: 24.px)));
  }

  Widget _infoWidget() {
    return labelWidgetWrapWidget(
        title: 'INFO',
        widget: Column(
          children: [
            labelWidget(title: 'Pubkey', subTitle: 'Key01', showDivider: true,onTap: (){
              OXNavigator.pushPage(context, (context) => WalletPubkeyPage());
            }),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 10.px,
                horizontal: 16.px,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 0.5,
                    color: ThemeColor.color160,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: TextStyle(
                      color: ThemeColor.color0,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.px,
                    ),
                  ),
                  Text(
                    'This is description, This is description, This is description, This is description, This is description, This is description...',
                    style: TextStyle(
                      color: ThemeColor.color100,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.px,
                    ),
                  ),
                ],
              ),
            ),
            labelWidget(
                title: 'Type', subTitle: 'Local Wallet', showDivider: true),
            labelWidget(title: 'ID', subTitle: '00023231'),
          ],
        ));
  }

  Widget _generalWidget() {
    return labelWidgetWrapWidget(
        title: 'GENERAL',
        widget: Column(
          children: [
            labelWidget(
                title: 'Mints',
                subTitle: '6',
                showDivider: true,
                onTap: () {
                  OXNavigator.pushPage(context, (context) => WalletMintsPage());
                }),
            labelWidget(title: 'Relay', subTitle: '6',onTap: (){
              OXNavigator.pushPage(context, (context) => CommonSelectRelayPage());
            }),
          ],
        ));
  }


  void checkChangeWalletTips() {


    OXCommonHintDialog.show(context,
        title: 'Confirm change to nip60 wallet?',
        content: 'Are you sure you want to upgrade to NIP60 wallet? After upgrading, please back up your wallet again.',
        actionList: [
          OXCommonHintAction.cancel(onTap: () {
            OXNavigator.pop(context);
          }),
          OXCommonHintAction.sure(
              text: 'Yes',
              onTap: () {
                // OXNavigator.pushReplacement(context, WalletPage());
              }),
        ],
        isRowAction: true);

  }

  void checkLogOutTips() {


    OXCommonHintDialog.show(context,
        title: 'Are you sure you want to log out?',
        content: 'Please make sure you have backed up your wallet before logging out.',
        actionList: [
          OXCommonHintAction.cancel(onTap: () {
            OXNavigator.pop(context);
          }),
          OXCommonHintAction.sure(
              text: 'Yes',
              onTap: () {
                // OXNavigator.pushReplacement(context, WalletPage());
              }),
        ],
        isRowAction: true);

  }
}
