import 'dart:io';
import 'package:clean_master/screens/dashboard_screens/photo_gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter/cupertino.dart';

import 'package:velocity_x/velocity_x.dart';

import '../widgets/photo_buttons.dart';


class PhotoManagement extends StatefulWidget {
  const PhotoManagement({super.key});

  @override
  State<PhotoManagement> createState() => _PhotoManagementState();
}

class _PhotoManagementState extends State<PhotoManagement> {
  List<AssetEntity> _photos1 = [];
  bool _isLoading = true; // Add loading state

  @override
  void initState() {
    super.initState();
    _loadPhotos1();
  }

  Future<void> _loadPhotos1() async {
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
        _photos1 = imageAssets.toList();
        _isLoading = false; // Mark loading as complete
      });
    }
  }
  // List<AssetEntity> screenshotImages = [];
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _requestStoragePermission();
  //   _loadScreenshotImages();
  // }
  // Future<void> _requestStoragePermission() async {
  //   final status = await Permission.storage.request();
  //   if (status.isGranted) {
  //     // Permission granted, proceed with loading images
  //     _loadScreenshotImages();
  //   } else {
  //     // Handle the case where permission is denied
  //     print('Storage permission denied');
  //   }
  // }
  // Future<void> _loadScreenshotImages() async {
  //   final albums = await PhotoManager.getAssetPathList(onlyAll: true);
  //   AssetPathEntity? screenshots;
  //
  //   for (final album in albums) {
  //     if (album.name == 'Screenshots') {
  //       screenshots = album;
  //       break;
  //     }
  //   }
  //
  //   if (screenshots != null) {
  //     final assets = await screenshots.getAssetListRange(start: 0, end: 100); // Adjust the end value as needed
  //     setState(() {
  //       screenshotImages = assets;
  //     });
  //   } else {
  //     // Handle the case where the 'Screenshots' album is not found
  //     print('Screenshots album not found');
  //   }
  // }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        automaticallyImplyLeading: true,
        title: const Text('Photo Management',style: TextStyle(fontSize: 20,fontFamily: 'alk',fontWeight: FontWeight.bold,color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black, // Change the color to your desired color
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 70.0,left: 16,right: 16,bottom: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  ///TODO: TO be Done
                  photoButtons(icon: Icons.image_outlined,
                      onPressed: (){

                      },
                      title: 'Similar Photos'),
                ],
              ),
              20.heightBox,
              Row(
                children: [
                  // photoButtons(icon: Icons.broken_image, onPressed: (){},title: 'Screenshot'),
                  Expanded(
                    child: Container(
                      //Changed height for better view
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                           BoxShadow(
                            color: CupertinoColors.systemGrey3,
                            blurRadius: 7,
                            spreadRadius: 4,
                          ),
                        ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.broken_image,color: Colors.black,),
                                10.widthBox,
                                const Text('Screenshot',style:
                                TextStyle(fontFamily: 'alk',fontSize: 16,color: Colors.black,overflow: TextOverflow.ellipsis),),
                                //Changed to Spacer to resolve pixels overflow error
                                // 140.widthBox,
                                Spacer(),
                                IconButton(onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PhotoGallery()));
                                }, icon: Icon(Icons.arrow_forward_ios,color: Colors.black38,))
                              ],
                            ),
                            5.heightBox,
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    //Chnaged
                                    height:100,
                                    child: MasonryGridView.builder(
                                      itemCount: _photos1.length,
                                      scrollDirection: Axis.horizontal,
                                      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1,
                                      ),
                                      itemBuilder: (context, index) {
                                        return FutureBuilder<File?>(
                                          future: _photos1[index].file,
                                          builder: (context, snapshot) {
                                            if (
                                            snapshot.hasData) {
                                              return Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(12),
                                                    // boxShadow: [
                                                    //   BoxShadow(
                                                    //     spreadRadius: 2,
                                                    //     // blurRadius: 4
                                                    //   ),
                                                    // ],
                                                    // border: Border.all(
                                                    //   color: Colors.black,
                                                    //   width: 2,
                                                    // ),
                                                  ),
                                                  child: Image(
                                                    image: FileImage(snapshot.data! as File),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return CircularProgressIndicator();
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              20.heightBox,
              Row(
                children: [
                  photoButtons(icon: Icons.blur_circular_outlined, onPressed: (){},title: 'Similar Live Photos'),
                ],
              ),
              20.heightBox,
              Row(
                children: [
                  photoButtons(icon: Icons.photo_camera_back_rounded, onPressed: (){},title: 'Burst Photos'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
