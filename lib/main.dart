import 'dart:ui';

import 'package:deep_notes/AddNoteScreen.dart';
import 'package:deep_notes/model/NoteModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'Constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deep Notes',
      home: MyHomePage(title: 'Deep Notes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search your notes";
  NoteState _selectedDrawerItem;

  @override
  void initState() {
    _selectedDrawerItem = NoteState.Active;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.menu_rounded,
                  color: Colors.black54,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            title: _buildSearchBar() /*_buildTitle(context)*/,
            actions: _buildActions(),
            backgroundColor: Colors.white,
            backwardsCompatibility: false,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark),
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Center(),
          ),
          drawer: _buildDrawer(),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddNoteScreen(
                        rootNode: NoteModel(),
                      )),
            ),
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          )),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchQueryController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: searchQuery,
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.black54),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    SvgPicture.asset(
                      "assets/logo.svg",
                      width: 30,
                      semanticsLabel: APP_NAME,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      APP_NAME,
                      style: TextStyle(fontSize: 24, color: Colors.black87),
                    )
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  child: _buildDrawerItems(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItems() {
    return Container(
      child: Column(
        children: [
          _drawerItem(
              Icons.event_note_rounded,
              "Notes",
              _selectedDrawerItem == NoteState.Active,
              activeDrawerItemSelected),
          _drawerItem(
              Icons.archive_outlined,
              "Archive",
              _selectedDrawerItem == NoteState.Archived,
              archivedDrawerItemSelected),
          _drawerItem(
              Icons.delete,
              "Trash",
              _selectedDrawerItem == NoteState.Trashed,
              trashedDrawerItemSelected)
        ],
      ),
    );
  }

  Widget _drawerItem(
      IconData iconData, String text, bool selected, Function onTapped) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTapped,
      child: Container(
        decoration: selected
            ? BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)))
            : null,
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Row(
          children: [
            Icon(
              iconData,
              size: 25.0,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 20.0),
            )
          ],
        ),
      ),
    );
  }

  void activeDrawerItemSelected() {
    setState(() {
      _selectedDrawerItem = NoteState.Active;
    });
  }

  void archivedDrawerItemSelected() {
    setState(() {
      _selectedDrawerItem = NoteState.Archived;
    });
  }

  void trashedDrawerItemSelected() {
    setState(() {
      _selectedDrawerItem = NoteState.Trashed;
    });
  }
}
