import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/shared/models/laporan_model.dart';

class LineChartProfit extends StatelessWidget {
  final List<LaporanBulananModel> data;

  const LineChartProfit({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty || data.length < 2) {
      return const _EmptyChart(
          message:
              'Butuh minimal 2 bulan data untuk menampilkan tren.');
    }

    final profits = data.map((e) => e.totalProfit).toList();
    final maxY    = profits.reduce((a, b) => a > b ? a : b) * 1.25;
    final minY    = profits.reduce((a, b) => a < b ? a : b) * 0.8;

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          minY: minY < 0 ? minY : 0,
          maxY: maxY <= 0 ? 1000000 : maxY,
          gridData: FlGridData(
            show:             true,
            drawVerticalLine: false,
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
                reservedSize: 52,
                getTitlesWidget: (value, _) => Text(
                  _formatSingkat(value),
                  style: const TextStyle(
                      fontSize: 10, color: AppTheme.textHint),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles:   true,
                reservedSize: 28,
                getTitlesWidget: (value, _) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= data.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(data[idx].namaBulan,
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
          lineBarsData: [
            LineChartBarData(
              spots: data.asMap().entries.map((e) =>
                  FlSpot(e.key.toDouble(), e.value.totalProfit)
              ).toList(),
              isCurved:          true,
              curveSmoothness:   0.35,
              color:             AppTheme.success,
              barWidth:          3,
              isStrokeCapRound:  true,
              dotData: FlDotData(
                show:    true,
                getDotPainter: (_, __, ___, ____) =>
                    FlDotCirclePainter(
                  radius:           4,
                  color:            Colors.white,
                  strokeWidth:      2.5,
                  strokeColor:      AppTheme.success,
                ),
              ),
              belowBarData: BarAreaData(
                show:  true,
                color: AppTheme.success.withOpacity(0.08),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) => spots.map((spot) {
                final idx  = spot.x.toInt();
                final item = data[idx];
                final fmt  = NumberFormat.currency(
                    locale: 'id_ID', symbol: 'Rp ',
                    decimalDigits: 0);
                return LineTooltipItem(
                  '${item.namaBulan} ${item.tahun}\n'
                  '${fmt.format(item.totalProfit)}',
                  const TextStyle(
                    color:      Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize:   12,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  String _formatSingkat(double v) {
    if (v >= 1e9) return '${(v / 1e9).toStringAsFixed(1)}M';
    if (v >= 1e6) return '${(v / 1e6).toStringAsFixed(1)}Jt';
    if (v >= 1e3) return '${(v / 1e3).toStringAsFixed(0)}Rb';
    return v.toStringAsFixed(0);
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
          Icon(Icons.show_chart_outlined, size: 48,
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