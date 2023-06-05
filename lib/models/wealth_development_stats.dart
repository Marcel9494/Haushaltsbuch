import 'dart:math';

import 'booking.dart';

class WealthDevelopmentStats {
  late String month;
  late double wealth;

  // TODO hier weitermachen und Vermögensenticklung für die Vergangenheit pro Monat berechnen.
  static Future<double> calculatePastWealth(DateTime currentDate, double currentBalance) async {
    List<Booking> _bookingList = await Booking.loadMonthlyBookingList(currentDate.month - 1, currentDate.year);
    double monthExpenditures = Booking.getExpenditures(_bookingList);
    double monthRevenues = Booking.getRevenues(_bookingList);
    double monthInvestments = Booking.getInvestments(_bookingList);
    double monthWealth = currentBalance + monthRevenues + monthInvestments - monthExpenditures;
    return monthWealth;
  }

  static double calculateAverageWealthGrowth(List<double> revenues, List<double> expenditures) {
    double averageWealthGrowth = 0.0;
    for (int i = 0; i < revenues.length; i++) {
      //print("Revenues: " + revenues[i].toString());
      //print("Expenditures: " + expenditures[i].toString());
      averageWealthGrowth = averageWealthGrowth + revenues[i] - expenditures[i];
      //print("Average Wealth Growth 1: " + averageWealthGrowth.toString());
    }
    return averageWealthGrowth / revenues.length;
  }

  static double calculateAverageInvestmentGrowth(List<double> revenues, List<double> expenditures, List<double> investments) {
    double averageWealthGrowth = 0.0;
    for (int i = 0; i < revenues.length; i++) {
      //print("Revenues: " + revenues[i].toString());
      //print("Expenditures: " + expenditures[i].toString());
      averageWealthGrowth = averageWealthGrowth + revenues[i] - expenditures[i];
      //print("Average Wealth Growth 1: " + averageWealthGrowth.toString());
    }
    return averageWealthGrowth / revenues.length;
  }

  static double calculateCompoundInterest(double startCapital, int year) {
    return startCapital * pow((1 + 0.6 / 100), year);
  }
}
