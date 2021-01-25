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
          profileCubit: BlocProvider.of<ProfileCubit>(context),
        );
        addPetCubit.init();
        return addPetCubit;
      },
      lazy: false,
      child: _AddPetView(),
    );
  }
}

class _AddPetView extends StatefulWidget {
  @override
  _AddPetViewState createState() => _AddPetViewState();
}

class _AddPetViewState extends State<_AddPetView> {
  AddPetStateData lastData = const AddPetStateData();
  bool isBusy;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddPetCubit, AddPetState>(
        builder: (context, addPetState) {
      isBusy = false;
      addPetState.maybeMap(
        ready: (readyState) {
          lastData = readyState.data;
        },
        busy: (_) {
          isBusy = true;
        },
        error: (errorState) {
          showErrorToast(errorState.error);
        },
        orElse: () => null,
      );
      return SafeArea(
        child: Scaffold(
          body: addPetState.maybeWhen(
            initial: () => _InitialBody(),
            inactive: () => _InactiveBody(),
            orElse: () => _ReadyBody(lastData),
          ),
        ),
      );
    });
  }
}

class _InitialBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class _InactiveBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}

class _ReadyBody extends StatelessWidget {
  _ReadyBody(this.data);

  final AddPetStateData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          elevation: 0.0,
          expandedHeight: screenHeight / 2,
          title: const Text(
            'Add Your Pet',
            // style: TextStyle(color: theme.primaryColor),
          ),
          centerTitle: true,
          flexibleSpace:
              (data.newPet.photos == null || data.newPet.photos.isEmpty)
                  ? Center(
                      child: _AddPhotoButton(data),
                    )
                  : CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: data.newPet.photos,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          Image.asset('${kAssetPath}placeholder_pet.png'),
                    ),
        ),
        SliverToBoxAdapter(
          child: Container(
            color: theme.backgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(kHorizontalPadding),
              child: _AddPetForm(data),
            ),
          ),
        ),
      ],
    );
  }
}

class _AddPhotoButton extends StatelessWidget {
  _AddPhotoButton(this.data);

  final AddPetStateData data;

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
        addPetCubit.updateNewPet(
          data.newPet.copyWith(photos: photoUrl),
        );
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
  _AddPetForm(this.data);

  final AddPetStateData data;

  @override
  _AddPetFormState createState() => _AddPetFormState();
}

class _AddPetFormState extends State<_AddPetForm> {
  final _formKey = GlobalKey<FormState>();
  final _breedFocusNode = FocusNode();
  final _conditionFocusNode = FocusNode();
  final _coloringFocusNode = FocusNode();
  AddPetCubit addPetCubit;
  AddPetStateData data;

  @override
  void initState() {
    super.initState();
    addPetCubit = BlocProvider.of<AddPetCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    final PetModel newPet = widget.data.newPet;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<CategoryModel>(
            decoration: const InputDecoration(
              labelText: 'Category',
              helperText: '',
            ),
            value: newPet.category,
            items: _getDropdownItemsFromList(widget.data.categories),
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
            //newPet.breed?.name == null ? null : newPet.breed,
            value: newPet.breed,
            items: _getDropdownItemsFromList(widget.data.breedsByCategory),
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
            value: newPet.condition,
            items: _getDropdownItemsFromList(widget.data.conditions),
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
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Input pet coloring' : null,
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
              addPetCubit
                  .updateNewPet(newPet.copyWith(distance: double.parse(value)));
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
                    navigator.pop(newPet);
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
