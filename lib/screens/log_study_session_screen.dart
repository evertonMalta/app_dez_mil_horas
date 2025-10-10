import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../providers/topic_provider.dart';
import '../services/service_locator.dart';

class LogStudySessionScreen extends StatefulWidget {
  const LogStudySessionScreen({super.key});

  @override
  State<LogStudySessionScreen> createState() => _LogStudySessionScreenState();
}

class _LogStudySessionScreenState extends State<LogStudySessionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _minutesController = TextEditingController();
  late final TopicProvider _topicProvider;
  String? _topicId;

  @override
  void initState() {
    super.initState();
    _topicProvider = sl<TopicProvider>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _topicId = ModalRoute.of(context)?.settings.arguments as String?;
  }

  @override
  void dispose() {
    _minutesController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_topicId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro: ID do tópico não encontrado!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    final minutes = int.tryParse(_minutesController.text);
    if (minutes == null) return;

    _topicProvider.addStudySession(_topicId!, minutes);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sessão registrada com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Sessão de Estudo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _minutesController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Minutos Estudados',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.timer_outlined),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, insira os minutos.';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor, insira um número válido.';
                  }
                  if (int.parse(value) <= 0) {
                    return 'O valor deve ser maior que zero.';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _saveForm(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveForm,
        child: const Icon(Icons.save),
      ),
    );
  }
}
