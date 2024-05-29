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
import 'package:team_project/providers/comment/comment_provider.dart';
import 'package:team_project/providers/comment/comment_state.dart';
import 'package:team_project/providers/feed/feed_provider.dart';
import 'package:team_project/providers/feed/feed_state.dart';
import 'package:team_project/providers/like/feed_like_provider.dart';
import 'package:team_project/providers/like/feed_like_state.dart';
import 'package:team_project/providers/like/like_provider.dart';
import 'package:team_project/providers/like/like_state.dart';
import 'package:team_project/providers/notice/notice_provider.dart';
import 'package:team_project/providers/notice/notice_state.dart';
import 'package:team_project/providers/profile/profile_provider.dart';
import 'package:team_project/providers/profile/profile_state.dart';
import 'package:team_project/providers/report/report_provider.dart';
import 'package:team_project/providers/report/report_state.dart';
import 'package:team_project/providers/schedule/schedule_provider.dart';
import 'package:team_project/providers/schedule/schedule_state.dart';
import 'package:team_project/providers/search/search_provider.dart';
import 'package:team_project/providers/search/search_state.dart';
import 'package:team_project/providers/user/user_provider.dart';
import 'package:team_project/providers/user/user_state.dart';
import 'package:team_project/repositories/auth_repository.dart';
import 'package:team_project/repositories/club_repository.dart';
import 'package:team_project/repositories/comment_repository.dart';
import 'package:team_project/repositories/feed_like_repository.dart';
import 'package:team_project/repositories/feed_repository.dart';
import 'package:team_project/repositories/like_repository.dart';
import 'package:team_project/repositories/notice_repository.dart';
import 'package:team_project/repositories/profile_repository.dart';
import 'package:team_project/repositories/report_repository.dart';
import 'package:team_project/repositories/schedule_repository.dart';
import 'package:team_project/repositories/search_repository.dart';
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
        Provider<LikeRepository>(
          create: (context) => LikeRepository(
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        Provider<FeedLikeRepository>(
          create: (context) => FeedLikeRepository(
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        Provider<ReportRepository>(
          create: (context) => ReportRepository(
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        Provider<FeedRepository>(
          create: (context) => FeedRepository(
            firebaseStorage: FirebaseStorage.instance,
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        Provider<NoticeRepository>(
          create: (context) => NoticeRepository(
            firebaseStorage: FirebaseStorage.instance,
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        Provider<CommentRepository>(
          create: (context) => CommentRepository(
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        Provider<ScheduleRepository>(
          create: (context) => ScheduleRepository(
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        Provider<SearchRepository>(
          create: (context) => SearchRepository(
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
        StateNotifierProvider<ProfileProvider, ProfileState>(
          create: (context) => ProfileProvider(),
        ),
        StateNotifierProvider<ClubProvider, ClubState>(
          create: (context) => ClubProvider(),
        ),
        StateNotifierProvider<LikeProvider, LikeState>(
          create: (context) => LikeProvider(),
        ),
        StateNotifierProvider<FeedLikeProvider, FeedLikeState>(
          create: (context) => FeedLikeProvider(),
        ),
        StateNotifierProvider<ReportProvider, ReportState>(
          create: (context) => ReportProvider(),
        ),
        StateNotifierProvider<FeedProvider, FeedState>(
          create: (context) => FeedProvider(),
        ),
        StateNotifierProvider<NoticeProvider, NoticeState>(
          create: (context) => NoticeProvider(),
        ),
        StateNotifierProvider<CommentProvider, CommentState>(
          create: (context) => CommentProvider(),
        ),
        StateNotifierProvider<ScheduleProvider, ScheduleState>(
          create: (context) => ScheduleProvider(),
        ),
        StateNotifierProvider<SearchProvider, SearchState>(
          create: (context) => SearchProvider(),
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