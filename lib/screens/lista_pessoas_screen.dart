import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker/models/pessoa.dart';
import 'package:gym_tracker/services/local_storage_service.dart';
import 'package:gym_tracker/screens/add_pessoa_screen.dart';
import 'package:gym_tracker/screens/lista_treinos_screen.dart';
import 'package:gym_tracker/screens/progresso_screen.dart';
import 'package:gym_tracker/widgets/pessoa_card.dart';

class ListaPessoasScreen extends StatelessWidget {
  const ListaPessoasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storageService = Provider.of<LocalStorageService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GymTracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {},
          ),
        ],
      ),
      body: storageService.pessoas.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.fitness_center,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum aluno cadastrado',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Adicione seu primeiro aluno para começar',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: storageService.pessoas.length,
              itemBuilder: (context, index) {
                final pessoa = storageService.pessoas[index];
                return PessoaCard(
                  pessoa: pessoa,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ListaTreinosScreen(pessoa: pessoa),
                      ),
                    );
                  },
                  onProgress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProgressoScreen(pessoa: pessoa),
                      ),
                    );
                  },
                  onEdit: () {
                    _editarPessoa(context, pessoa);
                  },
                  onDelete: () {
                    _excluirPessoa(context, pessoa);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _adicionarPessoa(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _adicionarPessoa(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPessoaScreen(),
      ),
    );
  }

  void _editarPessoa(BuildContext context, Pessoa pessoa) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPessoaScreen(pessoa: pessoa),
      ),
    );
  }

  void _excluirPessoa(BuildContext context, Pessoa pessoa) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Aluno'),
        content: Text('Tem certeza que deseja excluir ${pessoa.nome}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await Provider.of<LocalStorageService>(context, listen: false)
                    .deletePessoa(pessoa.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${pessoa.nome} excluído com sucesso!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erro ao excluir: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
