class VehicleModel {
  String id;
  String plateNum;
  String type;
  String vehicleModel;

  VehicleModel(
    this.id,
    this.plateNum,
    this.type,
    this.vehicleModel,
  );

  Map toJson() => {
        'id': id,
        'plateNum': plateNum,
        'type': type,
        'vehicleModel': vehicleModel,
      };

  VehicleModel.fromJson(Map json)
      : id = json['id'],
        plateNum = json['plateNum'],
        type = json['type'],
        vehicleModel = json['vehicleModel'];
}
