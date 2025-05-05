import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jammui/homepage/homepage.dart';
import 'package:jammui/login/chooseloginorsignup.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Color primaryGreen = const Color(0xFF33b864);
  final Color lightGreen = const Color(0xFFB2F2BB);
  final Color darkGreen = const Color(0xFF1F7A4D);

  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _videoController = VideoPlayerController.asset('assets/videos/splash_animation.mp4')
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isVideoInitialized = true;
          });
          _videoController.setLooping(false);
          _videoController.play();
        }
      }).catchError((error) {
        print('Error initializing video: $error');
        _navigateAfterDelay();
      });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CurrentPageProvider>(context, listen: false).setCurrentPage('splash');
      _navigateAfterDelay();
    });
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3));
    if (_videoController.value.isInitialized && _videoController.value.duration.inSeconds > 3) {
      await _videoController.position.then((pos) {
        if (pos! < _videoController.value.duration) {
          return Future.delayed(_videoController.value.duration - pos);
        }
      });
    }
    _navigateBasedOnAuth();
  }

  void _navigateBasedOnAuth() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (mounted) {
      if (currentUser != null) {
        // Update the current page to 'home' before navigation
        Provider.of<CurrentPageProvider>(context, listen: false).setCurrentPage('home');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Homepage()),
        );
      } else {
        // Update the current page to 'login' before navigation
        Provider.of<CurrentPageProvider>(context, listen: false).setCurrentPage('login');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ChooseSignupOrLogin()),
        );
      }
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryGreen,
      ),
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            if (_videoController.value.isPlaying) {
              _videoController.pause();
            }
            _navigateBasedOnAuth();
          },
          child: Stack(
            children: [
              // Static placeholder image initially
              SizedBox.expand(
                child: Image.asset(
                  'assets/images/splash_placeholder.png',
                  fit: BoxFit.cover,
                ),
              ),
              // Video overlay once initialized
              if (_isVideoInitialized)
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoController.value.size.width,
                      height: _videoController.value.size.height,
                      child: VideoPlayer(_videoController),
                    ),
                  ),
                ),
              // Overlay content
            ],
          ),
        ),
      ),
    );
  }
}