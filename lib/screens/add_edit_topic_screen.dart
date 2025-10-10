import 'package:flutter/material.dart';
import '../providers/topic_provider.dart';
import '../services/service_locator.dart';

class AddEditTopicScreen extends StatefulWidget {
  const AddEditTopicScreen({super.key});

  @override
  State<AddEditTopicScreen> createState() => _AddEditTopicScreenState();
}

class _AddEditTopicScreenState extends State<AddEditTopicScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  String? _topicId;
  late final TopicProvider _topicProvider;

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
    _titleController.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }


    if (_topicId != null) {
      _topicProvider.addTopic(_titleController.text, parentId: _topicId);
    } else {
      _topicProvider.addTopic(_titleController.text);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Tópico de Estudo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Título do Tópico',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.label_important_outline),
                ),
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, insira um título.';
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
