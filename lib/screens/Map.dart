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
        resizeToAvoidBottomInset : false,
        appBar: null,
        body: Stack(
        children: <Widget> [
          Row(
            children: [
              Expanded(
                child: GoogleMap(
                  mapToolbarEnabled: false,
                  mapType: MapType.normal,
                  markers: Set<Marker>.of(state.getMarkers()),
                  initialCameraPosition: MapScreenState.getkGooglePlex(),
                  onMapCreated: (GoogleMapController controller) {
                    state.onMapCreated(controller);
                  },
                  onCameraIdle: () async {
                    state.onCameraIdle();
                  },
                  onCameraMove: (CameraPosition cameraPosition) {
                    state.onCameraMove(cameraPosition);
                  },
                ),
              ),
            ],
          ),
          Positioned(
            top: 40 ,
            right: 15,
            left: 15,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20)
                ),
              ),
              child: Row(
                children: <Widget> [
                  Expanded(
                    child: TextField(
                      controller: state.getSearchController(),
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          hintText: "Search..."),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      onPressed: () async => await state.searchAllCarparksNearDestination(),
                      icon: Icon(Icons.search),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 105,
            right: 5,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
              ),
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    SortScreen(carparksToSort: state.getNearest5Carparks(), currentLocation: state.getLocation(),)));
              },
             child: Icon(Icons.all_inbox_sharp),
            ),
          ),
        ],
      ),),
    );
  }
}