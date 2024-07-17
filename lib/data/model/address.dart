import 'dart:convert';

Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(Address data) => json.encode(data.toJson());

class Address {
  String street;
  String line2;
  String city;
  String zip;
  String? state;

  Address({
    required this.street,
    required this.line2,
    required this.city,
    required this.zip,
    this.state,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        street: json["street"],
        line2: json["line2"],
        city: json["city"],
        zip: json["zip"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "street": street,
        "line2": line2,
        "city": city,
        "zip": zip,
        "state": state,
      };

  @override
  String toString() {
    return street;
  }
}
