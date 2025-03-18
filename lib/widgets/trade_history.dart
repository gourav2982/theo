import 'package:flutter/material.dart';
import 'package:theo/models/backtest_config_models.dart';

class TradeHistoryTable extends StatelessWidget {
  final List<TradeRecord> trades;

  const TradeHistoryTable({
    Key? key,
    required this.trades,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Trade History',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF111827), // gray-900
            fontFamily: 'Roboto',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFE5E7EB), // gray-200
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(
                  const Color(0xFFF9FAFB), // gray-50
                ),
                dataRowColor: MaterialStateProperty.all(Colors.white),
                dividerThickness: 1,
                columns: const [
                  DataColumn(
                    label: Text(
                      'DATE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B7280), // gray-500
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'ACTION',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B7280), // gray-500
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'SYMBOL',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B7280), // gray-500
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'PRICE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B7280), // gray-500
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ],
                rows: trades.map((trade) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          trade.date,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280), // gray-500
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          trade.action,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: trade.isBuy
                                ? const Color(0xFF059669) // green-600
                                : const Color(0xFFDC2626), // red-600
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          trade.symbol,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1F2937), // gray-800
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          trade.price,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1F2937), // gray-800
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}