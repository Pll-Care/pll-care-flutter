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
  final provider = ref.read(tokenProvider);
  return GoRouter(
      initialLocation: '/home',
      debugLogDiagnostics: true,
      navigatorKey: rootNavKey,
      refreshListenable: TokenProvider(ref: ref),
      routes: <RouteBase>[
        GoRoute(
            path: '/login',
            name: LoginScreen.routeName,
            pageBuilder: (context, state) {
              return NoTransitionPage(child: LoginScreen());
            }),
        GoRoute(
          path: '/test',
          name: TestScreen.routeName,
          pageBuilder: (context, state) {
            return NoTransitionPage(child: TestScreen());
          },
        ),
        ShellRoute(
            navigatorKey: shellNavKey,
            builder: (context, state, child) {
              return DefaultLayout(body: child);
            },
            routes: [
              GoRoute(
                  path: '/management',
                  name: ProjectListScreen.routeName,
                  redirect: (_, state) => provider.redirectLogic(state),
                  pageBuilder: (context, state) {
                    return const NoTransitionPage(child: ProjectListScreen());
                  },
                  routes: [
                    GoRoute(
                      path: ':projectId/overview',
                      name: ProjectManagementScreen.routeName,
                      pageBuilder: (context, state) {
                        final int projectId =
                            int.parse(state.pathParameters['projectId']!);
                        return NoTransitionPage(
                            child: ProjectManagementScreen(
                          projectId: projectId,
                        ));
                      },
                    ),
                  ]),
              GoRoute(
                path: '/home',
                name: HomeScreen.routeName,
                builder: (_, state) => const HomeScreen(),
                pageBuilder: (context, state) {
                  return const NoTransitionPage(child: HomeScreen());
                },
              ),
              GoRoute(
                  path: '/recruit',
                  name: PostScreen.routeName,
                  pageBuilder: (context, state) {
                    return const NoTransitionPage(child: PostScreen());
                  },
                  routes: [
                    GoRoute(
                        path: 'form',
                        name: PostFormScreen.routeName,
                        pageBuilder: (context, state) {
                          int? postId;
                          if (state.uri.queryParameters['postId'] != null) {
                            postId =
                                int.parse(state.uri.queryParameters['postId']!);
                          }
                          return NoTransitionPage(
                              child: PostFormScreen(
                            postId: postId,
                          ));
                        }),
                    GoRoute(
                        path: ':postId',
                        name: PostDetailScreen.routeName,
                        pageBuilder: (context, state) {
                          final int postId =
                              int.parse(state.pathParameters['postId']!);
                          return NoTransitionPage(
                              child: PostDetailScreen(
                            postId: postId,
                          ));
                        }),
                  ]),
            ]),
      ]);
});
