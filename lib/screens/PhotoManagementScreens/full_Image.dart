import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class FullScreenImage extends StatefulWidget {
  final String imagePath;
  final AssetEntity? asset;

  FullScreenImage({required this.imagePath, this.asset});

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  bool _isDeleting = false;


  void _deleteImage() async {
    if (_isDeleting) return;
    final file = File(widget.imagePath);
    if (file.existsSync()) {
      setState(() {
        _isDeleting = true;
      });
      await file.delete(); // Delete the image from phone storage
      if (widget.asset != null) {
        // If it's an asset from Photo Manager, also remove it from the library
        try {
          await PhotoManager.editor.deleteWithIds([widget.asset!.id]);
        } catch (e) {
          print('Failed to delete asset from Photo Manager: $e');
        }
      }
      Navigator.pop(context, true); // Pass 'true' as a result to indicate deletion
    }
  }


  ///Before setState Callback
  // void _deleteImage() async {
  //   if (_isDeleting) return;
  //   final file = File(widget.imagePath);
  //   if (file.existsSync()) {
  //     setState(() {
  //       _isDeleting = true;
  //     });
  //     await file.delete(); // Delete the image from phone storage
  //     if (widget.asset != null) {
  //       // If it's an asset from Photo Manager, also remove it from the library
  //       try {
  //         await PhotoManager.editor.deleteWithIds([widget.asset!.id]);
  //       } catch (e) {
  //         print('Failed to delete asset from Photo Manager: $e');
  //       }
  //     }
  //     Navigator.pop(context); // Close the fullscreen view
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context); // Close the fullscreen view when tapped
            },
            child: Center(
              child: Hero(
                tag: widget.imagePath, // Unique tag for the Hero animation
                child: Image.file(
                  File(widget.imagePath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 36,
                ),
                onPressed: () {
                  _deleteImage(); // Delete the image when the delete icon is tapped
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}



///Back-up before Delete , Info and swipe

// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:photo_view/photo_view.dart';
//
// class FullScreenImage extends StatelessWidget {
//   final String imagePath;
//
//   FullScreenImage({required this.imagePath});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GestureDetector(
//         onTap: () {
//           Navigator.pop(context); // Close the fullscreen view when tapped
//         },
//         child: Center(
//           child: Hero(
//             tag: imagePath, // Unique tag for the Hero animation
//             child: PhotoView(
//               imageProvider: FileImage(File(imagePath)),
//               minScale: PhotoViewComputedScale.contained,
//               maxScale: PhotoViewComputedScale.covered * 2.0,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
