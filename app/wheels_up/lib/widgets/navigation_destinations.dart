import 'package:flutter/material.dart';

const List<NavigationDestination> mainNavigationDestinations = [
  NavigationDestination(
    icon: Icon(Icons.home_outlined),
    selectedIcon: Icon(
      Icons.home,
      color: Colors.black,
    ),
    label: 'Home',
  ),
  NavigationDestination(
    icon: Icon(Icons.chat_outlined),
    selectedIcon: Icon(
      Icons.chat,
      color: Colors.black,
    ),
    label: "Chat"
  ),
  NavigationDestination(
    icon: Icon(Icons.favorite_outline),
    selectedIcon: Icon(
      Icons.favorite,
      color: Colors.black,
    ),
    label: 'Favorite',
  ),
  NavigationDestination(
    icon: Icon(Icons.person_outline),
    selectedIcon: Icon(
      Icons.person,
      color: Colors.black,
    ),
    label: 'Profile',
  ),
];
