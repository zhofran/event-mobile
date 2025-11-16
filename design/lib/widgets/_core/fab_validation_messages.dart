import 'package:deps/features/features.dart';
import 'package:deps/packages/reactive_forms.dart';

/// Shared validation messages utility for form components
class FabValidationMessages {
  /// Get default validation messages with optional custom messages
  static Map<String, String Function(Object)> getValidationMessages({
    String? fieldLabel,
    Map<String, String Function(Object)>? customMessages,
  }) {
    final label = fieldLabel?.capitalize() ?? 'Field';

    return {
      ValidationMessage.minLength: (error) =>
          $.tr.design.widgets.reactives.fabReactiveTextfield.minLength(
            field: label,
            count: (error as Map)['requiredLength'].toString(),
          ),
      ValidationMessage.maxLength: (error) =>
          $.tr.design.widgets.reactives.fabReactiveTextfield.maxLength(
            field: label,
            count: (error as Map)['requiredLength'].toString(),
          ),
      ValidationMessage.required: (_) =>
          $.tr.design.widgets.reactives.fabReactiveTextfield.required(
            field: label,
          ),
      ValidationMessage.email: (_) =>
          $.tr.design.widgets.reactives.fabReactiveTextfield.email(
            field: label,
          ),
      if (customMessages != null) ...customMessages,
    };
  }

  /// Get error message from form control
  static String? getErrorMessage({
    required FormControl formControl,
    String? fieldLabel,
    Map<String, String Function(Object)>? customMessages,
  }) {
    if (!formControl.hasErrors) return null;

    final errors = formControl.errors;
    final errorKey = errors.keys.first;
    final errorValue = errors[errorKey] ?? {};

    final validationMessages = getValidationMessages(
      fieldLabel: fieldLabel,
      customMessages: customMessages,
    );

    // Check if we have a custom validation message for this error
    if (validationMessages.containsKey(errorKey)) {
      return validationMessages[errorKey]!(errorValue);
    }

    // Fallback to a generic error message
    return 'Invalid ${fieldLabel?.toLowerCase() ?? 'field'}';
  }
}
