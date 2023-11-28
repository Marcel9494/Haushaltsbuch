import 'dart:math';

import 'booking/booking_model.dart';
import 'booking/booking_repository.dart';

// TODO muss noch umgebaut werden vorerst noch kein Repository Pattern implementieren bevor nicht geklärt ist,
// TODO ob dieses Feature in das Erste Release aufgenommen wird => wahrscheinlich nicht.
class WealthDevelopmentStats {
  late String month;
  late double wealth;

  // TODO hier weitermachen und Vermögensentwicklung für die Vergangenheit pro Monat berechnen.
  static Future<double> calculatePastWealth(DateTime currentDate, double currentBalance) async {
    BookingRepository bookingRepository = BookingRepository();
    List<Booking> _bookingList = await bookingRepository.loadMonthlyBookingList(currentDate.month - 1, currentDate.year);
    double monthExpenditures = bookingRepository.getExpenditures(_bookingList);
    double monthRevenues = bookingRepository.getRevenues(_bookingList);
    double monthInvestments = bookingRepository.getInvestments(_bookingList);
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
