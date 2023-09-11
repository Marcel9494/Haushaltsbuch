enum BudgetModeType { budgetCreationMode, subbudgetCreationMode, updateDefaultBudgetMode, updateBudgetMode }

extension BudgetModeTypeExtension on BudgetModeType {
  String get name {
    switch (this) {
      case BudgetModeType.budgetCreationMode:
        return 'Budget erstellen';
      case BudgetModeType.subbudgetCreationMode:
        return 'Subbudget erstellen';
      case BudgetModeType.updateDefaultBudgetMode:
        return 'Standardbudget bearbeiten';
      case BudgetModeType.updateBudgetMode:
        return 'Budget bearbeiten';
      default:
        throw Exception('$name is not a valid Budget Mode type.');
    }
  }
}
