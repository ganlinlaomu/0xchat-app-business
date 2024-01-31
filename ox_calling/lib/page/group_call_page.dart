import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatcore/chat-core.dart';

///Title: group_call_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/1/30 16:36
class GroupCallPage extends StatefulWidget{
  final List<UserDB> userList;
  final String mediaType; // audio;  video.

  const GroupCallPage(this.userList, this.mediaType, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _GroupCallPageState();
  }

}

class _GroupCallPageState extends State<GroupCallPage>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[300], // 设置背景色
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // 返回按钮
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Waiting', style: TextStyle(color: Colors.white)), // 等待文字
        backgroundColor: Colors.transparent, // 透明背景
        elevation: 0, // 去除阴影
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white), // 添加按钮
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3列
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 6, // 人数
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage('https://placekitten.com/200/200'), // 示例头像
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            color: Colors.purple[400], // 控制按钮的背景色
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.mic_off, color: Colors.white),
                  onPressed: () {},
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // 按钮背景颜色
                    shape: CircleBorder(), // 圆形按钮
                  ),
                  child: Icon(Icons.call_end, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.volume_up, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}