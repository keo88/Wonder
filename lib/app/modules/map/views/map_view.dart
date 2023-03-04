import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wonder_flutter/app/common/constants.dart';
import 'package:wonder_flutter/app/common/util/exports.dart';
import 'package:wonder_flutter/app/modules/widgets/app_bottom_navigation_bar.dart';
import 'package:wonder_flutter/app/modules/widgets/rotation_3d.dart';
import 'package:wonder_flutter/app/modules/widgets/sliding_up_panel.dart';
import 'package:wonder_flutter/app/modules/widgets/small_walk_container.dart';

import '../controllers/map_controller.dart';

class MapView extends GetView<MapController> {
  const MapView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
            Obx(() {
                return GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: MapController.initPos,
                  onMapCreated: controller.onMapCreated,
                  onCameraMove: controller.onCameraMove,
                  onTap: controller.onMapTap,
                  markers: Set<Marker>.of(controller.markers),
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                  tiltGesturesEnabled: false,
                  rotateGesturesEnabled: false,
                  minMaxZoomPreference: const MinMaxZoomPreference(12, 18),
                  padding: EdgeInsets.only(bottom: controller.cardHeight, top: 60),
                );
              }
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildWalkContainers(),
                const SizedBox(height: 20),
              ],
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ElevatedButton(
                      onPressed: controller.slidingUpPanelController.show,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.8),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        padding: const EdgeInsets.all(5),
                      ),
                      child: const Icon(Icons.bookmark_rounded, color: AppColors.middleGrey),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SlidingUpPanel(
              slidingUpPanelController: controller.slidingUpPanelController,
              child: Obx(() {
                  return ListView.builder(
                    itemCount: controller.bookmarks.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 80,
                        padding: const EdgeInsets.symmetric(horizontal: Constants.defaultHorizontalPadding),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: AppColors.faintGrey, width: 0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(controller.bookmarks[index].title, style: AppTextStyle.bookmarkTitleStyle),
                                  Text(controller.bookmarks[index].description, style: AppTextStyle.bookmarkDescriptionStyle),
                                  Text(controller.bookmarks[index].address, style: AppTextStyle.bookmarkAddressStyle),
                                ],
                              )
                            ),
                            IconButton(onPressed: () {}, icon: const Icon(Icons.edit_rounded)),
                            IconButton(onPressed: () {}, icon: const Icon(Icons.delete_rounded)),
                          ],
                        ),
                      );
                    },
                  );
                }
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 1,
      ),
    );
  }

  Widget _buildWalkContainers() {
    return Obx(() {
      if (controller.walks.isNotEmpty) {
        // return SmallWalkContainer(walk: controller.currentWalk);
        return Listener(
          onPointerUp: controller.onHandlePointerUp,
          child: NotificationListener(
            onNotification: controller.onHandleScrollNotifications,
            child: SizedBox(
              //Wrap list in a container to control height and padding
              height: controller.cardHeight,
              //Use a ListView.builder, calls buildItemRenderer() lazily, whenever it need to display a listItem
              child: PageView.builder(
                //Use bounce-style scroll physics, feels better with this demo
                physics: const BouncingScrollPhysics(),
                controller: controller.pageController,
                itemCount: controller.walks.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, i) {
                  return Obx(() {
                      return Rotation3d(
                        rotationY: controller.currentRotation,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 7.5, right: 7.5, top: 10.0),
                          child: Hero(
                            tag: 'walk-container-${controller.walks[i].id}',
                            child: SmallWalkContainer(
                              onSaveButtonPressed: () {},
                              onStartButtonPressed: controller.onStartButtonPressed,
                              walk: controller.walks[i],
                            ),
                          ),
                        ),
                      );
                    }
                  );
                },
              ),
            ),
          ),
        );
        // WalkCardsWidget(walks: controller.walks, onWalkChange: (walk) {
        //   printInfo(info: 'onCityChange ${walk.name}}');
        // });
      } else {
        return const SizedBox(height: 1);
      }
    });
  }
}
