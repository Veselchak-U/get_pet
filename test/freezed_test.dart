import 'package:flutter_test/flutter_test.dart';
import 'package:get_pet/models/breed.dart';

void main() {
  test('copyWith()', () {
    final breedOne = BreedModel(
      id: '1',
      categoryId: '2',
      name: 'The name of breed',
    );
    final breedTwo = breedOne.copyWith(id: '11');
    expect(breedOne.id, '1');
    expect(breedTwo.id, '11');
    expect(breedTwo.categoryId, '2');
    expect(breedTwo.name, 'The name of breed');
  });

  test('custom toString()', () {
    final breedOne = BreedModel(
      id: '1',
      categoryId: '2',
      name: 'The name of breed',
    );
    expect(breedOne.toString(), 'The name of breed');
  });
}
