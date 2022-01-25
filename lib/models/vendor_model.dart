class VendorModel {
  String id;
  String name;
  String email;
  String pNumber;
  String createAt;
  String updateAt;

  VendorModel(
    this.id,
    this.name,
    this.email,
    this.pNumber,
    this.createAt,
    this.updateAt,
  );

  Map toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'pNumber': pNumber,
        'createAt': createAt,
        'updateAt': updateAt,
      };

  VendorModel.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        pNumber = json['pNumber'],
        createAt = json['createAt'],
        updateAt = json['updateAt'];
}
