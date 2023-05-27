import 'booking.dart';

class WealthDevelopmentStats {
  late String month;
  late double wealth;

  static Future<double> calculatePastWealthForMonth(DateTime currentDate, double currentBalance, List<Booking> bookingList) async {
    double monthExpenditures = Booking.getExpenditures(bookingList);
    double monthRevenues = Booking.getRevenues(bookingList);
    double monthInvestments = Booking.getInvestments(bookingList);
    double monthWealth = currentBalance + monthRevenues + monthInvestments - monthExpenditures;
    return monthWealth;
  }

  static double calculateAverageWealthGrowth(List<double> revenues, List<double> expenditures) {
    double balance = 0.0;
    List<double> monthBalances = [];
    for (int i = 0; i < revenues.length; i++) {
      print(expenditures[i]);
      if (revenues[i] == 0.0 && expenditures[i] == 0.0) {
        continue;
      }
      monthBalances.add(revenues[i] - expenditures[i]);
      print(monthBalances);
    }
    for (int i = 0; i < monthBalances.length; i++) {
      balance += monthBalances[i];
    }
    if (monthBalances.isEmpty) {
      return 0.0;
    }
    return balance / monthBalances.length;
  }
}
