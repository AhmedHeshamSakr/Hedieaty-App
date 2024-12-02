import 'package:flutter/material.dart';

class GiftModel {
  final int id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String status;
  final int eventId;
  final Text pledgedByUserId;

  GiftModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.status,
    required this.eventId,
    required this.pledgedByUserId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'status': status,
      'eventId': eventId,
      'pledgedByUserId': pledgedByUserId,
    };
  }

  factory GiftModel.fromMap(Map<String, dynamic> map) {
    return GiftModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      category: map['category'],
      price: map['price'],
      status: map['status'],
      eventId: map['eventId'],
      pledgedByUserId:map['pledgedByUserId'],
    );
  }

  GiftModel copyWith({
    int? id,
    String? name,
    String? description,
    String? category,
    String? status,
    double? price,
    int? eventId,
  }) {
    return GiftModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      status: status ?? this.status,
      price: price ?? this.price,
      eventId: eventId ?? this.eventId,
      pledgedByUserId: pledgedByUserId,
    );
  }
}
