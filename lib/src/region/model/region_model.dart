///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class ProvinceModelData {
/*
{
  "province_id": "1",
  "province": "Bali"
} 
*/

  String? provinceId;
  String? province;

  ProvinceModelData({
    this.provinceId,
    this.province,
  });
  ProvinceModelData.fromJson(Map<String, dynamic> json) {
    provinceId = json['province_id']?.toString();
    province = json['province']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['province_id'] = provinceId;
    data['province'] = province;
    return data;
  }
}

class ProvinceModel {
/*
{
  "success": true,
  "data": [
    {
      "province_id": "1",
      "province": "Bali"
    }
  ],
  "message": "success"
} 
*/

  bool? success;
  List<ProvinceModelData?>? data;
  String? message;

  ProvinceModel({
    this.success,
    this.data,
    this.message,
  });
  ProvinceModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      final v = json['data'];
      final arr0 = <ProvinceModelData>[];
      v.forEach((v) {
        arr0.add(ProvinceModelData.fromJson(v));
      });
      this.data = arr0;
    }
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
    data['message'] = message;
    return data;
  }
}

///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class CityModelData {
/*
{
  "city_id": "114",
  "city_name": "Denpasar",
  "type": "Kota",
  "postal_code": "80227"
} 
*/

  String? cityId;
  String? cityName;
  String? type;
  String? postalCode;

  CityModelData({
    this.cityId,
    this.cityName,
    this.type,
    this.postalCode,
  });
  CityModelData.fromJson(Map<String, dynamic> json) {
    cityId = json['city_id']?.toString();
    cityName = json['city_name']?.toString();
    type = json['type']?.toString();
    postalCode = json['postal_code']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['city_id'] = cityId;
    data['city_name'] = cityName;
    data['type'] = type;
    data['postal_code'] = postalCode;
    return data;
  }
}

class CityModel {
/*
{
  "success": true,
  "data": [
    {
      "city_id": "114",
      "city_name": "Denpasar",
      "type": "Kota",
      "postal_code": "80227"
    }
  ],
  "message": "success"
} 
*/

  bool? success;
  List<CityModelData?>? data;
  String? message;

  CityModel({
    this.success,
    this.data,
    this.message,
  });
  CityModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      final v = json['data'];
      final arr0 = <CityModelData>[];
      v.forEach((v) {
        arr0.add(CityModelData.fromJson(v));
      });
      this.data = arr0;
    }
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
    data['message'] = message;
    return data;
  }
}

///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class DistrictModelData {
/*
{
  "district_id": "1573",
  "district_name": "Denpasar Barat",
  "type": "Kota"
} 
*/

  String? districtId;
  String? districtName;
  String? type;

  DistrictModelData({
    this.districtId,
    this.districtName,
    this.type,
  });
  DistrictModelData.fromJson(Map<String, dynamic> json) {
    districtId = json['district_id']?.toString();
    districtName = json['district_name']?.toString();
    type = json['type']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['district_id'] = districtId;
    data['district_name'] = districtName;
    data['type'] = type;
    return data;
  }
}

class DistrictModel {
/*
{
  "success": true,
  "data": [
    {
      "district_id": "1573",
      "district_name": "Denpasar Barat",
      "type": "Kota"
    }
  ],
  "message": "success"
} 
*/

  bool? success;
  List<DistrictModelData?>? data;
  String? message;

  DistrictModel({
    this.success,
    this.data,
    this.message,
  });
  DistrictModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      final v = json['data'];
      final arr0 = <DistrictModelData>[];
      v.forEach((v) {
        arr0.add(DistrictModelData.fromJson(v));
      });
      this.data = arr0;
    }
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
    data['message'] = message;
    return data;
  }
}

///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class SubDistrictModelData {
/*
{
  "subdistrict_id": "1573",
  "subdistrict_name": "Denpasar Barat",
  "type": "Kota"
} 
*/

  String? subdistrictId;
  String? subdistrictName;
  String? type;

  SubDistrictModelData({
    this.subdistrictId,
    this.subdistrictName,
    this.type,
  });
  SubDistrictModelData.fromJson(Map<String, dynamic> json) {
    subdistrictId = json['subdistrict_id']?.toString();
    subdistrictName = json['subdistrict_name']?.toString();
    type = json['type']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['subdistrict_id'] = subdistrictId;
    data['subdistrict_name'] = subdistrictName;
    data['type'] = type;
    return data;
  }
}

class SubDistrictModel {
/*
{
  "success": true,
  "data": [
    {
      "subdistrict_id": "1573",
      "subdistrict_name": "Denpasar Barat",
      "type": "Kota"
    }
  ],
  "message": "success"
} 
*/

  bool? success;
  List<SubDistrictModelData?>? data;
  String? message;

  SubDistrictModel({
    this.success,
    this.data,
    this.message,
  });
  SubDistrictModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      final v = json['data'];
      final arr0 = <SubDistrictModelData>[];
      v.forEach((v) {
        arr0.add(SubDistrictModelData.fromJson(v));
      });
      this.data = arr0;
    }
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
    data['message'] = message;
    return data;
  }
}
