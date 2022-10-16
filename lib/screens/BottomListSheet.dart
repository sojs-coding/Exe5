import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/PublicCarpark.dart';

//############################################
// NOT BEING USED!
//############################################

class BottomListSheet extends StatefulWidget {
  const BottomListSheet({super.key, required this.nearest5Carparks});
  final List<PublicCarpark> nearest5Carparks;
  @override
  State<BottomListSheet> createState() => BottomListSheetState(nearest5Carparks: nearest5Carparks);
}

class BottomListSheetState  extends State<BottomListSheet> {
  TextEditingController editingController = TextEditingController();
  
  BottomListSheetState({required this.nearest5Carparks});
  late List<PublicCarpark> nearest5Carparks;
  List<PublicCarpark> items = [];

  @override
  void initState() {
    items.addAll(nearest5Carparks);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return makeDismissible(
      child: Listener (
        onPointerDown: (_) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild?.unfocus();
          }
        },
        child: DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, controller) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      filterSearchResults(value.toUpperCase());
                    },
                    controller: editingController, 
                    decoration: const InputDecoration(
                        labelText: "Search",
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(items[index].address),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget makeDismissible({required Widget child}) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () => Navigator.of(context).pop(),
    child: GestureDetector(onTap: () {}, child: child),
  );

  void filterSearchResults(String query) {
    List<PublicCarpark> dummySearchList = [];
    dummySearchList.addAll(nearest5Carparks);
    if(query.isNotEmpty) {
      List<PublicCarpark> dummyListData = [];
      for (var item in dummySearchList) {
        if(item.address.contains(query)) {
          dummyListData.add(item);
        }
      }
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(nearest5Carparks);
      });
    }
  }
}