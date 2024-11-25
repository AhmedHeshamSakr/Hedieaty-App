class Gift {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String imageUrl;
  final String status; // "available", "pledged", "purchased"
  final String eventId;

  Gift({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.status,
    required this.eventId,
  });
}

//   /// Domain-specific method to check if the gift is pledged
//   bool isPledged() {
//     return status == "pledged";
//   }
// }
//
