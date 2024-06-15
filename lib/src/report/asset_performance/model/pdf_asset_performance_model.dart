///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class PDFAssetPerformanceModelData {
/*
{
  "pdfFile": "http://bimops-api.erdata.id/storage/pdf/asset-performence/QmltYXlpaTI0.pdf"
} 
*/

  String? pdfFile;

  PDFAssetPerformanceModelData({
    this.pdfFile,
  });
  PDFAssetPerformanceModelData.fromJson(Map<String, dynamic> json) {
    pdfFile = json['pdfFile']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['pdfFile'] = pdfFile;
    return data;
  }
}

class PDFAssetPerformanceModel {
/*
{
  "success": true,
  "data": {
    "pdfFile": "http://bimops-api.erdata.id/storage/pdf/asset-performence/QmltYXlpaTI0.pdf"
  },
  "message": "Sukses"
} 
*/

  bool? success;
  PDFAssetPerformanceModelData? data;
  String? message;

  PDFAssetPerformanceModel({
    this.success,
    this.data,
    this.message,
  });
  PDFAssetPerformanceModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = (json['data'] != null)
        ? PDFAssetPerformanceModelData.fromJson(json['data'])
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
