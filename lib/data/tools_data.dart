import 'package:flutter/material.dart';
import 'package:theo/models/tool_models.dart';

class ToolsData {
  static List<ToolOption> getToolOptions() {
    return [
      ToolOption(
        id: 'backtest',
        icon: Icons.sync_alt,
        label: 'Backtest',
        description: 'Test your strategies against historical market data',
      ),
      ToolOption(
        id: 'papertrading',
        icon: Icons.description,
        label: 'Paper Trading',
        description: 'Practice trading without real money',
      ),
      ToolOption(
        id: 'alerts',
        icon: Icons.notifications,
        label: 'Manage Alerts',
        description: 'Configure your buy/sell notifications',
      ),
      ToolOption(
        id: 'baskets',
        icon: Icons.work,
        label: 'Manage Baskets',
        description: 'Organize stocks into custom groups',
      ),
      ToolOption(
        id: 'strategies',
        icon: Icons.tune,
        label: 'Manage Strategies',
        description: 'Create and edit your trading strategies',
      ),
      ToolOption(
        id: 'indicators',
        icon: Icons.bar_chart,
        label: 'Manage Indicators',
        description: 'Configure technical analysis indicators',
      ),
    ];
  }
}