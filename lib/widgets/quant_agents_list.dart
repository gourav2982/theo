import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';
import 'package:theo/models/models.dart';

class QuantAgentsList extends StatelessWidget {
  final List<QuantAgent> agents;

  const QuantAgentsList({
    Key? key,
    required this.agents,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: agents.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final agent = agents[index];
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  agent.name,
                  style: AppTheme.subheadingStyle,
                ),
                Text(
                  agent.performance,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.accentGreen,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}