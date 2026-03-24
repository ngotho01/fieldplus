import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class SignatureScreen extends StatefulWidget {
  final void Function(dynamic) onSigned;
  const SignatureScreen({super.key, required this.onSigned});

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  final List<List<Offset>> _strokes = [];
  List<Offset> _current = [];
  bool _exporting = false;

  void _clear() => setState(() {
    _strokes.clear();
    _current = [];
  });

  Future<void> _confirm() async {
    if (_strokes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign before confirming')),
      );
      return;
    }

    setState(() => _exporting = true);

    final recorder = ui.PictureRecorder();
    final canvas   = Canvas(recorder);
    final size     = MediaQuery.of(context).size;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );

    final paint = Paint()
      ..color       = Colors.black
      ..strokeWidth = 3.0
      ..strokeCap   = StrokeCap.round
      ..strokeJoin  = StrokeJoin.round
      ..style       = PaintingStyle.stroke;

    for (final stroke in _strokes) {
      if (stroke.length < 2) continue;
      final path = Path()..moveTo(stroke[0].dx, stroke[0].dy);
      for (int i = 1; i < stroke.length; i++) {
        // Smooth with quadratic bezier
        if (i < stroke.length - 1) {
          final mid = Offset(
            (stroke[i].dx + stroke[i + 1].dx) / 2,
            (stroke[i].dy + stroke[i + 1].dy) / 2,
          );
          path.quadraticBezierTo(
            stroke[i].dx, stroke[i].dy, mid.dx, mid.dy,
          );
        } else {
          path.lineTo(stroke[i].dx, stroke[i].dy);
        }
      }
      canvas.drawPath(path, paint);
    }

    final picture = recorder.endRecording();
    final img     = await picture.toImage(size.width.toInt(), size.height.toInt());
    final data    = await img.toByteData(format: ui.ImageByteFormat.png);
    final bytes   = data!.buffer.asUint8List();

    widget.onSigned(bytes);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Client Signature'),
        actions: [
          TextButton(onPressed: _clear, child: const Text('Clear')),
          TextButton(
            onPressed: _exporting ? null : _confirm,
            child: _exporting
                ? const SizedBox(
              width: 16, height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Text('Confirm'),
          ),
        ],
      ),
      body: GestureDetector(
        onPanStart:  (d) { _current = [d.localPosition]; },
        onPanUpdate: (d) {
          setState(() {
            _current.add(d.localPosition);
            if (_strokes.isEmpty || _strokes.last != _current) {
              _strokes.add(_current);
            }
          });
        },
        onPanEnd: (_) {
          _strokes.add(List<Offset>.from(_current));
          _current = [];
        },
        child: CustomPaint(
          painter: _SignaturePainter(_strokes),
          size: Size.infinite,
          child: _strokes.isEmpty
              ? Center(
            child: Text(
              'Sign here',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 24,
              ),
            ),
          )
              : null,
        ),
      ),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  const _SignaturePainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color       = Colors.black
      ..strokeWidth = 3.0
      ..strokeCap   = StrokeCap.round
      ..strokeJoin  = StrokeJoin.round
      ..style       = PaintingStyle.stroke;

    for (final stroke in strokes) {
      if (stroke.length < 2) continue;
      final path = Path()..moveTo(stroke[0].dx, stroke[0].dy);
      for (int i = 1; i < stroke.length; i++) {
        if (i < stroke.length - 1) {
          final mid = Offset(
            (stroke[i].dx + stroke[i + 1].dx) / 2,
            (stroke[i].dy + stroke[i + 1].dy) / 2,
          );
          path.quadraticBezierTo(stroke[i].dx, stroke[i].dy, mid.dx, mid.dy);
        } else {
          path.lineTo(stroke[i].dx, stroke[i].dy);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_SignaturePainter old) => true;
}