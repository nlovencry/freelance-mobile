///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class VoidWORealizationModelData {
/*
{
  "id": 7865,
  "doc_no": "WO-2024-0000041",
  "asset_code": "HT642",
  "asset_category_code": "A09",
  "ba_no_persetujuan": "null",
  "ba_no_realisasi": "null",
  "type_work": "CM",
  "asset_meter_code": "null",
  "type_trans": "persetujuan",
  "date_doc": "2024-03-25",
  "cabang_code": "CAB27",
  "regional_code": "REG02",
  "description": "DAILY INSPECTION HT MERCEDES-BENZ AXOR 4028 (MT)",
  "doc_status": "Void",
  "is_downtime": 0,
  "apv_level": -1,
  "preventive_maintanance_id": "null",
  "jobplan_id": "null",
  "workorder_id": "WO-2022-5998",
  "frequency_time_based": 0,
  "frequency_unit_based": "null",
  "meter_reading": 0,
  "is_delete": 0,
  "company_id": 3,
  "status_part": "waiting",
  "date_start": "null",
  "date_end": "null",
  "created_at": 1711345576,
  "updated_at": "null",
  "created_by": 1,
  "updated_by": "null",
  "is_mr": 0,
  "submit_rls": "null",
  "start_downtime": "null",
  "up_date": "null",
  "approver": "null"
}
*/

  int? id;
  String? docNo;
  String? assetCode;
  String? assetCategoryCode;
  String? baNoPersetujuan;
  String? baNoRealisasi;
  String? typeWork;
  String? assetMeterCode;
  String? typeTrans;
  String? dateDoc;
  String? cabangCode;
  String? regionalCode;
  String? description;
  String? docStatus;
  int? isDowntime;
  int? apvLevel;
  String? preventiveMaintananceId;
  String? jobplanId;
  String? workorderId;
  int? frequencyTimeBased;
  String? frequencyUnitBased;
  int? meterReading;
  int? isDelete;
  int? companyId;
  String? statusPart;
  String? dateStart;
  String? dateEnd;
  int? createdAt;
  String? updatedAt;
  int? createdBy;
  String? updatedBy;
  int? isMr;
  String? submitRls;
  String? startDowntime;
  String? upDate;
  String? approver;

  VoidWORealizationModelData({
    this.id,
    this.docNo,
    this.assetCode,
    this.assetCategoryCode,
    this.baNoPersetujuan,
    this.baNoRealisasi,
    this.typeWork,
    this.assetMeterCode,
    this.typeTrans,
    this.dateDoc,
    this.cabangCode,
    this.regionalCode,
    this.description,
    this.docStatus,
    this.isDowntime,
    this.apvLevel,
    this.preventiveMaintananceId,
    this.jobplanId,
    this.workorderId,
    this.frequencyTimeBased,
    this.frequencyUnitBased,
    this.meterReading,
    this.isDelete,
    this.companyId,
    this.statusPart,
    this.dateStart,
    this.dateEnd,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.isMr,
    this.submitRls,
    this.startDowntime,
    this.upDate,
    this.approver,
  });
  VoidWORealizationModelData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    docNo = json['doc_no']?.toString();
    assetCode = json['asset_code']?.toString();
    assetCategoryCode = json['asset_category_code']?.toString();
    baNoPersetujuan = json['ba_no_persetujuan']?.toString();
    baNoRealisasi = json['ba_no_realisasi']?.toString();
    typeWork = json['type_work']?.toString();
    assetMeterCode = json['asset_meter_code']?.toString();
    typeTrans = json['type_trans']?.toString();
    dateDoc = json['date_doc']?.toString();
    cabangCode = json['cabang_code']?.toString();
    regionalCode = json['regional_code']?.toString();
    description = json['description']?.toString();
    docStatus = json['doc_status']?.toString();
    isDowntime = json['is_downtime']?.toInt();
    apvLevel = json['apv_level']?.toInt();
    preventiveMaintananceId = json['preventive_maintanance_id']?.toString();
    jobplanId = json['jobplan_id']?.toString();
    workorderId = json['workorder_id']?.toString();
    frequencyTimeBased = json['frequency_time_based']?.toInt();
    frequencyUnitBased = json['frequency_unit_based']?.toString();
    meterReading = json['meter_reading']?.toInt();
    isDelete = json['is_delete']?.toInt();
    companyId = json['company_id']?.toInt();
    statusPart = json['status_part']?.toString();
    dateStart = json['date_start']?.toString();
    dateEnd = json['date_end']?.toString();
    createdAt = json['created_at']?.toInt();
    updatedAt = json['updated_at']?.toString();
    createdBy = json['created_by']?.toInt();
    updatedBy = json['updated_by']?.toString();
    isMr = json['is_mr']?.toInt();
    submitRls = json['submit_rls']?.toString();
    startDowntime = json['start_downtime']?.toString();
    upDate = json['up_date']?.toString();
    approver = json['approver']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['doc_no'] = docNo;
    data['asset_code'] = assetCode;
    data['asset_category_code'] = assetCategoryCode;
    data['ba_no_persetujuan'] = baNoPersetujuan;
    data['ba_no_realisasi'] = baNoRealisasi;
    data['type_work'] = typeWork;
    data['asset_meter_code'] = assetMeterCode;
    data['type_trans'] = typeTrans;
    data['date_doc'] = dateDoc;
    data['cabang_code'] = cabangCode;
    data['regional_code'] = regionalCode;
    data['description'] = description;
    data['doc_status'] = docStatus;
    data['is_downtime'] = isDowntime;
    data['apv_level'] = apvLevel;
    data['preventive_maintanance_id'] = preventiveMaintananceId;
    data['jobplan_id'] = jobplanId;
    data['workorder_id'] = workorderId;
    data['frequency_time_based'] = frequencyTimeBased;
    data['frequency_unit_based'] = frequencyUnitBased;
    data['meter_reading'] = meterReading;
    data['is_delete'] = isDelete;
    data['company_id'] = companyId;
    data['status_part'] = statusPart;
    data['date_start'] = dateStart;
    data['date_end'] = dateEnd;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['is_mr'] = isMr;
    data['submit_rls'] = submitRls;
    data['start_downtime'] = startDowntime;
    data['up_date'] = upDate;
    data['approver'] = approver;
    return data;
  }
}

class VoidWORealizationModel {
/*
{
  "success": true,
  "data": {
    "id": 7865,
    "doc_no": "WO-2024-0000041",
    "asset_code": "HT642",
    "asset_category_code": "A09",
    "ba_no_persetujuan": "null",
    "ba_no_realisasi": "null",
    "type_work": "CM",
    "asset_meter_code": "null",
    "type_trans": "persetujuan",
    "date_doc": "2024-03-25",
    "cabang_code": "CAB27",
    "regional_code": "REG02",
    "description": "DAILY INSPECTION HT MERCEDES-BENZ AXOR 4028 (MT)",
    "doc_status": "Void",
    "is_downtime": 0,
    "apv_level": -1,
    "preventive_maintanance_id": "null",
    "jobplan_id": "null",
    "workorder_id": "WO-2022-5998",
    "frequency_time_based": 0,
    "frequency_unit_based": "null",
    "meter_reading": 0,
    "is_delete": 0,
    "company_id": 3,
    "status_part": "waiting",
    "date_start": "null",
    "date_end": "null",
    "created_at": 1711345576,
    "updated_at": "null",
    "created_by": 1,
    "updated_by": "null",
    "is_mr": 0,
    "submit_rls": "null",
    "start_downtime": "null",
    "up_date": "null",
    "approver": "null"
  },
  "message": "Data berhasil void"
}
*/

  bool? success;
  VoidWORealizationModelData? data;
  String? message;

  VoidWORealizationModel({
    this.success,
    this.data,
    this.message,
  });
  VoidWORealizationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = (json['data'] != null) ? VoidWORealizationModelData.fromJson(json['data']) : null;
    message = json['message']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success'] = success;
    if (data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}
