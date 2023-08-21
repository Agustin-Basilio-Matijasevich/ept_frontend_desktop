import 'package:ept_frontend/models/usuario.dart';
import 'package:ept_frontend/services/auth.dart';
import 'package:ept_frontend/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_for_all/firebase_for_all.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseCoreForAll.initializeApp(options: DefaultFirebaseOptions.currentPlatform, firestore: true, auth: true, storage: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Usuario?>.value(
      value: AuthService().usuario,
      initialData: null,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}