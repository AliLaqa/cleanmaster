import 'dart:io';
import 'package:clean_master/Helpers/RequestPermissionHelper.dart';
import 'package:clean_master/screens/PhotoManagementScreens/screenshots_gallery.dart';
import 'package:clean_master/screens/PhotoManagementScreens/similar_photos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../Helpers/loadScreenshotHelper.dart';
import '../../widgets/photo_buttons.dart';


class PhotoManagement extends StatefulWidget {
  const PhotoManagement({super.key});

  @override
  State<PhotoManagement> createState() => _PhotoManagementState();
}

class _PhotoManagementState extends State<PhotoManagement> {


  @override
  void initState() {
    super.initState();
    LoadScreenshots();
  }

  Future<void> LoadScreenshots() async {
    final loadedScreenshots = await loadingScreenshots();

    setState(() {
      screenShots = loadedScreenshots;
      isLoading = false;
    });
  }

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
        padding: const EdgeInsets.only(top: 20.0,left: 16,right: 16,bottom: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ///Similar Photos Button Start--------------------------->
              // Row(
              //   children: [
              //     ///TODO: TO be Done
              //     photoButtons(icon: Icons.image_outlined,
              //         onPressed: (){
              //
              //         },
              //         title: 'Similar Photos'),
              //   ],
              // ),
              Row(
                children: [
                  // photoButtons(icon: Icons.broken_image, onPressed: (){},title: 'Screenshot'),
                  Expanded(
                    child: Container(
                      //Changed height for better view
                      height: 220,
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
                                const Icon(Icons.image_outlined,color: Colors.black,),
                                10.widthBox,
                                const Text('Similar Photos',style:
                                TextStyle(fontFamily: 'alk',fontSize: 16,color: Colors.black,overflow: TextOverflow.ellipsis),),
                                //Changed to Spacer to resolve pixels overflow error
                                // 140.widthBox,
                                Spacer(),
                                IconButton(onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                      PhotoGallery()));
                                }, icon: Icon(Icons.arrow_forward_ios,color: Colors.black38,))
                              ],
                            ),
                            5.heightBox,
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: Container(
                            //         height:150,
                            //         child: MasonryGridView.builder(
                            //           itemCount: _photos1.length,
                            //           scrollDirection: Axis.horizontal,
                            //           gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            //             crossAxisCount: 1,
                            //           ),
                            //           itemBuilder: (context, index) {
                            //             return FutureBuilder<File?>(
                            //               future: _photos1[index].file,
                            //               builder: (context, snapshot) {
                            //                 if (
                            //                 snapshot.hasData) {
                            //                   return Padding(
                            //                     padding: EdgeInsets.all(8),
                            //                     child: Container(
                            //                       decoration: BoxDecoration(
                            //                         borderRadius: BorderRadius.circular(12),
                            //                         boxShadow: [
                            //                           BoxShadow(
                            //                               blurRadius: 1
                            //                           ),
                            //                         ],
                            //                         border: Border.all(
                            //                           color: Colors.black,
                            //                           width: 1,
                            //                         ),
                            //                       ),
                            //                       child: Image(
                            //                         image: FileImage(snapshot.data! as File),
                            //                         fit: BoxFit.cover,
                            //                       ),
                            //                     ),
                            //                   );
                            //                 } else {
                            //                   return CircularProgressIndicator();
                            //                 }
                            //               },
                            //             );
                            //           },
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ///Similar Photos Button End----------------------------------->
              20.heightBox,
              ///ScreenShot Button start------------------------------------->
              Row(
                children: [
                  // photoButtons(icon: Icons.broken_image, onPressed: (){},title: 'Screenshot'),
                  Expanded(
                    child: Container(
                      //Changed height for better view
                      height: 220,
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
                        padding: const EdgeInsets.all(12.0),
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ScreenshotsGallery()));
                                }, icon: Icon(Icons.arrow_forward_ios,color: Colors.black38,))
                              ],
                            ),
                            5.heightBox,
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height:120,
                                    child: MasonryGridView.builder(
                                      itemCount: screenShots.length,
                                      scrollDirection: Axis.horizontal,
                                      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1,
                                      ),
                                      itemBuilder: (context, index) {
                                        return FutureBuilder<File?>(
                                          future: screenShots[index].file,
                                          builder: (context, snapshot) {
                                            if (
                                            snapshot.hasData) {
                                              return Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 5),
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
                                                    border: Border.all(
                                                      color: Colors.black,
                                                      width: 1,
                                                    ),
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
              ///ScreenShot Button End------------------------------------->
              20.heightBox,
              ///Similar Live Button start------------------------------------->
              Row(
                children: [
                  photoButtons(icon: Icons.blur_circular_outlined,
                      onPressed: (){},
                      title: 'Similar Live Photos'),
                ],
              ),
              ///Similar Live Button End------------------------------------->
              20.heightBox,
              ///Burst Photos Button start------------------------------------->
              Row(
                children: [
                  photoButtons(icon: Icons.photo_camera_back_rounded,
                      onPressed: (){},
                      title: 'Burst Photos'),
                ],
              ),
              ///Burst Photos Button End------------------------------------->
            ],
          ),
        ),
      ),
    );
  }
}
