import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_chat/page/contacts/contact_group_list_page.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';

class VoiceCallChooseMembersPage extends ContactGroupListPage {
  final String groupId;
  final String? title;
  final GroupListAction? groupListAction;

  const VoiceCallChooseMembersPage({required this.groupId,this.title,this.groupListAction = GroupListAction.add}) : super(title: title);

  @override
  _ContactGroupMemberState createState() => _ContactGroupMemberState();
}

class _ContactGroupMemberState extends ContactGroupListPageState {

  late final groupId;

  @override
  void initState() {
    super.initState();
    groupId = (widget as VoiceCallChooseMembersPage).groupId;
    _fetchUserListAsync();
  }

  Future<void> _fetchUserListAsync() async {
    List<UserDB> users = await fetchUserList();
    setState(() {
      userList = users;
      super.groupedUser();
    });
  }

  Future<List<UserDB>> fetchUserList() async {
    List<UserDB> allGroupMembers = await Groups.sharedInstance.getAllGroupMembers(groupId);
    List<UserDB> allContacts = Contacts.sharedInstance.allContacts.values.toList();
    GroupDB? groupDB = Groups.sharedInstance.groups[groupId];
    String owner = '';
    if(groupDB != null) owner = groupDB.owner;
    switch (widget.groupListAction) {
      case GroupListAction.view:
        return allGroupMembers;
      case GroupListAction.add:
        for(int index =0;index <allGroupMembers.length;index ++){
          allContacts.removeWhere((element) => element.pubKey == allGroupMembers[index].pubKey);
        }
        return allContacts;
      case GroupListAction.remove:
        allGroupMembers.removeWhere((element) => element.pubKey == owner);
        return allGroupMembers;
      case GroupListAction.send:
        return allContacts;
      default:
        return [];
    }
  }

  @override
  String buildTitle() {
    final userCount = userList.length;
    final selectedUserCount = selectedUserList.length;
    if (widget.title == null) {
      switch (widget.groupListAction) {
        case GroupListAction.view:
          return '${Localized.text('ox_chat.group_member')} ${userCount > 0 ? '($userCount)' : ''}';
        case GroupListAction.add:
          return '${Localized.text('ox_chat.add_member_title')} ${selectedUserCount > 0 ? '($selectedUserCount)' : ''}';
        case GroupListAction.remove:
          return '${Localized.text('ox_chat.remove_member_title')} ${selectedUserCount > 0 ? '($selectedUserCount)' : ''}';
        case GroupListAction.send:
          return '${Localized.text('ox_chat.select_chat')}';
        default:
          return '';
      }
    }
    return widget.title!;
  }

  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }

  @override
  buildViewPressed() {
    OXNavigator.presentPage(context, (context) => VoiceCallChooseMembersPage(groupId:groupId,groupListAction: GroupListAction.add,));
  }

  @override
  buildSendPressed() {
    ///jump Multiple Voice
    CommonToast.instance.show(context, 'buildSendPressed jump Multiple Voice selectedUserList =${selectedUserList.length}');
  }

  @override
  buildAddPressed() {
    ///jump Multiple Voice
    CommonToast.instance.show(context, 'buildAddPressed jump Multiple Voice selectedUserList =${selectedUserList.length}');
    OXNavigator.pop(context, selectedUserList);
  }
}
