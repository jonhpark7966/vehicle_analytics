import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:transparent_image/transparent_image.dart';


enum SidebarIndex{
  Dashboard,
  Vehicle,
  J2263,
  WLTP,
  IdleNVH;

  static fromName(String name){
    if(name.contains("Vehicle")){
      return SidebarIndex.Dashboard;
    }else if(name.contains("J2263")){
      return SidebarIndex.J2263;
    }else if(name.contains("WLTP")){
      return SidebarIndex.WLTP;
    }
    return SidebarIndex.Dashboard;
  }
}

class TestSidebarX extends StatelessWidget {
  TestSidebarX({
    Key? key,
    required SidebarXController controller,
    required String? imageUrl,
    required setState,
  })  : _controller = controller, _imageUrl = imageUrl, _setState = setState,
        super(key: key);

  final SidebarXController _controller;
  String? _imageUrl;
  var _setState;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: canvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: scaffoldBackgroundColor,
        textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Colors.white),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: canvasColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: actionColor.withOpacity(0.37),
          ),
          gradient: const LinearGradient(
            colors: [accentCanvasColor, canvasColor],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white.withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(
          color: canvasColor,
        ),
      ),
      footerDivider: divider,
      headerBuilder: (context, extended) {
        return SizedBox(
          height: extended?150:60,
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child:
                  (_imageUrl==null)?
                   Image.memory(kTransparentImage):
                   Image.network(_imageUrl!)
                  )),
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.dashboard ,
          label: 'Dashboard',
          onTap: () {
            _setState((){});
          },
        ),
        SidebarXItem(
          icon: Icons.car_crash,
          label: 'Vehicle',
          onTap: (){ _setState((){}); }
        ),
        SidebarXItem(
          icon: Icons.multiline_chart,
          label: 'CoastDown-J2263',
          onTap: (){ _setState((){}); }
        ),
        SidebarXItem(
          icon: Icons.multiline_chart,
          label: 'CoastDown-WLTP',
          onTap: (){ _setState((){}); }
        ),
        const SidebarXItem(
          icon: Icons.mic,
          label: 'Idle NVH',
        ),
      ],
    );
  }
}

const primaryColor = Color(0xFF685BFF);
const canvasColor = Color(0xFF2E2E48);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color(0xFF3E3E61);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final divider = Divider(color: white.withOpacity(0.3), height: 1);