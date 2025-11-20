import 'dart:convert';

BranchModel branchModelFromJson(String str) =>
    BranchModel.fromJson(json.decode(str));

String branchModelToJson(BranchModel data) => json.encode(data.toJson());

class BranchModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;

  BranchModel({this.success, this.code, this.message, this.data});

  factory BranchModel.fromJson(Map<String, dynamic> json) => BranchModel(
    success: json["success"],
    code: json["code"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": code,
    "message": message,
    "data": data!.toJson(),
  };
}

class Data {
  final List<Hawalabranch>? hawalabranches;

  Data({this.hawalabranches});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    hawalabranches: List<Hawalabranch>.from(
      json["hawalabranches"].map((x) => Hawalabranch.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "hawalabranches": List<dynamic>.from(
      hawalabranches!.map((x) => x.toJson()),
    ),
  };
}

class Hawalabranch {
  final int? id;
  final String? name;
  final String? address;
  final String? phoneNumber;

  Hawalabranch({this.id, this.name, this.address, this.phoneNumber});

  factory Hawalabranch.fromJson(Map<String, dynamic> json) => Hawalabranch(
    id: json["id"],
    name: json["name"],
    address: json["address"],
    phoneNumber: json["phone_number"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address": address,
    "phone_number": phoneNumber,
  };
}
