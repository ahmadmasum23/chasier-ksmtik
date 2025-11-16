import 'package:flutter/material.dart';
import 'package:kasir_kosmetic/ui/widgets/app_drawer.dart';
import 'package:kasir_kosmetic/ui/widgets/custom_app_bar.dart';

class BaseScreen extends StatelessWidget {
  final String title;
  final Widget body;
  final bool showProfile;

  const BaseScreen({
    super.key,
    required this.title,
    required this.body,
    this.showProfile = true, 
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: const AppDrawer(),
      appBar: CustomAppBar(
        showProfile: showProfile,
        title: title,   
        onMenuPressed: () {
          scaffoldKey.currentState?.openDrawer();
        },
      ),
      body: body,
    );
  }
}