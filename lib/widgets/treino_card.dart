import 'package:flutter/material.dart';
import 'package:gym_tracker/models/treino.dart';
import 'package:intl/intl.dart';

class TreinoCard extends StatelessWidget {
  final Treino treino;
  final VoidCallback onTap;
  final VoidCallback onToggleRealizado;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TreinoCard({
    super.key,
    required this.treino,
    required this.onTap,
    required this.onToggleRealizado,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      // COR ALTERADA: Fundo azul claro para treinos realizados
      color: treino.realizado ? Color(0xFFE3F2FD) : null,
      child: ListTile(
        leading: _buildLeadingIcon(),
        title: Text(
          treino.nomeExercicio,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: treino.realizado ? TextDecoration.lineThrough : null,
            // COR ALTERADA: Texto azul para realizados
            color: treino.realizado ? Color(0xFF1976D2) : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Grupo: ${treino.grupoMuscular}'),
            Text('${treino.series} séries × ${treino.repeticoes} reps'),
            if (treino.carga > 0) Text('Carga: ${treino.carga} kg'),
            if (treino.observacoes != null && treino.observacoes!.isNotEmpty)
              Text(
                'Obs: ${treino.observacoes!}',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            const SizedBox(height: 4),
            Text(
              DateFormat('dd/MM/yyyy - HH:mm').format(treino.dataTreino),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'toggle',
              child: Row(
                children: [
                  Icon(
                    treino.realizado ? Icons.close : Icons.check,
                    color: treino.realizado ? Colors.red : Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Text(treino.realizado
                      ? 'Marcar não realizado'
                      : 'Marcar realizado'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Editar'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Excluir'),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case 'toggle':
                onToggleRealizado();
                break;
              case 'edit':
                onEdit();
                break;
              case 'delete':
                onDelete();
                break;
            }
          },
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLeadingIcon() {
    IconData icon;
    Color color;

    switch (treino.grupoMuscular) {
      case 'Peito':
        icon = Icons.fitness_center;
        color = Colors.red;
        break;
      case 'Costas':
        icon = Icons.arrow_upward;
        color = Colors.blue;
        break;
      case 'Pernas':
        icon = Icons.directions_walk;
        color = Colors.green;
        break;
      case 'Ombros':
        icon = Icons.arrow_upward;
        color = Colors.orange;
        break;
      case 'Bíceps':
        icon = Icons.accessibility;
        color = Colors.purple;
        break;
      case 'Tríceps':
        icon = Icons.accessibility_new;
        color = Colors.pink;
        break;
      case 'Abdômen':
        icon = Icons.square;
        color = Colors.teal;
        break;
      case 'Cardio':
        icon = Icons.directions_run;
        color = Colors.cyan;
        break;
      default:
        icon = Icons.fitness_center;
        color = Colors.grey;
    }

    return Stack(
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        if (treino.realizado)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.blue, // COR ALTERADA: Azul no lugar do verde
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 12,
              ),
            ),
          ),
      ],
    );
  }
}
