import 'dart:convert';

import 'package:barikoi_autocomplete/src/model/place.dart';

Places placesFromJson(String str) => Places.fromJson(json.decode(str));

String placesToJson(Places data) => json.encode(data.toJson());

class Places {
  final List<Place>? places;
  final String? message;
  final int? status;

  Places({
    this.places,
    this.message,
    this.status,
  });

  factory Places.fromJson(Map<String, dynamic> json) => Places(
    places: json["places"] == null ? [] : List<Place>.from(json["places"]!.map((x) => Place.fromJson(x))),
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "places": places == null ? [] : List<dynamic>.from(places!.map((x) => x.toJson())),
    "message": message,
    "status": status,
  };
}
