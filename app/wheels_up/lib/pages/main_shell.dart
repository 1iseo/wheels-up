import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wheels_up/models/car_listing.dart';
import 'package:wheels_up/pages/home/home_page_pemilik.dart';
import 'package:wheels_up/pages/landing_welcome.dart';
import 'package:wheels_up/pages/login_page.dart';
import 'package:wheels_up/pages/profile/edit_profile.dart';
import 'package:wheels_up/pages/profile/profile_page.dart';
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

  final GoRouter _router =
      GoRouter(navigatorKey: rootKey, initialLocation: '/', routes: <RouteBase>[
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
                      path: '/listing',
                      builder: (context, state) {
                        final listing = state.extra as CarListing2;
                        return ViewListing(listing: listing);
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
              builder: (context, state) => const ProfilePage(),
              routes: <RouteBase>[
                GoRoute(
                  path: '/edit',
                  builder: (context, state) => const EditProfilePage(),
                ),
              ],
            ),
          ],
        ),
      ],
    )
  ]);

  final GoRouter _guestRouter = GoRouter(
    initialLocation: '/landing',
    routes: <RouteBase>[
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
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentAuthState>(
      builder: (context, authState, child) => MaterialApp.router(
          routerConfig: authState.isAuthenticated ? _router : _guestRouter),
    );
  }
}
