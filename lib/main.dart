import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/di/injection_container.dart' as di;
import 'core/local_storage/hive_service.dart';
import 'core/router/app_router.dart';
import 'presentation/bloc/bookmarks/bookmarks_cubit.dart';
import 'presentation/bloc/home/home_cubit.dart';
import 'presentation/bloc/search/search_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await di.init();
  final hiveService = di.sl<HiveService>();
  await hiveService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<HomeCubit>()),
        BlocProvider(create: (_) => di.sl<SearchCubit>()),
        BlocProvider(create: (_) => di.sl<BookmarksCubit>()),
      ],
      child: MaterialApp.router(
        title: 'MovieStash',
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ),
      ),
    );
  }
}
