// ignore_for_file: no_logic_in_create_state, import_of_legacy_library_into_null_safe,file_names, deprecated_member_use

import 'package:Xpiree/Modules/Document/UI/add_document.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Xpiree/Modules/Calender/UI/calender_view.dart';
import 'package:Xpiree/Modules/Dashboard/UI/dashboard.dart';
import 'package:Xpiree/Modules/Document/UI/saved_document.dart';
import 'package:Xpiree/Modules/FolderList/UI/folder_list.dart';
import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';

class NavigationBottom extends StatefulWidget {
  final int selectedIndex;
  const NavigationBottom({Key? key, required this.selectedIndex})
      : super(key: key);

  @override
  NavigationBottomState createState() => NavigationBottomState(selectedIndex);
}

class NavigationBottomState extends State<NavigationBottom> {
  int _selectedIndex;
  /*  int dashboardTabIndex = 0;
  late List<Widget> _widgetOptions; */
  NavigationBottomState(this._selectedIndex);
  @override
  void initState() {
    /* dashboardTabIndex = widget.dashboardTabIndex;
    _widgetOptions = <Widget>[
      Dashboard(indexTab: dashboardTabIndex),
      const CalenderView(),
      const SavedDocument(),
      const FolderList(),
    ]; */
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: Theme.of(context).colorScheme.whiteColor,
      notchMargin: 5,
      child: SizedBox(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildNavigationItem(
                    // Icons.dashboard,
                    Icons.home,
                    "Home",
                    0),
                buildNavigationItem(Icons.today_outlined, "Calender", 1),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddDocument()),
                );
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Theme.of(context).primaryColor),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildNavigationItem(
                    // Icons.bookmarks_outlined,
                    Icons.task_alt_rounded,
                    "Tasks",
                    2),
                buildNavigationItem(FontAwesomeIcons.folder, "Folders", 3),
              ],
            )
          ],
        ),
      ),
    );
    /*   return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex == 0) {
          return true;
        }
        setState(() {
          _selectedIndex = 0;
        });
        return false;
      },
      child: Scaffold(
          backgroundColor:
              Theme.of(context).colorScheme.navBarColor.withOpacity(0.1),
          body: _widgetOptions.elementAt(_selectedIndex),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddDocument()),
              );
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            color: Theme.of(context).colorScheme.navBarColor,
            notchMargin: 10,
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildNavigationItem(Icons.dashboard, "Dashboard", 0),
                      buildNavigationItem(Icons.today_outlined, "Calender", 1),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildNavigationItem(
                          Icons.bookmarks_outlined, "Bookmarks", 2),
                      buildNavigationItem(
                          FontAwesomeIcons.folder, "Folders", 3),
                    ],
                  )
                ],
              ),
            ),
          )
          ),
    ); */
  }

  Widget buildNavigationItem(IconData icon, String _text, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        if (_selectedIndex == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const Dashboard(
                      indexTab: 1,
                    )),
          );
        } else if (_selectedIndex == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CalenderView()),
          );
        } else if (_selectedIndex == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SavedDocument()),
          );
        } else if (_selectedIndex == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FolderList()),
          );
        }
      },
      child: Container(
        height: 57,
        //  0.075,
        width: MediaQuery.of(context).size.width / 5,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          children: [
            Icon(
              icon,
              color: index == _selectedIndex
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.textBoxBorderColor,
              size: 26,
            ),
            Text(
              _text,
              style: TextStyle(
                fontSize: 10,
                fontWeight:
                    index == _selectedIndex ? FontWeight.bold : FontWeight.w600,
                color: index == _selectedIndex
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.textBoxBorderColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  /* Widget buildNavigationItem(IconData icon, String _text, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.075,
        width: MediaQuery.of(context).size.width / 5,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 5),
        color: Theme.of(context).colorScheme.navBarColor,
        child: Column(
          children: [
            Icon(
              icon,
              color: index == _selectedIndex
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.textBoxBorderColor,
              size: 30,
            ),
            Text(
              _text,
              style: TextStyle(
                fontSize: 11,
                fontWeight:
                    index == _selectedIndex ? FontWeight.bold : FontWeight.w600,
                color: index == _selectedIndex
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.textBoxBorderColor,
              ),
            )
          ],
        ),
      ),
    );
  }
 */

}
