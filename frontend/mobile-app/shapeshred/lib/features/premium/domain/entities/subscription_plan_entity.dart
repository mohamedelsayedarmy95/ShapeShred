class SubscriptionPlan {
  final String id;
  final String name;
  final double price;
  final String period;
  final String description;
  final bool isPopular;
  final double discount; // 0.0 if no discount

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.period,
    required this.description,
    this.isPopular = false,
    this.discount = 0.0,
  });

  String get priceLabel => '\$${price.toStringAsFixed(2)}';
  String get periodLabel => '/ $period';
  String get discountLabel =>
      discount > 0 ? 'Save ${(discount * 100).toInt()}%' : '';
}
