import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker/models/pessoa.dart';
import 'package:gym_tracker/services/local_storage_service.dart';

class AddPessoaScreen extends StatefulWidget {
  final Pessoa? pessoa;

  const AddPessoaScreen({super.key, this.pessoa});

  @override
  State<AddPessoaScreen> createState() => _AddPessoaScreenState();
}

class _AddPessoaScreenState extends State<AddPessoaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  final _pesoController = TextEditingController();
  final _alturaController = TextEditingController();

  String _sexo = 'Masculino';
  String _nivel = 'Iniciante';
  String _objetivo = 'Hipertrofia';

  final List<String> _sexos = ['Masculino', 'Feminino'];
  final List<String> _niveis = ['Iniciante', 'Intermediário', 'Avançado'];
  final List<String> _objetivos = [
    'Hipertrofia',
    'Emagrecimento',
    'Força',
    'Condicionamento'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.pessoa != null) {
      _nomeController.text = widget.pessoa!.nome;
      _idadeController.text = widget.pessoa!.idade.toString();
      _pesoController.text = widget.pessoa!.peso.toString();
      _alturaController.text = widget.pessoa!.altura.toString();
      _sexo = widget.pessoa!.sexo;
      _nivel = widget.pessoa!.nivel;
      _objetivo = widget.pessoa!.objetivo;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _idadeController.dispose();
    _pesoController.dispose();
    _alturaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pessoa == null ? 'Adicionar Aluno' : 'Editar Aluno'),
        actions: [
          if (widget.pessoa != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _excluirPessoa,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  _nomeController.text.isNotEmpty
                      ? _nomeController.text[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome Completo',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _idadeController,
                decoration: const InputDecoration(
                  labelText: 'Idade',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a idade';
                  }
                  final idade = int.tryParse(value);
                  if (idade == null || idade < 1 || idade > 120) {
                    return 'Idade inválida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _pesoController,
                      decoration: const InputDecoration(
                        labelText: 'Peso (kg)',
                        prefixIcon: Icon(Icons.monitor_weight),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Insira o peso';
                        }
                        final peso = double.tryParse(value);
                        if (peso == null || peso < 1 || peso > 300) {
                          return 'Peso inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _alturaController,
                      decoration: const InputDecoration(
                        labelText: 'Altura (m)',
                        prefixIcon: Icon(Icons.height),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Insira a altura';
                        }
                        final altura = double.tryParse(value);
                        if (altura == null || altura < 0.5 || altura > 2.5) {
                          return 'Altura inválida';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _sexo,
                decoration: const InputDecoration(
                  labelText: 'Sexo',
                  prefixIcon: Icon(Icons.people),
                ),
                items: _sexos.map((String sexo) {
                  return DropdownMenuItem<String>(
                    value: sexo,
                    child: Text(sexo),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _sexo = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _nivel,
                decoration: const InputDecoration(
                  labelText: 'Nível',
                  prefixIcon: Icon(Icons.star),
                ),
                items: _niveis.map((String nivel) {
                  return DropdownMenuItem<String>(
                    value: nivel,
                    child: Text(nivel),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _nivel = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _objetivo,
                decoration: const InputDecoration(
                  labelText: 'Objetivo',
                  prefixIcon: Icon(Icons.flag),
                ),
                items: _objetivos.map((String objetivo) {
                  return DropdownMenuItem<String>(
                    value: objetivo,
                    child: Text(objetivo),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _objetivo = newValue!;
                  });
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _salvarPessoa,
                  child: Text(
                    widget.pessoa == null
                        ? 'ADICIONAR ALUNO'
                        : 'ATUALIZAR ALUNO',
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

  void _salvarPessoa() async {
    if (_formKey.currentState!.validate()) {
      try {
        final storageService =
            Provider.of<LocalStorageService>(context, listen: false);

        final pessoa = Pessoa(
          id: widget.pessoa?.id ?? storageService.generateId(),
          nome: _nomeController.text,
          idade: int.parse(_idadeController.text),
          peso: double.parse(_pesoController.text),
          altura: double.parse(_alturaController.text),
          dataCriacao: widget.pessoa?.dataCriacao ?? DateTime.now(),
          sexo: _sexo,
          nivel: _nivel,
          objetivo: _objetivo,
        );

        if (widget.pessoa == null) {
          await storageService.addPessoa(pessoa);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Aluno adicionado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          await storageService.updatePessoa(pessoa);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Aluno atualizado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _excluirPessoa() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Aluno'),
        content:
            Text('Tem certeza que deseja excluir ${_nomeController.text}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await Provider.of<LocalStorageService>(context, listen: false)
                    .deletePessoa(widget.pessoa!.id);
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('${_nomeController.text} excluído com sucesso!'),
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
