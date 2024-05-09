class Nutrient {
  final String label;
  final double quantity;
  final String unit;

  Nutrient({required this.label, required this.quantity, required this.unit});

  factory Nutrient.fromJson(Map<String, dynamic> json) {
    return Nutrient(
      label: json['label'],
      quantity: json['quantity'],
      unit: json['unit'],
    );
  }
}
