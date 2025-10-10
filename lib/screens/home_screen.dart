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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      Navigator.of(context).pushNamed(
                        AppRoutes.topicDetail,
                        arguments: topic.id,
                      );
                      print('Navegar para os detalhes de: ${topic.title}');
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
