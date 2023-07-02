class Place {
  final int? id;
  final String? longitude;
  final String? latitude;
  final String? address;
  final String? city;
  final String? area;
  final int? postCode;
  final String? pType;
  final String? uCode;

  Place({
    this.id,
    this.longitude,
    this.latitude,
    this.address,
    this.city,
    this.area,
    this.postCode,
    this.pType,
    this.uCode,
  });

  factory Place.fromJson(Map<String, dynamic> json) => Place(
    id: json["id"],
    longitude: json["longitude"],
    latitude: json["latitude"],
    address: json["address"],
    city: json["city"],
    area: json["area"],
    postCode: json["postCode"],
    pType: json["pType"],
    uCode: json["uCode"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "longitude": longitude,
    "latitude": latitude,
    "address": address,
    "city": city,
    "area": area,
    "postCode": postCode,
    "pType": pType,
    "uCode": uCode,
  };
}