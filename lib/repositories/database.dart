import 'package:cats/import.dart';
import 'package:flutter/material.dart';
import 'package:graphql/client.dart';

import '../local.dart';

const _kGraphqlUri = 'https://cats.hasura.app/v1/graphql';
const _kToken = 'Bearer $kDatabaseToken';
// const _kEnableWebSockets = false;
const _kTimeoutMillisec = 5000;

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
        .timeout(Duration(milliseconds: _kTimeoutMillisec));
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

  Future<List<CategoryModel>> loadCategories() async {
    List<CategoryModel> result = [];
    final options = QueryOptions(
      documentNode: _API.readPetCategories,
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final queryResult = await _client
        .query(options)
        .timeout(Duration(milliseconds: _kTimeoutMillisec));
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

  Future<List<BreedModel>> loadBreeds(/* {@required CategoryModel category} */) async {
    // assert(category == null);

    List<BreedModel> result = [
      BreedModel.fromJson({
        "id": "39da69c6-3c90-4bb8-bfb1-a0d91109957d",
        "category_id": "abe09048-c1dc-4f4b-87e3-421b7f34e07d",
        "name": "Scottish Fold"
      }),
      BreedModel.fromJson({
        "id": "c8305d81-19df-4ddb-8111-0c3d2aea88c5",
        "category_id": "abe09048-c1dc-4f4b-87e3-421b7f34e07d",
        "name": "Maine Coon"
      }),
      BreedModel.fromJson({
        "id": "9b569495-bb2e-41e5-8f18-ec151158a9fd",
        "category_id": "abe09048-c1dc-4f4b-87e3-421b7f34e07d",
        "name": "Burmes"
      }),
      BreedModel.fromJson({
        "id": "11545066-92ec-42dc-bfbe-7cff7b41fdb0",
        "category_id": "01b9c85f-4ea9-4e45-a15c-d8f5a3247478",
        "name": "American"
      }),
      BreedModel.fromJson({
        "id": "e04326db-55d4-421e-97ee-066661e3c921",
        "category_id": "01b9c85f-4ea9-4e45-a15c-d8f5a3247478",
        "name": "Belgian Hare"
      }),
      BreedModel.fromJson({
        "id": "0eee4171-ecbf-4bee-8ca6-61614b302d3c",
        "category_id": "01b9c85f-4ea9-4e45-a15c-d8f5a3247478",
        "name": "Blanc de Hotot"
      }),
      BreedModel.fromJson({
        "id": "20bd66d3-c9d1-448d-ba88-9e6a40a2ef6f",
        "category_id": "01b9c85f-4ea9-4e45-a15c-d8f5a3247478",
        "name": "Californian"
      }),
      BreedModel.fromJson({
        "id": "b31551de-b71d-4f5c-95bf-781ccadab093",
        "category_id": "abe09048-c1dc-4f4b-87e3-421b7f34e07d",
        "name": "Ragdoll"
      }),
      BreedModel.fromJson({
        "id": "756a0161-79ee-49a4-a001-bb380393e52a",
        "category_id": "75fe6ef0-80b4-4ef0-9fb9-5f53d25ee166",
        "name": "Roborowski"
      }),
      BreedModel.fromJson({
        "id": "a48ff5bf-0edb-448f-8905-c55a9c70d60a",
        "category_id": "75fe6ef0-80b4-4ef0-9fb9-5f53d25ee166",
        "name": "Chinese"
      }),
      BreedModel.fromJson({
        "id": "c7662407-2323-473a-b9db-1ec004b0623a",
        "category_id": "01b9c85f-4ea9-4e45-a15c-d8f5a3247478",
        "name": "English Spot"
      }),
      BreedModel.fromJson({
        "id": "a7fdf25a-b521-4849-b86d-f03ba4b3aa03",
        "category_id": "48b47e8e-addd-489c-aa2b-dac5234371e2",
        "name": "Affenpinscher"
      }),
      BreedModel.fromJson({
        "id": "16672393-afc4-4a38-990a-fed61b08a7b6",
        "category_id": "48b47e8e-addd-489c-aa2b-dac5234371e2",
        "name": "Bloodhound"
      }),
      BreedModel.fromJson({
        "id": "79683bc7-09d8-4d6f-a8c4-d200185f91ea",
        "category_id": "48b47e8e-addd-489c-aa2b-dac5234371e2",
        "name": "Boston Terrier"
      }),
      BreedModel.fromJson({
        "id": "177e3e5c-0dfa-4627-b66e-f42da6246023",
        "category_id": "48b47e8e-addd-489c-aa2b-dac5234371e2",
        "name": "Chow Chow"
      }),
      BreedModel.fromJson({
        "id": "8bcab19a-1e2f-42ff-9b8c-c437d617d053",
        "category_id": "75fe6ef0-80b4-4ef0-9fb9-5f53d25ee166",
        "name": "Ruso"
      }),
      BreedModel.fromJson({
        "id": "9a487687-0990-4854-a089-d9e706ccdbc9",
        "category_id": "75fe6ef0-80b4-4ef0-9fb9-5f53d25ee166",
        "name": "Golden"
      }),
      BreedModel.fromJson({
        "id": "350128fa-b9f1-4791-8427-aabacb00bbc3",
        "category_id": "75fe6ef0-80b4-4ef0-9fb9-5f53d25ee166",
        "name": "Dwarf Campbell"
      }),
      BreedModel.fromJson({
        "id": "daf88bf6-aec7-4eff-a658-1d072a12c276",
        "category_id": "75fe6ef0-80b4-4ef0-9fb9-5f53d25ee166",
        "name": "Syrian"
      }),
      BreedModel.fromJson({
        "id": "3cfbb2ad-1e08-4a3a-9908-ff8d21c57369",
        "category_id": "75fe6ef0-80b4-4ef0-9fb9-5f53d25ee166",
        "name": "Dwarf Winter"
      }),
      BreedModel.fromJson({
        "id": "2eb7bb9c-ae5d-41b7-a086-90398450182b",
        "category_id": "01b9c85f-4ea9-4e45-a15c-d8f5a3247478",
        "name": "Checkered Giant"
      }),
      BreedModel.fromJson({
        "id": "415c026a-d227-4518-b761-b34c1b52c5b5",
        "category_id": "01b9c85f-4ea9-4e45-a15c-d8f5a3247478",
        "name": "Dutch"
      }),
      BreedModel.fromJson({
        "id": "51835e22-df36-42fc-9fc1-8174f0989848",
        "category_id": "01b9c85f-4ea9-4e45-a15c-d8f5a3247478",
        "name": "English Lop"
      }),
      BreedModel.fromJson({
        "id": "afdc3686-1511-4316-a52e-6c9bc8e7d991",
        "category_id": "48b47e8e-addd-489c-aa2b-dac5234371e2",
        "name": "Akita Shepherd"
      }),
      BreedModel.fromJson({
        "id": "616d4444-84a3-4823-b68d-38493c7e31db",
        "category_id": "48b47e8e-addd-489c-aa2b-dac5234371e2",
        "name": "American Foxhound"
      }),
      BreedModel.fromJson({
        "id": "0f9fdcaf-9911-42c8-b39a-89846dac0cc7",
        "category_id": "48b47e8e-addd-489c-aa2b-dac5234371e2",
        "name": "Shepherd"
      }),
      BreedModel.fromJson({
        "id": "afe28458-ab55-4135-aa85-c20cdd9a8101",
        "category_id": "48b47e8e-addd-489c-aa2b-dac5234371e2",
        "name": "Australian Terrier"
      }),
      BreedModel.fromJson({
        "id": "6a00d6d4-0706-408c-98b6-f1f2ab56d760",
        "category_id": "48b47e8e-addd-489c-aa2b-dac5234371e2",
        "name": "Bearded Collie"
      }),
      BreedModel.fromJson({
        "id": "bac8e3b5-fbd7-48da-b52b-c3a7005c4a5d",
        "category_id": "48b47e8e-addd-489c-aa2b-dac5234371e2",
        "name": "Belgian Sheepdog"
      }),
      BreedModel.fromJson({
        "id": "55592989-9688-49c5-88aa-22a61ed385bf",
        "category_id": "48b47e8e-addd-489c-aa2b-dac5234371e2",
        "name": "Chinese Shar-Pei"
      }),
      BreedModel.fromJson({
        "id": "d62f88a0-5046-4691-938c-c6913b96a33e",
        "category_id": "48b47e8e-addd-489c-aa2b-dac5234371e2",
        "name": "Border Collie"
      }),
      BreedModel.fromJson({
        "id": "baf1ca1f-926b-4bb2-b4ea-715435435005",
        "category_id": "abe09048-c1dc-4f4b-87e3-421b7f34e07d",
        "name": "American Shorthair"
      }),
      BreedModel.fromJson({
        "id": "a0087cf7-6dde-4a5f-9448-ce6d80bfc817",
        "category_id": "abe09048-c1dc-4f4b-87e3-421b7f34e07d",
        "name": "British Shorthair"
      }),
      BreedModel.fromJson({
        "id": "11b17ef0-265e-489e-8965-ace91df1f0a0",
        "category_id": "abe09048-c1dc-4f4b-87e3-421b7f34e07d",
        "name": "Abyssinian"
      }),
    ];
    // final options = QueryOptions(
    //   documentNode: _API.readConditions,
    //   fetchPolicy: FetchPolicy.noCache,
    //   errorPolicy: ErrorPolicy.all,
    // );
    // final queryResult = await _client
    //     .query(options)
    //     .timeout(Duration(milliseconds: _kTimeoutMillisec));
    // if (queryResult.hasException) {
    //   throw queryResult.exception;
    // }
    // // print(queryResult.data);
    // final dataItems =
    //     (queryResult.data['conditions'] as List).cast<Map<String, dynamic>>();
    // for (final item in dataItems) {
    //   try {
    //     result.add(ConditionModel.fromJson(item));
    //   } catch (e) {
    //     print(e);
    //   }
    // }

    // return result.where((BreedModel e) => e.categoryId == category.id);
    return result;
  }

  Future<List<PetModel>> searchPets(
      {String categoryId, String query, int limit = 20}) async {
    assert(categoryId != null || query != null);
    List<PetModel> result = [];
    final options = QueryOptions(
      documentNode: _API.searchPets,
      variables: {
        'member_id': kDatabaseUserId,
        'category_id': categoryId,
        'query': '%$query%',
        'limit': limit,
      },
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final queryResult = await _client
        .query(options)
        .timeout(Duration(milliseconds: _kTimeoutMillisec));
    if (queryResult.hasException) {
      // print(queryResult.exception.clientException.message);
      throw queryResult.exception;
    }
    // print(queryResult.data);
    final dataItems = (queryResult.data['get_pets_by_member_id'] as List)
        .cast<Map<String, dynamic>>();
    for (final item in dataItems) {
      try {
        result.add(PetModel.fromJson(item));
        print(PetModel.fromJson(item).breed.name);
        print(PetModel.fromJson(item).address);
      } catch (e) {
        print(e);
      }
    }
    return result;
  }

  Future<List<PetModel>> loadNewestPets() async {
    List<PetModel> result = [];
    final options = QueryOptions(
      documentNode: _API.readNewestPets,
      variables: {
        'member_id': kDatabaseUserId,
      },
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final queryResult = await _client
        .query(options)
        .timeout(Duration(milliseconds: _kTimeoutMillisec));
    if (queryResult.hasException) {
      throw queryResult.exception;
    }
    // print(queryResult.data);
    final dataItems = (queryResult.data['get_pets_by_member_id'] as List)
        .cast<Map<String, dynamic>>();
    for (final item in dataItems) {
      try {
        result.add(PetModel.fromJson(item));
      } catch (e) {
        print(e);
      }
    }
    return result;
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
        .timeout(Duration(milliseconds: _kTimeoutMillisec));
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

  Future<bool> updatePetLike({String petId, bool isLike}) async {
    var result = true;

    final options = MutationOptions(
      documentNode: isLike ? _API.insertPetLike : _API.deletePetLike,
      variables: {
        'member_id': kDatabaseUserId,
        'pet_id': petId,
      },
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final mutationResult = await _client
        .mutate(options)
        .timeout(Duration(milliseconds: _kTimeoutMillisec));
    if (mutationResult.hasException) {
      result = false;
      throw mutationResult.exception;
    }
    // print(queryResult.data);
    // final dataItems =
    //     (mutationResult.data['insert_liked_one'] as List).cast<Map<String, dynamic>>();
    // return TodoModel.fromJson(dataItem);

    return result;
  }
}

class _API {
  static final searchPets = gql(r'''
    query SearchPets($member_id: uuid!, $category_id: uuid, $query: String, $limit: Int!) {
      get_pets_by_member_id(args: {member_id: $member_id},
        where: {_and: [
                  {category: {id: {_eq: $category_id}}},
                  {_or: [
                    {breed: {name: {_ilike: $query}}},
                    {address: {_ilike: $query}},
                  ]},
               ]},
        order_by: {updated_at: desc},
        limit: $limit
      ) {
        ...PetFields
      }
    }
  ''')..definitions.addAll(fragments.definitions);

  static final insertPetLike = gql(r'''
    mutation InsertPetLike($member_id: uuid!, $pet_id: uuid!) {
      insert_liked_one(object: {member_id: $member_id, pet_id: $pet_id}) {
        member_id
        pet_id
      }
    }
  ''');

  static final deletePetLike = gql(r'''
    mutation DeletePetLike($member_id: uuid!, $pet_id: uuid!) {
      delete_liked_by_pk(member_id: $member_id, pet_id: $pet_id) {
        member_id
        pet_id
      }
    }
  ''');

  static final readConditions = gql(r'''
    query ReadConditions {
      conditions {
        ...ConditionFields
      }
    }
  ''')..definitions.addAll(fragments.definitions);

  static final readPetCategories = gql(r'''
    query ReadPetCategories {
      categories(order_by: {sort_order: asc}) {
        ...CategoryFields
      }
    }
  ''')..definitions.addAll(fragments.definitions);

  static final readNearestVets = gql(r'''
    query ReadNearestVets {
      vets {
        ...VetFields
      }
    }
  ''')..definitions.addAll(fragments.definitions);

  static final readNewestPets = gql(r'''
    query ReadNewestPets($member_id: uuid!) {
      get_pets_by_member_id(args: {member_id: $member_id}) {
        ...PetFields
      }
    }
  ''')..definitions.addAll(fragments.definitions);

  static final readAllPets = gql(r'''
    query ReadAllPets {
      pets {
        ...PetFields
      }
    }
  ''')..definitions.addAll(fragments.definitions);

  static final fragments = gql(r'''
    fragment CategoryFields on category {
      # __typename
      id
      name
      total_of
      asset_image
      background_color
    }
    fragment ConditionFields on condition {
      # __typename
      id
      name
      text_color
      background_color
    }
    fragment BreedFields on breed {
      # __typename
      id
      category_id
      name
    }
    fragment VetFields on vet {
      # __typename
      id
      name
      phone
      timetable
      is_open_now
      logo_image
    }
    fragment MemberFields on member {
      # __typename
      id
      name
      photo
      email
      phone
    }
    fragment LikedFields on member {
      # __typename
      member_id
      pet_id
    }
    fragment PetFields on pet {
      # __typename
      # id
      # category_id
      # age
      # coloring
      # weight
      # address
      # distance
      # photos
      # description
      # member_id
      # condition_id
      # breed_id
      # liked
      id
      age
      coloring
      description
      weight
      photos
      address
      distance
      liked
      breed {
        id
        name
      }
      category {
        id
        name
        total_of
        asset_image
        background_color
      }
      condition {
        id
        name
        text_color
        background_color
      }
      member {
        id
        name
        photo
        email
        phone
      }
    }
  ''');
}
