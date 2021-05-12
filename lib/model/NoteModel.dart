import 'package:flutter/foundation.dart';

class NoteModel extends ChangeNotifier {
  NoteState state = NoteState.Active;
  String text = "";
  List<NoteModel> descendants = [];

  addDescendants(NoteModel value) {
    descendants.add(value);
  }
}

enum NoteState { Active, Archived, Trashed }
