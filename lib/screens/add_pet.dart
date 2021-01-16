import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_pet/import.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddPetScreen extends StatelessWidget {
  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/add_pet',
      builder: (_) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final addPetCubit = AddPetCubit(
          repo: RepositoryProvider.of<DatabaseRepository>(context),
        );
        addPetCubit.init();
        return addPetCubit;
      },
      lazy: false,
      child: _AddPetBody(),
    );
  }
}

class _AddPetBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final isActiveUser =
        BlocProvider.of<ProfileCubit>(context).state.user.isActive;
    return BlocBuilder<AddPetCubit, AddPetState>(
      builder: (context, addPetState) {
        if (!isActiveUser) {
          return SafeArea(
            child: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Unfortunately, your account is restricted.'),
                    const Text("You can't create a new pet."),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => navigator.pop(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.pets),
                            SizedBox(width: 8),
                            Text('Back'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Stack(
          children: [
            SafeArea(
              child: Scaffold(
                body: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      elevation: 0.0,
                      expandedHeight: screenHeight / 2,
                      title: const Text(
                        'Add Your Pet',
                        // style: TextStyle(color: theme.primaryColor),
                      ),
                      centerTitle: true,
                      flexibleSpace: (addPetState.newPet.photos == null ||
                              addPetState.newPet.photos.isEmpty)
                          ? Center(
                              child: _AddPhotoButton(),
                            )
                          : CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: addPetState.newPet.photos,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                  '${kAssetPath}placeholder_pet.png'),
                            ),
                      // FadeInImage.assetNetwork(
                      //     image: addPetState.newPet.photos,
                      //     fit: BoxFit.cover,
                      //     placeholder: '${kAssetPath}placeholder_pet.png',
                      //     imageErrorBuilder: (context, object, stack) =>
                      //         Image.asset(
                      //             '${kAssetPath}placeholder_pet.png'),
                      //   ),
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
              ),
            ),
            if (addPetState.status == AddPetStatus.busy)
              const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        );
      },
    );
  }
}

class _AddPhotoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final AddPetCubit addPetCubit = BlocProvider.of<AddPetCubit>(context);
        final ProfileCubit profileCubit =
            BlocProvider.of<ProfileCubit>(context);
        ImagePicker imagePicker;
        PickedFile pickedFile;
        String photoUrl;
        try {
          imagePicker = ImagePicker();
          pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
        } on dynamic catch (error, stackTrace) {
          addPetCubit.saveError(error, stackTrace);
        }
        if (pickedFile != null) {
          // out(pickedFile.path);
          final FirebaseStorage storage = FirebaseStorage.instance;
          final File file = File(pickedFile.path);
          final String fileDir = profileCubit.state.user.id;
          final String fileName = pickedFile.path.split('/').last;
          // out(fileName);
          final Reference reference = storage.ref('$fileDir/$fileName');
          try {
            await reference.putFile(file);
            photoUrl = await reference.getDownloadURL();
            // out(await reference.getDownloadURL());
          } on dynamic catch (error, stackTrace) {
            addPetCubit.saveError(error, stackTrace);
          }
        }
        // изменяем URL фото "извне" формы
        addPetCubit.setExternalUpdateFlag(value: true);
        addPetCubit.updateNewPet(
          addPetCubit.state.newPet.copyWith(photos: photoUrl),
        );
        // 'https://cdn.pixabay.com/photo/2014/11/30/14/11/cat-551554_960_720.jpg'
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
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
  AddPetCubit addPetCubit;

  @override
  void initState() {
    super.initState();
    addPetCubit = BlocProvider.of<AddPetCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    final PetModel newPet = addPetCubit.state.newPet;
    // при изменении URL фото "извне" обновляем содержимое соответствующего поля
    return BlocListener<AddPetCubit, AddPetState>(
      listenWhen: (previous, current) =>
          current.externalUpdate &&
          previous.newPet.photos != current.newPet.photos,
      listener: (context, state) {
        addPetCubit.setExternalUpdateFlag(value: false);
        _controller.text = state.newPet.photos ?? '';
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Photo url',
                helperText: '',
              ),
              // initialValue: 'Photo url',
              textInputAction: TextInputAction.next,
              controller: _controller,
              readOnly: true,
              // enabled: false,
              // onChanged: (value) {
              //   addPetCubit.updateNewPet(newPet.copyWith(photos: value));
              // },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                String result;
                if (value.isEmpty) {
                  result = 'Select photo';
                }
                // else if (Uri.parse(value).isAbsolute) {
                //   addPetCubit.updateNewPet(newPet.copyWith(photos: value));
                //   result = null;
                // } else {
                //   result = 'Input correct url';
                // }
                return result;
              },
            ),
            DropdownButtonFormField<CategoryModel>(
              decoration: const InputDecoration(
                labelText: 'Category',
                helperText: '',
              ),
              value: addPetCubit.state.newPet.category,
              items: _getDropdownItemsFromList(addPetCubit.state.categories),
              onChanged: (category) {
                addPetCubit.setCategory(category);
                _breedFocusNode.requestFocus();
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>
                  (value == null) ? 'Select pet category' : null,
            ),
            DropdownButtonFormField<BreedModel>(
              decoration: const InputDecoration(
                labelText: 'Breed',
                helperText: '',
              ),
              focusNode: _breedFocusNode,
              value: addPetCubit.state.newPet.breed?.name == null
                  ? null
                  : addPetCubit.state.newPet.breed,
              items:
                  _getDropdownItemsFromList(addPetCubit.state.breedsByCategory),
              onChanged: (breed) {
                addPetCubit.updateNewPet(newPet.copyWith(breed: breed));
                _conditionFocusNode.requestFocus();
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => (value == null) ? 'Select pet breed' : null,
            ),
            DropdownButtonFormField<ConditionModel>(
              decoration: const InputDecoration(
                labelText: 'Condition',
                helperText: '',
              ),
              focusNode: _conditionFocusNode,
              value: addPetCubit.state.newPet.condition,
              items: _getDropdownItemsFromList(addPetCubit.state.conditions),
              onChanged: (condition) {
                addPetCubit.updateNewPet(newPet.copyWith(condition: condition));
                _coloringFocusNode.requestFocus();
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>
                  (value == null) ? 'Select pet condition' : null,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Coloring',
                helperText: '',
              ),
              initialValue: 'Gray',
              focusNode: _coloringFocusNode,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) {
                addPetCubit.updateNewPet(newPet.copyWith(coloring: value));
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => (value == null || value.isEmpty)
                  ? 'Input pet coloring'
                  : null,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Age',
                helperText: '',
              ),
              initialValue: '4 months',
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) {
                addPetCubit.updateNewPet(newPet.copyWith(age: value));
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Input pet age' : null,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Weight',
                helperText: '',
              ),
              initialValue: '2.2',
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              onFieldSubmitted: (value) {
                addPetCubit
                    .updateNewPet(newPet.copyWith(weight: double.parse(value)));
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Input pet weight' : null,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Address',
                helperText: '',
              ),
              initialValue: 'Address',
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) {
                addPetCubit.updateNewPet(newPet.copyWith(address: value));
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Input pet address' : null,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Distance',
                helperText: '',
              ),
              initialValue: '1.1',
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              onFieldSubmitted: (value) {
                addPetCubit.updateNewPet(
                    newPet.copyWith(distance: double.parse(value)));
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => (value == null || value.isEmpty)
                  ? 'Input distance to pet'
                  : null,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Pet story',
                helperText: '',
              ),
              initialValue: 'Pet story',
              minLines: 1,
              maxLines: 5,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.multiline,
              onFieldSubmitted: (value) {
                addPetCubit.updateNewPet(newPet.copyWith(description: value));
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Input pet story' : null,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    out('Form OK');
                    final result = await addPetCubit.addPet();
                    if (result) {
                      navigator.pop(addPetCubit.state.newPet);
                    }
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
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
              child: Text(list[index].toString()),
            ));
  }
}
