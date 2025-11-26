import 'package:flutter/material.dart';
import 'package:gym_tracker/models/pessoa.dart';

class ProgressoChart extends StatelessWidget {
  final Pessoa pessoa;
  final Map<String, dynamic> estatisticas;

  const ProgressoChart({
    super.key,
    required this.pessoa,
    required this.estatisticas,
  });

  @override
  Widget build(BuildContext context) {
    final grupos = estatisticas['gruposMusculares'] as Map<String, int>;

    if (grupos.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text('Não há dados suficientes para exibir estatísticas.'),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Distribuição de Treinos por Grupo Muscular',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Substitui o gráfico por uma lista simples
            ..._buildListaGrupos(grupos, estatisticas['totalTreinos'] as int),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildListaGrupos(Map<String, int> grupos, int totalTreinos) {
    return grupos.entries.map((entry) {
      final percentage =
          totalTreinos > 0 ? (entry.value / totalTreinos * 100) : 0;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(entry.key),
            ),
            Expanded(
              flex: 3,
              child: LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getColorForGroup(entry.key),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                '${entry.value} (${percentage.toStringAsFixed(1)}%)',
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Color _getColorForGroup(String grupo) {
    switch (grupo) {
      case 'Peito':
        return Colors.red;
      case 'Costas':
        return Colors.blue;
      case 'Pernas':
        return Colors.green;
      case 'Ombros':
        return Colors.orange;
      case 'Bíceps':
        return Colors.purple;
      case 'Tríceps':
        return Colors.pink;
      case 'Abdômen':
        return Colors.teal;
      case 'Cardio':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }
}