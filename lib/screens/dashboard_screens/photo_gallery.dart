import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:io';

class PhotoGallery extends StatefulWidget {
  const PhotoGallery({super.key});

  @override
  _PhotoGalleryState createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  List<AssetEntity> _photos = [];
  bool _isLoading = true; // Add loading state

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
        title: const Text('Screenshots',style: TextStyle(fontSize: 20,fontFamily: 'alk',fontWeight: FontWeight.bold,color: Colors.black),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Expanded(
              child: MasonryGridView.builder(
                itemCount: _photos.length,
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                ),
                itemBuilder: (context, index) {
                  return FutureBuilder<File?>(
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
                                  spreadRadius: 2,
                                  // blurRadius: 4
                                ),
                              ],
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
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