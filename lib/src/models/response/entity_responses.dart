import 'package:gvm_flutter/src/models/model_base.dart';
import 'package:gvm_flutter/src/models/models_library.dart';

class GetEntitiesResponse {
  List<Entity> entities;

  GetEntitiesResponse({required this.entities});

  factory GetEntitiesResponse.fromJson(Map<String, dynamic> json) {
    return GetEntitiesResponse(
      entities: createModels<Entity>(json['entities'], Entity.fromJson),
    );
  }
}

class GetEntityResponse {
  Entity entity;

  GetEntityResponse({required this.entity});

  factory GetEntityResponse.fromJson(Map<String, dynamic> json) {
    return GetEntityResponse(
      entity: Entity.fromJson(json['entity']),
    );
  }
}
