import 'package:app_dez_mil_horas/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import '../utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  final int currentPageIndex;

  const AppDrawer({super.key, required this.currentPageIndex});

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      onDestinationSelected: (index) {
        if (index == currentPageIndex) {
          return;
        }

        Navigator.of(context).pop();

        switch (index) {
          case 0:
            Navigator.of(context).pushReplacementNamed(AppRoutes.home);
            break;
          case 1:
            Navigator.of(context).pushReplacementNamed(AppRoutes.profile);
            break;
          case 2:
            Navigator.of(context).pushReplacementNamed(AppRoutes.about);
            break;
          case 3:
            Navigator.of(context).pushReplacementNamed(AppRoutes.search);
            break;
          case 4:
            _showLogoutDialog(context);
            break;
        }
      },
      selectedIndex: currentPageIndex,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text('Menu', style: Theme.of(context).textTheme.titleSmall),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Início'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: Text('Perfil'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.info_outline),
          selectedIcon: Icon(Icons.info),
          label: Text('Sobre'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.search),
          selectedIcon: Icon(Icons.search),
          label: Text('Pesquisar'),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 28),
          child: Divider(),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.logout),
          label: Text('Sair'),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Saída'),
        content: const Text('Você tem certeza que deseja sair?'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          FilledButton(
            child: const Text('Sair'),
            onPressed: () {
              AuthController().logout(ctx);
            },
          ),
        ],
      ),
    );
  }
}
