class ModelParseException implements Exception {
  final String model;
  final String field;
  final dynamic value;
  final Object? innerException;

  ModelParseException(this.model, this.field, this.value,
      [this.innerException]);

  @override
  String toString() {
    return 'Failed to parse $field in $model model. Value: $value. ${innerException != null ? 'Error: $innerException' : ''}';
  }
}
