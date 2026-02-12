
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:riyobox/providers/settings_provider.dart';
import 'package:riyobox/providers/playback_provider.dart';
import 'package:riyobox/presentation/screens/home_screen.dart';
import 'package:riyobox/presentation/screens/movie_details_screen.dart';
import 'package:riyobox/presentation/screens/video_player_screen.dart';
import 'package:riyobox/presentation/screens/settings_screen.dart';
import 'package:riyobox/presentation/screens/profile_screen.dart';
import 'package:riyobox/presentation/screens/cast_screen.dart';
import 'package:riyobox/presentation/screens/categories_screen.dart';
import 'package:riyobox/presentation/screens/downloads_screen.dart';
import 'package:riyobox/presentation/screens/my_riyobox_screen.dart';
import 'package:riyobox/presentation/screens/search_screen.dart';

void main() {
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/category', // Initial index was 1 (Category)
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainScreen(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/category',
          builder: (context, state) => const CategoriesScreen(),
        ),
        GoRoute(
          path: '/downloads',
          builder: (context, state) => const DownloadsScreen(),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchScreen(),
        ),
        GoRoute(
          path: '/my-riyobox',
          builder: (context, state) => const MyRiyoboxScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/movie/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return MovieDetailsScreen(movieId: id);
      },
    ),
    GoRoute(
      path: '/movie/:id/play',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return VideoPlayerScreen(movieId: id);
      },
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/profile',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/cast',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CastScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => PlaybackProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return MaterialApp.router(
          routerConfig: _router,
          title: 'RIYOBOX',
          locale: settings.language == 'Arabic' ? const Locale('ar', '') : const Locale('en', ''),
          builder: (context, child) {
            return Directionality(
              textDirection: settings.language == 'Arabic' ? TextDirection.rtl : TextDirection.ltr,
              child: child!,
            );
          },
          theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF1C1B1F),
        colorScheme: const ColorScheme.dark(
          primary: Colors.deepPurple,
          secondary: Colors.yellow,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
        ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Color(0xFF1C1B1F),
                selectedItemColor: Colors.yellow,
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: true,
              ),
            ),
          );
        },
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/category')) return 1;
    if (location.startsWith('/downloads')) return 2;
    if (location.startsWith('/search')) return 3;
    if (location.startsWith('/my-riyobox')) return 4;
    return 1; // Default
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/category');
        break;
      case 2:
        context.go('/downloads');
        break;
      case 3:
        context.go('/search');
        break;
      case 4:
        context.go('/my-riyobox');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.download_outlined),
            activeIcon: Icon(Icons.download),
            label: 'Downloads',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'My RIYOBOX',
          ),
        ],
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
      ),
    );
  }
}
