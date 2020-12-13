import 'package:flutter/foundation.dart';
import 'package:get_pet/import.dart';
import 'package:graphql/client.dart';

import '../local.dart';

// const _kEnableWebSockets = false;
const _kTimeoutMillisec = 10000;

class DatabaseRepository {
  DatabaseRepository({@required this.authRepository}) {
    _client = _getClient();
  }

  final AuthenticationRepository authRepository;
  GraphQLClient _client;

  List<CategoryModel> _cashedCategories;
  List<ConditionModel> _cashedConditions;
  List<BreedModel> _cashedBreeds;

  GraphQLClient _getClient() {
    final httpLink = HttpLink(uri: kGraphQLEndpoint);
    final authLink = AuthLink(
      getToken: () async {
        final idToken = await authRepository.getIdToken(forceRefresh: true);
        // out('!!! authRepository.getIdToken !!!');
        return 'Bearer $idToken';
      },
    );
    final link = authLink.concat(httpLink);
    return GraphQLClient(
      cache: InMemoryCache(),
      link: link,
    );
  }

  // Future<MemberModel> upsertMember(MemberData data) {
  //   final result = _service.mutate<MemberModel>(
  //     document: _API.upsertMember,
  //     variables: data.toJson(),
  //     root: 'insert_member_one',
  //     convert: MemberModel.fromJson,
  //   );
  //   return result;
  // }

  Future<bool> upsertMember(UserModel user) async {
    var result = true;

    final options = MutationOptions(
      documentNode: _API.upsertMember,
      variables: {
        'name': user.displayName,
        'photo': user.photoURL,
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
    return result;
  }

  Future<int> readNotificationCount() async {
    final result = 2;
    return result;
  }

  Future<String> readUserAvatarImage() async {
    final result =
        'https://images.unsplash.com/photo-1602773890240-87ce74fc752e?ixlib=rb-1.2.1&auto=format&fit=crop&w=700&q=80';
    return result;
  }

  Future<List<ConditionModel>> readConditions({bool fromCash = true}) async {
    if (fromCash && _cashedConditions != null) {
      return _cashedConditions;
    }
    final List<ConditionModel> result = [];
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
    // out(queryResult.data);
    final dataItems =
        (queryResult.data['conditions'] as List).cast<Map<String, dynamic>>();
    for (final item in dataItems) {
      try {
        result.add(ConditionModel.fromJson(item));
      } catch (error) {
        out(error);
        return Future.error(error);
      }
    }
    _cashedConditions = result;
    return result;
  }

  Future<List<CategoryModel>> readCategories({bool fromCash = true}) async {
    if (fromCash && _cashedCategories != null) {
      return _cashedCategories;
    }
    final List<CategoryModel> result = [];
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
    // out(queryResult.data);
    final dataItems =
        (queryResult.data['categories'] as List).cast<Map<String, dynamic>>();
    for (final item in dataItems) {
      try {
        result.add(CategoryModel.fromJson(item));
      } catch (error) {
        out(error);
        return Future.error(error);
      }
    }
    _cashedCategories = result;
    return result;
  }

  Future<List<BreedModel>> readBreeds({bool fromCash = true}) async {
    if (fromCash && _cashedBreeds != null) {
      return _cashedBreeds;
    }
    final List<BreedModel> result = [];

    final options = QueryOptions(
      documentNode: _API.readBreeds,
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final queryResult = await _client
        .query(options)
        .timeout(Duration(milliseconds: _kTimeoutMillisec));
    if (queryResult.hasException) {
      throw queryResult.exception;
    }
    // out(queryResult.data);
    final dataItems =
        (queryResult.data['breeds'] as List).cast<Map<String, dynamic>>();
    for (final item in dataItems) {
      try {
        result.add(BreedModel.fromJson(item));
      } catch (error) {
        out(error);
        return Future.error(error);
      }
    }
    _cashedBreeds = result;
    return result;
  }

  Future<List<PetModel>> searchPets(
      {String categoryId,
      String conditionId,
      String query,
      int limit = 20}) async {
    assert(categoryId != null || query != null);
    final options = QueryOptions(
      documentNode: _API.searchPets,
      variables: {
        // 'member_id': kDatabaseUserId,
        // 'member_id': authRepository.currentUser.id,
        'category_id': categoryId,
        'condition_id': conditionId,
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
      throw queryResult.exception;
    }
    // out(queryResult.data);
    final petItems =
        (queryResult.data['pets'] as List).cast<Map<String, dynamic>>();
    final List<PetModel> pets = [];
    for (final item in petItems) {
      try {
        pets.add(PetModel.fromJson(item));
      } catch (error) {
        out(error);
        return Future.error(error);
      }
    }
    final likedItems =
        (queryResult.data['liked'] as List).cast<Map<String, dynamic>>();
    final List<String> likes = [];
    for (final item in likedItems) {
      try {
        likes.add(item['pet_id'] as String);
      } catch (error) {
        out(error);
        return Future.error(error);
      }
    }
    final List<PetModel> result = [];
    pets.forEach((pet) {
      final liked = likes.contains(pet.id);
      final petWhithLike = pet.copyWith(liked: liked);
      result.add(petWhithLike);
    });
    return result;
  }

  Future<List<PetModel>> readNewestPets() async {
    final List<PetModel> result = [];
    final options = QueryOptions(
      documentNode: _API.readNewestPets, //_API.readPets,
      variables: {
        // 'member_id': kDatabaseUserId,
        'member_id': authRepository.currentUser.id,
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
    // out(queryResult.data);
    final dataItems = (queryResult.data['get_pets_by_member_id'] as List)
        .cast<Map<String, dynamic>>();
    for (final item in dataItems) {
      try {
        result.add(PetModel.fromJson(item));
      } catch (error) {
        out(error);
        return Future.error(error);
      }
    }
    // TODO: move sorting to server
    result.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return result;
  }

  Future<List<PetModel>> readNewestPetsWithLikes() async {
    final options = QueryOptions(
      documentNode: _API.readNewestPetsWithLikes,
      // variables: {
      //   // 'member_id': kDatabaseUserId,
      //   'member_id': authRepository.currentUser.id,
      // },
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final queryResult = await _client
        .query(options)
        .timeout(Duration(milliseconds: _kTimeoutMillisec));
    if (queryResult.hasException) {
      throw queryResult.exception;
    }
    // out(queryResult.data);
    final petItems =
        (queryResult.data['pets'] as List).cast<Map<String, dynamic>>();
    final List<PetModel> pets = [];
    for (final item in petItems) {
      try {
        pets.add(PetModel.fromJson(item));
      } catch (error) {
        out(error);
        return Future.error(error);
      }
    }
    final likedItems =
        (queryResult.data['liked'] as List).cast<Map<String, dynamic>>();
    final List<String> likes = [];
    for (final item in likedItems) {
      try {
        likes.add(item['pet_id'] as String);
      } catch (error) {
        out(error);
        return Future.error(error);
      }
    }
    final List<PetModel> result = [];
    pets.forEach((pet) {
      final liked = likes.contains(pet.id);
      final petWhithLike = pet.copyWith(liked: liked);
      result.add(petWhithLike);
    });
    out('readNewestPetsWithLikes()');
    return result;
  }

  Future<List<VetModel>> readNearestVets() async {
    final List<VetModel> result = [];
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
    // out(queryResult.data);
    final dataItems =
        (queryResult.data['vets'] as List).cast<Map<String, dynamic>>();
    for (final item in dataItems) {
      try {
        result.add(VetModel.fromJson(item));
      } catch (error) {
        out(error);
        return Future.error(error);
      }
    }
    return result;
  }

  Future<bool> updatePetLike(PetModel pet) async {
    final String petId = pet.id;
    final bool isLike = !pet.liked;
    var result = true;

    final options = MutationOptions(
      documentNode: isLike ? _API.insertPetLike : _API.deletePetLike,
      variables: isLike
          ? {
              'pet_id': petId,
            }
          : {
              'member_id': authRepository.currentUser.id,
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
    return result;
  }

  // Future<bool> updatePetLike({String petId, bool isLike}) async {
  //   var result = true;

  //   final options = MutationOptions(
  //     documentNode: isLike ? _API.insertPetLike : _API.deletePetLike,
  //     variables: isLike
  //         ? {
  //             // 'member_id': kDatabaseUserId,
  //             // 'member_id': authRepository.currentUser.id,
  //             'pet_id': petId,
  //           }
  //         : {
  //             // 'member_id': kDatabaseUserId,
  //             'member_id': authRepository.currentUser.id,
  //             'pet_id': petId,
  //           },
  //     fetchPolicy: FetchPolicy.noCache,
  //     errorPolicy: ErrorPolicy.all,
  //   );
  //   final mutationResult = await _client
  //       .mutate(options)
  //       .timeout(Duration(milliseconds: _kTimeoutMillisec));
  //   if (mutationResult.hasException) {
  //     result = false;
  //     throw mutationResult.exception;
  //   }
  //   return result;
  // }

  Future<PetModel> createPet(PetModel newPet) async {
    final options = MutationOptions(
      documentNode: _API.createPet,
      variables: {
        'category_id': newPet.category.id,
        'breed_id': newPet.breed.id,
        'condition_id': newPet.condition.id,
        // 'member_id': kDatabaseUserId,
        // 'member_id': authRepository.currentUser.id,
        'coloring': newPet.coloring,
        'age': newPet.age,
        'weight': newPet.weight,
        'address': newPet.address,
        'distance': newPet.distance,
        'description': newPet.description,
        'photos': newPet.photos,
      },
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final mutationResult = await _client
        .mutate(options)
        .timeout(Duration(milliseconds: _kTimeoutMillisec));
    if (mutationResult.hasException) {
      throw mutationResult.exception;
    }
    // out(mutationResult.data);
    final dataItem =
        mutationResult.data['insert_pet_one'] as Map<String, dynamic>;
    try {
      out('createPet()');
      return PetModel.fromJson(dataItem);
    } catch (error) {
      out(error);
      return Future.error(error);
    }
  }
}

class _API {
  static final upsertMember = gql(r'''
    mutation UpsertMember($name: String $photo: String) {
      insert_member_one(object: {name: $name, photo: $photo},
      on_conflict: {constraint: member_pkey, update_columns: [name, photo]}) {
        ...MemberFields
      }
    }
  ''')..definitions.addAll(fragments.definitions);

  static final createPet = gql(r'''
    mutation CreatePet(
      $category_id: uuid!,
      $breed_id: uuid!,
      $condition_id: uuid!,
      # $member_id: uuid!,
      $coloring: String!,
      $age: String!,
      $weight: numeric!,
      $address: String!,
      $distance: numeric!,
      $description: String!,
      $photos: String!,
    ) {
      insert_pet_one(object: {
        category_id: $category_id,
        breed_id: $breed_id,
        condition_id: $condition_id,
        # member_id: $member_id,
        coloring: $coloring,
        age: $age,
        weight: $weight,
        address: $address,
        distance: $distance,
        description: $description,
        photos: $photos,
        }) {
        ...PetFields
      }
    }
  ''')..definitions.addAll(fragments.definitions);

  static final searchPets = gql(r'''
    query SearchPets($category_id: uuid, $condition_id: uuid, $query: String, $limit: Int!) {
      pets(where: {_and: [
                    {category: {id: {_eq: $category_id}}},
                    {condition: {id: {_eq: $condition_id}}},
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
      liked {
        ...LikedFields
      }
    }
  ''')..definitions.addAll(fragments.definitions);

  // static final searchPets = gql(r'''
  //   query SearchPets($member_id: uuid!, $category_id: uuid, $condition_id: uuid, $query: String, $limit: Int!) {
  //     get_pets_by_member_id(args: {member_id: $member_id},
  //       where: {_and: [
  //                 {category: {id: {_eq: $category_id}}},
  //                 {condition: {id: {_eq: $condition_id}}},
  //                 {_or: [
  //                   {breed: {name: {_ilike: $query}}},
  //                   {address: {_ilike: $query}},
  //                 ]},
  //              ]},
  //       order_by: {updated_at: desc},
  //       limit: $limit
  //     ) {
  //       ...PetFields
  //     }
  //   }
  // ''')..definitions.addAll(fragments.definitions);

  static final insertPetLike = gql(r'''
    mutation InsertPetLike($pet_id: uuid!) {
      insert_liked_one(object: {pet_id: $pet_id}) {
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

  // static final readPets = gql(r'''
  //   query ReadAllPets {
  //     pets {
  //       ...PetFields
  //     }
  //   }
  // ''')..definitions.addAll(fragments.definitions);

  static final readNewestPetsWithLikes = gql(r'''
    query ReadPets {
      pets(order_by: {updated_at: desc}, limit: 10) {
        ...PetFields
      }
      liked {
        ...LikedFields
      }
    }
  ''')..definitions.addAll(fragments.definitions);

  // static final readAllPets = gql(r'''
  //   query ReadAllPets {
  //     pets {
  //       ...PetFields
  //     }
  //   }
  // ''')..definitions.addAll(fragments.definitions);

  static final readBreeds = gql(r'''
    query ReadBreeds {
      breeds {
        ...BreedFields
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
    fragment LikedFields on liked {
      # __typename
      # member_id
      pet_id
    }
    fragment PetFields on pet {
      # __typename
      id
      age
      coloring
      description
      weight
      photos
      address
      distance
      liked
      updated_at
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
