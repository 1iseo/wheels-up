import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wheels_up/models/car_listing.dart';
import 'package:wheels_up/pages/home/home_page_pemilik.dart';
import 'package:wheels_up/pages/landing_welcome.dart';
import 'package:wheels_up/pages/login_page.dart';
import 'package:wheels_up/pages/profile/profile_page.dart';
import 'package:wheels_up/pages/signup_page.dart';
import 'package:wheels_up/pages/view_listing.dart';
import 'package:wheels_up/services/auth_service.dart';
import 'package:wheels_up/widgets/navigation_destinations.dart';
import 'package:wheels_up/pages/home/home_page.dart';
import 'package:wheels_up/pages/home/home_page_penyewa.dart';

final GlobalKey<NavigatorState> rootKey =
    GlobalKey<NavigatorState>(debugLabel: "root");
final GlobalKey<NavigatorState> m1 =
    GlobalKey<NavigatorState>(debugLabel: "m1");
final GlobalKey<NavigatorState> m2 =
    GlobalKey<NavigatorState>(debugLabel: "m2");
final GlobalKey<NavigatorState> m3 =
    GlobalKey<NavigatorState>(debugLabel: "m3");
final GlobalKey<NavigatorState> m4 =
    GlobalKey<NavigatorState>(debugLabel: "m4");

class MainAppShell2 extends StatelessWidget {
  final bool isAuthenticated;
  final void Function(bool) onAuthenticationUpdate;
  const MainAppShell2(
      {super.key,
      required this.isAuthenticated,
      required this.onAuthenticationUpdate});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: isAuthenticated
          ? GoRouter(
              navigatorKey: rootKey,
              initialLocation: '/',
              routes: <RouteBase>[
                  StatefulShellRoute.indexedStack(
                    builder: (context, state, navigationShell) {
                      return Scaffold(
                        bottomNavigationBar: NavigationBar(
                          labelBehavior: NavigationDestinationLabelBehavior
                              .onlyShowSelected,
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
                        navigatorKey: m1,
                        routes: <GoRoute>[
                          GoRoute(
                              path: '/',
                              builder: (context, state) => const HomePage(),
                              routes: <RouteBase>[
                                GoRoute(
                                    path: '/listing',
                                    builder: (context, state) {
                                      final listing =
                                          state.extra as CarListing2;
                                      return ViewListing(listing: listing);
                                    }),
                              ]),
                        ],
                      ),
                      StatefulShellBranch(
                        navigatorKey: m2,
                        routes: <GoRoute>[
                          GoRoute(
                            path: '/home2',
                            builder: (context, state) =>
                                const HomePagePemilik(),
                          ),
                        ],
                      ),
                      StatefulShellBranch(
                        navigatorKey: m3,
                        routes: <GoRoute>[
                          GoRoute(
                            path: '/home3',
                            builder: (context, state) =>
                                const HomePagePenyewa(),
                          ),
                        ],
                      ),
                      StatefulShellBranch(
                        navigatorKey: m4,
                        routes: <GoRoute>[
                          GoRoute(
                            path: '/profile',
                            builder: (context, state) => ProfilePage(
                              notifyAuthChanged: onAuthenticationUpdate,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ])
          : GoRouter(
              initialLocation: '/landing',
              routes: <RouteBase>[
                GoRoute(
                  path: '/landing',
                  builder: (context, state) => const LandingWelcome(),
                ),
                GoRoute(
                  path: '/login',
                  builder: (context, state) => LoginPage(
                    notifyAuthChanged: onAuthenticationUpdate,
                  ),
                ),
                GoRoute(
                  path: '/signup',
                  builder: (context, state) => SignUpPage(
                    notifyAuthChanged: onAuthenticationUpdate,
                  ),
                ),
              ],
            ),
    );
  }
}
