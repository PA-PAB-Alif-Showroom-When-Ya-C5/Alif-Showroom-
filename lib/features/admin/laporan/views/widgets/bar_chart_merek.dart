import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/shared/models/laporan_model.dart';

class BarChartMerek extends StatelessWidget {
  final List<MerekTerlaris> data;

  const BarChartMerek({super.key, required this.data});

  static const _colors = [
    AppTheme.primary,
    AppTheme.accent,
    AppTheme.success,
    AppTheme.info,
    AppTheme.warning,
    AppTheme.error,
  ];

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const _EmptyChart(
          message: 'Belum ada data merek untuk periode ini.');
    }

    final maxY = data
            .map((e) => e.jumlah.toDouble())
            .reduce((a, b) => a > b ? a : b) *
        1.3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 220,
          child: BarChart(
            BarChartData(
              maxY:            maxY,
              minY:            0,
              gridData:        FlGridData(
                show:              true,
                drawVerticalLine:  false,
                horizontalInterval: maxY / 4,
                getDrawingHorizontalLine: (_) => FlLine(
                  color:       AppTheme.divider,
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(
                show:   true,
                border: const Border(
                  bottom: BorderSide(color: AppTheme.divider),
                  left:   BorderSide(color: AppTheme.divider),
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles:   true,
                    reservedSize: 28,
                    interval:     maxY / 4 < 1 ? 1 : null,
                    getTitlesWidget: (value, _) => Text(
                      value.toInt().toString(),
                      style: const TextStyle(
                          fontSize: 10,
                          color: AppTheme.textHint),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles:   true,
                    reservedSize: 32,
                    getTitlesWidget: (value, _) {
                      final idx = value.toInt();
                      if (idx < 0 || idx >= data.length) {
                        return const SizedBox.shrink();
                      }
                      final merek = data[idx].merek;
                      // Truncate panjang label
                      final label = merek.length > 7
                          ? '${merek.substring(0, 6)}.'
                          : merek;
                      return Padding(
                        padding:
                            const EdgeInsets.only(top: 6),
                        child: Text(label,
                            style: const TextStyle(
                              fontSize: 10,
                              color:    AppTheme.textSecondary,
                            )),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
              ),
              barGroups: data.asMap().entries.map((entry) {
                final idx    = entry.key;
                final item   = entry.value;
                final color  = _colors[idx % _colors.length];

                return BarChartGroupData(
                  x: idx,
                  barRods: [
                    BarChartRodData(
                      toY:            item.jumlah.toDouble(),
                      color:          color,
                      width:          28,
                      borderRadius:   const BorderRadius.vertical(
                          top: Radius.circular(6)),
                      backDrawRodData: BackgroundBarChartRodData(
                        show:  true,
                        toY:   maxY,
                        color: color.withOpacity(0.06),
                      ),
                    ),
                  ],
                );
              }).toList(),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, _, rod, __) {
                    final item = data[group.x];
                    return BarTooltipItem(
                      '${item.merek}\n${item.jumlah} unit',
                      const TextStyle(
                          color:      Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize:   12),
                    );
                  },
                ),
              ),
            ),
          ),
        ),

        // ── Legenda ────────────────────────────────────────
        const SizedBox(height: AppTheme.spacingMd),
        Wrap(
          spacing:   AppTheme.spacingMd,
          runSpacing: AppTheme.spacingXs,
          children: data.asMap().entries.map((entry) {
            final color = _colors[entry.key % _colors.length];
            return Row(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: 12, height: 12,
                decoration: BoxDecoration(
                  color:        color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '${entry.value.merek} (${entry.value.jumlah})',
                style: const TextStyle(
                    fontSize: 11,
                    color:    AppTheme.textSecondary),
              ),
            ]);
          }).toList(),
        ),
      ],
    );
  }
}

class _EmptyChart extends StatelessWidget {
  final String message;
  const _EmptyChart({required this.message});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 160,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart_outlined, size: 48,
              color: AppTheme.textHint.withOpacity(0.4)),
          const SizedBox(height: AppTheme.spacingSm),
          Text(message,
              style: const TextStyle(
                  color: AppTheme.textHint, fontSize: 13),
              textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}