import '../../domain/entities/quarto_entity.dart';

class QuartoMockRepository {
  List<QuartoEntity> getTodosOsQuartos() {
    return [
      QuartoEntity(
        id: '1',
        numero: '101',
        tipo: TipoQuarto.luxo,
        status: StatusQuarto.disponivel,
        capacidade: 2,
        precoBase: 250.0,
      ),
      QuartoEntity(
        id: '2',
        numero: '102',
        tipo: TipoQuarto.standard,
        status: StatusQuarto.ocupado,
        capacidade: 3,
        precoBase: 180.0,
      ),
    ];
  }
}
