import 'package:flutter/material.dart';

class CustomerTile extends StatelessWidget {
  final String name;
  final String email;
  final String phoneNumber;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CustomerTile({
    Key? key,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(email),
            Text(phoneNumber),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}