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
    icon: Icon(Icons.car_rental_outlined),
    selectedIcon: Icon(
      Icons.miscellaneous_services,
      color: Colors.black,
    ),
    label: 'Rental Requests',
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
