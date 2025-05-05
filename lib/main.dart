import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jammui/homepage/homepage.dart';
import 'package:jammui/login/chooseloginorsignup.dart';
import 'package:jammui/login/loginpage.dart';
import 'package:jammui/login/signuppage.dart';
import 'package:jammui/splashscreen.dart';
import 'package:jammui/theme.dart';
import 'package:provider/provider.dart';
import 'chatbotwindow.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Import your test pages
// import 'path/to/mocktest_page.dart';
// import 'path/to/exam_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp().catchError((error) {
    print('Firebase initialization error: $error');
  });

  runApp(const MyAppWithProvider());
}

class MyAppWithProvider extends StatelessWidget {
  const MyAppWithProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: ChangeNotifierProvider(
        create: (context) => CurrentPageProvider(),
        child: const MyApp(),
      ),
    );
  }
}

// Create a provider to track current page type
class CurrentPageProvider extends ChangeNotifier {
  String _currentPage = 'initial'; // Default to splash

  String get currentPage => _currentPage;

  bool get isOnTestPage => _currentPage == 'splash' || _currentPage == 'exam' || _currentPage == 'mocktest';// || _currentPage == 'subjectmocktest';

  void setCurrentPage(String page) {
    _currentPage = page;
    notifyListeners();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showChatbot = false;

  void _toggleChatbot() {
    setState(() {
      _showChatbot = !_showChatbot;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, CurrentPageProvider>(
      builder: (context, themeProvider, pageProvider, child) {
        return MaterialApp(
          title: 'Virtual Healthcare Assistant',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.getTheme(),
          builder: (context, child) {
            return StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                final isLoggedIn = snapshot.hasData;
                final shouldShowChatbot = isLoggedIn && !pageProvider.isOnTestPage;
                // Debug print to check state
                print('isLoggedIn: $isLoggedIn, currentPage: ${pageProvider.currentPage}, shouldShowChatbot: $shouldShowChatbot');

                return Stack(
                  children: [
                    child!, // The Navigator with all routes
                    if (shouldShowChatbot) ...[
                      if (_showChatbot)
                        Overlay(
                          initialEntries: [
                            OverlayEntry(
                              builder: (context) => GestureDetector(
                                onTap: () {},
                                child: Container(
                                  color: Colors.grey[300],
                                  child: Material(
                                    color: Colors.transparent,
                                    child: ChatbotWindow(onClose: _toggleChatbot),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (!_showChatbot)
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: Material(
                            color: Colors.transparent,
                            child: Builder(
                              builder: (context) {
                                return FloatingActionButton(
                                  onPressed: _toggleChatbot,
                                  backgroundColor: const Color(0xFF33B864),
                                  child: const Icon(Icons.chat, color: Colors.white),
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ],
                );
              },
            );
          },
          home: const SplashScreen(), // Initial page
          routes: {
            '/chooseLoginOrSignup': (context) => const ChooseSignupOrLogin(),
            '/login': (context) => LoginPage(),
            '/signup': (context) => const SignUpPage(),
            '/home': (context) => Homepage(),
          },
        );
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting, stay on splash
          Provider.of<CurrentPageProvider>(context, listen: false).setCurrentPage('splash');
          return const SplashScreen();
        }

        final pageProvider = Provider.of<CurrentPageProvider>(context, listen: false);
        if (snapshot.hasData) {
          print('User is authenticated, navigating to Homepage');
          pageProvider.setCurrentPage('home'); // Set to 'home' when authenticated
          return Homepage();
        }

        print('User is not authenticated, navigating to ChooseSignupOrLogin');
        pageProvider.setCurrentPage('login'); // Set to 'login' when not authenticated
        return const ChooseSignupOrLogin();
      },
    );
  }
}