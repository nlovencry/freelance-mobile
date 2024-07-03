import 'dart:io';

import 'package:hy_tutorial/src/work_order/wo_realization/model/wo_search.dart';

class WOActivitiesParam {
  final String taskName;
  final String taskDuration;
  final String description;

  WOActivitiesParam(this.taskName, this.taskDuration, this.description);
}

class WOToolsParam {
  final String toolsId;
  final String companyId;
  final String toolsName;
  final String uom;
  final String qty;

  WOToolsParam(
      this.toolsId, this.companyId, this.toolsName, this.uom, this.qty);
}

class WOLaboursParam {
  String craft;
  String skill;
  String amount;
  List<String> personilNip;

  WOLaboursParam(this.craft, this.skill, this.amount, this.personilNip);
}

class WOServiceParam {
  final String serviceId;
  final String serviceName;
  final String uom;
  final String qty;

  WOServiceParam(
    this.serviceId,
    this.serviceName,
    this.uom,
    this.qty,
  );
}

class WOSparepartParam {
  final String companyId;
  final String code;
  final String name;
  final String qty;
  final String uom;
  final String eta;
  final String description;
  final String whName;
  final String whCode;
  final String unitCode;
  final String unitName;

  WOSparepartParam(
      this.companyId,
      this.code,
      this.name,
      this.qty,
      this.uom,
      this.eta,
      this.description,
      this.whName,
      this.whCode,
      this.unitCode,
      this.unitName);
}

class WOAttachmentParam {
  final File file;
  final String fileURL;
  final String fileName;
  final String description;

  WOAttachmentParam(
    this.file,
    this.fileURL,
    this.fileName,
    this.description,
  );
}

class WOProgressParam {
  final File file;
  final String fileURL;
  final String baseProgressId;
  final String date;
  final String justification;
  final String description;
  final String attachment;

  WOProgressParam(this.file, this.fileURL, this.baseProgressId, this.date,
      this.justification, this.description, this.attachment);
}

class WOFailureCodeParam {
  final String assetSystemId;
  final String assetSystemCode;
  final String assetSystemName;
  final String assetSubSystemId;
  final String assetSubSystemCode;
  final String assetSubSystemName;
  final String description;

  WOFailureCodeParam(
      this.assetSystemId,
      this.assetSystemCode,
      this.assetSystemName,
      this.assetSubSystemName,
      this.assetSubSystemId,
      this.assetSubSystemCode,
      this.description);
}

class WOAttachmentRealizationParam {
  final File file;
  final String fileURL;
  final String fileName;
  final String description;

  WOAttachmentRealizationParam(
      this.description, this.file, this.fileURL, this.fileName);
}
