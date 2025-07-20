import 'package:json_annotation/json_annotation.dart';

part 'vrm_model.g.dart';

@JsonSerializable()
class VRMModel {
  final String id;
  final String name;
  final String description;
  final String? thumbnailUrl;
  final String? modelUrl;
  final VRMMetadata metadata;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final VRMStats stats;

  VRMModel({
    required this.id,
    required this.name,
    required this.description,
    this.thumbnailUrl,
    this.modelUrl,
    required this.metadata,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
    required this.stats,
  });

  factory VRMModel.fromJson(Map<String, dynamic> json) =>
      _$VRMModelFromJson(json);
  Map<String, dynamic> toJson() => _$VRMModelToJson(this);

  VRMModel copyWith({
    String? id,
    String? name,
    String? description,
    String? thumbnailUrl,
    String? modelUrl,
    VRMMetadata? metadata,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    VRMStats? stats,
  }) {
    return VRMModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      modelUrl: modelUrl ?? this.modelUrl,
      metadata: metadata ?? this.metadata,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      stats: stats ?? this.stats,
    );
  }
}

@JsonSerializable()
class VRMMetadata {
  final String version;
  final String title;
  final String? author;
  final String? contactInformation;
  final String? reference;
  final String? thumbnailImage;
  final String? licenseUrl;
  final List<String>? allowedUserName;
  final bool violentUsage;
  final bool sexualUsage;
  final bool commercialUsage;
  final bool otherPermissionUrl;
  final bool showUserAvatar;
  final bool showUserAvatarName;

  VRMMetadata({
    required this.version,
    required this.title,
    this.author,
    this.contactInformation,
    this.reference,
    this.thumbnailImage,
    this.licenseUrl,
    this.allowedUserName,
    required this.violentUsage,
    required this.sexualUsage,
    required this.commercialUsage,
    required this.otherPermissionUrl,
    required this.showUserAvatar,
    required this.showUserAvatarName,
  });

  factory VRMMetadata.fromJson(Map<String, dynamic> json) =>
      _$VRMMetadataFromJson(json);
  Map<String, dynamic> toJson() => _$VRMMetadataToJson(this);
}

@JsonSerializable()
class VRMStats {
  final int vertexCount;
  final int materialCount;
  final int meshCount;
  final int boneCount;
  final int blendShapeCount;
  final double fileSize;
  final String format;

  VRMStats({
    required this.vertexCount,
    required this.materialCount,
    required this.meshCount,
    required this.boneCount,
    required this.blendShapeCount,
    required this.fileSize,
    required this.format,
  });

  factory VRMStats.fromJson(Map<String, dynamic> json) =>
      _$VRMStatsFromJson(json);
  Map<String, dynamic> toJson() => _$VRMStatsToJson(this);
}
