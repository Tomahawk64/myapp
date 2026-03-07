import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class VideoUploadScreen extends StatefulWidget {
  final String bookingId;

  const VideoUploadScreen({super.key, required this.bookingId});

  @override
  State<VideoUploadScreen> createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends State<VideoUploadScreen> {
  XFile? _videoFile;
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  Future<void> _pickVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() {
        _videoFile = video;
      });
    }
  }

  Future<void> _uploadVideo() async {
    if (_videoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a video first.')),
      );
      return;
    }

    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Video upload is available on mobile only.'),
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('pooja_proof_videos/${widget.bookingId}/${DateTime.now().millisecondsSinceEpoch}.mp4');

      final bytes = await _videoFile!.readAsBytes();
      final uploadTask = storageRef.putData(bytes);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        if (mounted) {
          setState(() {
            _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
          });
        }
      });

      await uploadTask;
      final downloadUrl = await storageRef.getDownloadURL();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload successful! URL: $downloadUrl')),
        );
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload video: ${e.message}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Pooja Proof'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _videoFile == null
                  ? const Column(
                      children: [
                        Icon(Icons.video_library, size: 64, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('No video selected.', style: TextStyle(color: Colors.grey)),
                      ],
                    )
                  : Text(
                      'Selected: ${_videoFile!.name}',
                      textAlign: TextAlign.center,
                    ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _pickVideo,
                icon: const Icon(Icons.video_library),
                label: const Text('Select Video'),
              ),
              const SizedBox(height: 20),
              if (_isUploading) ...[
                LinearProgressIndicator(value: _uploadProgress),
                const SizedBox(height: 8),
                Text('${(_uploadProgress * 100).toStringAsFixed(0)}%'),
                const SizedBox(height: 20),
              ],
              ElevatedButton.icon(
                onPressed: _isUploading ? null : _uploadVideo,
                icon: const Icon(Icons.cloud_upload),
                label: const Text('Upload Video'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
