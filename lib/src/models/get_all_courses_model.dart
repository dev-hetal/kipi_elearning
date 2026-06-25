class GetAllCoursesModel {
  bool? status;
  int? statusCode;
  String? message;
  CourseData? data;

  GetAllCoursesModel({this.status, this.statusCode, this.message, this.data});

  GetAllCoursesModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    statusCode = json["statusCode"];
    message = json["message"];
    data = json["data"] != null ? CourseData.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = status;
    data["statusCode"] = statusCode;
    data["message"] = message;
    if (this.data != null) {
      data["data"] = this.data!.toJson();
    }
    return data;
  }
}

class CourseData {
  int? limit;
  int? totalRecords;
  int? totalPages;
  bool? hasPreviousPage;
  int? currentPage;
  bool? hasNextPage;
  List<AllCoursesRecordList>? recordList;

  CourseData(
      {this.limit,
      this.totalRecords,
      this.totalPages,
      this.hasPreviousPage,
      this.currentPage,
      this.hasNextPage,
      this.recordList});

  CourseData.fromJson(Map<String, dynamic> json) {
    limit = json["limit"];
    totalRecords = json["totalRecords"];
    totalPages = json["totalPages"];
    hasPreviousPage = json["hasPreviousPage"];
    currentPage = json["currentPage"];
    hasNextPage = json["hasNextPage"];
    if (json["recordList"] != null) {
      recordList = <AllCoursesRecordList>[];
      json["recordList"].forEach((v) {
        recordList!.add(AllCoursesRecordList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["limit"] = limit;
    data["totalRecords"] = totalRecords;
    data["totalPages"] = totalPages;
    data["hasPreviousPage"] = hasPreviousPage;
    data["currentPage"] = currentPage;
    data["hasNextPage"] = hasNextPage;
    if (recordList != null) {
      data["recordList"] = recordList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllCoursesRecordList {
  String? id;
  String? instituteId;
  String? subjectId;
  String? materialType;
  num? price;
  String? title;
  String? subTitle;
  String? userType;
  String? appType;
  String? courseStatus;
  List<String>? entities;
  String? status;
  String? instructor;
  num? expiryTime;
  String? thumbNail;
  String? introVideo;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? createdBy;
  String? updatedBy;
  String? deletedBy;
  CourseThumbNail? courseThumbNail;
  CourseThumbNail? courseIntroVideo;

  AllCoursesRecordList(
      {this.id,
      this.instituteId,
      this.subjectId,
      this.materialType,
      this.price,
      this.title,
      this.subTitle,
      this.userType,
      this.appType,
      this.courseStatus,
      this.entities,
      this.status,
      this.instructor,
      this.expiryTime,
      this.thumbNail,
      this.introVideo,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.createdBy,
      this.updatedBy,
      this.deletedBy,
      this.courseThumbNail,
      this.courseIntroVideo});

  AllCoursesRecordList.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    instituteId = json["instituteId"];
    subjectId = json["subjectId"];
    materialType = json["materialType"];
    price = json["price"];
    title = json["title"];
    subTitle = json["subTitle"];
    userType = json["userType"];
    appType = json["appType"];
    courseStatus = json["courseStatus"];
    entities = json["entities"].cast<String>();
    status = json["status"];
    instructor = json["instructor"];
    expiryTime = json["expiryTime"];
    thumbNail = json["thumbNail"];
    introVideo = json["introVideo"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
    deletedAt = json["deletedAt"];
    createdBy = json["createdBy"];
    updatedBy = json["updatedBy"];
    deletedBy = json["deletedBy"];
    courseThumbNail = json["courseThumbNail"] != null ? CourseThumbNail.fromJson(json["courseThumbNail"]) : null;
    courseIntroVideo = json["courseIntroVideo"] != null ? CourseThumbNail.fromJson(json["courseIntroVideo"]) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["instituteId"] = instituteId;
    data["subjectId"] = subjectId;
    data["materialType"] = materialType;
    data["price"] = price;
    data["title"] = title;
    data["subTitle"] = subTitle;
    data["userType"] = userType;
    data["appType"] = appType;
    data["courseStatus"] = courseStatus;
    data["entities"] = entities;
    data["status"] = status;
    data["instructor"] = instructor;
    data["expiryTime"] = expiryTime;
    data["thumbNail"] = thumbNail;
    data["introVideo"] = introVideo;
    data["createdAt"] = createdAt;
    data["updatedAt"] = updatedAt;
    data["deletedAt"] = deletedAt;
    data["createdBy"] = createdBy;
    data["updatedBy"] = updatedBy;
    data["deletedBy"] = deletedBy;
    if (courseThumbNail != null) {
      data["courseThumbNail"] = courseThumbNail!.toJson();
    }
    if (courseIntroVideo != null) {
      data["courseIntroVideo"] = courseIntroVideo!.toJson();
    }
    return data;
  }
}

class CourseThumbNail {
  String? id;
  String? originalFileName;
  String? storageFileName;
  String? storagePath;
  String? filePath;
  String? expiredAt;
  String? presignedUrl;

  CourseThumbNail(
      {this.id,
      this.originalFileName,
      this.storageFileName,
      this.storagePath,
      this.filePath,
      this.expiredAt,
      this.presignedUrl});

  CourseThumbNail.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    originalFileName = json["originalFileName"];
    storageFileName = json["storageFileName"];
    storagePath = json["storagePath"];
    filePath = json["filePath"];
    expiredAt = json["expiredAt"];
    presignedUrl = json["presignedUrl"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["originalFileName"] = originalFileName;
    data["storageFileName"] = storageFileName;
    data["storagePath"] = storagePath;
    data["filePath"] = filePath;
    data["expiredAt"] = expiredAt;
    data["presignedUrl"] = presignedUrl;
    return data;
  }
}
