import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ox_common/business_interface/ox_usercenter/zaps_detail_model.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/took_kit.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_usercenter/model/zaps_record.dart';

class ZapsRecordPage extends StatelessWidget {

  final ZapsRecordDetail zapsRecordDetail;

  const ZapsRecordPage({Key? key, required this.zapsRecordDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        title: 'Zaps record',
        centerTitle: true,
        useLargeTitle: false,
        titleTextColor: ThemeColor.color0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Adapt.px(24),
        vertical: Adapt.px(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSummary(),
          SizedBox(height: Adapt.px(12),),
          _buildDescription(),
        ],
      ),
    );
  }

  Widget _buildItem(String label,{String? value}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(16)),
      height: Adapt.px(52),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: Adapt.px(16),
              fontWeight: FontWeight.w400,
              color: ThemeColor.color100,
            ),
          ).setPadding(EdgeInsets.only(right: Adapt.px(16))),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                value ?? '',
                maxLines: 1,
                style: TextStyle(
                  fontSize: Adapt.px(16),
                  fontWeight: FontWeight.w400,
                  color: ThemeColor.color10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    final List<MapEntry<String,String>> zapsRecordDetailList = zapsRecordDetail.zapsRecordAttributes.entries.toList();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(16)),
        color: ThemeColor.color180,
      ),
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 0),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          if (index == 1) {
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: _buildItem(
                zapsRecordDetailList[index].key,
                value: _formatString(zapsRecordDetailList[index].value),
              ),
              onTap: () async {
                await TookKit.copyKey(context, zapsRecordDetailList[index].value);
              },
            );
          }
          return _buildItem(
            zapsRecordDetailList[index].key,
            value: _formatString(zapsRecordDetailList[index].value),
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(height: Adapt.px(0.5), color: ThemeColor.color160,),
        itemCount: zapsRecordDetailList.length,
      ),
    );
  }

  Widget _buildDescription(){
    String description = zapsRecordDetail.description ?? '';
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(16)),
        color: ThemeColor.color180,
      ),
      child: Column(
        children: [
          _buildItem('Description'),
          Divider(
            height: Adapt.px(0.5),
            color: ThemeColor.color160,
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(Adapt.px(16)),
            child: description.isNotEmpty
                ? Text(
                    description,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: Adapt.px(16),
                        fontWeight: FontWeight.w400,
                        color: ThemeColor.color10),
                  )
                : Text(
                'No Description',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: Adapt.px(16),
                    fontWeight: FontWeight.w400,
                    color: ThemeColor.color160),
            ),
          ),
        ],
      ),
    );
  }

  String _formatString(String value){
    const halfMaxLength = 15;
    if(value.length > halfMaxLength * 2) {
      return value.substring(0, halfMaxLength - 2) + '...' + value.substring(value.length - halfMaxLength + 2);
    }
    return value;
  }
}
