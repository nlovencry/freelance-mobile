///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class TowerDetailModelData {
/*
{
  "Id": "01J06EX7EJHFXC47Y6AE8SSPTC",
  "Name": "PLTA Malang",
  "UnitNumber": "0H823A1"
} 
*/

  String? Id;
  String? Name;
  String? UnitNumber;

  TowerDetailModelData({
    this.Id,
    this.Name,
    this.UnitNumber,
  });
  TowerDetailModelData.fromJson(Map<String, dynamic> json) {
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

class TowerDetailModel {
/*
{
  "Success": true,
  "StatusCode": 200,
  "Message": "berhasil mengubah tower",
  "Data": {
    "Id": "01J06EX7EJHFXC47Y6AE8SSPTC",
    "Name": "PLTA Malang",
    "UnitNumber": "0H823A1"
  }
} 
*/

  bool? Success;
  int? StatusCode;
  String? Message;
  TowerDetailModelData? Data;

  TowerDetailModel({
    this.Success,
    this.StatusCode,
    this.Message,
    this.Data,
  });
  TowerDetailModel.fromJson(Map<String, dynamic> json) {
    Success = json['Success'];
    StatusCode = json['StatusCode']?.toInt();
    Message = json['Message']?.toString();
    Data = (json['Data'] != null)
        ? TowerDetailModelData.fromJson(json['Data'])
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
