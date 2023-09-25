import 'package:clean_master/Helpers/RequestPermissionHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:io';

import 'full_Image.dart';

class ScreenshotsGallery extends StatefulWidget {
  const ScreenshotsGallery({Key? key}) : super(key: key);

  @override
  _ScreenshotsGalleryState createState() => _ScreenshotsGalleryState();
}

class _ScreenshotsGalleryState extends State<ScreenshotsGallery> {
  List<AssetEntity> _photos = [];
  bool _isLoading = true; // Add loading state

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }



  Future<void> _loadPhotos() async {
    if (permissionsGranted = true) {
      final albums = await PhotoManager.getAssetPathList(onlyAll: true);
      final recentAlbum = albums.first;
      final recentPhotos = await recentAlbum.getAssetListRange(
        start: 0,
        end: await recentAlbum.assetCountAsync,
      );

      // Filter out non-image assets
      final imageAssets = recentPhotos.where((asset) =>
      // asset.type == AssetType.image &&
      //     asset.mimeType!.startsWith('image/'));
      asset.mimeType!.startsWith('image/') &&
          asset.title?.toLowerCase().contains('screenshot') == true);

      setState(() {
        _photos = imageAssets.toList();
        // Mark loading as complete
        _isLoading = false;
      });
    } else {
      RequestPermission(context);
      _loadPhotos();
    }
  }

  void _deleteImage(int index) async {
    final asset = _photos[index];
    final file = await asset.file;

    if (file != null && await file.exists()) {
      // Check if permission is granted
      final status = await Permission.storage.request();

      if (status.isGranted) {
        // Permission granted, proceed with deletion
        await file.delete(); // This will delete the image from the phone
        setState(() {
          _photos.removeAt(index);
        });
      } else {
        print('Storage Permission denied therefore unable to delete the image, coming from _deleteImage Function.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black, // Change the color to your desired color
        ),
        title: const Text(
          'Screenshots',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'alk',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Expanded(
              child: MasonryGridView.builder(
                itemCount: _photos.length,
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      final file = await _photos[index].file;
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FullScreenImage(
                            imagePath: file?.path ?? '',
                          ),
                        ),
                      );
                      if (result == true) {
                        // Image was deleted, refresh the _photos list
                        setState(() {
                          _photos.removeAt(index);
                        });
                      }
                    },

                    ///Before setState callback
                    // onTap: () async {
                    //   final file = await _photos[index].file;
                    //   Navigator.of(context).push(
                    //     MaterialPageRoute(
                    //       builder: (context) => FullScreenImage(
                    //         imagePath: file?.path ?? '',
                    //       ),
                    //     ),
                    //   );
                    // },
                    child: Stack(
                      children: [
                        FutureBuilder<File?>(
                          future: _photos[index].file,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                padding: EdgeInsets.all(8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(3, 3),
                                        spreadRadius: 1,
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Image(
                                    image: FileImage(snapshot.data!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              _deleteImage(index); // Delete the image when the delete icon is tapped
                            },
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red, // Change to your desired color
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// Wrapping with Gesture Detector to navigate the user to show full screen image on FullScreen Image Class
///Backup getting All Images, Needs to change to get only ScreenShots.

// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:photo_manager/photo_manager.dart';
// import 'dart:io';
// import 'full_Image.dart';
//
// class PhotoGallery extends StatefulWidget {
//   const PhotoGallery({super.key});
//
//   @override
//   _PhotoGalleryState createState() => _PhotoGalleryState();
// }
//
// class _PhotoGalleryState extends State<PhotoGallery> {
//   List<AssetEntity> _photos = [];
//   bool _isLoading = true; // Add loading state
//
//   @override
//   void initState() {
//     super.initState();
//     _loadPhotos();
//   }
//
//   Future<void> _loadPhotos() async {
//     final result = await PhotoManager.requestPermissionExtend();
//     if (result.hasAccess) {
//       final albums = await PhotoManager.getAssetPathList(onlyAll: true);
//       final recentAlbum = albums.first;
//       final recentPhotos = await recentAlbum.getAssetListRange(
//         start: 0,
//         end: await recentAlbum.assetCountAsync,
//       );
//
//       // Filter out non-image assets
//       final imageAssets = recentPhotos.where((asset) =>
//       asset.type == AssetType.image &&
//           asset.mimeType!.startsWith('image/')&&
//           asset.title?.toLowerCase().contains('screenshot') == true);
//
//       setState(() {
//         _photos = imageAssets.toList();
//         _isLoading = false; // Mark loading as complete
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: const IconThemeData(
//           color: Colors.black, // Change the color to your desired color
//         ),
//         title: const Text('Screenshots',style: TextStyle(fontSize: 20,fontFamily: 'alk',fontWeight: FontWeight.bold,color: Colors.black),),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8),
//         child: Column(
//           children: [
//             Expanded(
//               child: MasonryGridView.builder(
//                 itemCount: _photos.length,
//                 gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                 ),
//                 itemBuilder: (context, index) {
//
//                   return GestureDetector(
//                     onLongPress: () {
//
//                     },
//                     onTap: () async {
//                       final file = await _photos[index].file;
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => FullScreenImage(
//                             imagePath: file?.path ?? '', // Pass the image path to fullscreen screen
//                           ),
//                         ),
//                       );
//                     },
//                     child: FutureBuilder<File?>(
//                       future: _photos[index].file,
//                       builder: (context, snapshot) {
//                         if (
//                         snapshot.hasData) {
//                           return Padding(
//                             padding: EdgeInsets.all(8),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 boxShadow: [
//                                   BoxShadow(
//                                       offset: Offset(3, 3),
//                                       spreadRadius: 1,
//                                       blurRadius: 4
//                                   ),
//                                 ],
//                               ),
//                               child: Image(
//                                 image: FileImage(snapshot.data!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           );
//                         } else {
//                           return CircularProgressIndicator();
//                         }
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }