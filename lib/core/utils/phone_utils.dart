/// Result of attempting to normalize a raw phone number string.
class PhoneNormalizationResult {
  const PhoneNormalizationResult({
    required this.normalized,
    required this.isPlausible,
    this.reason,
  });

  /// Best-effort normalized representation, e.g. "+919876543210".
  /// Preserves digits as a string; never treated as a number.
  final String normalized;

  /// Whether this looks like a plausible phone number. This is a heuristic,
  /// not full validation - the UI must label results accordingly.
  final bool isPlausible;

  /// Short human-readable reason when [isPlausible] is false.
  final String? reason;
}

/// A single name/phone record extracted from pasted or imported text.
class ExtractedLeadRecord {
  ExtractedLeadRecord({
    required this.rawText,
    required this.name,
    required this.rawPhone,
    required this.normalization,
  });

  final String rawText;
  String? name;
  String rawPhone;
  PhoneNormalizationResult normalization;

  bool get isPlausible => normalization.isPlausible;
}

/// Utilities for finding and normalizing phone numbers from free-form text.
///
/// This is a heuristic, offline implementation. It intentionally avoids
/// matching things that look like dates, IDs, or short unrelated numbers.
class PhoneUtils {
  PhoneUtils._();

  /// Matches digit runs (optionally with +, spaces, hyphens, dots, parens)
  /// that are long enough to plausibly be a phone number.
  static final RegExp _candidateRegex = RegExp(
    r'(\+?\(?\d{1,4}\)?[\d\-\.\s]{5,}\d)',
  );

  static final RegExp _nonDigitPlus = RegExp(r'[^\d+]');
  static final RegExp _leadingZeros00 = RegExp(r'^00');

  /// Extracts all plausible phone-number candidates (with best-effort
  /// associated names) from a block of pasted text.
  ///
  /// Supports newline-separated entries, comma-separated entries,
  /// tab-separated (spreadsheet-style) entries, and the common "name on its
  /// own line, followed by a phone number on the next line" layout produced
  /// by copying from documents or contact exports.
  static List<ExtractedLeadRecord> extractFromText(
    String input, {
    String? defaultCountryCode,
  }) {
    final records = <ExtractedLeadRecord>[];
    final lines = input.split(RegExp(r'\r?\n'));
    String? pendingName;

    for (final rawLine in lines) {
      final line = rawLine.trim();
      if (line.isEmpty) continue;

      if (line.contains('\t')) {
        records.addAll(
          _extractFromSegments(
            line,
            line.split('\t'),
            defaultCountryCode: defaultCountryCode,
          ),
        );
        pendingName = null;
        continue;
      }

      if (line.contains(',')) {
        records.addAll(
          _extractFromSegments(
            line,
            line.split(','),
            defaultCountryCode: defaultCountryCode,
          ),
        );
        pendingName = null;
        continue;
      }

      final match = _candidateRegex.firstMatch(line);
      if (match == null) {
        // No phone number on this line - it's likely a name that belongs
        // to a phone number on a following line.
        pendingName = _cleanName(line) ?? pendingName;
        continue;
      }

      final phone = match.group(0)!;
      final before = line.substring(0, match.start).trim();
      final after = line.substring(match.end).trim();
      final inlineName = before.isNotEmpty
          ? before
          : (after.isNotEmpty ? after : null);
      final name = _cleanName(inlineName) ?? pendingName;
      pendingName = null;

      records.add(
        ExtractedLeadRecord(
          rawText: line,
          name: name,
          rawPhone: phone,
          normalization: normalize(
            phone,
            defaultCountryCode: defaultCountryCode,
          ),
        ),
      );
    }

    return records;
  }

  static List<ExtractedLeadRecord> _extractFromSegments(
    String rawLine,
    List<String> segments, {
    String? defaultCountryCode,
  }) {
    final results = <ExtractedLeadRecord>[];
    String? pendingName;

    for (final rawSegment in segments) {
      final segment = rawSegment.trim();
      if (segment.isEmpty) continue;

      final match = _candidateRegex.firstMatch(segment);
      if (match == null) {
        // No number in this segment - treat as a possible name for the
        // next segment that does contain a number.
        pendingName ??= segment;
        continue;
      }

      final phone = match.group(0)!;
      final before = segment.substring(0, match.start).trim();
      final after = segment.substring(match.end).trim();
      final nameFromSegment = before.isNotEmpty
          ? before
          : (after.isNotEmpty ? after : null);
      final name = _cleanName(nameFromSegment ?? pendingName);
      pendingName = null;

      results.add(
        ExtractedLeadRecord(
          rawText: rawLine,
          name: name,
          rawPhone: phone,
          normalization: normalize(
            phone,
            defaultCountryCode: defaultCountryCode,
          ),
        ),
      );
    }

    return results;
  }

  static String? _cleanName(String? raw) {
    if (raw == null) return null;
    var cleaned = raw
        .replaceAll(
          RegExp(
            r'^(contact|name|mobile|phone|tel|call)\s*[:\-]?\s*',
            caseSensitive: false,
          ),
          '',
        )
        .replaceAll(RegExp(r'[:\-,]+$'), '')
        .trim();
    if (cleaned.isEmpty) return null;
    return cleaned;
  }

  /// Normalizes a raw phone string into a best-effort canonical form.
  ///
  /// Digits are preserved as a string (never parsed as a number) so that
  /// leading zeros and country-code prefixes are not lost.
  static PhoneNormalizationResult normalize(
    String raw, {
    String? defaultCountryCode,
  }) {
    var cleaned = raw.trim().replaceAll(_nonDigitPlus, '');
    if (cleaned.isEmpty) {
      return const PhoneNormalizationResult(
        normalized: '',
        isPlausible: false,
        reason: 'No digits found',
      );
    }

    if (cleaned.startsWith(_leadingZeros00)) {
      cleaned = '+${cleaned.substring(2)}';
    }

    final hasPlus = cleaned.startsWith('+');
    var digits = hasPlus ? cleaned.substring(1) : cleaned;

    // Strip a single trunk-prefix zero, e.g. "0" + 10-digit local number.
    if (!hasPlus && digits.length == 11 && digits.startsWith('0')) {
      digits = digits.substring(1);
    }

    if (digits.length < 7 || digits.length > 15) {
      return PhoneNormalizationResult(
        normalized: hasPlus ? '+$digits' : digits,
        isPlausible: false,
        reason: 'Unlikely digit count (${digits.length})',
      );
    }

    if (hasPlus) {
      return PhoneNormalizationResult(normalized: '+$digits', isPlausible: true);
    }

    if (digits.length == 10 &&
        defaultCountryCode != null &&
        defaultCountryCode.isNotEmpty) {
      return PhoneNormalizationResult(
        normalized: '+$defaultCountryCode$digits',
        isPlausible: true,
      );
    }

    if (digits.length > 10) {
      // Likely already contains a country code, but we can't be fully sure.
      return PhoneNormalizationResult(normalized: '+$digits', isPlausible: true);
    }

    // 10 digits but no default country code configured - still plausible,
    // just not converted to international format.
    return PhoneNormalizationResult(normalized: digits, isPlausible: true);
  }
}
