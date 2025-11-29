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

  Map<String, dynamic>? _args;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map<String, dynamic>) {
        _args = args;
        if (_args!['action'] == 'edit') {
          _topicId = _args!['id'];
          final topic = _topicProvider.getTopicById(_topicId!);
          if (topic != null) {
            _titleController.text = topic.title;
          }
        }
      }
      _isInit = false;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    if (_args != null && _args!['action'] == 'edit') {
      await _topicProvider.updateTopic(_topicId!, _titleController.text);
    } else {
      // Add mode
      String? parentId;
      if (_args != null && _args!['action'] == 'add_subtopic') {
        parentId = _args!['parentId'];
      }
      await _topicProvider.addTopic(_titleController.text, parentId: parentId);
    }

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = _args != null && _args!['action'] == 'edit';
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar Tópico' : 'Novo Tópico de Estudo'),
      ),
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
