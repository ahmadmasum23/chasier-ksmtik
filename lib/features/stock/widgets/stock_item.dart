// import 'package:flutter/material.dart';

// class StockItem extends StatelessWidget {
//   final String productName;
//   final int quantity;
//   final String location;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;

//   const StockItem({
//     Key? key,
//     required this.productName,
//     required this.quantity,
//     required this.location,
//     required this.onEdit,
//     required this.onDelete,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: ListTile(
//         title: Text(productName),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Quantity: $quantity'),
//             Text('Location: $location'),
//           ],
//         ),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.edit),
//               onPressed: onEdit,
//             ),
//             IconButton(
//               icon: const Icon(Icons.delete),
//               onPressed: onDelete,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }