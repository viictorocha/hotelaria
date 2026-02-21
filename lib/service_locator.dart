import 'package:get_it/get_it.dart';
// import 'data/repositories/quarto_mock_repository.dart';

// O GetIt.instance é o objeto que guarda as referências
final getIt = GetIt.instance;

void setupLocator() {
  // REGISTRO DE REPOSITÓRIOS
  // Usamos 'registerLazySingleton' para que a classe só seja criada
  // na primeira vez que for usada, economizando memória.
  // getIt.registerLazySingleton<QuartoMockRepository>(
  //   () => QuartoMockRepository(),
  // );

  // Se você tiver outros repositórios futuramente:
  // getIt.registerLazySingleton<ReservaRepository>(() => ReservaRepositoryImpl());
}
