import 'package:flutter/material.dart';
import '../models/prontuario.dart';
import '../services/firestore_service.dart';

class FormularioProntuarioScreen extends StatefulWidget {
  final Prontuario? prontuario;

  const FormularioProntuarioScreen({Key? key, this.prontuario})
    : super(key: key);

  @override
  _FormularioProntuarioScreenState createState() =>
      _FormularioProntuarioScreenState();
}

class _FormularioProntuarioScreenState
    extends State<FormularioProntuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pacienteController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _service = FirestoreService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.prontuario != null) {
      _pacienteController.text = widget.prontuario!.paciente;
      _descricaoController.text = widget.prontuario!.descricao;
    }
  }

  @override
  void dispose() {
    _pacienteController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        if (widget.prontuario == null) {
          final prontuario = Prontuario(
            paciente: _pacienteController.text,
            descricao: _descricaoController.text,
            data: DateTime.now(),
          );
          await _service.adicionarProntuario(prontuario);
        } else {
          final prontuarioAtualizado = widget.prontuario!.copyWith(
            paciente: _pacienteController.text,
            descricao: _descricaoController.text,
            data: DateTime.now(),
          );
          await _service.atualizarProntuario(prontuarioAtualizado);
        }

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditando = widget.prontuario != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditando ? 'Editar Prontuário' : 'Novo Prontuário'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                controller: _pacienteController,
                decoration: InputDecoration(
                  labelText: 'Nome do Paciente',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Informe o nome, máx 50 caracteres' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                maxLength: 100,
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) => value!.isEmpty
                    ? 'Informe a descrição, máx 100 caracteres'
                    : null,
              ),
              SizedBox(height: 20),
              if (_isLoading)
                CircularProgressIndicator()
              else
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _salvar,
                    child: Text(
                      isEditando ? 'Atualizar' : 'Salvar',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
