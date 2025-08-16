import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paceup/routing/paths.dart';
import 'package:provider/provider.dart';

class Bottomnavigation extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const Bottomnavigation({super.key, required this.navigationShell});

  @override
  State<Bottomnavigation> createState() => _BottomnavigationState();
}

class _BottomnavigationState extends State<Bottomnavigation> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final _selectedColor = Theme.of(context).primaryColor; // Mavi
    final _unselectedColor = const Color.fromARGB(255, 165, 165, 165); // Gri
    // Mevcut sayfanın yolunu al (Yeni yöntem)
    final String currentPath = GoRouterState.of(context).uri.toString();

    bool showBottomNavBar =
        currentPath != Paths.logopage &&
        currentPath != Paths.promotionpage &&
        currentPath != Paths.notificationspage &&
        currentPath != Paths.gopage &&
        currentPath != Paths.comingsoonpage &&
        currentPath != Paths.loginpage;
    return Scaffold(
      bottomNavigationBar: showBottomNavBar
          ? NavigationBarTheme(
              data: NavigationBarThemeData(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                // Seçilince/Seçilmezken ikon rengi ve boyutu
                // iconTheme: MaterialStateProperty.resolveWith<IconThemeData>((
                //   states,
                // ) {
                //   final selected = states.contains(MaterialState.selected);
                //   return IconThemeData(
                //     size: 26,
                //     color: selected ? _selectedColor : _unselectedColor,
                //   );
                // }),
                // Seçilince/Seçilmezken yazı stili ve rengi
                labelTextStyle: MaterialStateProperty.all(
                  Theme.of(context).textTheme.bodyMedium,
                ),
                // İstersen mavi “indicator pill”i kapat:
                indicatorColor: Colors.transparent,
              ),
              child: NavigationBar(
                selectedIndex: widget.navigationShell.currentIndex,
                onDestinationSelected: (i) =>
                    widget.navigationShell.goBranch(i),
                // Etiket davranışı (NavigationBar’da default zaten görünüyor)
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                destinations: [
                  NavigationDestination(
                    icon: _buildAssetIcon('assets/icons/homeVector.png'),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: _buildAssetIcon('assets/icons/progressVector.png'),
                    label: 'Progress',
                  ),
                  NavigationDestination(
                    icon: _buildAssetIcon('assets/icons/challengesVector.png'),
                    label: 'Challenges',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person, color: Color(0xFF8E8E90)),
                    label: 'Profile',
                  ),
                ],
              ),
            )
          : null, // Eğer BottomNavigationBar gösterilmeyecekse, null döndür
      body: widget.navigationShell,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  Widget _buildAssetIcon(String path) {
    return NavigationBarTheme.of(context).iconTheme?.resolve({})?.color != null
        ? Image.asset(
            path,
            width: 26,
            height: 26,
            color: NavigationBarTheme.of(context).iconTheme
                ?.resolve({MaterialState.selected}) // seçili rengini al
                ?.color,
          )
        : Image.asset(path, width: 26, height: 26);
  }
}
