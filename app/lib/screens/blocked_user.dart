import 'package:flutter/material.dart';

class BlockedUser extends StatefulWidget {
  const BlockedUser({Key? key}) : super(key: key);

  @override
  State<BlockedUser> createState() => _BlockedUserState();
}

class _BlockedUserState extends State<BlockedUser> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('You are Inactive by Admin'),
          ],
        ),
      ),
    );
  }
}
