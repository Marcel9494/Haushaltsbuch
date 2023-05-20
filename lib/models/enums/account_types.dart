enum AccountType { account, capitalInvestments, cash, card, insurance, credit, other }

extension AccountTypeExtension on AccountType {
  String get name {
    switch (this) {
      case AccountType.account:
        return 'Konto';
      case AccountType.capitalInvestments:
        return 'Kapitalanlage';
      case AccountType.cash:
        return 'Bargeld';
      case AccountType.card:
        return 'Karte';
      case AccountType.insurance:
        return 'Versicherung';
      case AccountType.credit:
        return 'Kredit';
      case AccountType.other:
        return 'Sonstiges';
      default:
        throw Exception('$name is not a valid Account type.');
    }
  }

  String get pluralName {
    switch (this) {
      case AccountType.account:
        return 'Konten';
      case AccountType.capitalInvestments:
        return 'Kapitalanlagen';
      case AccountType.cash:
        return 'Bargeld';
      case AccountType.card:
        return 'Karten';
      case AccountType.insurance:
        return 'Versicherungen';
      case AccountType.credit:
        return 'Kredite';
      case AccountType.other:
        return 'Sonstiges';
      default:
        throw Exception('$name is not a valid Account type.');
    }
  }

  static String getAccountTypePluralName(String account) {
    try {
      if (account == AccountType.account.name) {
        return AccountType.account.pluralName;
      } else if (account == AccountType.capitalInvestments.name) {
        return AccountType.capitalInvestments.pluralName;
      } else if (account == AccountType.cash.name) {
        return AccountType.cash.pluralName;
      } else if (account == AccountType.card.name) {
        return AccountType.card.pluralName;
      } else if (account == AccountType.insurance.name) {
        return AccountType.insurance.pluralName;
      } else if (account == AccountType.credit.name) {
        return AccountType.credit.pluralName;
      } else if (account == AccountType.other.name) {
        return AccountType.other.pluralName;
      }
    } catch (e) {
      throw Exception('$account is not a valid Account name.');
    }
    return AccountType.account.pluralName;
  }
}
