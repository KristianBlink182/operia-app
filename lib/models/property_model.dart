class Property {
  final int id;
  final String title;
  final String descriptionEs;
  final String descriptionEn;
  final String listingType;
  final double totalAreaM2;
  final double clearHeightM;
  final double priceUsd;
  final String district;

  Property({
    required this.id,
    required this.title,
    required this.descriptionEs,
    required this.descriptionEn,
    required this.listingType,
    required this.totalAreaM2,
    required this.clearHeightM,
    required this.priceUsd,
    required this.district,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      title: json['title'] ?? '',
      descriptionEs: json['description_es'] ?? '',
      descriptionEn: json['description_en'] ?? '',
      listingType: json['listing_type'] ?? 'rent',
      totalAreaM2: double.tryParse(json['total_area_m2'].toString()) ?? 0.0,
      clearHeightM: double.tryParse(json['clear_height_m'].toString()) ?? 0.0,
      priceUsd: double.tryParse(json['price_usd'].toString()) ?? 0.0,
      district: json['district'] ?? '',
    );
  }
}