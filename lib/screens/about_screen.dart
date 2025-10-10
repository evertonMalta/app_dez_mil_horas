import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: const AppDrawer(currentPageIndex: 2,),
      appBar: AppBar(
        title: const Text('Sobre'),
        backgroundColor: colorScheme.primaryContainer,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '10.000 Horas',
                    style: textTheme.headlineSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Este aplicativo foi desenvolvido para ajudar você a rastrear suas horas de estudo, inspirado na teoria de que são necessárias 10.000 horas de prática deliberada para se tornar um especialista em qualquer campo.',
                    style: textTheme.bodyLarge,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          Card(
            elevation: 1,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.code, color: colorScheme.secondary),
                  title: const Text('Desenvolvedor'),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(),
                ),
                const ListTile(
                  leading: Icon(Icons.person_outline),
                  title: Text('Everton Malta Gouveia de Queiroz'), 
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Card(
            elevation: 1,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.school, color: colorScheme.secondary),
                  title: const Text('Professor'),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(),
                ),
                const ListTile(
                  leading: Icon(Icons.person_outline),
                  title: Text('Prof. Dr. Rodrigo de Oliveira Plotze'), 
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
