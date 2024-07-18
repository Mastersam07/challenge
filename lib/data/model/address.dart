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
}
