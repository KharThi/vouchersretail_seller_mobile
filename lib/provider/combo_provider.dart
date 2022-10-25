import 'package:flutter/material.dart';
import 'package:nyoba/models/combo_model.dart';
import 'package:nyoba/services/combo_api.dart';

class ComboProvider with ChangeNotifier {
  bool loading = false;
  List<Combo> listCombo = [];
  Future<List<Combo>?> fetchCombos() async {
    loading = true;
    var result;
    List<Combo> list = List.empty(growable: true);
    await ComboAPI().fetchCombo().then((data) {
      result = data;
      list = data.cast<Combo>();
    });
    listCombo.clear();
    listCombo = list;
    loading = false;
    notifyListeners();
    return list;
  }
}
