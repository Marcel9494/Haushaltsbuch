enum ModeType { creationMode, editMode }

extension ModeTypeExtension on ModeType {
  String get name {
    switch (this) {
      case ModeType.creationMode:
        return 'Erstellen';
      case ModeType.editMode:
        return 'Bearbeiten';
      default:
        throw Exception('$name is not a valid Mode type.');
    }
  }
}
