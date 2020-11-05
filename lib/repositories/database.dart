import 'package:cats/import.dart';
import 'package:graphql/client.dart';

import '../local.dart';

const _kGraphqlUri = 'https://cats.hasura.app/v1/graphql';
const _kToken = 'Bearer $kDatabaseToken';
// const _kEnableWebSockets = false;
const _kGraphQLTimeout = 5000;

class DatabaseRepository {
  final GraphQLClient _client = _getClient();

  static GraphQLClient _getClient() {
    final httpLink = HttpLink(uri: _kGraphqlUri);
    final authLink = AuthLink(getToken: () async => _kToken);
    final link = authLink.concat(httpLink);
    return GraphQLClient(
      cache: InMemoryCache(),
      link: link,
    );
  }

  Future<int> loadNotificationCount() async {
    var result = 2;
    // await Future.delayed(const Duration(milliseconds: 300));
    return result;
  }

  Future<String> loadUserAvatarImage() async {
    var result =
        'https://images.unsplash.com/photo-1602773890240-87ce74fc752e?ixlib=rb-1.2.1&auto=format&fit=crop&w=700&q=80';
    // await Future.delayed(const Duration(milliseconds: 300));
    return result;
  }

  Future<List<ConditionModel>> loadConditions() async {
    List<ConditionModel> result = [];
    final options = QueryOptions(
      documentNode: _API.readConditions,
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final queryResult = await _client
        .query(options)
        .timeout(Duration(milliseconds: _kGraphQLTimeout));
    if (queryResult.hasException) {
      throw queryResult.exception;
    }
    // print(queryResult.data);
    final dataItems =
        (queryResult.data['conditions'] as List).cast<Map<String, dynamic>>();
    for (final item in dataItems) {
      try {
        result.add(ConditionModel.fromJson(item));
      } catch (e) {
        print(e);
      }
    }
    return result;
  }

  Future<List<CategoryModel>> loadPetCategories() async {
    List<CategoryModel> result = [];
    final options = QueryOptions(
      documentNode: _API.readPetCategories,
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final queryResult = await _client
        .query(options)
        .timeout(Duration(milliseconds: _kGraphQLTimeout));
    if (queryResult.hasException) {
      throw queryResult.exception;
    }
    // print(queryResult.data);
    final dataItems =
        (queryResult.data['categories'] as List).cast<Map<String, dynamic>>();
    for (final item in dataItems) {
      try {
        result.add(CategoryModel.fromJson(item));
      } catch (e) {
        print(e);
      }
    }
    return result;

    // var result = [
    //   PetCategory(
    //     name: 'Hamsters',
    //     count: 56,
    //     image: 'assets/image/hamster.png',
    //     background: Color(0xffF9EDD3),
    //   ),
    //   PetCategory(
    //     name: 'Cats',
    //     count: 210,
    //     image: 'assets/image/cat.png',
    //     background: Color(0xffD8F1FD),
    //   ),
    //   PetCategory(
    //     name: 'Bunnies',
    //     count: 90,
    //     image: 'assets/image/rabbit.png',
    //     background: Color(0xffE6F3E7),
    //   ),
    //   PetCategory(
    //     name: 'Dogs',
    //     count: 340,
    //     image: 'assets/image/dog.png',
    //     background: Color(0xffFAE0D8),
    //   ),
    // ];
    // await Future.delayed(const Duration(milliseconds: 300));
    // return result;
  }

  Future<List<PetModel>> loadNewestPets() async {
    List<PetModel> result = [];
    final options = QueryOptions(
      documentNode: _API.readNewestPets,
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final queryResult = await _client
        .query(options)
        .timeout(Duration(milliseconds: _kGraphQLTimeout));
    if (queryResult.hasException) {
      throw queryResult.exception;
    }
    // print(queryResult.data);
    final dataItems =
        (queryResult.data['pets'] as List).cast<Map<String, dynamic>>();
    for (final item in dataItems) {
      try {
        result.add(PetModel.fromJson(item));
      } catch (e) {
        print(e);
      }
    }
    return result;

    // List<Pet> result = [
    //   Pet(
    //     breed: 'Abyssinian Cats',
    //     // gender: Gender.male,
    //     age: '4 monts',
    //     coloring: 'Grey',
    //     weight: 2.0,
    //     address: 'California',
    //     distance: 2.5,
    //     action: PetAction.adoption,
    //     liked: true,
    //     photos: [
    //       'https://cdn.pixabay.com/photo/2020/05/05/10/14/cat-5132411_960_720.jpg'
    //     ],
    //     description: 'Ищу нового хозяина',
    //     contact: Member(name: 'Nannie Baker'),
    //   ),
    //   Pet(
    //     breed: 'Scottish Fold',
    //     // gender: Gender.female,
    //     age: '1,5 years',
    //     coloring: 'Leopard',
    //     weight: 3.5,
    //     address: 'New Jersey',
    //     distance: 1.2,
    //     action: PetAction.mating,
    //     liked: false,
    //     photos: [
    //       'https://cdn.pixabay.com/photo/2014/11/05/17/28/savannah-cat-518126_960_720.jpg'
    //     ],
    //     description: 'Желаю завести семью',
    //     contact: Member(name: 'Donald Trump'),
    //   ),
    //   Pet(
    //     breed: 'Abyssinian Cats',
    //     // gender: Gender.male,
    //     age: '4 monts',
    //     coloring: 'Grey',
    //     weight: 2.0,
    //     address: 'California',
    //     distance: 2.5,
    //     action: PetAction.adoption,
    //     liked: true,
    //     photos: [
    //       'https://cdn.pixabay.com/photo/2020/05/05/10/14/cat-5132411_960_720.jpg'
    //     ],
    //     description: 'Ищу нового хозяина',
    //     contact: Member(name: 'Nannie Baker'),
    //   ),
    //   Pet(
    //     breed: 'Scottish Fold',
    //     // gender: Gender.female,
    //     age: '1,5 years',
    //     coloring: 'Leopard',
    //     weight: 3.5,
    //     address: 'New Jersey',
    //     distance: 1.2,
    //     action: PetAction.mating,
    //     liked: false,
    //     photos: [
    //       'https://cdn.pixabay.com/photo/2014/11/05/17/28/savannah-cat-518126_960_720.jpg'
    //     ],
    //     description: 'Желаю завести семью',
    //     contact: Member(name: 'Donald Trump'),
    //   ),
    //   Pet(
    //     breed: 'Abyssinian Cats',
    //     // gender: Gender.male,
    //     age: '4 monts',
    //     coloring: 'Grey',
    //     weight: 2.0,
    //     address: 'California',
    //     distance: 2.5,
    //     action: PetAction.adoption,
    //     liked: true,
    //     photos: [
    //       'https://cdn.pixabay.com/photo/2020/05/05/10/14/cat-5132411_960_720.jpg'
    //     ],
    //     description: 'Ищу нового хозяина',
    //     contact: Member(name: 'Nannie Baker'),
    //   ),
    //   Pet(
    //     breed: 'Scottish Fold',
    //     // gender: Gender.female,
    //     age: '1,5 years',
    //     coloring: 'Leopard',
    //     weight: 3.5,
    //     address: 'New Jersey',
    //     distance: 1.2,
    //     action: PetAction.mating,
    //     liked: false,
    //     photos: [
    //       'https://cdn.pixabay.com/photo/2014/11/05/17/28/savannah-cat-518126_960_720.jpg'
    //     ],
    //     description: 'Желаю завести семью',
    //     contact: Member(name: 'Donald Trump'),
    //   ),
    // ];
    // await Future.delayed(const Duration(milliseconds: 300));
    // return result;
  }

  Future<List<VetModel>> loadNearestVets() async {
    List<VetModel> result = [];
    final options = QueryOptions(
      documentNode: _API.readNearestVets,
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final queryResult = await _client
        .query(options)
        .timeout(Duration(milliseconds: _kGraphQLTimeout));
    if (queryResult.hasException) {
      throw queryResult.exception;
    }
    // print(queryResult.data);
    final dataItems =
        (queryResult.data['vets'] as List).cast<Map<String, dynamic>>();
    for (final item in dataItems) {
      try {
        result.add(VetModel.fromJson(item));
      } catch (e) {
        print(e);
      }
    }
    return result;

    // var result = [
    //   Vet(
    //     name: 'Animal Emergency Hospital',
    //     phone: '(369) 133-8956',
    //     timetable: 'OPEN - 24/7',
    //     isOpenNow: true,
    //     logo:
    //         'https://static.wixstatic.com/media/4c5817_9e055ee1e22043f2879122b97d8bfbd1~mv2.png/v1/fill/w_63,h_60,al_c,q_85,usm_0.66_1.00_0.01/%D0%9B%D0%9E%D0%93%D0%9Epng.webp',
    //   ),
    //   Vet(
    //     name: 'РИмонт ЖЫвотных',
    //     phone: '(8634) 222-333',
    //     timetable: 'TOMORROW AT 8:00',
    //     isOpenNow: false,
    //     logo: 'http://animalservice.ru/images/menu.png',
    //   ),
    //   Vet(
    //     name: 'Зоосфера',
    //     phone: '(495) 123-4567',
    //     timetable: 'OPEN - 24/7',
    //     isOpenNow: true,
    //     logo:
    //         'https://zoosffera.1c-umi.ru/images/cms/thumbs/a5b0aeaa3fa7d6e58d75710c18673bd7ec6d5f6d/i_1_200_auto.jpg',
    //   ),
    // ];
    // await Future.delayed(const Duration(milliseconds: 300));
    // return result;
  }
}

class _API {
  static final readConditions = gql(r'''
    query ReadConditions {
      conditions {
        id
        name
        text_color
        background_color
      }
    }
  ''');

  static final readPetCategories = gql(r'''
    query ReadPetCategories {
      categories(order_by: {sort_order: asc}) {
        id
        name
        total_of
        image
        background
      }
    }
  ''');

  static final readNearestVets = gql(r'''
    query ReadNearestVets {
      vets {
        id
        name
        logo
        phone
        timetable
        is_open_now
      }
    }
  ''');

  static final readNewestPets = gql(r'''
    query ReadNewestPets {
      pets {
        id
        category_id
        condition_id
        description
        distance
        member_id
        photos
        weight
        coloring
        breed
        age
        address
      }
    }
  ''');
}
