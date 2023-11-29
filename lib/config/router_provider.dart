
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pllcare/auth/provider/auth_provider.dart';
import 'package:pllcare/auth/view/login_screen.dart';
import 'package:pllcare/common/component/default_layout.dart';
import 'package:pllcare/project/view/project_list_screen.dart';
import 'package:pllcare/project/view/project_management_screen.dart';

import '../home_screen.dart';
import '../post/view/post_screen.dart';
import '../test_screen.dart';

final GlobalKey<NavigatorState> rootNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final provider = ref.read(authProvider);
  return GoRouter(
      initialLocation: '/home',
      debugLogDiagnostics: true,
      navigatorKey: rootNavKey,
      routes: <RouteBase>[
        // GoRoute(
        //     path: '/home',
        //     name: HomeScreen.routeName,
        //     builder: (BuildContext context, GoRouterState state) {
        //       return const HomeScreen();
        //     }),
        GoRoute(
            path: '/login',
            name: LoginScreen.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return LoginScreen();
            }),
        GoRoute(
            path: '/test',
            name: TestScreen.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return TestScreen();
            }),
        ShellRoute(
          navigatorKey: shellNavKey,
            builder: (context, state, child) {
              return DefaultLayout(
                  body: child);
            },
            routes: [
              GoRoute(
                  path: '/management',
                  name: ProjectListScreen.routeName,
                  builder: (_, state) => const ProjectListScreen(),
                  routes: [
                    GoRoute(
                        path: ':projectId/overview',
                        name: ProjectManagementScreen.routeName,
                        builder: (BuildContext context, GoRouterState state) {
                          final int projectId =
                              int.parse(state.pathParameters['projectId']!);
                          return ProjectManagementScreen(
                            projectId: projectId,
                          );
                        }),
                  ]),
              GoRoute(
                path: '/home',
                name: HomeScreen.routeName,
                builder: (_, state) => const HomeScreen(),
              ),
              GoRoute(
                path: '/recruit',
                name: PostScreen.routeName,
                builder: (_, state) => const PostScreen(),
              ),
            ]),
      ]);
});
