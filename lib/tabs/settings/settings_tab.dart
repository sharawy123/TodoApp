import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/auth/login_screen.dart';
import 'package:to_do_app/auth/user_provider.dart';

import '../tasks/tasks_provider.dart';

class SettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Logout',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                    onPressed: () {
                      Provider.of<UserProvider>(context,listen: false).UpdateUser(null);
                      Provider.of<TaskProvider>(context,listen: false).tasks.clear();

                      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
                    },
                    icon: Icon(
                      Icons.logout,
                      size: 28,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}

