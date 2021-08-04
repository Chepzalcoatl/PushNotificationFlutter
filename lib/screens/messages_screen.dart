import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/res/custom_colors.dart';
import 'package:login/screens/user_info_screen.dart';
import 'package:login/widgets/app_bar_title.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  MessagesScreenPageState createState() => MessagesScreenPageState();
}

class MessagesScreenPageState extends State<MessagesScreen> {
  late User _user;
  
  @override
  void initState() {
    _user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: CustomColors.firebaseNavy,
        title: AppHomeBar(),
      ),
      body: Center(child: Text('Hola '+ _user.displayName!)),
    );
  }

  AppHomeBar() {
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
}