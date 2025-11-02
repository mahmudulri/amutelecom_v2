// To parse this JSON data, do
//
//     final customResultModel = customResultModelFromJson(jsonString);

import 'dart:convert';

CustomResultModel customResultModelFromJson(String str) =>
    CustomResultModel.fromJson(json.decode(str));

String customResultModelToJson(CustomResultModel data) =>
    json.encode(data.toJson());

class CustomResultModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;

  CustomResultModel({
    this.success,
    this.code,
    this.message,
    this.data,
  });

  factory CustomResultModel.fromJson(Map<String, dynamic> json) =>
      CustomResultModel(
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
  final Order? order;

  Data({
    this.order,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        order: Order.fromJson(json["order"]),
      );

  Map<String, dynamic> toJson() => {
        "order": order!.toJson(),
      };
}

class Order {
  final String? rechargebleAccount;
  final Bundle? bundle;
  final String? orderType;

  final int? status;
  final DateTime? createdAt;

  final int? id;

  Order({
    this.rechargebleAccount,
    this.bundle,
    this.orderType,
    this.status,
    this.createdAt,
    this.id,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        rechargebleAccount: json["rechargeble_account"],
        bundle: json["bundle"] == null ? null : Bundle.fromJson(json["bundle"]),
        orderType: json["order_type"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "rechargeble_account": rechargebleAccount,
        "bundle": bundle!.toJson(),
        "order_type": orderType,
        "status": status,
        "id": id,
      };
}

class Bundle {
  final String? bundleTitle;
  final String? bundleDescription;
  final String? bundleType;
  final String? validityType;
  final String? isCustomRecharge;
  final String? amount;
  final String? buyingPrice;
  final String? adminBuyingPrice;
  final String? sellingPrice;

  final Service? service;

  Bundle({
    this.bundleTitle,
    this.bundleDescription,
    this.bundleType,
    this.validityType,
    this.isCustomRecharge,
    this.amount,
    this.buyingPrice,
    this.adminBuyingPrice,
    this.sellingPrice,
    this.service,
  });

  factory Bundle.fromJson(Map<String, dynamic> json) => Bundle(
        bundleTitle: json["bundle_title"],
        bundleDescription: json["bundle_description"],
        bundleType: json["bundle_type"],
        validityType: json["validity_type"],
        isCustomRecharge: json["is_custom_recharge"],
        amount: json["amount"],
        buyingPrice: json["buying_price"],
        adminBuyingPrice: json["admin_buying_price"],
        sellingPrice: json["selling_price"],
        service: Service.fromJson(json["service"]),
      );

  Map<String, dynamic> toJson() => {
        "bundle_title": bundleTitle,
        "bundle_description": bundleDescription,
        "bundle_type": bundleType,
        "validity_type": validityType,
        "is_custom_recharge": isCustomRecharge,
        "amount": amount,
        "buying_price": buyingPrice,
        "admin_buying_price": adminBuyingPrice,
        "selling_price": sellingPrice,
        "service": service!.toJson(),
      };
}

class Service {
  final Company? company;

  Service({
    this.company,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        company: Company.fromJson(json["company"]),
      );

  Map<String, dynamic> toJson() => {
        "company": company!.toJson(),
      };
}

class Company {
  final int? id;
  final String? companyName;
  final String? companyLogo;

  Company({
    this.id,
    this.companyName,
    this.companyLogo,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"],
        companyName: json["company_name"],
        companyLogo: json["company_logo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_name": companyName,
        "company_logo": companyLogo,
      };
}
