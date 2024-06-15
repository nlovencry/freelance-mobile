///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class TowerCreateModelData {
/*
{
  "Id": "01J0EZP4QSX439KA7M3QZA54YF",
  "Name": "PLTA Kebumen 2",
  "UnitNumber": "0H823Z9"
} 
*/

  String? Id;
  String? Name;
  String? UnitNumber;

  TowerCreateModelData({
    this.Id,
    this.Name,
    this.UnitNumber,
  });
  TowerCreateModelData.fromJson(Map<String, dynamic> json) {
    Id = json['Id']?.toString();
    Name = json['Name']?.toString();
    UnitNumber = json['UnitNumber']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Id'] = Id;
    data['Name'] = Name;
    data['UnitNumber'] = UnitNumber;
    return data;
  }
}

class TowerCreateModel {
/*
{
  "Success": true,
  "StatusCode": 200,
  "Message": "berhasil membuat tower baru",
  "Data": {
    "Id": "01J0EZP4QSX439KA7M3QZA54YF",
    "Name": "PLTA Kebumen 2",
    "UnitNumber": "0H823Z9"
  }
} 
*/

  bool? Success;
  int? StatusCode;
  String? Message;
  TowerCreateModelData? Data;

  TowerCreateModel({
    this.Success,
    this.StatusCode,
    this.Message,
    this.Data,
  });
  TowerCreateModel.fromJson(Map<String, dynamic> json) {
    Success = json['Success'];
    StatusCode = json['StatusCode']?.toInt();
    Message = json['Message']?.toString();
    Data = (json['Data'] != null)
        ? TowerCreateModelData.fromJson(json['Data'])
        : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Success'] = Success;
    data['StatusCode'] = StatusCode;
    data['Message'] = Message;
    if (Data != null) {
      data['Data'] = Data!.toJson();
    }
    return data;
  }
}
