import 'package:flutter/material.dart';

import '/models/booking/booking_model.dart';
import '/models/booking/booking_repository.dart';
import '/models/categorie/categorie_repository.dart';
import '/models/percentage_stats/percentage_stats_model.dart';
import '/models/screen_arguments/categorie_amount_list_screen_arguments.dart';

import '/utils/consts/route_consts.dart';
import '/utils/number_formatters/number_formatter.dart';

class CategoriePercentageCard extends StatefulWidget {
  final PercentageStats percentageStats;
  final DateTime? selectedDate;
  final List<Booking> bookingList;

  const CategoriePercentageCard({
    Key? key,
    required this.percentageStats,
    required this.bookingList,
    this.selectedDate,
  }) : super(key: key);

  @override
  State<CategoriePercentageCard> createState() => _CategoriePercentageCardState();
}

class _CategoriePercentageCardState extends State<CategoriePercentageCard> {
  List<String> _subcategorieNames = [];
  List<Booking> _subcategorieBookings = [];
  final List<double> _subcategorieAmounts = [];
  final List<double> _subcategoriePercentages = [];

  // TODO erweitern um getRevenues und getInvestments
  Future<List<String>> _loadSubcategorieNameList() async {
    CategorieRepository categorieRepository = CategorieRepository();
    BookingRepository bookingRepository = BookingRepository();
    _subcategorieNames = await categorieRepository.loadSubcategorieNameList(widget.percentageStats.name);
    for (int i = 0; i < _subcategorieNames.length; i++) {
      double totalAmount = 0.0;
      _subcategorieBookings = await bookingRepository.loadSubcategorieBookingList(widget.bookingList, _subcategorieNames[i]);
      for (int j = 0; j < _subcategorieBookings.length; j++) {
        totalAmount += formatMoneyAmountToDouble(_subcategorieBookings[j].amount);
      }
      _subcategorieAmounts.add(totalAmount);
    }
    double totalExpenditures = bookingRepository.getExpenditures(widget.bookingList);
    for (int i = 0; i < _subcategorieNames.length; i++) {
      _subcategoriePercentages.add((_subcategorieAmounts[i] * 100) / totalExpenditures);
    }
    return _subcategorieNames;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: widget.percentageStats.statColor, width: 6.0)),
          ),
          child: ListTileTheme(
            contentPadding: const EdgeInsets.only(left: 8.0),
            horizontalTitleGap: 0.0,
            minLeadingWidth: 0.0,
            child: ExpansionTile(
              title: const SizedBox.shrink(),
              controlAffinity: ListTileControlAffinity.leading,
              textColor: Colors.white,
              iconColor: Colors.white,
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '${widget.percentageStats.percentage.abs().toStringAsFixed(1).replaceAll('.', ',')} %\t\t${widget.percentageStats.name}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        formatToMoneyAmount(formatMoneyAmountToDouble(widget.percentageStats.amount).abs().toString()),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: IconButton(
                      icon: const Icon(Icons.bar_chart_rounded),
                      onPressed: () =>
                          Navigator.pushNamed(context, categorieAmountListRoute, arguments: CategorieAmountListScreenArguments(widget.selectedDate!, widget.percentageStats.name)),
                      padding: const EdgeInsets.only(right: 6.0),
                    ),
                  ),
                ],
              ),
              children: <Widget>[
                FutureBuilder(
                  future: _loadSubcategorieNameList(),
                  builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const SizedBox();
                      case ConnectionState.done:
                        return SizedBox(
                          height: _subcategorieNames.length * 58.0,
                          child: ListView.builder(
                            itemCount: _subcategorieNames.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int subcategorieIndex) {
                              return ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 34.0, right: 8.0),
                                      child: Text(
                                        _subcategoriePercentages[subcategorieIndex].toStringAsFixed(1).replaceAll('.', ',') + ' %  ' + _subcategorieNames[subcategorieIndex],
                                        style: const TextStyle(fontSize: 14.0),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 52.0),
                                      child: Text(
                                        formatToMoneyAmount(_subcategorieAmounts[subcategorieIndex].toString()),
                                        style: const TextStyle(fontSize: 14.0),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      default:
                        return const SizedBox();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
