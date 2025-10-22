import 'package:deps/features/features.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:deps/packages/injectable.dart';

import '../../data/company_profile.service.dart';
import '../../domain/models/company_profile.model.dart';

@injectable
class CompanyProfileCubit extends Cubit<PaginatedListState<CompanyProfileModel>> {
  CompanyProfileCubit(this._service) : super(const PaginatedListState.initial());

  final CompanyProfileService _service;

  Future<void> fetchCompanyProfile({required int companyId}) async {
    emit(const PaginatedListState.loading());

    // Mock data based on the design reference
    final mockCompanyProfile = CompanyProfileModel(
      id: companyId,
      name: 'Ceria Corp.',
      tagline: 'We innovate goods for the greater good',
      description: '''Be part of Indonesia's most purposeful beauty movement. At Ceria Corp, we believe beauty is more than skin deep — it's a force for good. With 14,000+ Paragonians across the nation, we build brands that move markets, touch hearts, and uplift communities. Our growth isn't a reward for doing good — it's driven by it. Because we don't just create beneficial — we grow by choosing to be beneficial.''',
      industry: 'Mining & Smelter',
      location: 'Jakarta, Indonesia, DKI Jakarta',
      website: 'www.ptceria.com',
      verifiedDate: 'August 15, 2024',
      employeeRange: '500 - 1000 Employees',
      employeeCount: '10,001+ employees',
      specialties: ['Cosmetics', 'Distribution', 'Manufacture', 'Mining & Smelter'],
      foundedYear: 1985,
      bannerImage: 'https://picsum.photos/400/200',
      logoImage: 'https://picsum.photos/100/100',
      teamImages: [
        'https://picsum.photos/80/80?random=1',
        'https://picsum.photos/80/80?random=2',
        'https://picsum.photos/80/80?random=3',
        'https://picsum.photos/80/80?random=4',
        'https://picsum.photos/80/80?random=5',
        'https://picsum.photos/80/80?random=6',
      ],
      isVerified: true,
      growthData: [
        MonthlyGrowthData(month: 'Jul', value: 15),
        MonthlyGrowthData(month: 'Aug', value: 25),
        MonthlyGrowthData(month: 'Sep', value: 35),
      ],
    );

    emit(PaginatedListState.loaded([mockCompanyProfile]));
  }

  void refresh() => emit(const PaginatedListState.refresh());
}
