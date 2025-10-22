import 'package:deps/packages/freezed_annotation.dart';

part 'company_profile.model.freezed.dart';
part 'company_profile.model.g.dart';

@freezed
sealed class CompanyProfileModel with _$CompanyProfileModel {
  factory CompanyProfileModel({
    required int id,
    required String name,
    required String tagline,
    required String description,
    required String industry,
    required String location,
    required String website,
    required String verifiedDate,
    required String employeeRange,
    required String employeeCount,
    required List<String> specialties,
    required int foundedYear,
    required String bannerImage,
    required String logoImage,
    required List<String> teamImages,
    required bool isVerified,
    required List<MonthlyGrowthData> growthData,
  }) = _CompanyProfileModel;

  factory CompanyProfileModel.fromJson(Map<String, dynamic> json) => _$CompanyProfileModelFromJson(json);

  factory CompanyProfileModel.empty() => CompanyProfileModel(
        id: 0,
        name: 'Company Name',
        tagline: 'Company tagline',
        description: 'Company description',
        industry: 'Technology',
        location: 'Jakarta, Indonesia',
        website: 'www.company.com',
        verifiedDate: 'January 1, 2024',
        employeeRange: '1-10 Employees',
        employeeCount: '1+ employees',
        specialties: [],
        foundedYear: 2020,
        bannerImage: '',
        logoImage: '',
        teamImages: [],
        isVerified: false,
        growthData: [],
      );

  CompanyProfileModel._();

  bool get isEmpty => this == CompanyProfileModel.empty();
}

@freezed
sealed class MonthlyGrowthData with _$MonthlyGrowthData {
  factory MonthlyGrowthData({
    required String month,
    required double value,
  }) = _MonthlyGrowthData;

  factory MonthlyGrowthData.fromJson(Map<String, dynamic> json) => _$MonthlyGrowthDataFromJson(json);
}