import 'package:clean_master/screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}


//
// class ImageDuplicateFinder extends StatefulWidget {
//   @override
//   _ImageDuplicateFinderState createState() => _ImageDuplicateFinderState();
// }
//
// class _ImageDuplicateFinderState extends State<ImageDuplicateFinder> {
//   final ImagePicker _picker = ImagePicker();
//   List<XFile>? images;
//   Map<String, List<XFile>> imageMap = {};
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
//           if (imageMap.isNotEmpty)
//             Expanded(// this is the function need to convert into gridview
//               child: ListView(
//                 children: imageMap.values
//                     .where((list) => list.length > 1)
//                     .map((list) {
//                   return Column(
//                     children: list.map((image) {
//                       return Image.file(File(image.path));
//                     }).toList(),
//                   );
//                 }).toList(),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   void _pickImages() async {
//     await requestGalleryPermission();
//     List<XFile>? pickedImages = await _picker.pickMultiImage();
//     if (pickedImages != null) {
//       setState(() {
//         images = pickedImages;
//       });
//     }
//   }
//
//   String calculateHash(XFile image) {
//     final bytes = File(image.path).readAsBytesSync();
//     final hash = md5.convert(bytes);
//     return hash.toString();
//   }
//
//   void _findDuplicates() {
//     if (images == null) {
//       return;
//     }
//
//     imageMap.clear();
//
//     for (var image in images!) {
//       String hash = calculateHash(image);
//
//       if (imageMap.containsKey(hash)) {
//         imageMap[hash]!.add(image);
//       } else {
//         imageMap[hash] = [image];
//       }
//     }
//
//     setState(() {});
//   }
//   // Request gallery permission
//   static requestGalleryPermission() async {
//     final status = await Permission.photos.request();
//
//     if (status != PermissionStatus.granted) {
//       print('Gallery permission not granted');
//     } else {
//       print('Gallery permission granted');
//     }
//   }
// }
