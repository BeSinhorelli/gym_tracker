import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker/models/pessoa.dart';
import 'package:gym_tracker/models/treino.dart';
import 'package:gym_tracker/services/local_storage_service.dart';

class AddTreinoScreen extends StatefulWidget {
  final Pessoa pessoa;
  final Treino? treino;

  const AddTreinoScreen({
    super.key,
    required this.pessoa,
    this.treino,
  });

  @override
  State<AddTreinoScreen> createState() => _AddTreinoScreenState();
}

class _AddTreinoScreenState extends State<AddTreinoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeExercicioController = TextEditingController();
  final _seriesController = TextEditingController();
  final _repeticoesController = TextEditingController();
  final _cargaController = TextEditingController();
  final _observacoesController = TextEditingController();

  String _grupoMuscular = 'Peito';
  bool _realizado = false;
  DateTime _dataTreino = DateTime.now();
  TimeOfDay _horaTreino = TimeOfDay.now();

  final List<String> _gruposMusculares = [
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
  void initState() {
    super.initState();
    if (widget.treino != null) {
      _nomeExercicioController.text = widget.treino!.nomeExercicio;
      _seriesController.text = widget.treino!.series.toString();
      _repeticoesController.text = widget.treino!.repeticoes.toString();
      _cargaController.text = widget.treino!.carga.toString();
      _observacoesController.text = widget.treino!.observacoes ?? '';
      _grupoMuscular = widget.treino!.grupoMuscular;
      _realizado = widget.treino!.realizado;
      _dataTreino = widget.treino!.dataTreino;
      _horaTreino =
          TimeOfDay(hour: _dataTreino.hour, minute: _dataTreino.minute);
    }
  }

  @override
  void dispose() {
    _nomeExercicioController.dispose();
    _seriesController.dispose();
    _repeticoesController.dispose();
    _cargaController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.treino == null ? 'Novo Treino' : 'Editar Treino'),
        actions: [
          if (widget.treino != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _excluirTreino,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.pessoa.nome,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nomeExercicioController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Exercício',
                  prefixIcon: Icon(Icons.fitness_center),
                  hintText: 'Ex: Supino Reto, Agachamento...',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do exercício';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _grupoMuscular,
                decoration: const InputDecoration(
                  labelText: 'Grupo Muscular',
                  prefixIcon: Icon(Icons.category),
                ),
                items: _gruposMusculares.map((String grupo) {
                  return DropdownMenuItem<String>(
                    value: grupo,
                    child: Text(grupo),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _grupoMuscular = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione um grupo muscular';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _seriesController,
                      decoration: const InputDecoration(
                        labelText: 'Séries',
                        prefixIcon: Icon(Icons.repeat),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Insira o número de séries';
                        }
                        final series = int.tryParse(value);
                        if (series == null || series < 1 || series > 20) {
                          return 'Séries inválidas (1-20)';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _repeticoesController,
                      decoration: const InputDecoration(
                        labelText: 'Repetições',
                        prefixIcon: Icon(Icons.repeat_one),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Insira o número de repetições';
                        }
                        final repeticoes = int.tryParse(value);
                        if (repeticoes == null ||
                            repeticoes < 1 ||
                            repeticoes > 50) {
                          return 'Repetições inválidas (1-50)';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cargaController,
                decoration: const InputDecoration(
                  labelText: 'Carga (kg)',
                  prefixIcon: Icon(Icons.monitor_weight),
                  hintText: '0 para exercícios sem carga',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira a carga (0 para sem carga)';
                  }
                  final carga = double.tryParse(value);
                  if (carga == null || carga < 0 || carga > 1000) {
                    return 'Carga inválida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _selecionarData,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Data do Treino',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          '${_dataTreino.day}/${_dataTreino.month}/${_dataTreino.year}',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: _selecionarHora,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Hora do Treino',
                          prefixIcon: Icon(Icons.access_time),
                        ),
                        child: Text(
                          _horaTreino.format(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _observacoesController,
                decoration: const InputDecoration(
                  labelText: 'Observações (opcional)',
                  prefixIcon: Icon(Icons.note),
                  hintText: 'Ex: Execução, desconforto, progresso...',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Treino Realizado'),
                subtitle: const Text('Marque se o treino já foi realizado'),
                value: _realizado,
                onChanged: (value) {
                  setState(() {
                    _realizado = value;
                  });
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _salvarTreino,
                  child: Text(
                    widget.treino == null
                        ? 'ADICIONAR TREINO'
                        : 'ATUALIZAR TREINO',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selecionarData() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataTreino,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _dataTreino) {
      setState(() {
        _dataTreino = picked;
      });
    }
  }

  Future<void> _selecionarHora() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _horaTreino,
    );
    if (picked != null && picked != _horaTreino) {
      setState(() {
        _horaTreino = picked;
      });
    }
  }

  void _salvarTreino() async {
    if (_formKey.currentState!.validate()) {
      try {
        final storageService =
            Provider.of<LocalStorageService>(context, listen: false);

        final dataHoraTreino = DateTime(
          _dataTreino.year,
          _dataTreino.month,
          _dataTreino.day,
          _horaTreino.hour,
          _horaTreino.minute,
        );

        final treino = Treino(
          id: widget.treino?.id ?? storageService.generateId(),
          pessoaId: widget.pessoa.id,
          nomeExercicio: _nomeExercicioController.text,
          series: int.parse(_seriesController.text),
          repeticoes: int.parse(_repeticoesController.text),
          carga: double.parse(_cargaController.text),
          grupoMuscular: _grupoMuscular,
          observacoes: _observacoesController.text.isEmpty
              ? null
              : _observacoesController.text,
          realizado: _realizado,
          dataTreino: dataHoraTreino,
        );

        if (widget.treino == null) {
          await storageService.addTreino(treino);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Treino adicionado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          await storageService.updateTreino(treino);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Treino atualizado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar treino: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _excluirTreino() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Treino'),
        content: Text(
            'Tem certeza que deseja excluir "${_nomeExercicioController.text}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await Provider.of<LocalStorageService>(context, listen: false)
                    .deleteTreino(widget.treino!.id);
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '"${_nomeExercicioController.text}" excluído com sucesso!'),
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
