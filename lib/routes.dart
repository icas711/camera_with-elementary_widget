import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:testtask/ui/pages/generate_image_page.dart';
import 'package:testtask/ui/pages/on_boarding_page.dart';
import 'package:testtask/ui/pages/pictures_list_screen.dart';
import 'package:testtask/ui/widgets/http_request.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  debugLogDiagnostics: true,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return //GenerateImage();},
            OnBoardingPage();
      },
      routes: [
        GoRoute(
          path: 'picturelist',
          name: 'picture-list',
          builder: (context, state) {
            // pageBuilder: (context, state) => NoTransitionPage(
            // child:
            return const PictureListScreen();
          },
        ),
        GoRoute(
            path: 'generate',
            name: 'generate',
            builder: (context, state) {
              return GenerateImage();
            },
            routes: [
              GoRoute(
                path: 'request',
                name: 'request',
                builder: (context, state) {
                  return const HttpRequestToServer();
                },
              ),
            ]),
      ],
    ),

    // ),
    /*routes: [
          GoRoute(
            path: 'home-detail-:guideId',
            name: 'home-detail',
            builder: (context, state) {
              final personId =
              int.tryParse(state.pathParameters['guideId']!);
              final _tyuw =
                  BlocProvider.of<GuideListCubit>(context).state;
              final foodlist = (_tyuw as GuideLoaded).guidesList;
              GuideEntity food = foodlist[0];
              for (int i = 0; i < foodlist.length; i++) {
                if (foodlist[i].id == personId) {
                  food = foodlist[i];
                }
              }
              return HomeDetailsScreen(
                guide: food,
              );
            },
          ),
        ],*/
  ],
);
