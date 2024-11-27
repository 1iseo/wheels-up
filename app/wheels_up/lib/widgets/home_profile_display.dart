import 'package:flutter/material.dart';

class HomeProfileDisplay extends StatelessWidget {
  const HomeProfileDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=880&q=80'),
            ),
            SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Halo!"),
                Text(
                  "Baby Zoo",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                )
              ],
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () => {},
          iconSize: 24,
          icon: const Icon(Icons.notifications),
          color: Colors.black,
        )
      ],
    );
  }
}
