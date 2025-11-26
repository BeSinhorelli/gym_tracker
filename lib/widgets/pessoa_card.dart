import 'package:flutter/material.dart';
import 'package:gym_tracker/models/pessoa.dart';
import 'package:intl/intl.dart';

class PessoaCard extends StatelessWidget {
  final Pessoa pessoa;
  final VoidCallback onTap;
  final VoidCallback onProgress;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PessoaCard({
    super.key,
    required this.pessoa,
    required this.onTap,
    required this.onProgress,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            pessoa.nome[0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          pessoa.nome,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Idade: ${pessoa.idade} anos'),
            Text('Peso: ${pessoa.peso} kg • Altura: ${pessoa.altura} m'),
            Text('Objetivo: ${pessoa.objetivo} • ${pessoa.nivel}'),
            Text(
              'Cadastrado em: ${DateFormat('dd/MM/yyyy').format(pessoa.dataCriacao)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'progress',
              child: Row(
                children: [
                  Icon(Icons.bar_chart),
                  SizedBox(width: 8),
                  Text('Ver Progresso'),
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
              case 'progress':
                onProgress();
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
}
