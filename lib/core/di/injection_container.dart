import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection_container.config.dart';

final GetIt sl = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => sl.init();

Future<void> init() async {
  await configureDependencies();
}
