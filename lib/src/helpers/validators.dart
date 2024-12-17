class Validators {
  static String? validateEmail(String? value, {bool required = true}) {
    if (value == null || value.isEmpty) {
      return required ? 'El correo electrónico es obligatorio' : null;
    }
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegExp.hasMatch(value)) {
      return 'Introduce un correo electrónico válido';
    }
    return null;
  }

  static String? validatePassword(String? value,
      {int minLength = 8,
      int maxLength = 256,
      bool requireUppercase = false,
      bool requireLowercase = false,
      bool requireNumbers = false,
      bool requireSpecialChars = false}) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria';
    }
    if (value.length < minLength) {
      return 'La contraseña debe tener al menos $minLength caracteres';
    }
    if (value.length > maxLength) {
      return 'La contraseña debe tener menos de $maxLength caracteres';
    }
    if (requireUppercase && !value.contains(RegExp(r'[A-Z]'))) {
      return 'La contraseña debe contener al menos una mayúscula';
    }
    if (requireLowercase && !value.contains(RegExp(r'[a-z]'))) {
      return 'La contraseña debe contener al menos una minúscula';
    }
    if (requireNumbers && !value.contains(RegExp(r'[0-9]'))) {
      return 'La contraseña debe contener al menos un número';
    }
    if (requireSpecialChars &&
        !value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'La contraseña debe contener al menos un carácter especial';
    }
    return null;
  }

  static String? validateString(
    String? value, {
    bool required = true,
    int? maxLength,
    int? minLength,
    String? fieldName,
    Pattern? pattern,
    String? patternError,
  }) {
    if (value == null || value.isEmpty) {
      return required ? '${fieldName ?? 'Este campo'} es obligatorio' : null;
    }
    if (maxLength != null && value.length > maxLength) {
      return '${fieldName ?? 'Este campo'} debe tener menos de $maxLength caracteres';
    }
    if (minLength != null && value.length < minLength) {
      return '${fieldName ?? 'Este campo'} debe tener al menos $minLength caracteres';
    }
    if (pattern != null && !pattern.allMatches(value).isNotEmpty) {
      return patternError ??
          '${fieldName ?? 'Este campo'} no tiene un formato válido';
    }
    return null;
  }

  static String? validateMatch(String? value, String? match,
      {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Este campo'} es obligatorio';
    }
    if (value != match) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  static String? validatePhone(String? value, {bool required = true}) {
    if (value == null || value.isEmpty) {
      return required ? 'El número de teléfono es obligatorio' : null;
    }
    final phoneRegExp = RegExp(r'^\+?[\d\s-]{9,}$');
    if (!phoneRegExp.hasMatch(value)) {
      return 'Introduce un número de teléfono válido';
    }
    return null;
  }

  static String? validateUrl(String? value, {bool required = true}) {
    if (value == null || value.isEmpty) {
      return required ? 'La URL es obligatoria' : null;
    }
    final urlRegExp = RegExp(
        r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$');
    if (!urlRegExp.hasMatch(value)) {
      return 'Introduce una URL válida';
    }
    return null;
  }

  static String? validateDate(
    String? value, {
    bool required = true,
    DateTime? minDate,
    DateTime? maxDate,
  }) {
    if (value == null || value.isEmpty) {
      return required ? 'La fecha es obligatoria' : null;
    }

    final date = DateTime.tryParse(value);
    if (date == null) {
      return 'Introduce una fecha válida';
    }

    if (minDate != null && date.isBefore(minDate)) {
      return 'La fecha debe ser posterior a ${_formatDate(minDate)}';
    }

    if (maxDate != null && date.isAfter(maxDate)) {
      return 'La fecha debe ser anterior a ${_formatDate(maxDate)}';
    }

    return null;
  }

  static String? validateNumber(
    String? value, {
    bool required = true,
    num? min,
    num? max,
    bool integer = false,
  }) {
    if (value == null || value.isEmpty) {
      return required ? 'Este campo es obligatorio' : null;
    }

    final number = num.tryParse(value);
    if (number == null) {
      return 'Introduce un número válido';
    }

    if (integer && number % 1 != 0) {
      return 'Introduce un número entero';
    }

    if (min != null && number < min) {
      return 'El número debe ser mayor o igual a $min';
    }

    if (max != null && number > max) {
      return 'El número debe ser menor o igual a $max';
    }

    return null;
  }

  // Utilidad para formatear fechas
  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
