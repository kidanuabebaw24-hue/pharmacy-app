import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmacy_app/features/auth/data/auth_repository.dart';
import 'package:pharmacy_app/features/auth/presentation/login_screen.dart';
import 'package:pharmacy_app/features/auth/presentation/register_screen.dart';
import 'dart:async';

import 'package:pharmacy_app/core/presentation/main_layout.dart';
import 'package:pharmacy_app/features/dashboard/dashboard_screen.dart';
import 'package:pharmacy_app/features/inventory/presentation/inventory_screen.dart';
import 'package:pharmacy_app/features/inventory/presentation/add_product_screen.dart';
import 'package:pharmacy_app/features/orders/orders_screen.dart';
import 'package:pharmacy_app/features/suppliers/suppliers_screen.dart';

part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter router(RouterRef ref) {
  final authState = ref.watch(authRepositoryProvider).authStateChanges;

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(authState),
    redirect: (context, state) {
      final isLoggedIn = ref.read(authRepositoryProvider).currentUser != null;
       final user = FirebaseAuth.instance.currentUser;
       final isAuth = user != null;

       final isLoggingIn = state.uri.toString() == '/login' || state.uri.toString() == '/register';

       if (!isAuth && !isLoggingIn) return '/login';
       if (isAuth && isLoggingIn) return '/';

       return null;
    },
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/inventory',
            builder: (context, state) => const InventoryScreen(),
            routes: [
              GoRoute(
                path: 'add',
                parentNavigatorKey: _rootNavigatorKey, // Open full screen
                builder: (context, state) => const AddProductScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/orders',
            builder: (context, state) => const OrdersScreen(),
          ),
           GoRoute(
            path: '/suppliers',
            builder: (context, state) => const SuppliersScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
       GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

