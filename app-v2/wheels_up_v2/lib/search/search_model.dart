import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'search_model.freezed.dart';
part 'search_model.g.dart';

@freezed
class SearchHit with _$SearchHit {
  factory SearchHit({
    required String id,
    required String title,  
    required String description,
    required int pricePerHour,
    required String thumbnail,
    required String location,
  }) = _SearchHit;

  factory SearchHit.fromJson(Map<String, dynamic> json) => _$SearchHitFromJson(json);
}