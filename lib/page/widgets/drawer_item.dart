// drawer_item.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final String url;
  final VoidCallback? onTap;

  const DrawerItem({
    Key? key,
    required this.text,
    required this.icon,
    required this.url,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.indigo.shade600,
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.right,
        ),
        onTap: onTap ?? () async {
          Navigator.pop(context);
          
          final Uri uri = Uri.parse(url);
          if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('لا يمكن فتح الرابط: $url')),
            );
          }
        },
      ),
    );
  }
}