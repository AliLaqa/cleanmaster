import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'full_Image.dart';
import 'dart:async';
import 'dart:io';

class PhotoGallery extends StatefulWidget {
  const PhotoGallery({super.key});

  @override
  _PhotoGalleryState createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  ///For all Images
  List<AssetEntity> _photos = [];
  bool _isLoading = true; // Add loading state
  ///For duplicate Images
  List<List<AssetEntity>> duplicatePhotos = [];
  ///For number of images scanned
  int imagesScanned = 0;
  ///For showing CircularProgressIndicator until all the images have been scanned.
  bool _isFindingDuplicates = false;

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  ///For Loading Image Files from Phone
  Future<void> _loadPhotos() async {
    final result = await PhotoManager.requestPermissionExtend();
    if (result.hasAccess) {
      final albums = await PhotoManager.getAssetPathList(onlyAll: true);
      final recentAlbum = albums.first;
      final recentPhotos = await recentAlbum.getAssetListRange(
        start: 0,
        end: await recentAlbum.assetCountAsync,
      );

      // Filter out non-image assets
      final imageAssets = recentPhotos.where((asset) =>
      asset.type == AssetType.image &&
          asset.mimeType!.startsWith('image/'));

      setState(() {
        _photos = imageAssets.toList();
        _isLoading = false; // Mark loading as complete
      });
    }
  }

  /// For Finding Duplicate Image Files
  void _findDuplicate() async {
    print("_findDuplicate function called---------------------------->");
    // Setting the bool flag to true when finding duplicates starts to show CircularProgressIndicator
    setState(() {
      _isFindingDuplicates = true;
    });

    if (_photos.isEmpty) {
      return print("Found no images on Phone to scan for duplicate images,Please check _loadPhotos() Function if Images are present on phone but not showing on Screen before scanning for duplicate images");
    }
    print("Scanning for duplicate images---------------------------->");
    //Made List "photoMap" to store found duplicate images below
    final Map<String, List<AssetEntity>> photoMap = {};

    for (var photo in _photos) {
      final String hash = await _calculateHash(photo); // Await here
      print("Hash: $hash"); // Add this line to check the hash values
      if (photoMap.containsKey(hash)) {
        print("Adding found duplicate images in photoMap List-------------->");
        photoMap[hash]!.add(photo);
        ///TODO: Call Navigation to Duplicate Image Screen.
      } else {
        photoMap[hash] = [photo];
      }
    }
    print("Found these duplicate images: $photoMap in photoMap =>");

    setState(() {
      print("assigning photoMap images to duplicatePhotos List below to display on screen");
      duplicatePhotos = photoMap.values.where((list) => list.length > 1).toList();
      print("DuplicatePhotos.length found${duplicatePhotos.length} duplicate images");
      // Setting the bool flag back to false when finding duplicates is completed to stop CircularProgressIndicator.
      _isFindingDuplicates = false;
    });
    ////Navigate User to DuplicateImageScreen after scanning is complete.
    _showDuplicateImagesScreen();
  }

  Future<String> _calculateHash(AssetEntity photo) async {
    imagesScanned++;
    ///Showing how many Images have been scanned
    print("_calculateHash Function scanned $imagesScanned Images" );
    final file = await photo.file;
    if (file != null) {
      final bytes = await file.readAsBytes();
      final digest = sha256.convert(bytes);
      return digest.toString();
    } else {
      // Handle the case where the file is null (e.g., file not found)
      return ''; // Return an empty string or handle it differently
    }
  }

  void _showDuplicateImagesScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DuplicateImagesScreen(
          duplicatePhotos: duplicatePhotos,
        ),
      ),
    );
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
        title: const Text('Simillar Photos Finder',style: TextStyle(fontSize: 20,fontFamily: 'alk',fontWeight: FontWeight.bold,color: Colors.black),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            _photos.isEmpty ?
                Center(child: CircularProgressIndicator()) :
            Expanded(
              flex: 1,
              child: MasonryGridView.builder(
                itemCount: _photos.length,
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {

                  return GestureDetector(
                    onLongPress: () {

                    },
                    onTap: () async {
                      final file = await _photos[index].file;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FullScreenImage(
                            imagePath: file?.path ?? '', // Pass the image path to fullscreen screen
                          ),
                        ),
                      );
                    },
                    child: FutureBuilder<File?>(
                      future: _photos[index].file,
                      builder: (context, snapshot) {
                        if (
                        snapshot.hasData) {
                          return Padding(
                            padding: EdgeInsets.all(8),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(3, 3),
                                      spreadRadius: 1,
                                      blurRadius: 4
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
                  );
                },
              ),
            ),
            // _photos.isNotEmpty && _isFindingDuplicates == false ?
            _isFindingDuplicates == false ?
            Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    _findDuplicate();
                    // _showDuplicateImagesScreen();
                  },
                  child: Text("Find Duplicate")
                  // child: _isFindingDuplicates
                  //     ? CircularProgressIndicator()
                  //     : Text("Find Duplicate"),
                ),
              ) : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  strokeWidth: 5,
                  color: Colors.blue,
                ),
                SizedBox(width: 5,),
                Text('Searching for Simillar Images',
                  style: TextStyle(fontSize: 12,fontFamily: 'alk',fontWeight: FontWeight.bold,color: Colors.black),),
              ],
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}

class DuplicateImagesScreen extends StatelessWidget {
  final List<List<AssetEntity>> duplicatePhotos;

  DuplicateImagesScreen({required this.duplicatePhotos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Duplicate Images'),
      ),
      body: ListView.builder(
        itemCount: duplicatePhotos.length,
        itemBuilder: (context, index) {
          final duplicateList = duplicatePhotos[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Duplicate Set ${index + 1}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: duplicateList.map((photo) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 100,
                        height: 100,
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
                        child: FutureBuilder<File?>(
                          future: photo.file,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Image.file(
                                snapshot.data!,
                                fit: BoxFit.cover,
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

///Working Code before CircularProgressIndicator

// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:photo_manager/photo_manager.dart';
// import 'package:flutter/material.dart';
// import 'package:crypto/crypto.dart';
// import 'full_Image.dart';
// import 'dart:async';
// import 'dart:io';
//
// class PhotoGallery extends StatefulWidget {
//   const PhotoGallery({super.key});
//
//   @override
//   _PhotoGalleryState createState() => _PhotoGalleryState();
// }
//
// class _PhotoGalleryState extends State<PhotoGallery> {
//   ///For all Images
//   List<AssetEntity> _photos = [];
//   bool _isLoading = true; // Add loading state
//   ///For duplicate Images
//   List<List<AssetEntity>> duplicatePhotos = [];
//   ///For number of images scanned
//   int imagesScanned = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadPhotos();
//   }
//
//   ///For Loading Image Files from Phone
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
//           asset.mimeType!.startsWith('image/'));
//
//       setState(() {
//         _photos = imageAssets.toList();
//         _isLoading = false; // Mark loading as complete
//       });
//     }
//   }
//
//   /// For Finding Duplicate Image Files
//   void _findDuplicate() async {
//     print("_findDuplicate function called---------------------------->");
//     if (_photos.isEmpty) {
//       return print("Found no images on Phone to scan for duplicate images,Please check _loadPhotos() Function if Images are present on phone but not showing on Screen before scanning for duplicate images");
//     }
//     print("Scanning for duplicate images---------------------------->");
//     //Made List "photoMap" to store found duplicate images below
//     final Map<String, List<AssetEntity>> photoMap = {};
//
//     for (var photo in _photos) {
//       final String hash = await _calculateHash(photo); // Await here
//       print("Hash: $hash"); // Add this line to check the hash values
//       if (photoMap.containsKey(hash)) {
//         print("Adding found duplicate images in photoMap List-------------->");
//         photoMap[hash]!.add(photo);
//         ///TODO: Call Navigation to Duplicate Image Screen.
//       } else {
//         photoMap[hash] = [photo];
//       }
//     }
//     print("Found these duplicate images: $photoMap in photoMap =>");
//
//     setState(() {
//       print("assigning photoMap images to duplicatePhotos List below to display on screen");
//       duplicatePhotos = photoMap.values.where((list) => list.length > 1).toList();
//       print("DuplicatePhotos.length found${duplicatePhotos.length} duplicate images");
//     });
//   }
//
//   Future<String> _calculateHash(AssetEntity photo) async {
//     imagesScanned++;
//     ///Showing how many Images have been scanned
//     print("_calculateHash Function scanned $imagesScanned Images" );
//     final file = await photo.file;
//     if (file != null) {
//       final bytes = await file.readAsBytes();
//       final digest = sha256.convert(bytes);
//       return digest.toString();
//     } else {
//       // Handle the case where the file is null (e.g., file not found)
//       return ''; // Return an empty string or handle it differently
//     }
//   }
//
//   void _showDuplicateImagesScreen() {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => DuplicateImagesScreen(
//           duplicatePhotos: duplicatePhotos,
//         ),
//       ),
//     );
//   }
//
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
//               flex: 1,
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
//             if(_photos.isNotEmpty)
//               ElevatedButton(
//                   onPressed: (){
//                     _findDuplicate();
//                     _showDuplicateImagesScreen();
//                   },
//                   child: Text("Find Duplicate")),
//             SizedBox(
//               height: 20,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }



///Backup of original
//
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:crypto/crypto.dart';
// import 'package:permission_handler/permission_handler.dart';

// class ImageDuplicateFinder extends StatefulWidget {
//   const ImageDuplicateFinder({super.key});
//
//   @override
//   _ImageDuplicateFinderState createState() => _ImageDuplicateFinderState();
// }
//
// class _ImageDuplicateFinderState extends State<ImageDuplicateFinder> {
//   final ImagePicker _picker = ImagePicker();
//   ///For selected images
//   List<XFile>? images;
//   ///For duplicated Images
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