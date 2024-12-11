import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wheels_up/models/car_listing.dart';
import 'package:wheels_up/pages/home/home_page_pemilik.dart';
import 'package:wheels_up/pages/landing_welcome.dart';
import 'package:wheels_up/pages/login_page.dart';
import 'package:wheels_up/pages/profile/edit_profile.dart';
import 'package:wheels_up/pages/profile/profile_page.dart';
import 'package:wheels_up/pages/rental_form.dart';
import 'package:wheels_up/pages/signup_page.dart';
import 'package:wheels_up/pages/view_listing.dart';
import 'package:wheels_up/utils/current_auth_state.dart';
import 'package:wheels_up/widgets/navigation_destinations.dart';
import 'package:wheels_up/pages/home/home_page.dart';
import 'package:wheels_up/pages/home/home_page_penyewa.dart';

final GlobalKey<NavigatorState> rootKey =
    GlobalKey<NavigatorState>(debugLabel: "root");

class MainAppShell2 extends StatelessWidget {
  MainAppShell2({super.key});

  static final GoRouter _router = GoRouter(
    navigatorKey: rootKey,
    initialLocation: '/',
    redirect: (context, state) {
      final authState = Provider.of<CurrentAuthState>(context, listen: false);
      final isAuthenticated = authState.isAuthenticated;

      // Skip redirect for authenticated routes during hot reload
      if (isAuthenticated && state.matchedLocation != '/') {
        return null;
      }

      if (!isAuthenticated &&
          !state.matchedLocation.startsWith('/landing') &&
          !state.matchedLocation.startsWith('/login') &&
          !state.matchedLocation.startsWith('/signup')) {
        return '/landing';
      }

      if (isAuthenticated &&
          (state.matchedLocation.startsWith('/landing') ||
              state.matchedLocation.startsWith('/login') ||
              state.matchedLocation.startsWith('/signup'))) {
        return '/';
      }

      return null;
    },
    routes: <RouteBase>[
      // Guest routes
      GoRoute(
        path: '/landing',
        builder: (context, state) => const LandingWelcome(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpPage(),
      ),
      // Authenticated routes
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return Scaffold(
            bottomNavigationBar: NavigationBar(
              surfaceTintColor: Colors.grey.shade300,
              backgroundColor: Colors.white,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (int index) =>
                  navigationShell.goBranch(index),
              destinations: mainNavigationDestinations,
            ),
            body: navigationShell,
          );
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <GoRoute>[
              GoRoute(
                  path: '/',
                  builder: (context, state) => const HomePage(),
                  routes: <RouteBase>[
                    GoRoute(
                        path: 'listing',
                        builder: (context, state) {
                          final listing = state.extra as CarListingWithPoster;
                          return ViewListing(data: listing);
                        }),
                    GoRoute(
                        path: 'rentalform',
                        builder: (context, state) {
                          return const RentalFormPage();
                        }),
                  ]),
            ],
          ),
          StatefulShellBranch(
            routes: <GoRoute>[
              GoRoute(
                path: '/home2',
                builder: (context, state) => const HomePagePemilik(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <GoRoute>[
              GoRoute(
                path: '/home3',
                builder: (context, state) => const HomePagePenyewa(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <GoRoute>[
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage2(),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) => const EditProfilePage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _router.routeInformationParser,
      routeInformationProvider: _router.routeInformationProvider,
      routerDelegate: _router.routerDelegate,
    );
  }
}
