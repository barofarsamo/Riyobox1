
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:riyobox/providers/settings_provider.dart';
import 'package:riyobox/providers/playback_provider.dart';
import 'package:riyobox/providers/download_provider.dart';
import 'package:riyobox/providers/auth_provider.dart';
import 'package:riyobox/services/cast_service.dart';
import 'package:riyobox/presentation/screens/splash_screen.dart';
import 'package:riyobox/presentation/screens/onboarding_screen.dart';
import 'package:riyobox/presentation/screens/auth/login_screen.dart';
import 'package:riyobox/presentation/screens/auth/signup_screen.dart';
import 'package:riyobox/presentation/screens/home_screen.dart';
import 'package:riyobox/presentation/screens/movie_details_screen.dart';
import 'package:media_kit/media_kit.dart';
import 'package:riyobox/presentation/screens/video_player_screen.dart';
import 'package:riyobox/presentation/screens/settings_screen.dart';
import 'package:riyobox/presentation/screens/profile_screen.dart';
import 'package:riyobox/presentation/screens/cast_screen.dart';
import 'package:riyobox/presentation/screens/categories_screen.dart';
import 'package:riyobox/presentation/screens/downloads_screen.dart';
import 'package:riyobox/presentation/screens/my_riyobox_screen.dart';
import 'package:riyobox/presentation/screens/search_screen.dart';
import 'package:riyobox/presentation/widgets/sports_video_player.dart';
import 'package:riyobox/presentation/screens/genre_movies_screen.dart';
import 'package:riyobox/presentation/screens/admin/admin_panel_screen.dart';
import 'package:riyobox/presentation/screens/sports_screen.dart';
import 'package:riyobox/presentation/screens/match_details_screen.dart';
import 'package:riyobox/presentation/screens/league_standings_screen.dart';
import 'package:riyobox/presentation/screens/team_profile_screen.dart';
import 'package:riyobox/presentation/screens/sports_search_screen.dart';
import 'package:riyobox/providers/sports_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

GoRouter _createRouter(AuthProvider authProvider) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: authProvider,
    redirect: (context, state) {
      final bool loggingIn = state.uri.path == '/login';
      final bool signingUp = state.uri.path == '/signup';
      final bool splash = state.uri.path == '/splash';
      final bool welcome = state.uri.path == '/welcome';

      if (splash) return null;

      if (!authProvider.isOnboardingComplete) {
        return welcome ? null : '/welcome';
      }

      if (!authProvider.isAuthenticated) {
        return (loggingIn || signingUp || welcome) ? null : '/login';
      }

      if (loggingIn || signingUp || welcome) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
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
          GoRoute(
            path: '/genre/:name',
            builder: (context, state) {
              final name = state.pathParameters['name']!;
              return GenreMoviesScreen(genreName: name);
            },
          ),
          GoRoute(
            path: '/sports',
            builder: (context, state) => const SportsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/sports/play',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final url = state.uri.queryParameters['url']!;
          final title = state.uri.queryParameters['title'] ?? 'Live Sports';
          return SportsVideoPlayer(url: url, title: title);
        },
      ),
      GoRoute(
        path: '/sports/match/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return MatchDetailsScreen(fixtureId: id);
        },
      ),
      GoRoute(
        path: '/sports/league/:id/:season',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final season = int.parse(state.pathParameters['season']!);
          return LeagueStandingsScreen(leagueId: id, season: season);
        },
      ),
      GoRoute(
        path: '/sports/team/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return TeamProfileScreen(teamId: id);
        },
      ),
      GoRoute(
        path: '/sports/search',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SportsSearchScreen(),
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
    GoRoute(
      path: '/admin',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AdminPanelScreen(),
    ),
    ],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => PlaybackProvider()),
        ChangeNotifierProvider(create: (_) => DownloadProvider()),
        ChangeNotifierProvider(create: (_) => CastService()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SportsProvider()),
      ],
      child: Consumer2<SettingsProvider, AuthProvider>(
        builder: (context, settings, auth, child) {
          return MaterialApp.router(
            routerConfig: _createRouter(auth),
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
