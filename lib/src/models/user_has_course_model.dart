class UserHasCourseModel {
  bool? status;
  int? statusCode;
  String? message;
  List<UserHasCourseData>? data;

  UserHasCourseModel({this.status, this.statusCode, this.message, this.data});

  UserHasCourseModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    statusCode = json["statusCode"];
    message = json["message"];
    if (json["data"] != null) {
      data = <UserHasCourseData>[];
      json["data"].forEach((v) {
        data!.add(UserHasCourseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = status;
    data["statusCode"] = statusCode;
    data["message"] = message;
    if (this.data != null) {
      data["data"] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserHasCourseData {
  String? id;
  String? userId;
  String? courseId;
  String? instituteId;
  num? price;
  num? discount;
  String? expiryDate;
  String? status;
  String? courseStatus;
  String? walletTransactionId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? createdBy;
  String? updatedBy;
  String? deletedBy;

  UserHasCourseData(
      {this.id,
      this.userId,
      this.courseId,
      this.instituteId,
      this.price,
      this.discount,
      this.expiryDate,
      this.status,
      this.courseStatus,
      this.walletTransactionId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.createdBy,
      this.updatedBy,
      this.deletedBy});

  UserHasCourseData.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    userId = json["userId"];
    courseId = json["courseId"];
    instituteId = json["instituteId"];
    price = json["price"];
    discount = json["discount"];
    expiryDate = json["expiryDate"];
    status = json["status"];
    courseStatus = json["courseStatus"];
    walletTransactionId = json["walletTransactionId"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
    deletedAt = json["deletedAt"];
    createdBy = json["createdBy"];
    updatedBy = json["updatedBy"];
    deletedBy = json["deletedBy"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["userId"] = userId;
    data["courseId"] = courseId;
    data["instituteId"] = instituteId;
    data["price"] = price;
    data["discount"] = discount;
    data["expiryDate"] = expiryDate;
    data["status"] = status;
    data["courseStatus"] = courseStatus;
    data["walletTransactionId"] = walletTransactionId;
    data["createdAt"] = createdAt;
    data["updatedAt"] = updatedAt;
    data["deletedAt"] = deletedAt;
    data["createdBy"] = createdBy;
    data["updatedBy"] = updatedBy;
    data["deletedBy"] = deletedBy;
    return data;
  }
}
