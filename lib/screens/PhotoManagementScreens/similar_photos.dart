import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:image_picker/image_picker.dart';

class DuplicateImagesFinder extends StatefulWidget {
  const DuplicateImagesFinder({super.key});

  @override
  _DuplicateImagesFinderState createState() => _DuplicateImagesFinderState();
}

class _DuplicateImagesFinderState extends State<DuplicateImagesFinder> {
  List<AssetEntity> _photos = [];
  bool _isLoading = true;
  List<List<AssetEntity>> duplicateImages = [];

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  Future<void> _loadPhotos() async {
    final result = await PhotoManager.requestPermissionExtend();
    if (result.hasAccess) {
      final albums = await PhotoManager.getAssetPathList(onlyAll: true);
      final recentAlbum = albums.first;
      final recentPhotos = await recentAlbum.getAssetListRange(
        start: 0,
        end: await recentAlbum.assetCountAsync,
      );

      final imageAssets = recentPhotos.where((asset) =>
      asset.type == AssetType.image &&
          asset.mimeType!.startsWith('image/') &&
          asset.title?.toLowerCase().contains('screenshot') == true);

      setState(() {
        _photos = imageAssets.toList();
        _isLoading = false;
      });
    }
  }

  Future<void> _findDuplicates() async {
    if (_photos.isEmpty) {
      print('No photos to find duplicates from.');
      return;
    }

    print('Finding duplicate images...');
    final Map<String, List<AssetEntity>> imageMap = {};

    for (var asset in _photos) {
      final String hash = await calculateHash(asset);
      if (imageMap.containsKey(hash)) {
        imageMap[hash]!.add(asset);
      } else {
        imageMap[hash] = [asset];
      }
    }

    setState(() {
      duplicateImages = imageMap.values.where((list) => list.length > 1).toList();
    });

    print('Duplicate images found: ${duplicateImages.length} groups');
  }

  Future<String> calculateHash(AssetEntity asset) async {
    final file = await asset.file;
    final bytes = await file!.readAsBytes();
    final digest = sha256.convert(bytes);
    return digest.toString();
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
          color: Colors.black,
        ),
        title: const Text(
          'Duplicate Images',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'alk',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _findDuplicates,
            child: Text('Find Duplicate Images'),
          ),
          if (duplicateImages.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: duplicateImages.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      Text('Duplicate Group ${index + 1}'),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: duplicateImages[index].length,
                        itemBuilder: (context, subIndex) {
                          return FutureBuilder<File?>(
                            future: duplicateImages[index][subIndex].file,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (!snapshot.hasData) {
                                return Text('Error: Unable to load image');
                              } else {
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
                                    child: Image.file(
                                      snapshot.data!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}


///Photo Gallery
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


///Backup of original

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:crypto/crypto.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class ImageDuplicateFinder extends StatefulWidget {
//   const ImageDuplicateFinder({super.key});
//
//   @override
//   _ImageDuplicateFinderState createState() => _ImageDuplicateFinderState();
// }
//
// class _ImageDuplicateFinderState extends State<ImageDuplicateFinder> {
//   final ImagePicker _picker = ImagePicker();
//   List<XFile>? images;
//   List<List<XFile>> duplicateImages = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Duplicate Finder'),
//       ),
//       body: Column(
//         children: <Widget>[
//           ElevatedButton(
//             onPressed: _pickImages,
//             child: Text('Select Images'),
//           ),
//           if (images != null)
//             ElevatedButton(
//               onPressed: _findDuplicates,
//               child: Text('Find Duplicates'),
//             ),
//           if (duplicateImages.isNotEmpty)
//             Expanded(
//               child: ListView.builder(
//                 itemCount: duplicateImages.length,
//                 itemBuilder: (context, index) {
//                   return Column(
//                     children: <Widget>[
//                       Text('Duplicate Group ${index + 1}'),
//                       ListView.builder(
//                         shrinkWrap: true,
//                         physics: NeverScrollableScrollPhysics(),
//                         itemCount: duplicateImages[index].length,
//                         itemBuilder: (context, subIndex) {
//                           return FutureBuilder<void>(
//                             future: _loadImage(duplicateImages[index][subIndex]),
//                             builder: (context, snapshot) {
//                               if (snapshot.connectionState == ConnectionState.waiting) {
//                                 return CircularProgressIndicator(); // Display a loading indicator while the image is being loaded.
//                               } else if (snapshot.hasError) {
//                                 return Text('Error: ${snapshot.error}');
//                               } else {
//                                 return Image.file(File(duplicateImages[index][subIndex].path));
//                               }
//                             },
//                           );
//                         },
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _loadImage(XFile imageFile) async {
//     final completer = Completer<void>();
//     final image = Image.file(File(imageFile.path));
//     image.image.resolve(ImageConfiguration()).addListener(
//       ImageStreamListener((_, __) {
//         completer.complete();
//       }),
//     );
//     return completer.future;
//   }
//
//   void _pickImages() async {
//     if (await requestGalleryPermission()) {
//       List<XFile>? pickedImages = await _picker.pickMultiImage();
//       setState(() {
//         images = pickedImages;
//       });
//     } else {
//       // Handle permission denied
//     }
//   }
//
//   Future<bool> requestGalleryPermission() async {
//     if (Platform.isAndroid && int.parse(Platform.version.split('.')[0]) < 13) {
//       // For Android versions below 13, use the old permission system
//       final status = await Permission.storage.request();
//       return status.isGranted;
//     } else {
//       // For Android 13 and above, and for iOS, use the new permission system
//       final status = await Permission.photos.request();
//       return status.isGranted;
//     }
//   }
//
//   void _findDuplicates() {
//     if (images == null) {
//       return;
//     }
//
//     final Map<String, List<XFile>> imageMap = {};
//
//     for (var image in images!) {
//       final String hash = calculateHash(image);
//       print("Hash: $hash"); // Add this line to check the hash values
//       if (imageMap.containsKey(hash)) {
//         imageMap[hash]!.add(image);
//       } else {
//         imageMap[hash] = [image];
//       }
//     }
//
//     print("Duplicate Images Map: $imageMap"); // Add this line to check the imageMap
//     setState(() {
//       duplicateImages = imageMap.values.where((list) => list.length > 1).toList();
//       print("duplicateImages.length"+duplicateImages.length.toString());
//
//     });
//   }
//
//   String calculateHash(XFile image) {
//     final bytes = File(image.path).readAsBytesSync();
//     final digest = sha256.convert(bytes);
//     return digest.toString();
//   }
// }