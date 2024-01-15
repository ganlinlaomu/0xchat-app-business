import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/took_kit.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_wallet/utils/wallet_utils.dart';
import 'package:ox_wallet/widget/common_card.dart';
import 'package:cashu_dart/cashu_dart.dart';
import 'package:ox_wallet/widget/common_labeled_item.dart';

class WalletTransactionRecord extends StatefulWidget {
  final IHistoryEntry entry;
  const WalletTransactionRecord({super.key, required this.entry});

  @override
  State<WalletTransactionRecord> createState() => _WalletTransactionRecordState();
}

class _WalletTransactionRecordState extends State<WalletTransactionRecord> {

  final List<StepItemModel> _items  = [];

  @override
  void initState() {
    _initData();
    super.initState();
  }

  _initData(){
    final record = widget.entry;
    String type = widget.entry.amount > 0 ? 'Receive' : 'Send';
    _items.add(StepItemModel(title: type,subTitle: '${record.amount.toInt().abs()} sats'));
    _items.add(StepItemModel(title: 'Memo',subTitle: record.mintsRaw));
    _items.add(StepItemModel(title: 'Mint',subTitle: record.mints.join('\r\n')),);
    _items.add(StepItemModel(title: 'Created Time',subTitle: WalletUtils.formatTimestamp(record.timestamp.toInt())));
    if(record.type == IHistoryType.eCash){
      _items.add(StepItemModel(title: 'Check',subTitle: 'Check if token has been spent'));
      _items.add(StepItemModel(title: 'Token',subTitle: WalletUtils.formatToken(record.value),onTap: (value) => TookKit.copyKey(context, record.value)));
    }else{
      _items.add(StepItemModel(title: 'Fee',subTitle: record.fee?.toInt().toString()));
      _items.add(StepItemModel(title: 'Invoice',subTitle: record.value,onTap: (value) => TookKit.copyKey(context, record.value)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        title: widget.entry.type == IHistoryType.eCash ? 'Ecash Payment' : 'Lightning Invoice',
        centerTitle: true,
        useLargeTitle: false,
      ),
      body: ListView.separated(
          itemBuilder: (context, index) => _buildItem(_items[index]),
          separatorBuilder: (context, index) => SizedBox(height: 24.px,),
          itemCount: _items.length,).setPadding(EdgeInsets.symmetric(horizontal: 24.px,vertical: 12.px),)
    );
  }

  Widget _buildItem(StepItemModel itemModel){
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => itemModel.onTap != null ? itemModel.onTap!(itemModel) : null,
      child: CommonCard(
        verticalPadding: 15.px,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(itemModel.title ?? '',style: TextStyle(fontSize: 14.px,height: 22.px / 14.px),),
            SizedBox(height: 4.px,),
            Text('${(itemModel.subTitle?.isEmpty ?? true) ? '-' : itemModel.subTitle}',style: TextStyle(fontSize: 12.px,height: 17.px / 12.px,color: ThemeColor.color0),),
          ],
        ),
      ),
    );
  }
}
