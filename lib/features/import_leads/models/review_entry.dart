import 'package:uuid/uuid.dart';

import '../../../core/utils/phone_utils.dart';

const _uuid = Uuid();

/// An editable row in the import review screen.
class ReviewEntry {
  ReviewEntry({
    String? id,
    required this.name,
    required this.phone,
    required this.normalized,
    required this.isPlausible,
    this.isDuplicate = false,
    this.included = true,
    this.sourceText,
  }) : id = id ?? _uuid.v4();

  final String id;
  final String? name;
  final String phone;
  final String normalized;
  final bool isPlausible;
  final bool isDuplicate;
  final bool included;
  final String? sourceText;

  factory ReviewEntry.fromExtracted(
    ExtractedLeadRecord r, {
    String? defaultCountryCode,
  }) {
    return ReviewEntry(
      name: r.name,
      phone: r.rawPhone,
      normalized: r.normalization.normalized,
      isPlausible: r.normalization.isPlausible,
      sourceText: r.rawText,
    );
  }

  ReviewEntry copyWith({
    String? name,
    String? phone,
    String? normalized,
    bool? isPlausible,
    bool? isDuplicate,
    bool? included,
  }) {
    return ReviewEntry(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      normalized: normalized ?? this.normalized,
      isPlausible: isPlausible ?? this.isPlausible,
      isDuplicate: isDuplicate ?? this.isDuplicate,
      included: included ?? this.included,
      sourceText: sourceText,
    );
  }
}
