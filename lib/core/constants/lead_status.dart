/// The lifecycle state of a lead.
enum LeadStatus {
  newLead('new', 'New'),
  contacted('contacted', 'Contacted'),
  interested('interested', 'Interested'),
  followUp('follow_up', 'Follow-up'),
  notInterested('not_interested', 'Not Interested'),
  converted('converted', 'Converted'),
  invalidNumber('invalid_number', 'Invalid Number');

  const LeadStatus(this.dbValue, this.label);

  final String dbValue;
  final String label;

  static LeadStatus fromDb(String value) {
    return LeadStatus.values.firstWhere(
      (s) => s.dbValue == value,
      orElse: () => LeadStatus.newLead,
    );
  }
}

/// The outcome recorded after attempting to contact a lead.
enum CallOutcome {
  noAnswer('no_answer', 'No answer'),
  busy('busy', 'Busy'),
  callBackLater('call_back_later', 'Call back later'),
  interested('interested', 'Interested'),
  notInterested('not_interested', 'Not interested'),
  converted('converted', 'Converted'),
  wrongNumber('wrong_number', 'Wrong number');

  const CallOutcome(this.dbValue, this.label);

  final String dbValue;
  final String label;

  static CallOutcome fromDb(String value) {
    return CallOutcome.values.firstWhere(
      (s) => s.dbValue == value,
      orElse: () => CallOutcome.noAnswer,
    );
  }

  /// The lead status that should follow this outcome, when applicable.
  LeadStatus? get impliedStatus {
    switch (this) {
      case CallOutcome.interested:
        return LeadStatus.interested;
      case CallOutcome.notInterested:
        return LeadStatus.notInterested;
      case CallOutcome.converted:
        return LeadStatus.converted;
      case CallOutcome.wrongNumber:
        return LeadStatus.invalidNumber;
      case CallOutcome.callBackLater:
        return LeadStatus.followUp;
      case CallOutcome.noAnswer:
      case CallOutcome.busy:
        return LeadStatus.contacted;
    }
  }
}
