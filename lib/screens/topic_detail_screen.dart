import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/topic.dart';
import '../providers/topic_provider.dart';
import '../services/service_locator.dart';
import '../utils/app_routes.dart';

class TopicDetailScreen extends StatefulWidget {
  const TopicDetailScreen({super.key});

  @override
  State<TopicDetailScreen> createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen> {
  late final TopicProvider _topicProvider;
  Topic? _topic;

  @override
  void initState() {
    super.initState();
    _topicProvider = sl<TopicProvider>();
    _topicProvider.addListener(_onDataChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final topicId = ModalRoute.of(context)?.settings.arguments as String?;
    if (topicId != null) {
      _topic = _topicProvider.getTopicById(topicId);
    }
  }

  @override
  void dispose() {
    _topicProvider.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    final topicId = ModalRoute.of(context)?.settings.arguments as String?;
    if (topicId != null) {
      setState(() {
        _topic = _topicProvider.getTopicById(topicId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (_topic == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('Tópico não encontrado!'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_topic!.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Card principal com o resumo
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tempo Total de Estudo', style: textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    _topic!.totalTimeFormatted,
                    style: textTheme.displaySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Seção de Sub-tópicos
          _buildSectionTitle(context, 'Sub-tópicos', Icons.topic_outlined),
          if (_topic!.subTopics.isEmpty)
            const Text('Nenhum sub-tópico cadastrado.')
          else
            ..._topic!.subTopics.map((subTopic) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    title: Text(subTopic.title),
                    trailing: Text(subTopic.totalTimeFormatted),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.topicDetail,
                        arguments: subTopic.id,
                      );
                    },
                  ),
                )),
          const SizedBox(height: 24),

          // Seção de Sessões de Estudo
          _buildSectionTitle(
              context, 'Sessões de Estudo', Icons.timer_outlined),
          if (_topic!.sessions.isEmpty)
            const Text('Nenhuma sessão de estudo registrada para este tópico.')
          else
            ..._topic!.sessions.map((session) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    leading: const Icon(Icons.history_toggle_off),
                    title: Text(
                        '${session.durationInMinutes} minutos de estudo'),
                    subtitle: Text(
                      DateFormat('dd/MM/yyyy \'às\' HH:mm')
                          .format(session.date),
                    ),
                  ),
                )),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
        FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.logStudySession, arguments: _topic!.id );
        },
        child: const Icon(Icons.punch_clock),
      ),
      SizedBox(height: 20, width: 10,),
      FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.addEditTopic, arguments: _topic!.id );
        },
        child: const Icon(Icons.add),
      ),
      ],)
    );
  }

  Widget _buildSectionTitle(
      BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(width: 8),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}
