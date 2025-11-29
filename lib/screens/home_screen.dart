import 'package:flutter/material.dart';
import '../providers/topic_provider.dart';
import '../services/service_locator.dart';
import '../utils/app_routes.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TopicProvider _topicProvider;

  @override
  void initState() {
    super.initState();
    _topicProvider = sl<TopicProvider>();
    _topicProvider.addListener(_onTopicsChanged);
  }

  @override
  void dispose() {
    _topicProvider.removeListener(_onTopicsChanged);
    super.dispose();
  }

  void _onTopicsChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final topics = _topicProvider.allTopics;

    return Scaffold(
      drawer: const AppDrawer(currentPageIndex: 0),
      appBar: AppBar(
        title: const Text('Meus Estudos'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.search);
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.addEditTopic);
            },
          ),
        ],
      ),
      body: topics.isEmpty
          ? const Center(
              child: Text(
                'Nenhum tópico de estudo ainda.\nClique em "+" para adicionar o primeiro!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: topics.length,
              itemBuilder: (context, index) {
                final topic = topics[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: Icon(
                      Icons.library_books_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 32,
                    ),
                    title: Text(
                      topic.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    trailing: Text(
                      topic.totalTimeFormatted,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.topicDetail, arguments: topic.id);
                    },
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Opções'),
                          content: const Text(
                            'O que deseja fazer com este tópico?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                Navigator.of(context).pushNamed(
                                  AppRoutes.addEditTopic,
                                  arguments: {'id': topic.id, 'action': 'edit'},
                                );
                              },
                              child: const Text('Editar'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Confirmar Exclusão'),
                                    content: const Text(
                                      'Tem certeza? Isso apagará todos os sub-tópicos e sessões.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(),
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _topicProvider.deleteTopic(topic.id);
                                          Navigator.of(ctx).pop();
                                        },
                                        child: const Text(
                                          'Excluir',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Text(
                                'Excluir',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.addEditTopic);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
