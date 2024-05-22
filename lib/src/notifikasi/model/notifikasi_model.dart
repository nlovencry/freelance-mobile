///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class NotifikasiModelData {
/*
{
  "id": 7865,
  "doc_no": "WO-2024-0000041",
  "date_doc": "2024-03-25",
  "module_id": "work-order-p",
  "user_id": 8,
  "doc_status": "REVIEW",
  "asset_code": "HT642",
  "asset_name": "HEADTRUCK 642 TTL",
  "site_name": "TERMINAL TELUK LAMONG",
  "description": "DAILY INSPECTION HT MERCEDES-BENZ AXOR 4028 (MT)"
} 
*/

  String? id;
  String? docNo;
  String? dateDoc;
  String? moduleId;
  String? userId;
  String? docStatus;
  String? assetCode;
  String? assetName;
  String? siteName;
  String? description;

  NotifikasiModelData({
    this.id,
    this.docNo,
    this.dateDoc,
    this.moduleId,
    this.userId,
    this.docStatus,
    this.assetCode,
    this.assetName,
    this.siteName,
    this.description,
  });
  NotifikasiModelData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    docNo = json['doc_no']?.toString();
    dateDoc = json['date_doc']?.toString();
    moduleId = json['module_id']?.toString();
    userId = json['user_id']?.toString();
    docStatus = json['doc_status']?.toString();
    assetCode = json['asset_code']?.toString();
    assetName = json['asset_name']?.toString();
    siteName = json['site_name']?.toString();
    description = json['description']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['doc_no'] = docNo;
    data['date_doc'] = dateDoc;
    data['module_id'] = moduleId;
    data['user_id'] = userId;
    data['doc_status'] = docStatus;
    data['asset_code'] = assetCode;
    data['asset_name'] = assetName;
    data['site_name'] = siteName;
    data['description'] = description;
    return data;
  }
}

class NotifikasiModel {
/*
{
  "success": true,
  "data": [
    {
      "id": 7865,
      "doc_no": "WO-2024-0000041",
      "date_doc": "2024-03-25",
      "module_id": "work-order-p",
      "user_id": 8,
      "doc_status": "REVIEW",
      "asset_code": "HT642",
      "asset_name": "HEADTRUCK 642 TTL",
      "site_name": "TERMINAL TELUK LAMONG",
      "description": "DAILY INSPECTION HT MERCEDES-BENZ AXOR 4028 (MT)"
    }
  ],
  "page": 1,
  "length": 10,
  "message": "Sukses"
} 
*/

  bool? success;
  List<NotifikasiModelData?>? data;
  String? page;
  String? length;
  String? message;

  NotifikasiModel({
    this.success,
    this.data,
    this.page,
    this.length,
    this.message,
  });
  NotifikasiModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
  if (json['data'] != null) {
  final v = json['data'];
  final arr0 = <NotifikasiModelData>[];
  v.forEach((v) {
  arr0.add(NotifikasiModelData.fromJson(v));
  });
    this.data = arr0;
    }
    page = json['page']?.toString();
    length = json['length']?.toString();
    message = json['message']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      final v = this.data;
      final arr0 = [];
  v!.forEach((v) {
  arr0.add(v!.toJson());
  });
      data['data'] = arr0;
    }
    data['page'] = page;
    data['length'] = length;
    data['message'] = message;
    return data;
  }
}
