import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_convert/model/user.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dialog.dart';

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 85,
            height: 85,
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 3)],
                image: DecorationImage(
                    image: NetworkImage(user.picture), fit: BoxFit.fill)),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              '${user.title}. ${user.firstName} ${user.lastName}',
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                '${user.email}',
                style: TextStyle(color: Colors.lightBlue, fontSize: 16),
              ),
            ),
            onTap: () async {
              final url = Mailto(to: [
                '${user.email}',
              ]).toString();
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                showCupertinoDialog(
                  context: context,
                  builder: MailClientOpenErrorDialog(url: url).build,
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              '${user.gender}',
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
