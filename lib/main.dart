import 'package:Pub/screens/pub_wrapper.dart';
import 'package:Pub/screens/pub_wrapper_builder.dart';
import 'package:Pub/services/authentication/pub_auth_service.dart';
import 'package:Pub/styles/pub_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PubAuthService>(
          create: (_) => PubAuthService(),
        ),
      ],
      child: PubWrapperBuilder(
        builder: (context, userSnapshot) {
          return MaterialApp(
            theme: PubTheme.lightTheme,
            home: PubWrapper(userSnapshot: userSnapshot),
          );
        },
      ),
    );
  }
}
