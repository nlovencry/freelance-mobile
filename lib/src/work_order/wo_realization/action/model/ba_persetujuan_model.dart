///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class BAPersetujuanModelData {
/*
{
  "pdf": "http://bimops-api.erdata.id/storage/pdf/report/QmltYXlpaTI3ODI3-persetujuan.pdf"
}
*/

  String? pdf;

  BAPersetujuanModelData({
    this.pdf,
  });
  BAPersetujuanModelData.fromJson(Map<String, dynamic> json) {
    pdf = json['pdf']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['pdf'] = pdf;
    return data;
  }
}

class BAPersetujuanModel {
/*
{
  "success": true,
  "data": {
    "pdf": "http://bimops-api.erdata.id/storage/pdf/report/QmltYXlpaTI3ODI3-persetujuan.pdf"
  },
  "message": "Sukses"
}
*/

  bool? success;
  BAPersetujuanModelData? data;
  String? message;

  BAPersetujuanModel({
    this.success,
    this.data,
    this.message,
  });
  BAPersetujuanModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = (json['data'] != null)
        ? BAPersetujuanModelData.fromJson(json['data'])
        : null;
    message = json['Message']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success'] = success;
    if (data != null) {
      data['data'] = this.data!.toJson();
    }
    data['Message'] = message;
    return data;
  }
}
