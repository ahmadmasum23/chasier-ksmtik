// import 'package:flutter/material.dart';

// class OnboardingItem extends StatelessWidget {
//   final String title;
//   final String description;
//   final String imageUrl;

//   const OnboardingItem({
//     Key? key,
//     required this.title,
//     required this.description,
//     required this.imageUrl,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Image.asset(
//           imageUrl,
//           height: 200,
//           width: 200,
//         ),
//         const SizedBox(height: 30),
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//           textAlign: TextAlign.center,
//         ),
//         const SizedBox(height: 16),
//         Text(
//           description,
//           style: const TextStyle(
//             fontSize: 16,
//             color: Colors.grey,
//           ),
//           textAlign: TextAlign.center, 
//         ),
//       ],
//     );
//   }
// }