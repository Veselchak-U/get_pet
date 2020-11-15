import 'package:cats/import.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPetScreen extends StatelessWidget {
  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/add_pet',
      builder: (_) => this,
      fullscreenDialog: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AddPetCubit(
        repo: RepositoryProvider.of<DatabaseRepository>(context),
      )..loadReferenceBooks(),
      lazy: false,
      child: _AddPetBody(),
    );
  }
}

class _AddPetBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocBuilder<AddPetCubit, AddPetState>(
      builder: (BuildContext context, AddPetState state) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                elevation: 0.0,
                expandedHeight: screenHeight / 2,
                title: Text(
                  'Add Your Pet',
                  style: TextStyle(color: theme.primaryColor),
                ),
                centerTitle: true,
                flexibleSpace:
                    (state.newPet.photos == null || state.newPet.photos.isEmpty)
                        ? Center(
                            child: _AddPhotoButton(),
                          )
                        : FadeInImage.assetNetwork(
                            image: state.newPet.photos,
                            fit: BoxFit.cover,
                            placeholder: '${kAssetPath}placeholder_pet.png',
                            imageErrorBuilder: (context, object, stack) =>
                                Image.asset('${kAssetPath}placeholder_pet.png'),
                          ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: theme.backgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(kHorizontalPadding),
                    child: _AddPetForm(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AddPhotoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AddPetCubit cubit = BlocProvider.of<AddPetCubit>(context);
    return ElevatedButton(
      onPressed: () {
        // изменяем URL фото "извне" формы
        cubit.setExternalUpdate(true);
        cubit.updateNewPet(cubit.state.newPet.copyWith(
            photos:
                'https://cdn.pixabay.com/photo/2014/11/30/14/11/cat-551554_960_720.jpg'));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_a_photo),
            SizedBox(width: 16),
            Text('Add Photo'),
          ],
        ),
      ),
    );
  }
}

class _AddPetForm extends StatefulWidget {
  @override
  _AddPetFormState createState() => _AddPetFormState();
}

class _AddPetFormState extends State<_AddPetForm> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  AddPetCubit cubit;

  @override
  void initState() {
    cubit = BlocProvider.of<AddPetCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('_AddPetFormState build()');
    PetModel newPet = cubit.state.newPet;
    print('newPet.category.name = ${newPet?.category?.name}');
    // при изменении URL фото "извне" обновляем содержимое соответствующего поля
    return BlocListener<AddPetCubit, AddPetState>(
      listenWhen: (AddPetState previous, AddPetState current) =>
          (current.externalUpdate &&
              previous.newPet.photos != current.newPet.photos),
      listener: (BuildContext context, AddPetState state) {
        print('BlocListener newPet.photos changed');
        cubit.setExternalUpdate(false);
        _controller.text = state.newPet.photos ?? '';
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Photo url',
                helperText: '',
              ),
              controller: _controller,
              // initialValue: cubit.state.newPet.photos,
              // onChanged: (value) {
              //   cubit.updateNewPet(newPet.copyWith(photos: value));
              // },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                var result = 'Unknown error';
                if (value.isEmpty) {
                  result = 'Input pet photo url';
                } else if (Uri.parse(value).isAbsolute) {
                  cubit.updateNewPet(newPet.copyWith(photos: value));
                  result = null;
                } else {
                  result = 'Input correct url';
                }
                return result;
              },
            ),
            DropdownButtonFormField<CategoryModel>(
              decoration: InputDecoration(
                labelText: 'Category',
                helperText: '',
              ),
              value: cubit.state.newPet.category,
              items: _getDropdownItemsFromList(cubit.state.categories),
              onChanged: (CategoryModel value) {
                cubit.updateNewPet(newPet.copyWith(category: value));
                cubit.updateBreedsByCategory(value);
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null) {
                  return 'Select pet category';
                }
                return null;
              },
            ),
            DropdownButtonFormField<BreedModel>(
              decoration: InputDecoration(
                labelText: 'Breed',
                helperText: '',
              ),
              value: cubit.state.newPet.breed,
              items: _getDropdownItemsFromList(cubit.state.breedsByCategory),
              onChanged: (BreedModel value) {
                cubit.updateNewPet(newPet.copyWith(breed: value));
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null) {
                  return 'Select pet breed';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Breed',
                helperText: '',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Select pet breed';
                }
                // newPet = newPet.copyWith(breed: value);
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Condition',
                helperText: '',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Select pet condition';
                }
                // newPet = newPet.copyWith(condition: value);
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Coloring',
                helperText: '',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Input pet coloring';
                }
                newPet = newPet.copyWith(coloring: value);
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Age',
                helperText: '',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Input pet age';
                }
                newPet = newPet.copyWith(age: value);
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Weight',
                helperText: '',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Input pet weight';
                }
                // newPet = newPet.copyWith(weight: value);
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Address',
                helperText: '',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Input pet address';
                }
                newPet = newPet.copyWith(address: value);
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Distance',
                helperText: '',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Input distance to pet';
                }
                // newPet = newPet.copyWith(distance: value);
                return null;
              },
            ),
            TextFormField(
              minLines: 1,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Pet story',
                helperText: '',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Input pet story';
                }
                newPet = newPet.copyWith(description: value);
                return null;
              },
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    print('Form OK');
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kHorizontalPadding),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon(Icons.pets),
                      // SizedBox(width: 16),
                      Text('Add Pet'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // List<DropdownMenuItem<CategoryModel>> _getCategoryItems() {
  //   var models = cubit.state.petCategories;
  //   return List.generate(
  //       models.length,
  //       (index) => DropdownMenuItem<CategoryModel>(
  //             value: models[index],
  //             child: Text('${models[index].name}'),
  //           ));
  // }

  List<DropdownMenuItem<T>> _getDropdownItemsFromList<T>(List<T> list) {
    return List.generate(
        list.length,
        (index) => DropdownMenuItem<T>(
              value: list[index],
              child: Text('${list[index].toString()}'),
            ));
  }
}
