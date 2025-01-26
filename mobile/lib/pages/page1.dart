import 'package:flutter/material.dart';
import 'dart:async';
import 'page2.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({Key? key}) : super(key: key);

  @override
  _GetStartedPageState createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonAnimation;

  final List<String> _images = [
    'assets/images/image1.jpg',
    'assets/images/image2.jpg',
    'assets/images/image3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();

    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _buttonAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _buttonAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _buttonAnimationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _buttonAnimationController.forward();
      }
    });

    _buttonAnimationController.forward();
  }

  void _startAutoScroll() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % _images.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      body: SafeArea(
        child: Column(
          children: [
          
            Flexible(
              flex: 3,
              child: Stack(
                children: [
                  ClipPath(
                    clipper: WaveClipper(),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      color: Colors.deepPurple,
                    ),
                  ),
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          _images[index],
                          height: 250,
                          width: 250,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  const LoginPage()),
                        );
                      },
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          
            Flexible(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: const [
                      Text(
                        "Welcome\nOur Courses",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Here you can learn new and most interesting things for you!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _images.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: _currentPage == index ? 12 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Colors.deepPurple
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: ScaleTransition(
                      scale: _buttonAnimation,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                        ),
                        child: const Text(
                          "Get Started",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 100);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
