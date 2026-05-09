class ValidationResult {
  final bool isValid;
  final String? message;
  final bool isHardLimit;

  ValidationResult._(this.isValid, this.message, this.isHardLimit);

  factory ValidationResult.valid() => ValidationResult._(true, null, false);
  factory ValidationResult.hardLimitViolation(String msg) => ValidationResult._(false, msg, true);
  factory ValidationResult.softLimitWarning(String msg) => ValidationResult._(false, msg, false);
}

class LimitValidator {
  ValidationResult validate(double rate, dynamic drug) {
    // Check Hard Limit
    if (drug.hardLimitHigh > 0 && rate > drug.hardLimitHigh) {
      return ValidationResult.hardLimitViolation(
        'Rate $rate mL/hr exceeds hard limit of ${drug.hardLimitHigh} mL/hr'
      );
    }
    
    // Check Soft Limit
    if (drug.softLimitHigh != null && rate > drug.softLimitHigh!) {
      return ValidationResult.softLimitWarning(
        'Rate $rate mL/hr exceeds soft limit of ${drug.softLimitHigh} mL/hr'
      );
    }
    
    return ValidationResult.valid();
  }
}
