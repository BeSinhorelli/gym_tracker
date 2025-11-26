import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker/models/pessoa.dart';
import 'package:gym_tracker/services/local_storage_service.dart';
import 'package:gym_tracker/widgets/progresso_chart.dart';

class ProgressoScreen extends StatelessWidget {
  final Pessoa pessoa;

  const ProgressoScreen({super.key, required this.pessoa});

  @override
  Widget build(BuildContext context) {
    final storageService = Provider.of<LocalStorageService>(context);
    final estatisticas = storageService.getEstatisticas(pessoa.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('Progresso - ${pessoa.nome}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Resumo Geral',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard(
                          context,
                          'Total de Treinos',
                          estatisticas['totalTreinos'].toString(),
                          Icons.fitness_center,
                        ),
                        _buildStatCard(
                          context,
                          'Realizados',
                          '${estatisticas['treinosRealizados']}',
                          Icons.check_circle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard(
                          context,
                          'Taxa de Realização',
                          '${estatisticas['taxaRealizacao'].toStringAsFixed(1)}%',
                          Icons.trending_up,
                        ),
                        _buildStatCard(
                          context,
                          'Carga Total',
                          '${estatisticas['cargaTotal'].toStringAsFixed(0)} kg',
                          Icons.monitor_weight,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ProgressoChart(
              pessoa: pessoa,
              estatisticas: estatisticas,
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Distribuição por Grupos Musculares',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._buildGruposMuscularesList(context, estatisticas),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context, String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  List<Widget> _buildGruposMuscularesList(
      BuildContext context, Map<String, dynamic> estatisticas) {
    final grupos = estatisticas['gruposMusculares'] as Map<String, int>;
    final totalTreinos = estatisticas['totalTreinos'] as int;

    if (grupos.isEmpty) {
      return [
        const Text('Nenhum treino registrado ainda.'),
      ];
    }

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
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                '${percentage.toStringAsFixed(1)}%',
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
