// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenMetadata _$TokenMetadataFromJson(Map<String, dynamic> json) =>
    TokenMetadata(
      json['address'] as String,
      json['chainId'] as int,
      json['decimals'] as int,
      json['name'] as String,
      json['symbol'] as String,
      json['logoURI'] as String,
      (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$TokenMetadataToJson(TokenMetadata instance) =>
    <String, dynamic>{
      'address': instance.address,
      'chainId': instance.chainId,
      'decimals': instance.decimals,
      'name': instance.name,
      'symbol': instance.symbol,
      'logoURI': instance.logoURI,
      'tags': instance.tags,
    };
