import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../../signature/screens/signature_screen.dart';



class SignatureFieldWidget extends StatelessWidget {
  final Map<String, dynamic> field;
  final dynamic value; // Uint8List or null
  final String? error;
  final void Function(dynamic) onChange;
  final String jobId;

  const SignatureFieldWidget({
    super.key, required this.field, required this.value,
    required this.error, required this.onChange, required this.jobId,
  });

  @override
  Widget build(BuildContext context) {
    final label = '${field['label']}${field['required'] == true ? ' *' : ''}';
    final bytes = value as Uint8List?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SignatureScreen(onSigned: onChange),
            ),
          ),
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(
                color: error != null
                    ? Theme.of(context).colorScheme.error
                    : Colors.grey.shade400,
              ),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade50,
            ),
            child: bytes != null
                ? Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Image.memory(bytes,
                      fit: BoxFit.contain, width: double.infinity),
                ),
                Positioned(
                  top: 4, right: 4,
                  child: GestureDetector(
                    onTap: () => onChange(null),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.refresh,
                          size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
                : const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.draw_outlined, color: Colors.grey),
                  Text('Tap to sign',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: 4),
          Text(error!,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.error, fontSize: 12)),
        ],
      ],
    );
  }
}