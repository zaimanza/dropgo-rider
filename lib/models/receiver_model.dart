class ReceiverModel {
  String id;
  String name;
  String pNumber;

  ReceiverModel(
    this.id,
    this.name,
    this.pNumber,
  );

  Map toJson() => {
        'id': id,
        'name': name,
        'pNumber': "+6" + pNumber,
      };

  ReceiverModel.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        pNumber = json['pNumber'];
}
