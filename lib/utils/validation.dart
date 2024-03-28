class Validation {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }

    // Regular expression to match valid phone numbers
    final RegExp phoneRegex = RegExp(r'^\+[1-9]\d{1,14}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  static String? validateAvatar(String? value) {
    // Avatar is optional, so return null if value is empty
    if (value == null || value.isEmpty) {
      return null;
    }
    // You can add custom validation for avatar here if needed
    return null;
  }
}
