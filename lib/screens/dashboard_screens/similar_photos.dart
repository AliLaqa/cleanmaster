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