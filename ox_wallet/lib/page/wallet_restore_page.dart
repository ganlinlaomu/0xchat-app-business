import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/file_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/theme_button.dart';
import 'package:ox_wallet/page/wallet_home_page.dart';
import 'package:ox_wallet/page/wallet_mint_management_add_page.dart';
import 'package:ox_wallet/services/ecash_manager.dart';
import 'package:ox_wallet/services/ecash_service.dart';
import 'package:ox_wallet/widget/common_labeled_item.dart';
import 'package:ox_localizable/ox_localizable.dart';



class WalletRestorePage extends StatefulWidget {

  final ScenarioType scenarioType;
  final VoidCallback? callback;
  const WalletRestorePage(
      {super.key,
        ScenarioType? scenarioType,
        this.callback}) :scenarioType = scenarioType ?? ScenarioType.operate;

  @override
  State<WalletRestorePage> createState() => WalletRestorePageState();
}

class WalletRestorePageState extends State<WalletRestorePage> {

  final TextEditingController _controller = TextEditingController();
  bool _enable = true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _enable = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ThemeColor.color190,
        appBar: CommonAppBar(
          title: '',
          centerTitle: true,
          useLargeTitle: false,
        ),
        body:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100.px,
              child: Center(
                child: _buildText(
                 'Restore wallet',
                ),
              ),
            ),
            CommonLabeledCard.textFieldAndImportFile(
              hintText: 'Enter Restore Public Key',
              controller: _controller,
              onTap: _importTokenFile,
            ),
            SizedBox(height: 30.px,),
            ThemeButton(text: 'Restore',height: 48.px,enable: _enable, onTap: _restoreWallet),
          ],
        ).setPadding(EdgeInsets.symmetric(horizontal: 24.px))
    );
  }

  Widget _buildText(String text){
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: [
            ThemeColor.gradientMainEnd,
            ThemeColor.gradientMainStart,
          ],
        ).createShader(Offset.zero & bounds.size);
      },
      child: Text(
        text,
        style: TextStyle(
            fontSize: 32.px,
            fontWeight: FontWeight.w700,
            height: 44.px / 32.px
        ),
      ),
    );
  }

  void _importTokenFile() async {
    try {
      final file = await FileUtils.importFile();
      if (file == null) return;
      final token = await file.readAsString();
      _controller.text = token;
    } catch (e) {
      _showToast(Localized.text("ox_wallet.import_invalid_tips"));
    }
  }

  Future<void> _restoreWallet() async {
    OXNavigator.pushPage(context, (context) => const WalletHomePage());
    // if(!EcashService.isCashuToken(_controller.text)){
    //   _showToast(Localized.text("ox_wallet.invalid_cashu_token"));
    //   return;
    // }
    // OXLoading.show();
    // final response = await EcashService.redeemEcash(_controller.text);
    // OXLoading.dismiss();
    // if(!response.isSuccess){
    //   _showToast(response.errorMsg);
    //   return;
    // }
    // _showToast(Localized.text("ox_wallet.import_success_tips"));
    // _handleUseScenario();
  }

  void _handleUseScenario() {
    if (widget.scenarioType == ScenarioType.operate) {
      if (context.mounted) OXNavigator.pop(context, true);
    } else {
      EcashManager.shared.setWalletAvailable();
      widget.callback?.call();
    }
  }

  void _showToast(String message) {
    if (context.mounted) CommonToast.instance.show(context, message);
  }
}