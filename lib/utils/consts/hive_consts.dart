import '../settings/settings.dart';

// Namen der Hive Boxen
var bookingsBox = demoMode ? 'DEMO_bookings' : 'bookings';
var accountsBox = demoMode ? 'DEMO_accounts' : 'accounts';
var primaryAccountsBox = demoMode ? 'DEMO_primaryAccounts' : 'primaryAccounts';
var categoriesBox = demoMode ? 'DEMO_categories' : 'categories';
var budgetsBox = demoMode ? 'DEMO_budgets' : 'budgets';
var subbudgetsBox = demoMode ? 'DEMO_subbudgets' : 'subbudgets';
var defaultBudgetsBox = demoMode ? 'DEMO_defaultBudgets' : 'defaultBudgets';
var globalStateBox = demoMode ? 'DEMO_globalState' : 'globalState';
var introScreenBox = demoMode ? 'DEMO_introScreen' : 'introScreen';

// TypeIDs der Hive Adapter/Klassen => bessere Übersicht
// Erlaubte Range für TypeId: 0 - 223
const int bookingTypeId = 0;
const int transactionTypeId = 1;
const int introScreenTypeId = 2;
const int accountTypeId = 3;
const int categoryTypeId = 4;
const int budgetTypeId = 5;
const int globalStateTypeId = 6;
const int defaultBudgetTypeId = 7;
const int categoryTypeTypeId = 8;
const int primaryAccountTypeId = 9;
const int subbudgetTypeId = 10;
