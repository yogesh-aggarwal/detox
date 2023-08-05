import 'package:cached_network_image/cached_network_image.dart';
import 'package:detox/core/auth.dart';
import 'package:detox/core/firebase.dart';
import 'package:detox/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    if (user == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        SizedBox(height: 16),
        Center(
          child: Column(
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: CachedNetworkImage(
                  imageUrl: user.dp,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, progress) {
                    return Center(child: CircularProgressIndicator());
                  },
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SizedBox(height: 16),
              Text(
                user.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 32),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Switch accounts'),
          onTap: () async {
            await GoogleSignIn().disconnect();
            await signInWithGoogle();
          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: () async {
            await GoogleSignIn().disconnect();
            await auth.signOut();
          },
        ),
      ],
    );
  }
}
