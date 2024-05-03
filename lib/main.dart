import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:team_project/firebase_options.dart';
import 'package:team_project/providers/auth/auth_provider.dart'
as myAuthProvider;
import 'package:team_project/providers/auth/auth_state.dart';
import 'package:team_project/providers/club/club_provider.dart';
import 'package:team_project/providers/club/club_state.dart';
import 'package:team_project/providers/feed/feed_provider.dart';
import 'package:team_project/providers/feed/feed_state.dart';
import 'package:team_project/providers/profile/profile_provider.dart';
import 'package:team_project/providers/profile/profile_state.dart';
import 'package:team_project/providers/user/user_provider.dart';
import 'package:team_project/providers/user/user_state.dart';
import 'package:team_project/repositories/auth_repository.dart';
import 'package:team_project/repositories/club_repository.dart';
import 'package:team_project/repositories/feed_repository.dart';
import 'package:team_project/repositories/profile_repository.dart';
import 'package:team_project/screen/auth/splash_screen.dart';
import 'package:team_project/theme/theme_constants.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  initializeDateFormatting().then(
        (_) => runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => ThemeManager()),
      ], child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>(
          create: (context) => AuthRepository(
            firebaseAuth: FirebaseAuth.instance,
            firebaseStorage: FirebaseStorage.instance,
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        Provider<FeedRepository>(
          create: (context) => FeedRepository(
            firebaseStorage: FirebaseStorage.instance,
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        Provider<ProfileRepository>(
          create: (context) => ProfileRepository(
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        Provider<ClubRepository>(
          create: (context) => ClubRepository(
            firebaseStorage: FirebaseStorage.instance,
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        StreamProvider<User?>(
          create: (context) => FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),
        StateNotifierProvider<myAuthProvider.AuthProvider, AuthState>(
          create: (context) => myAuthProvider.AuthProvider(),
        ),
        StateNotifierProvider<UserProvider, UserState>(
          create: (context) => UserProvider(),
        ),
        StateNotifierProvider<FeedProvider, FeedState>(
          create: (context) => FeedProvider(),
        ),
        StateNotifierProvider<ProfileProvider, ProfileState>(
          create: (context) => ProfileProvider(),
        ),
        StateNotifierProvider<ClubProvider, ClubState>(
          create: (context) => ClubProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Convex Bottom Bar Example',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: Provider.of<ThemeManager>(context).themeMode,
        home: SplashScreen(),
      ),
    );
  }
}