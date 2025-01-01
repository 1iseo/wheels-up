import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wheels_up_v2/auth/auth_provider.dart';
import 'package:wheels_up_v2/auth/login_page.dart';
import 'package:wheels_up_v2/auth/signup_page.dart';
import 'package:wheels_up_v2/common/loading_page.dart';
import 'package:wheels_up_v2/home/home_page.dart';
import 'package:wheels_up_v2/landing/landing_page.dart';
import 'package:wheels_up_v2/home/pemilik/home_page_pemilik.dart';
import 'package:wheels_up_v2/listings/listing_page.dart';
import 'package:wheels_up_v2/listings/listings_service.dart';
import 'package:wheels_up_v2/rental/rental_form_page.dart';
import 'package:wheels_up_v2/rental/rental_request_detail_screen.dart';
import 'package:wheels_up_v2/rental/rental_request_list_screen.dart';
import 'package:wheels_up_v2/rental/rental_service.dart';
import 'package:wheels_up_v2/user/edit_profile_page.dart';
import 'package:wheels_up_v2/user/profile_page.dart';

const List<NavigationDestination> mainNavigationDestinations = [
  NavigationDestination(
    icon: Icon(Icons.home_outlined),
    selectedIcon: Icon(
      Icons.home,
      color: Colors.white,
    ),
    label: 'Home',
  ),
  NavigationDestination(
    icon: Icon(Icons.swap_horiz_outlined),
    selectedIcon: Icon(
      Icons.swap_horiz,
      color: Colors.white,
    ),
    label: 'Rental Requests',
  ),
  NavigationDestination(
    icon: Icon(Icons.person_outline),
    selectedIcon: Icon(
      Icons.person,
      color: Colors.white,
    ),
    label: 'Profile',
  ),
];

final GlobalKey<NavigatorState> rootKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

GoRouter? _previousRouter;

final goRouterProvider = Provider<GoRouter>((ref) {
  return _previousRouter = GoRouter(
    navigatorKey: rootKey,
    initialLocation: _previousRouter?.state?.uri.toString() ?? '/',
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      final isAuthenticated = authState.value?.user != null;

      // Skip redirect for authenticated routes during hot reload
      // if (isAuthenticated && state.matchedLocation != '/') {
      //   return null;
      // }
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
                          final listing = state.extra as ListingWithPoster;
                          return ViewListingPage(data: listing);
                        }),
                    GoRoute(
                        path: 'rentalform',
                        builder: (context, state) {
                          final data = state.extra as ListingWithPoster;
                          return RentalFormPage(data: data);
                        }),
                  ]),
            ],
          ),
          // ),
          StatefulShellBranch(
            routes: <GoRoute>[
              GoRoute(
                path: '/rentalrequests',
                builder: (context, state) =>  RentalRequestListPage(),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'detail',
                    builder: (context, state) {
                      final data = state.extra as RentalRequestWithRelations;
                      return RentalRequestDetailScreen(rentalRequest: data);
                    },
                  ),
                ],
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
                    path: 'edit',
                    builder: (context, state) => EditProfilePage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      )
    ],
  );
});
