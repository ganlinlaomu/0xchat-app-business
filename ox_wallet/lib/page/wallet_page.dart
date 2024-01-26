import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/theme_button.dart';
import 'package:ox_wallet/page/wallet_home_page.dart';
import 'package:ox_wallet/page/wallet_mint_management_add_page.dart';
import 'package:ox_wallet/services/ecash_manager.dart';
import 'package:ox_wallet/services/ecash_service.dart';
import 'package:ox_wallet/widget/ecash_common_button.dart';
import 'package:ox_wallet/widget/privacy_policy_widget.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final _defaultMintURL = 'https://8333.space:3338';
  final ValueNotifier<bool> _hasAgreedToPrivacyPolicy = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ThemeColor.color190,
        appBar: CommonAppBar(
        centerTitle: true,
        useLargeTitle: false,
    ),
    body:SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CommonImage(
                iconName: 'icon_wallet_logo.png',
                size: 100.px,
                package: 'ox_wallet',
              ).setPaddingOnly(top: 44.px),
              CommonImage(
                iconName: 'icon_wallet_symbol.png',
                height: 25.px,
                width: 100.px,
                package: 'ox_wallet',
              ).setPaddingOnly(top: 16.px),
              Text(
                'You can either use the default mint\r\nor\r\nintroduce custom mint',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.px,
                    color: ThemeColor.color0,
                    height: 24.px / 16.px
                ),
              ).setPaddingOnly(top: 56.px),
              const Spacer(),
              ThemeButton(height: 48.px,text: 'Use the default mint',onTap: _useDefaultMint,),
              EcashCommonButton(text: 'Add mint URL',onTap: _addMint).setPaddingOnly(top: 18.px),
              PrivacyPolicyWidget(controller: _hasAgreedToPrivacyPolicy,).setPaddingOnly(top: 18.px),
              SizedBox(height: 40.px,)
              ],
            ).setPadding(EdgeInsets.symmetric(horizontal: 30.px)),
        ),
      ),
    ),
    );
  }

  void _addMint() {
    if (!_checkPrivacyPolicyAgreement()) return;
    OXNavigator.pushPage(
      context,
      (context) => WalletMintManagementAddPage(
        action: ImportAction.import,
        callback: () => OXNavigator.pushPage(context!, (context) => const WalletHomePage()),
      ),
    );
  }

  void _useDefaultMint() {
    if(!_checkPrivacyPolicyAgreement()) return;
    OXLoading.show();
    EcashService.addMint(_defaultMintURL).then((mint) {
      OXLoading.dismiss();
      if (mint != null) {
        EcashManager.shared.addMint(mint);
        EcashManager.shared.setWalletAvailable();
        OXNavigator.pushPage(context, (context) => const WalletHomePage());
      } else {
        CommonToast.instance.show(context, 'Add default mint Failed, Please try again.');
      }
    });
  }

  bool _checkPrivacyPolicyAgreement() {
    final hasAgreedToPrivacyPolicy = _hasAgreedToPrivacyPolicy.value;
    if (!hasAgreedToPrivacyPolicy) {
      CommonToast.instance.show(context, 'Please accept the privacy policy');
    }
    return hasAgreedToPrivacyPolicy;
  }

  @override
  void dispose() {
    _hasAgreedToPrivacyPolicy.dispose();
    super.dispose();
  }
}