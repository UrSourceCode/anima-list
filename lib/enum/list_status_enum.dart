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
      case 'Watching':
        return ListStatus.watching;
      case 'Completed':
        return ListStatus.completed;
      case 'On-Hold':
        return ListStatus.onHold;
      case 'Plan to Watch':
        return ListStatus.planToWatch;
      case 'Dropped':
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
}
