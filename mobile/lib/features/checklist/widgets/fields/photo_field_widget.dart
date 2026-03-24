import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/utils/image_utils.dart';
import '../../../../../services/location_service.dart';

const _uuid = Uuid();

// Per-photo upload progress: photoLocalPath → 0.0..1.0 (null = not uploading)
final _photoUploadProgressProvider =
StateProvider.family<double?, String>((ref, path) => null);

class PhotoFieldWidget extends ConsumerStatefulWidget {
  final Map<String, dynamic> field;
  final dynamic value;
  final String? error;
  final void Function(dynamic) onChange;
  final String jobId;

  const PhotoFieldWidget({
    super.key,
    required this.field,
    required this.value,
    required this.error,
    required this.onChange,
    required this.jobId,
  });

  @override
  ConsumerState<PhotoFieldWidget> createState() => _PhotoFieldWidgetState();
}

class _PhotoFieldWidgetState extends ConsumerState<PhotoFieldWidget> {
  List<String> get _photos =>
      (widget.value as List<dynamic>?)?.cast<String>() ?? [];

  int get _maxPhotos => (widget.field['max_photos'] as int?) ?? 3;

  Future<void> _capture() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty || !mounted) return;

    final result = await Navigator.push<String?>(
      context,
      MaterialPageRoute(builder: (_) => _CameraPage(camera: cameras.first)),
    );
    if (result == null) return;

    final pos = await ref.read(locationServiceProvider).getCurrentPosition();
    final processed = await ImageUtils.processPhoto(
      File(result),
      latitude:  pos?.latitude,
      longitude: pos?.longitude,
    );

    widget.onChange([..._photos, processed.path]);
  }

  void _remove(int index) {
    final updated = List<String>.from(_photos)..removeAt(index);
    widget.onChange(updated);
  }

  @override
  Widget build(BuildContext context) {
    final label =
        '${widget.field['label']}${widget.field['required'] == true ? ' *' : ''}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: [
            ..._photos.asMap().entries.map((e) => _PhotoThumb(
              path: e.value,
              onRemove: () => _remove(e.key),
            )),
            if (_photos.length < _maxPhotos)
              _AddPhotoButton(onTap: _capture),
          ],
        ),
        if (widget.error != null) ...[
          const SizedBox(height: 4),
          Text(widget.error!,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.error, fontSize: 12)),
        ],
      ],
    );
  }
}

class _PhotoThumb extends ConsumerWidget {
  final String path;
  final VoidCallback onRemove;
  const _PhotoThumb({required this.path, required this.onRemove});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(_photoUploadProgressProvider(path));

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(File(path),
              width: 80, height: 80, fit: BoxFit.cover),
        ),
        // Upload progress overlay
        if (progress != null && progress < 1.0)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: Colors.black45,
                child: Center(
                  child: SizedBox(
                    width: 36, height: 36,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        // Uploaded checkmark
        if (progress == 1.0)
          Positioned(
            bottom: 4, right: 4,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                  color: Colors.green, shape: BoxShape.circle),
              child: const Icon(Icons.check, size: 12, color: Colors.white),
            ),
          ),
        // Remove button (only when not uploading)
        if (progress == null || progress == 1.0)
          Positioned(
            top: 2, right: 2,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                    color: Colors.black54, shape: BoxShape.circle),
                child: const Icon(Icons.close, size: 14, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}

class _AddPhotoButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddPhotoButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80, height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade100,
        ),
        child: const Icon(Icons.add_a_photo_outlined, color: Colors.grey),
      ),
    );
  }
}

// ── Camera page ───────────────────────────────────────────────────────────────

class _CameraPage extends StatefulWidget {
  final CameraDescription camera;
  const _CameraPage({required this.camera});

  @override
  State<_CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<_CameraPage> {
  late CameraController _ctrl;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _ctrl = CameraController(widget.camera, ResolutionPreset.high);
    _ctrl.initialize().then((_) {
      if (!mounted) return;
      setState(() => _ready = true);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _shoot() async {
    final xFile = await _ctrl.takePicture();
    if (mounted) Navigator.pop(context, xFile.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _ready
          ? Stack(fit: StackFit.expand, children: [
        CameraPreview(_ctrl),
        Positioned(
          bottom: 32, left: 0, right: 0,
          child: Center(
            child: FloatingActionButton.large(
              heroTag: 'capture',
              onPressed: _shoot,
              backgroundColor: Colors.white,
              child: const Icon(Icons.camera_alt, color: Colors.black),
            ),
          ),
        ),
        Positioned(
          top: 40, left: 16,
          child: IconButton(
            icon: const Icon(Icons.close,
                color: Colors.white, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ])
          : const Center(
          child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}