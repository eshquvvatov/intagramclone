import 'package:flutter/material.dart';

Widget UsersInfo({
  required String text,
  required String count,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        count,
        style: const TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        height: 5,
      ),
      Text(
        text,
        style: const TextStyle(color: Colors.grey, fontSize: 16),
      ),
    ],
  );
}

