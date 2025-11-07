import 'dart:convert';

CompaniesModel companiesModelFromJson(String str) =>
    CompaniesModel.fromJson(json.decode(str));

String companiesModelToJson(CompaniesModel data) => json.encode(data.toJson());

class CompaniesModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  CompaniesModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory CompaniesModel.fromJson(Map<String, dynamic> json) => CompaniesModel(
    success: json["success"],
    code: json["code"],
    message: json["message"],
    data: json["data"] != null ? Data.fromJson(json["data"]) : null,
    payload: json["payload"] != null ? List<dynamic>.from(json["payload"]) : [],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": code,
    "message": message,
    "data": data?.toJson(),
    "payload": payload ?? [],
  };
}

class Data {
  final List<Company>? companies;

  Data({this.companies});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    companies: json["companies"] != null
        ? List<Company>.from(json["companies"].map((x) => Company.fromJson(x)))
        : [],
  );

  Map<String, dynamic> toJson() => {
    "companies": companies?.map((x) => x.toJson()).toList() ?? [],
  };
}

class Company {
  final int? id;
  final String? companyName;
  final String? companyLogo;
  final List<CompanyCode>? companyCodes;
  final Country? country;

  Company({
    this.id,
    this.companyName,
    this.companyLogo,
    this.companyCodes,
    this.country,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["id"],
    companyName: json["company_name"],
    companyLogo: json["company_logo"],
    companyCodes: json["company_codes"] != null
        ? List<CompanyCode>.from(
            json["company_codes"].map((x) => CompanyCode.fromJson(x)),
          )
        : [],
    country: json["country"] != null ? Country.fromJson(json["country"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company_name": companyName,
    "company_logo": companyLogo,
    "company_codes": companyCodes?.map((x) => x.toJson()).toList() ?? [],
    "country": country?.toJson(),
  };
}

class CompanyCode {
  final int? id;
  final String? reservedDigit;

  CompanyCode({this.id, this.reservedDigit});

  factory CompanyCode.fromJson(Map<String, dynamic> json) =>
      CompanyCode(id: json["id"], reservedDigit: json["reserved_digit"]);

  Map<String, dynamic> toJson() => {"id": id, "reserved_digit": reservedDigit};
}

class Country {
  final int? id;
  final CountryName? countryName;
  final String? countryFlagImageUrl;

  Country({this.id, this.countryName, this.countryFlagImageUrl});

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id: json["id"],
    countryName: json["country_name"] != null
        ? countryNameValues.map[json["country_name"]]
        : null,
    countryFlagImageUrl: json["country_flag_image_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "country_name": countryName != null
        ? countryNameValues.reverse[countryName!]
        : null,
    "country_flag_image_url": countryFlagImageUrl,
  };
}

enum CountryName { AFGHANISTAN, IRAN, TURKEY }

final countryNameValues = EnumValues({
  "Afghanistan": CountryName.AFGHANISTAN,
  "Iran": CountryName.IRAN,
  "Turkey": CountryName.TURKEY,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
