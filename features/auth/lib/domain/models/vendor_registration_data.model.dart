// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

class VendorRegistrationData {
  // Step 1: Company Information
  String? companyName;
  String? companyType;
  String? companyTypeId;
  String? companyDescription;
  String? companyAvatar;

  // Step 2: Business Details
  String? foundedYear;
  String? websiteUrl;
  String? socialMediaUrl;
  String? paymentTerm;
  
  // Step 3: Location & Market Focus
  String? country;
  String? countryIso2;
  String? city;
  String? cityId;
  List<String> marketFocus;

  // Additional vendor-specific fields
  List<int> eventTypeIds;
  String? averageEventSize;
  List<String> venueTypes;
  String? repName;
  String? repPosition;
  String? repEmail;

  VendorRegistrationData({
    this.companyName,
    this.companyType,
    this.companyTypeId,
    this.companyDescription,
    this.companyAvatar,
    this.foundedYear,
    this.websiteUrl,
    this.socialMediaUrl,
    this.paymentTerm,
    this.country,
    this.countryIso2,
    this.city,
    this.cityId,
    this.marketFocus = const [],
    this.eventTypeIds = const [],
    this.averageEventSize,
    this.venueTypes = const [],
    this.repName,
    this.repPosition,
    this.repEmail,
  });

  VendorRegistrationData copyWith({
    String? companyName,
    String? companyType,
    String? companyTypeId,
    String? companyDescription,
    String? companyAvatar,
    String? foundedYear,
    String? websiteUrl,
    String? socialMediaUrl,
    String? paymentTerm,
    String? country,
    String? countryIso2,
    String? city,
    String? cityId,
    List<String>? marketFocus,
    List<int>? eventTypeIds,
    String? averageEventSize,
    List<String>? venueTypes,
    String? repName,
    String? repPosition,
    String? repEmail,
  }) {
    return VendorRegistrationData(
      companyName: companyName ?? this.companyName,
      companyType: companyType ?? this.companyType,
      companyTypeId: companyTypeId ?? this.companyTypeId,
      companyDescription: companyDescription ?? this.companyDescription,
      companyAvatar: companyAvatar ?? this.companyAvatar,
      foundedYear: foundedYear ?? this.foundedYear,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      socialMediaUrl: socialMediaUrl ?? this.socialMediaUrl,
      paymentTerm: paymentTerm ?? this.paymentTerm,
      country: country ?? this.country,
      countryIso2: countryIso2 ?? this.countryIso2,
      city: city ?? this.city,
      cityId: cityId ?? this.cityId,
      marketFocus: marketFocus ?? this.marketFocus,
      eventTypeIds: eventTypeIds ?? this.eventTypeIds,
      averageEventSize: averageEventSize ?? this.averageEventSize,
      venueTypes: venueTypes ?? this.venueTypes,
      repName: repName ?? this.repName,
      repPosition: repPosition ?? this.repPosition,
      repEmail: repEmail ?? this.repEmail,
    );
  }

  bool get isStep1Complete {
    return companyName?.isNotEmpty == true &&
           companyTypeId?.isNotEmpty == true &&
           companyDescription?.isNotEmpty == true;
  }

  bool get isStep2Complete {
    return foundedYear?.isNotEmpty == true &&
           websiteUrl?.isNotEmpty == true &&
           socialMediaUrl?.isNotEmpty == true &&
           paymentTerm?.isNotEmpty == true;
  }

  bool get isStep3Complete {
    return country?.isNotEmpty == true &&
           city?.isNotEmpty == true &&
           marketFocus.isNotEmpty;
  }

  bool get isComplete {
    return isStep1Complete && isStep2Complete && isStep3Complete;
  }

  Map<String, dynamic> toApiPayload() {
    return {
      'company_name': companyName,
      'company_type_id': companyTypeId,
      'company_description': companyDescription,
      'event_type_ids': eventTypeIds,
      'average_event_size': averageEventSize ?? 'Medium',
      'website_url': websiteUrl,
      'social_media_url': socialMediaUrl,
      'city_id': cityId,
      'venue_types': venueTypes.isNotEmpty ? venueTypes : ['Indoor'],
      'rep_name': repName ?? 'N/A',
      'rep_position': repPosition ?? 'N/A',
      'rep_email': repEmail ?? 'N/A',
    };
  }

  @override
  String toString() {
    return 'VendorRegistrationData(companyName: $companyName, companyType: $companyType, city: $city, country: $country)';
  }
}