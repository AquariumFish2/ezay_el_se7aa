import 'package:flutter/cupertino.dart';

class Patient extends ChangeNotifier {
  String? team;
  String? illnessType;
  String? doctor;
  String? docId;
  String? volId = '';
  String? volName = '';
  String? name = '';
  String? address = '';
  String? phone = '';
  String? source = '';
  List<Map> latests = [];
  String? latestToPush = '';
  String? nationalId = '';
  String? date = '';
  String? state;
  String? illness = '';
  List<String> images = [];
  bool? availableForGuests;
  List<Map> costs = [];
  // bool? stateValidate;
  void stateNotvalidated() {
    // stateValidate = false;
    notifyListeners();
  }

  void setVolName(String volId, String team, String volName) {
    this.volId = volId;
    this.team = team;
    this.volName = volName;
    notifyListeners();
  }

  void setName(String value) {
    name = value;
    notifyListeners();
  }

  void setLatest(String latest) {
    latestToPush = latest;
    latests.add({
      'title': latest,
      'id': '${(DateTime.now().second)}:${(DateTime.now().millisecond)}'
    });
    notifyListeners();
  }

  void setIllness(String val) {
    illness = val;
    notifyListeners();
  }

  void setAddress(String val) {
    address = val;
    notifyListeners();
  }

  void setPhone(String val) {
    phone = val;
    notifyListeners();
  }

  void setSource(String val) {
    source = val;
    notifyListeners();
  }

  void addCost(Map val) {
    costs.add(val);
    notifyListeners();
  }

  void removeCost(Map val) {
    costs.remove(val);
    notifyListeners();
  }

  void setillnessType(String val) {
    illnessType = val;
    notifyListeners();
  }

  void setState(String val) {
    state = val;
    // stateValidate = true;
    notifyListeners();
  }

  void setDoctor(String id, List doctors) {
    docId = id;
    doctor = doctors.firstWhere((element) => element['idDoc'] == id)['name'];
    notifyListeners();
  }
}
