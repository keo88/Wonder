import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wonder_flutter/app/common/constants.dart';
import 'package:wonder_flutter/app/common/util/utils.dart';
import 'package:wonder_flutter/app/data/models/bookmark_model.dart';
import 'package:wonder_flutter/app/data/models/walk_model.dart';
import 'package:wonder_flutter/app/data/providers/bookmark_provider.dart';
import 'package:wonder_flutter/app/data/providers/walk_provider.dart';
import 'package:wonder_flutter/app/modules/map/controllers/swipe_page_controller_mixin.dart';
import 'package:wonder_flutter/app/modules/widgets/sliding_up_panel.dart';
import 'package:wonder_flutter/app/routes/app_pages.dart';

class MapController extends GetxController with GetSingleTickerProviderStateMixin,SwipePageControllerMixin {
  final WalkProvider _walkProvider = WalkProvider.to;
  final BookmarkProvider _bookmarkProvider = BookmarkProvider.to;

  static const CameraPosition initPos = CameraPosition(
    target: LatLng(37.5889938, 127.0292206),
    zoom: Constants.initialZoomLevel,
  );

  final currentIndex = (-1).obs;
  final RxList<Walk> walks = <Walk>[].obs;
  final RxList<Bookmark> bookmarks = <Bookmark>[].obs;
  final SlidingUpPanelController slidingUpPanelController = SlidingUpPanelController(duration: const Duration(milliseconds: 500));

  GoogleMapController? _mapController;
  double zoomVal = Constants.initialZoomLevel;
  late BitmapDescriptor defaultMarkerIcon;

  RxList<Marker> markers = <Marker>[].obs;

  Walk get currentWalk => walks[currentIndex.value];

  @override
  void onInit() async {
    super.onInit();
    await _setDefaultMapMarkerIcon();
    fetchBookmarks();
    fetchWalks();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void onCameraMove(CameraPosition position) {
    zoomVal = position.zoom;
  }

  void fetchWalks() async {
    walks.clear();
    walks.addAll(await _walkProvider.getWalks());
    getWalksStartingPoints();
    changeIndex(walks.isEmpty ? -1 : 0);
  }

  void fetchBookmarks() async {
    bookmarks.clear();
    bookmarks.addAll(await _bookmarkProvider.getBookmarks());
  }

  void getWalksStartingPoints() {
    markers.clear();
    for (Walk walk in walks) {
      markers.add(Marker(
        markerId: MarkerId(walk.id.toString()),
        position: LatLng(walk.coordinate![0].lat, walk.coordinate![0].lng),
        icon: defaultMarkerIcon,
        onTap: () {
          changeIndex(walks.indexOf(walk));
        }
      ));

      update();
    }
  }

  void changeIndex(int index) {
    if (index < walks.length) {
      if (currentIndex.value != index) {
        currentIndex.value = index;

        if (index != -1) {
          moveToPage(index);
        }
      }
    }
  }

  @override
  void onSwipe(int index) {
    changeIndex(index);
    if (_mapController != null && -1 < index && index < walks.length) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              walks[index].coordinate![0].lat,
              walks[index].coordinate![0].lng,
            ),
            zoom: zoomVal,
          )
        )
      );
    }
  }

  void onMapTap(LatLng argument) {
    fetchWalks();
  }

  void onStartButtonPressed() {
    Get.toNamed(Routes.MAP_DETAIL, arguments: {
      'id': currentWalk.id,
      'walk': currentWalk,
    });
    // Navigator.of(Get.context!).pushNamed('/map_detail', arguments: currentWalk);
  }

  Future _setDefaultMapMarkerIcon() async {

    final Uint8List markerIcon = await Utils.getBytesFromAsset('assets/images/map_marker.png', 100);
    defaultMarkerIcon =  BitmapDescriptor.fromBytes(markerIcon);
    return;
  }

}
