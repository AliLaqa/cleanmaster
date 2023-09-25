import 'package:photo_manager/photo_manager.dart';
import 'RequestPermissionHelper.dart';

//To Store Screenshots
List<AssetEntity> screenShots = [];
//To show CrcularProgressIndictor
bool isLoading = true;

Future<List<AssetEntity>> loadingScreenshots() async {

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

    return imageAssets.toList();
  } else {
    // Handle permission not granted
    return [];
  }
}
