import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controls/SortController.dart';
import 'package:flutter_parkwhere/controls/MapController.dart';

class MapScreenView extends StatelessWidget {
  final MapScreenState state;

  MapScreen get widget => state.widget;

  const MapScreenView(this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: null,
        body: Stack(
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: GoogleMap(
                    mapToolbarEnabled: false,
                    mapType: MapType.normal,
                    markers: Set<Marker>.of(state.markers),
                    initialCameraPosition: MapScreenState.kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      state.onMapCreated(controller);
                    },
                    onCameraIdle: () async {
                      state.onCameraIdle();
                    },
                    onCameraMove: (CameraPosition cameraPosition) {
                      state.onCameraMove(cameraPosition);
                    },
                    onTap: (LatLng location) {
                      state.dismissPinPill();
                    }
                  ),
                ),
              ],
            ),
            Positioned(
              //Search Bar
              top: 40,
              right: 15,
              left: 15,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: state.searchController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.go,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 15),
                            hintText: (state.selectedSearchOption[0]) ? "Search by Destination..." : "Search by Carpark ID...",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
                        onPressed: () 
                          async =>  (state.selectedSearchOption[0]) ? await state.searchAllCarparksNearDestination() : await state.searchCarparkID(),
                        icon: const Icon(Icons.search),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              //Search Option
              top: 100,
              left: 15,
              child: Container(
                  height: 40.0,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    
                  ),
                  child: ToggleButtons(
                    direction: state.vertical ? Axis.vertical : Axis.horizontal,
                    onPressed: (int index) {
                      state.searchOptionSelection(index);
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    selectedBorderColor: Colors.white,
                    selectedColor: Colors.white,
                    fillColor: Colors.blue,
                    color: Colors.blue,
                    constraints:
                        const BoxConstraints(minHeight: 40.0, minWidth: 100.0),
                    isSelected: state.selectedSearchOption,
                    children: state.searchOption,
                  )),
            ),
            Positioned(
              //Sort button
              top: 100,
              right: 5,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                ),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SortScreen(
                                carparksToSort: state.nearest5Carparks,
                                currentLocation: state.location,
                              )));
                },
                child: const Icon(Icons.all_inbox_sharp),
              ),
            ),
            AnimatedPositioned(
              bottom: state.pinPillPosition,
              right: 0,
              left: 0,
              duration: const Duration(milliseconds: 200),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  height: 150,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          blurRadius: 20,
                          offset: Offset.zero,
                          color: Colors.grey.withOpacity(0.5),
                        )
                      ]),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      state.buildAvatar(),
                      state.buildLocationInfo(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
