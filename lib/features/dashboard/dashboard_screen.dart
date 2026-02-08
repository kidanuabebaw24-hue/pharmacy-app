import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_app/features/auth/presentation/auth_controller.dart';
import 'package:pharmacy_app/features/auth/data/auth_repository.dart';
import 'package:pharmacy_app/features/auth/domain/user_model.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;
  final List<String> _images = [
    'assets/images/dashboard_bg.jpg',
    'assets/images/pharma2.webp',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        _currentPage++;
        if (_currentPage >= _images.length) {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProfileFuture = ref.watch(authRepositoryProvider).getCurrentUserProfile();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacy Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authControllerProvider.notifier).logout();
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: FutureBuilder<AppUser?>(
        future: userProfileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
             return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
             return Center(child: Text('Error loading profile: ${snapshot.error}'));
          }

          final user = snapshot.data;
          
          return Center(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: PageView.builder(
                          controller: _pageController,
                          scrollDirection: Axis.vertical,
                          itemCount: _images.length,
                          itemBuilder: (context, index) {
                            return Image.asset(
                              _images[index],
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.1),
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(20),
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user != null ? 'Welcome Back,' : 'Welcome',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (user != null)
                              Text(
                                user.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       const SizedBox(height: 20),
                      Text(
                        user?.role.name.toUpperCase() ?? '',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.grey[600],
                          letterSpacing: 1.2
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
