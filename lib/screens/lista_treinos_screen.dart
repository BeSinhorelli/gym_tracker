import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker/models/pessoa.dart';
import 'package:gym_tracker/models/treino.dart';
import 'package:gym_tracker/services/local_storage_service.dart';
import 'package:gym_tracker/screens/add_treino_screen.dart';
import 'package:gym_tracker/widgets/treino_card.dart';

class ListaTreinosScreen extends StatefulWidget {
  final Pessoa pessoa;

  const ListaTreinosScreen({super.key, required this.pessoa});

  @override
  State<ListaTreinosScreen> createState() => _ListaTreinosScreenState();
}

class _ListaTreinosScreenState extends State<ListaTreinosScreen> {
  String _filtroGrupoMuscular = 'Todos';
  bool _filtroRealizados = false;

  final List<String> _gruposMusculares = [
    'Todos',
    'Peito',
    'Costas',
    'Pernas',
    'Ombros',
    'Bíceps',
    'Tríceps',
    'Abdômen',
    'Cardio'
  ];

  @override
  Widget build(BuildContext context) {
    final storageService = Provider.of<LocalStorageService>(context);
    final treinos = storageService.getTreinosComFiltro(
      widget.pessoa.id,
      grupoMuscular:
          _filtroGrupoMuscular != 'Todos' ? _filtroGrupoMuscular : null,
      realizado: _filtroRealizados ? true : null,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Treinos - ${widget.pessoa.nome}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _mostrarFiltros,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildPessoaInfoCard(),
          _buildFiltrosAtivos(),
          Expanded(
            child: treinos.isEmpty
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
                          'Nenhum treino encontrado',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tente alterar os filtros ou adicionar um treino',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: treinos.length,
                    itemBuilder: (context, index) {
                      final treino = treinos[index];
                      return TreinoCard(
                        treino: treino,
                        onTap: () {
                          _editarTreino(context, treino);
                        },
                        onToggleRealizado: () {
                          _toggleRealizado(treino);
                        },
                        onEdit: () {
                          _editarTreino(context, treino);
                        },
                        onDelete: () {
                          _excluirTreino(context, treino);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _adicionarTreino(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPessoaInfoCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                widget.pessoa.nome[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.pessoa.nome,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                      '${widget.pessoa.idade} anos • ${widget.pessoa.peso} kg'),
                  Text('${widget.pessoa.objetivo} • ${widget.pessoa.nivel}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltrosAtivos() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          if (_filtroGrupoMuscular != 'Todos')
            Chip(
              label: Text(_filtroGrupoMuscular),
              onDeleted: () {
                setState(() {
                  _filtroGrupoMuscular = 'Todos';
                });
              },
            ),
          if (_filtroRealizados)
            Chip(
              label: const Text('Realizados'),
              onDeleted: () {
                setState(() {
                  _filtroRealizados = false;
                });
              },
            ),
        ],
      ),
    );
  }

  void _mostrarFiltros() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filtrar Treinos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _filtroGrupoMuscular,
                decoration: const InputDecoration(
                  labelText: 'Grupo Muscular',
                  border: OutlineInputBorder(),
                ),
                items: _gruposMusculares.map((String grupo) {
                  return DropdownMenuItem<String>(
                    value: grupo,
                    child: Text(grupo),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _filtroGrupoMuscular = newValue!;
                  });
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Mostrar apenas realizados'),
                value: _filtroRealizados,
                onChanged: (value) {
                  setState(() {
                    _filtroRealizados = value;
                  });
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _filtroGrupoMuscular = 'Todos';
                      _filtroRealizados = false;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Limpar Filtros'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _adicionarTreino(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTreinoScreen(pessoa: widget.pessoa),
      ),
    );
  }

  void _editarTreino(BuildContext context, Treino treino) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTreinoScreen(
          pessoa: widget.pessoa,
          treino: treino,
        ),
      ),
    );
  }

  void _toggleRealizado(Treino treino) async {
    try {
      final storageService =
          Provider.of<LocalStorageService>(context, listen: false);
      final treinoAtualizado = treino.copyWith(realizado: !treino.realizado);
      await storageService.updateTreino(treinoAtualizado);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            treino.realizado
                ? 'Treino marcado como não realizado'
                : 'Treino marcado como realizado!',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao atualizar treino: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _excluirTreino(BuildContext context, Treino treino) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Treino'),
        content:
            Text('Tem certeza que deseja excluir "${treino.nomeExercicio}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await Provider.of<LocalStorageService>(context, listen: false)
                    .deleteTreino(treino.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('"${treino.nomeExercicio}" excluído com sucesso!'),
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
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
