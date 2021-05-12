import 'package:deep_notes/model/NoteModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const String noteHint = "Type your note";

class AddNoteScreen extends StatefulWidget {
  final NoteModel rootNode;

  const AddNoteScreen({Key key, this.rootNode}) : super(key: key);
  @override
  State<AddNoteScreen> createState() {
    return AddNoteState();
  }
}

class AddNoteState extends State<AddNoteScreen> {
  List<NoteModel> _rootNodes = [];
  @override
  void initState() {
    _rootNodes.add(widget.rootNode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = _buildBody(_rootNodes);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: BackButton(
            color: Colors.black87,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: body);
  }

  Widget _buildBody(List<NoteModel> rootNodes) {
    List<Widget> mWidgets = [];
    for (NoteModel node in rootNodes) {
      mWidgets.add(_buildNodeWidget(node));
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: mWidgets,
        ),
      ),
    );
  }

  Widget _buildNodeWidget(NoteModel thisNode) {
    List<Widget> deepWidgets = buildDescendants(thisNode.descendants);
    return ChangeNotifierProvider(
      create: (BuildContext context) => thisNode,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: thisNode.text.isEmpty ? noteHint : thisNode.text,
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.black54),
              ),
            ),
            thisNode.descendants.isEmpty
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        thisNode.descendants.add(NoteModel());
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.expand_more_outlined,
                        color: Colors.black54,
                      ),
                    ),
                  )
                : Container(),
            Container(
              padding: EdgeInsets.only(left: 10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: deepWidgets,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> buildDescendants(List<NoteModel> descendants) {
    List<Widget> widgets = [];
    for (NoteModel d in descendants) {
      widgets.add(_buildNodeWidget(d));
    }
    widgets.add(
      _buildArrowUI(descendants),
    );
    return widgets;
  }

  Widget _buildArrowUI(List<NoteModel> descendants) {
    return Row(children: [
      Icon(
        Icons.arrow_forward_outlined,
        color: Colors.blue,
        size: 20.0,
      ),
      GestureDetector(
        onTap: () {
          setState(() {
            descendants.add(NoteModel());
          });
        },
        child: Container(
          padding: EdgeInsets.all(5.0),
          child: Icon(
            Icons.add_circle,
            size: 20.0,
            color: Colors.black54,
          ),
        ),
      ),
    ]);
  }
}
