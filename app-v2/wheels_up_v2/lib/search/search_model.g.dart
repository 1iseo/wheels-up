// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SearchHitImpl _$$SearchHitImplFromJson(Map<String, dynamic> json) =>
    _$SearchHitImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      pricePerHour: (json['pricePerHour'] as num).toInt(),
      thumbnail: json['thumbnail'] as String,
      location: json['location'] as String,
    );

Map<String, dynamic> _$$SearchHitImplToJson(_$SearchHitImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'pricePerHour': instance.pricePerHour,
      'thumbnail': instance.thumbnail,
      'location': instance.location,
    };
