
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../user_model.dart';

class AccountTab extends StatelessWidget {
  const AccountTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Account Tab"),
          SizedBox(height: 20),
          Text("Welcome, ${user?.displayName}!"),
          Text("Your role is: ${user?.role}"),
        ],
      ),
    );
  }
}
