import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_tracker/models/pessoa.dart';
import 'package:gym_tracker/models/treino.dart';

class LocalStorageService with ChangeNotifier {
  List<Pessoa> _pessoas = [];
  List<Treino> _treinos = [];

  List<Pessoa> get pessoas => _pessoas;
  List<Treino> get treinos => _treinos;

  // Carregar dados do SharedPreferences
  Future<void> loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('gymtracker_data');

      if (jsonString != null) {
        final jsonData = json.decode(jsonString);

        _pessoas = (jsonData['pessoas'] as List)
            .map((p) => Pessoa.fromMap(p))
            .toList();

        _treinos = (jsonData['treinos'] as List)
            .map((t) => Treino.fromMap(t))
            .toList();

        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao carregar dados: $e');
      }
    }
  }

  // Salvar dados no SharedPreferences
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = {
        'pessoas': _pessoas.map((p) => p.toMap()).toList(),
        'treinos': _treinos.map((t) => t.toMap()).toList(),
      };

      await prefs.setString('gymtracker_data', json.encode(jsonData));
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao salvar dados: $e');
      }
    }
  }

  // ========== CRUD PESSOAS ==========

  Future<void> addPessoa(Pessoa pessoa) async {
    _pessoas.add(pessoa);
    await _saveData();
    notifyListeners();
  }

  Future<void> updatePessoa(Pessoa pessoa) async {
    final index = _pessoas.indexWhere((p) => p.id == pessoa.id);
    if (index != -1) {
      _pessoas[index] = pessoa;
      await _saveData();
      notifyListeners();
    }
  }

  Future<void> deletePessoa(String id) async {
    // Remove a pessoa
    _pessoas.removeWhere((p) => p.id == id);
    // Remove todos os treinos da pessoa
    _treinos.removeWhere((t) => t.pessoaId == id);
    await _saveData();
    notifyListeners();
  }

  Pessoa? getPessoaById(String id) {
    try {
      return _pessoas.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // ========== CRUD TREINOS ==========

  Future<void> addTreino(Treino treino) async {
    _treinos.add(treino);
    await _saveData();
    notifyListeners();
  }

  Future<void> updateTreino(Treino treino) async {
    final index = _treinos.indexWhere((t) => t.id == treino.id);
    if (index != -1) {
      _treinos[index] = treino;
      await _saveData();
      notifyListeners();
    }
  }

  Future<void> deleteTreino(String id) async {
    _treinos.removeWhere((t) => t.id == id);
    await _saveData();
    notifyListeners();
  }

  List<Treino> getTreinosByPessoaId(String pessoaId) {
    return _treinos.where((t) => t.pessoaId == pessoaId).toList()
      ..sort((a, b) => b.dataTreino.compareTo(a.dataTreino));
  }

  List<Treino> getTreinosComFiltro(
    String pessoaId, {
    String? grupoMuscular,
    bool? realizado,
  }) {
    var treinosFiltrados = getTreinosByPessoaId(pessoaId);

    if (grupoMuscular != null && grupoMuscular != 'Todos') {
      treinosFiltrados = treinosFiltrados
          .where((t) => t.grupoMuscular == grupoMuscular)
          .toList();
    }

    if (realizado != null) {
      treinosFiltrados =
          treinosFiltrados.where((t) => t.realizado == realizado).toList();
    }

    return treinosFiltrados;
  }

  // ========== ESTATÍSTICAS ==========

  Map<String, dynamic> getEstatisticas(String pessoaId) {
    final treinosPessoa = getTreinosByPessoaId(pessoaId);
    final totalTreinos = treinosPessoa.length;
    final treinosRealizados = treinosPessoa.where((t) => t.realizado).length;
    final cargaTotal = treinosPessoa.fold(0.0, (sum, t) => sum + t.carga);

    final gruposMusculares = <String, int>{};
    for (final treino in treinosPessoa) {
      gruposMusculares[treino.grupoMuscular] =
          (gruposMusculares[treino.grupoMuscular] ?? 0) + 1;
    }

    return {
      'totalTreinos': totalTreinos,
      'treinosRealizados': treinosRealizados,
      'taxaRealizacao':
          totalTreinos > 0 ? (treinosRealizados / totalTreinos * 100) : 0,
      'cargaTotal': cargaTotal,
      'gruposMusculares': gruposMusculares,
    };
  }

  // ========== GERADOR DE ID ==========

  String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
