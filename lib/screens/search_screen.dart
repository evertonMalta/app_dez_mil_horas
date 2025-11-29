import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../models/topic.dart';
import '../providers/topic_provider.dart';
import '../utils/app_routes.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _topicProvider = GetIt.I.get<TopicProvider>();
  List<Topic> _filteredTopics = [];
  bool _sortByName = true;

  @override
  void initState() {
    super.initState();
    _filterTopics('');
  }

  void _filterTopics(String query) {
    final allTopics = _getAllTopicsFlat(_topicProvider.allTopics);

    setState(() {
      if (query.isEmpty) {
        _filteredTopics = allTopics;
      } else {
        _filteredTopics = allTopics
            .where(
              (topic) =>
                  topic.title.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
      _sortTopics();
    });
  }

  List<Topic> _getAllTopicsFlat(List<Topic> topics) {
    List<Topic> flatList = [];
    for (var topic in topics) {
      flatList.add(topic);
      flatList.addAll(_getAllTopicsFlat(topic.subTopics));
    }
    return flatList;
  }

  void _sortTopics() {
    if (_sortByName) {
      _filteredTopics.sort(
        (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
      );
    } else {      
      _filteredTopics.sort(
        (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Pesquisar tópicos...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: _filterTopics,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: Icon(_sortByName ? Icons.sort_by_alpha : Icons.sort),
            onPressed: () {
              setState(() {
                _sortByName = !_sortByName;
                _sortTopics();
              });
            },
            tooltip: 'Alternar ordenação',
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _filteredTopics.length,
        itemBuilder: (context, index) {
          final topic = _filteredTopics[index];
          return ListTile(
            title: Text(topic.title),
            subtitle: Text(topic.totalTimeFormatted),
            onTap: () {
              Navigator.of(
                context,
              ).pushNamed(AppRoutes.topicDetail, arguments: topic.id);
            },
          );
        },
      ),
    );
  }
}
