import 'package:flutter/foundation.dart';
import 'package:get_pet/import.dart';
import 'package:graphql/client.dart';

import '../local.dart';

// const _kEnableWebSockets = false;

class DatabaseRepository {
  DatabaseRepository({@required this.authRepository}) {
    // _client = _getClient();
  }

  final AuthenticationRepository authRepository;
  final logger = AppLogger.logger;
  // GraphQLClient _client;

  List<CategoryModel> _cashedCategories;
  List<ConditionModel> _cashedConditions;
  List<BreedModel> _cashedBreeds;

  GraphQLClient _getClient() {
    final httpLink = HttpLink(uri: kGraphQLEndpoint);
    final authLink = AuthLink(
      getToken: () async {
        final idToken = await authRepository.getIdToken(forceRefresh: true);
        return idToken == null ? null : 'Bearer $idToken';
      },
    );
    final Link link = (authLink != null) ? authLink.concat(httpLink) : httpLink;
    return GraphQLClient(
      cache: InMemoryCache(),
      link: link,
    );
  }

  Future<bool> upsertMember(UserModel user) async {
    var result = true;

    final options = MutationOptions(
      documentNode: _API.upsertMember,
      variables: {
        'name': user.name,
        'photo': user.photo,
        'email': user.email,
        'phone': user.phone,
      },
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final GraphQLClient client = _getClient();
    final mutationResult = await client
        .mutate(options)
        .timeout(const Duration(milliseconds: kTimeoutMillisec));
    if (mutationResult.hasException) {
      result = false;
      logger.e('DatabaseRepository upsertMember(${user.toJson()}) '
          '${mutationResult.exception}');
      throw mutationResult.exception;
    }
    return result;
  }

  Future<int> readNotificationCount() async {
    const result = 2;
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
    final GraphQLClient client = _getClient();
    final queryResult = await client
        .query(options)
        .timeout(const Duration(milliseconds: kTimeoutMillisec));
    if (queryResult.hasException) {
      logger.e('DatabaseRepository readConditions() ${queryResult.exception}');
      throw queryResult.exception;
    }
    logger.i('DatabaseRepository readConditions() ${queryResult.data}');
    final dataItems =
        (queryResult.data['conditions'] as List).cast<Map<String, dynamic>>();
    for (final item in dataItems) {
      try {
        result.add(ConditionModel.fromJson(item));
      } on dynamic catch (error, stackTrace) {
        logger.e('DatabaseRepository readConditions()', error, stackTrace);
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
    final GraphQLClient client = _getClient();
    final queryResult = await client
        .query(options)
        .timeout(const Duration(milliseconds: kTimeoutMillisec));
    if (queryResult.hasException) {
      logger.e('DatabaseRepository readCategories() ${queryResult.exception}');
      throw queryResult.exception;
    }
    logger.i('DatabaseRepository readCategories() ${queryResult.data}');
    final dataItems =
        (queryResult.data['categories'] as List).cast<Map<String, dynamic>>();
    for (final item in dataItems) {
      try {
        result.add(CategoryModel.fromJson(item));
      } on dynamic catch (error, stackTrace) {
        logger.e('DatabaseRepository readCategories()', error, stackTrace);
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
    final GraphQLClient client = _getClient();
    final queryResult = await client
        .query(options)
        .timeout(const Duration(milliseconds: kTimeoutMillisec));
    if (queryResult.hasException) {
      logger.e('DatabaseRepository readBreeds() ${queryResult.exception}');
      throw queryResult.exception;
    }
    logger.i('DatabaseRepository readBreeds() ${queryResult.data}');
    final dataItems =
        (queryResult.data['breeds'] as List).cast<Map<String, dynamic>>();
    for (final item in dataItems) {
      try {
        result.add(BreedModel.fromJson(item));
      } on dynamic catch (error, stackTrace) {
        logger.e('DatabaseRepository readBreeds()', error, stackTrace);
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
    final GraphQLClient client = _getClient();

    assert(categoryId != null || query != null);
    final options = QueryOptions(
      documentNode: _API.searchPets,
      variables: {
        'category_id': categoryId,
        'condition_id': conditionId,
        'query': '%$query%',
        'limit': limit,
      },
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final queryResult = await client
        .query(options)
        .timeout(const Duration(milliseconds: kTimeoutMillisec));
    if (queryResult.hasException) {
      logger.e('DatabaseRepository searchPets() ${queryResult.exception}');
      throw queryResult.exception;
    }
    logger.i('DatabaseRepository searchPets() ${queryResult.data}');
    final petItems =
        (queryResult.data['pets'] as List).cast<Map<String, dynamic>>();
    final List<PetModel> pets = [];
    for (final item in petItems) {
      try {
        pets.add(PetModel.fromJson(item));
      } on dynamic catch (error, stackTrace) {
        logger.e('DatabaseRepository searchPets()', error, stackTrace);
        return Future.error(error);
      }
    }
    final likedItems =
        (queryResult.data['liked'] as List).cast<Map<String, dynamic>>();
    final List<String> likes = [];
    for (final item in likedItems) {
      try {
        likes.add(item['pet_id'] as String);
      } on dynamic catch (error, stackTrace) {
        logger.e('DatabaseRepository searchPets()', error, stackTrace);
        return Future.error(error);
      }
    }
    final List<PetModel> result = [];
    for (final pet in pets) {
      final liked = likes.contains(pet.id);
      final petWhithLike = pet.copyWith(liked: liked);
      result.add(petWhithLike);
    }
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
    final GraphQLClient client = _getClient();
    final queryResult = await client
        .query(options)
        .timeout(const Duration(milliseconds: kTimeoutMillisec));
    if (queryResult.hasException) {
      logger.e('DatabaseRepository readNewestPets() ${queryResult.exception}');
      throw queryResult.exception;
    }
    logger.i('DatabaseRepository readNewestPets() ${queryResult.data}');
    final dataItems = (queryResult.data['get_pets_by_member_id'] as List)
        .cast<Map<String, dynamic>>();
    for (final item in dataItems) {
      try {
        result.add(PetModel.fromJson(item));
      } on dynamic catch (error, stackTrace) {
        logger.e('DatabaseRepository readNewestPets()', error, stackTrace);
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
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final GraphQLClient client = _getClient();
    final queryResult = await client
        .query(options)
        .timeout(const Duration(milliseconds: kTimeoutMillisec));
    if (queryResult.hasException) {
      logger.e('DatabaseRepository readNewestPetsWithLikes() '
          '${queryResult.exception}');
      throw queryResult.exception;
    }
    logger.v('DatabaseRepository readNewestPetsWithLikes() '
        '${queryResult.data}');
    final petItems =
        (queryResult.data['pets'] as List).cast<Map<String, dynamic>>();
    final List<PetModel> pets = [];
    for (final item in petItems) {
      try {
        pets.add(PetModel.fromJson(item));
      } on dynamic catch (error, stackTrace) {
        logger.e(
            'DatabaseRepository readNewestPetsWithLikes()', error, stackTrace);
        return Future.error(error);
      }
    }
    final likedItems =
        (queryResult.data['liked'] as List).cast<Map<String, dynamic>>();
    final List<String> likes = [];
    for (final item in likedItems) {
      try {
        likes.add(item['pet_id'] as String);
      } on dynamic catch (error, stackTrace) {
        logger.e(
            'DatabaseRepository readNewestPetsWithLikes()', error, stackTrace);
        return Future.error(error);
      }
    }
    final List<PetModel> result = [];
    for (final pet in pets) {
      final liked = likes.contains(pet.id);
      final petWhithLike = pet.copyWith(liked: liked);
      result.add(petWhithLike);
    }
    return result;
  }

  Future<List<VetModel>> readNearestVets() async {
    final List<VetModel> result = [];
    final options = QueryOptions(
      documentNode: _API.readNearestVets,
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final GraphQLClient client = _getClient();
    final queryResult = await client
        .query(options)
        .timeout(const Duration(milliseconds: kTimeoutMillisec));
    if (queryResult.hasException) {
      logger.e('DatabaseRepository readNearestVets() ${queryResult.exception}');
      throw queryResult.exception;
    }
    logger.i('DatabaseRepository readNearestVets() ${queryResult.data}');
    final dataItems =
        (queryResult.data['vets'] as List).cast<Map<String, dynamic>>();
    for (final item in dataItems) {
      try {
        result.add(VetModel.fromJson(item));
      } on dynamic catch (error, stackTrace) {
        logger.e('DatabaseRepository readNearestVets()', error, stackTrace);
        return Future.error(error);
      }
    }
    return result;
  }

  Future<bool> updatePetLike(PetModel pet) async {
    final String petId = pet.id;
    final String memberId = authRepository.currentUser.id;
    final bool isLike = !pet.liked;
    var result = true;

    final options = MutationOptions(
      documentNode: isLike ? _API.insertPetLike : _API.deletePetLike,
      variables: isLike
          ? {
              'pet_id': petId,
            }
          : {
              'member_id': memberId,
              'pet_id': petId,
            },
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final GraphQLClient client = _getClient();
    final mutationResult = await client
        .mutate(options)
        .timeout(const Duration(milliseconds: kTimeoutMillisec));
    if (mutationResult.hasException) {
      result = false;
      logger.e('DatabaseRepository updatePetLike'
          '("pet_id": $petId, "member_id": $memberId) '
          '${mutationResult.exception}');
      throw mutationResult.exception;
    }
    logger.i('DatabaseRepository updatePetLike'
        '("pet_id": $petId, "member_id": $memberId ${mutationResult.data}');
    return result;
  }

  Future<PetModel> createPet(PetModel newPet) async {
    final options = MutationOptions(
      documentNode: _API.createPet,
      variables: {
        'category_id': newPet.category.id,
        'breed_id': newPet.breed.id,
        'condition_id': newPet.condition.id,
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
    final GraphQLClient client = _getClient();
    final mutationResult = await client
        .mutate(options)
        .timeout(const Duration(milliseconds: kTimeoutMillisec));
    if (mutationResult.hasException) {
      logger.e('DatabaseRepository createPet'
          '("newPet": ${newPet.toJson()}) ${mutationResult.exception}');
      throw mutationResult.exception;
    }
    logger.i('DatabaseRepository createPet() ${mutationResult.data}');
    final dataItem =
        mutationResult.data['insert_pet_one'] as Map<String, dynamic>;
    PetModel result;
    try {
      result = PetModel.fromJson(dataItem);
    } on dynamic catch (error, stackTrace) {
      logger.e('DatabaseRepository createPet("${newPet.toJson()}")', error,
          stackTrace);
      return Future.error(error);
    }
    return result;
  }

  Future<UserModel> readUserProfile() async {
    final options = QueryOptions(
      documentNode: _API.readMember,
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final GraphQLClient client = _getClient();
    final queryResult = await client
        .query(options)
        .timeout(const Duration(milliseconds: kTimeoutMillisec));
    if (queryResult.hasException) {
      logger.e('DatabaseRepository readUserProfile() ${queryResult.exception}');
      throw queryResult.exception;
    }
    logger.i('DatabaseRepository readUserProfile() ${queryResult.data}');
    final dataItems = (queryResult.data['current_member'] as List)
        .cast<Map<String, dynamic>>();
    UserModel result;
    for (final item in dataItems) {
      try {
        result = UserModel.fromJson(item);
      } on dynamic catch (error, stackTrace) {
        logger.e('DatabaseRepository readUserProfile()', error, stackTrace);
        return Future.error(error);
      }
    }
    return result;
  }

  Future<SysParamModel> readSysParam(String label) async {
    assert(label != null && label.isNotEmpty);

    final options = QueryOptions(
      documentNode: _API.readSysParam,
      variables: {
        'label': label.toLowerCase(),
      },
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final GraphQLClient client = _getClient();
    final queryResult = await client
        .query(options)
        .timeout(const Duration(milliseconds: kTimeoutMillisec));
    if (queryResult.hasException) {
      logger.e('DatabaseRepository readSysParam() ${queryResult.exception}');
      throw queryResult.exception;
    }
    logger.i('DatabaseRepository readSysParam'
        '(label = "$label") ${queryResult.data}');
    final dataItem =
        queryResult.data['sys_param_by_pk'] as Map<String, dynamic>;
    SysParamModel result;
    try {
      result = SysParamModel.fromJson(dataItem);
    } on dynamic catch (error, stackTrace) {
      logger.e('DatabaseRepository readSysParam("$label")', error, stackTrace);
      return Future.error(error);
    }
    return result;
  }
}

class _API {
  static final readSysParam = gql(r'''
    query ReadSysParam($label: String!) {
      sys_param_by_pk(label: $label) {
        ...SysParamFields
      }
    }
  ''')..definitions.addAll(fragments.definitions);

  static final readMember = gql(r'''
    query ReadMember {
      current_member {
        ...UserFields
      }
    }
  ''')..definitions.addAll(fragments.definitions);

  static final upsertMember = gql(r'''
    mutation UpsertMember(
      $name: String,
      $photo: String,
      $email: String,
      $phone: String,
    ) {
      insert_member_one(object: {
        name: $name,
        photo: $photo,
        email: $email,
        phone: $phone
      },
      on_conflict: {
        constraint: member_pkey,
        update_columns: [name, photo, email, phone]
      }) {
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

  static final readBreeds = gql(r'''
    query ReadBreeds {
      breeds {
        ...BreedFields
      }
    }
  ''')..definitions.addAll(fragments.definitions);

  static final fragments = gql(r'''
    fragment SysParamFields on sys_param {
      label
      value
      value_txt
      note
    }
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
      is_active
    }

    fragment UserFields on current_member {
      # __typename
      id
      name
      photo
      email
      phone
      is_active
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
