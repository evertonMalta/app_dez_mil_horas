import 'package:get_it/get_it.dart';
import '../providers/topic_provider.dart';

final GetIt sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerSingleton<TopicProvider>(TopicProvider());
}
