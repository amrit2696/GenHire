class ClientOptionModel {
  final dynamic id;
  final String label;

  ClientOptionModel({required this.id, required this.label});

  factory ClientOptionModel.fromJson(Map<String, dynamic> json) {
    return ClientOptionModel(
      id: json['Id'],
      label: json['Name']?.toString() ?? '',
    );
  }
}
