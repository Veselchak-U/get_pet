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
                  // style: TextStyle(color: theme.primaryColor),
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
  final _breedFocusNode = FocusNode();
  final _conditionFocusNode = FocusNode();
  final _coloringFocusNode = FocusNode();
  AddPetCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<AddPetCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    PetModel newPet = cubit.state.newPet;
    // при изменении URL фото "извне" обновляем содержимое соответствующего поля
    return BlocListener<AddPetCubit, AddPetState>(
      listenWhen: (AddPetState previous, AddPetState current) =>
          (current.externalUpdate &&
              previous.newPet.photos != current.newPet.photos),
      listener: (BuildContext context, AddPetState state) {
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
              // initialValue: 'Photo url',
              textInputAction: TextInputAction.next,
              controller: _controller,
              onChanged: (value) {
                cubit.updateNewPet(newPet.copyWith(photos: value));
              },
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
                cubit.setCategory(value);
                _breedFocusNode.requestFocus();
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>
                  (value == null) ? 'Select pet category' : null,
            ),
            DropdownButtonFormField<BreedModel>(
              decoration: InputDecoration(
                labelText: 'Breed',
                helperText: '',
              ),
              focusNode: _breedFocusNode,
              value: (cubit.state.newPet.breed?.name == null
                  ? null
                  : cubit.state.newPet.breed),
              items: _getDropdownItemsFromList(cubit.state.breeds),
              onChanged: (BreedModel value) {
                cubit.updateNewPet(newPet.copyWith(breed: value));
                _conditionFocusNode.requestFocus();
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => (value == null) ? 'Select pet breed' : null,
            ),
            DropdownButtonFormField<ConditionModel>(
              decoration: InputDecoration(
                labelText: 'Condition',
                helperText: '',
              ),
              focusNode: _conditionFocusNode,
              value: cubit.state.newPet.condition,
              items: _getDropdownItemsFromList(cubit.state.conditions),
              onChanged: (ConditionModel value) {
                cubit.updateNewPet(newPet.copyWith(condition: value));
                _coloringFocusNode.requestFocus();
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>
                  (value == null) ? 'Select pet condition' : null,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Coloring',
                helperText: '',
              ),
              initialValue: 'Gray',
              focusNode: _coloringFocusNode,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) {
                cubit.updateNewPet(newPet.copyWith(coloring: value));
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => (value == null || value.isEmpty)
                  ? 'Input pet coloring'
                  : null,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Age',
                helperText: '',
              ),
              initialValue: '4 months',
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) {
                cubit.updateNewPet(newPet.copyWith(age: value));
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Input pet age' : null,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Weight',
                helperText: '',
              ),
              initialValue: '2.2',
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              onFieldSubmitted: (value) {
                cubit
                    .updateNewPet(newPet.copyWith(weight: double.parse(value)));
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Input pet weight' : null,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Address',
                helperText: '',
              ),
              initialValue: 'Address',
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) {
                cubit.updateNewPet(newPet.copyWith(address: value));
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Input pet address' : null,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Distance',
                helperText: '',
              ),
              initialValue: '1.1',
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              onFieldSubmitted: (value) {
                cubit.updateNewPet(
                    newPet.copyWith(distance: double.parse(value)));
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => (value == null || value.isEmpty)
                  ? 'Input distance to pet'
                  : null,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Pet story',
                helperText: '',
              ),
              initialValue: 'Pet story',
              minLines: 1,
              maxLines: 5,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.multiline,
              onFieldSubmitted: (value) {
                cubit.updateNewPet(newPet.copyWith(description: value));
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Input pet story' : null,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    print('Form OK');
                    cubit.addPet();
                    navigator.pop();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kHorizontalPadding),
                  child: Text('Add Pet'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<T>> _getDropdownItemsFromList<T>(List<T> list) {
    if (list == null || list.isEmpty) {
      return null;
    }
    return List.generate(
        list.length,
        (index) => DropdownMenuItem<T>(
              value: list[index],
              child: Text('${list[index].toString()}'),
            ));
  }
}
