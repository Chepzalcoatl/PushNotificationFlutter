import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login/data/message_dao.dart';
import 'package:login/models/message.dart';
import 'package:login/res/custom_colors.dart';
import 'package:login/screens/user_info_screen.dart';
import 'package:login/widgets/app_bar_title.dart';

class MessagesScreen extends StatefulWidget {
  MessagesScreen({Key? key, required this.user}) : super(key: key);
  final User user;
  final messageDao = MessageDao();

  @override
  MessagesScreenPageState createState() => MessagesScreenPageState();
}

class MessagesScreenPageState extends State<MessagesScreen> {
  TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  late User _user;

  @override
  void initState() {
    _user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToBottom());
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: CustomColors.firebaseNavy,
        title: _appHomeBar(),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller: _messageController,
                      onChanged: (text) => setState(() {}),
                      onSubmitted: (input) {
                        _sendMessage();
                      },
                      decoration:
                          const InputDecoration(hintText: 'Enter new message'),
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(_canSendMessage()
                        ? CupertinoIcons.arrow_right_circle_fill
                        : CupertinoIcons.arrow_right_circle),
                    onPressed: () {
                      _sendMessage();
                    })
              ],
            ),
            _getMessageList(),
          ],
        ),
      ),
    );
  }

  _appHomeBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/firebase_logo.png',
          height: 20,
        ),
        SizedBox(width: 8),
        Text(
          'Flutter',
          style: TextStyle(
            color: CustomColors.firebaseYellow,
            fontSize: 18,
          ),
        ),
        Text(
          ' Example',
          style: TextStyle(
            color: CustomColors.firebaseOrange,
            fontSize: 18,
          ),
        ),
        Spacer(),
        IconButton(
          icon: const Icon(Icons.account_circle_outlined),
          tooltip: 'See account detail',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserInfoScreen(
                  user: _user,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  bool _canSendMessage() => _messageController.text.length > 0;

  void _sendMessage() {
    if (_canSendMessage()) {
      final message = Message(_messageController.text, DateTime.now());
      widget.messageDao.saveMessage(message);
      _messageController.clear();
      setState(() {});
    }
  }

  Widget _getMessageList() {
    return Expanded(
      child: FirebaseAnimatedList(
        controller: _scrollController,
        query: widget.messageDao.getMessageQuery(),
        itemBuilder: (context, snapshot, animation, index) {
          final json = snapshot.value as Map<dynamic, dynamic>;
          final message = Message.fromJson(json);
          return _messageWidget(message.text, message.date);
        },
      ),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  Widget _messageWidget(String message, DateTime date) {
    return Padding(
        padding: const EdgeInsets.only(left: 1, top: 5, right: 1, bottom: 2),
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[350]!,
                          blurRadius: 2.0,
                          offset: Offset(0, 1.0))
                    ],
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.white),
                child: MaterialButton(
                    disabledTextColor: Colors.black87,
                    padding: EdgeInsets.only(left: 18),
                    onPressed: null,
                    child: Wrap(
                      children: <Widget>[
                        Container(
                            child: Row(
                          children: [
                            Text(message),
                          ],
                        )),
                      ],
                    ))),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    DateFormat('yyyy-MM-dd, kk:mma').format(date).toString(),
                    style: TextStyle(color: Colors.grey),
                  )),
            ),
          ],
        ));
  }
}
