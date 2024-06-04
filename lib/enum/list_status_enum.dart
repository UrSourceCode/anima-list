enum ListStatus {
  watching,
  completed,
  onHold,
  planToWatch,
  dropped,
}

extension ListStatusExtension on ListStatus {
  static ListStatus fromString(String status) {
    switch (status) {
      case 'watching':
        return ListStatus.watching;
      case 'completed':
        return ListStatus.completed;
      case 'onHold':
        return ListStatus.onHold;
      case 'planToWatch':
        return ListStatus.planToWatch;
      case 'dropped':
        return ListStatus.dropped;
      default:
        throw Exception('Unknown status: $status');
    }
  }

  String toReadableString() {
    switch (this) {
      case ListStatus.watching:
        return 'Watching';
      case ListStatus.completed:
        return 'Completed';
      case ListStatus.onHold:
        return 'On-Hold';
      case ListStatus.planToWatch:
        return 'Plan to Watch';
      case ListStatus.dropped:
        return 'Dropped';
      default:
        return '';
    }
  }

  String toFirestoreString() {
    return toString().split('.').last;
  }
}
