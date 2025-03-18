import 'package:flutter/material.dart';
import 'package:theo/models/backtest_models.dart';

class BacktestListItem extends StatelessWidget {
  final Backtest backtest;
  final VoidCallback onTap;

  const BacktestListItem({
    Key? key,
    required this.backtest,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row with name and performance metrics
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left column - Name and metadata
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        backtest.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF111827), // gray-900
                          fontFamily: 'Roboto',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 4,
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: Color(0xFF6B7280), // gray-500
                          ),
                          const SizedBox(width: 2),
                          Text(
                            backtest.date,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280), // gray-500
                              fontFamily: 'Roboto',
                            ),
                          ),
                          _buildDot(),
                          Text(
                            backtest.strategy,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280), // gray-500
                              fontFamily: 'Roboto',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          _buildDot(),
                          Text(
                            backtest.period,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280), // gray-500
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // Right column - Performance metrics
                if (backtest.status == BacktestStatus.completed)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${backtest.returnPercent! >= 0 ? '+' : ''}${backtest.returnPercent!.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: backtest.isOutperforming 
                                  ? const Color(0xFF059669) // green-600
                                  : const Color(0xFFDC2626), // red-600
                              fontFamily: 'Roboto',
                            ),
                          ),
                          const Text(
                            ' vs ',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9CA3AF), // gray-400
                              fontFamily: 'Roboto',
                            ),
                          ),
                          Text(
                            '${backtest.benchmark!.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280), // gray-500
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            backtest.isOutperforming 
                                ? Icons.arrow_upward 
                                : Icons.arrow_downward,
                            size: 12,
                            color: backtest.isOutperforming 
                                ? const Color(0xFF059669) // green-600
                                : const Color(0xFFDC2626), // red-600
                          ),
                          const SizedBox(width: 4),
                          Text(
                            backtest.isOutperforming 
                                ? 'Outperformed' 
                                : 'Underperformed',
                            style: TextStyle(
                              fontSize: 12,
                              color: backtest.isOutperforming 
                                  ? const Color(0xFF059669) // green-600
                                  : const Color(0xFFDC2626), // red-600
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCEFFF), // custom blue-100
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'In Progress',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E40AF), // blue-800
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
              ],
            ),
            
            // Tags
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTag(backtest.basket, const Color(0xFFF3F4F6)),
                if (backtest.strategy == 'Custom')
                  _buildTag('Custom Strategy', const Color(0xFFF5F3FF), const Color(0xFF7C3AED)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot() {
    return const Text(
      '•',
      style: TextStyle(
        fontSize: 12,
        color: Color(0xFF9CA3AF), // gray-400
      ),
    );
  }

  Widget _buildTag(String text, Color bgColor, [Color textColor = const Color(0xFF1F2937)]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textColor,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }
}