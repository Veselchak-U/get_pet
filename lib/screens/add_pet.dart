import 'package:cats/import.dart';
import 'package:flutter/material.dart';

class AddPetScreen extends StatelessWidget {
  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/add_pet',
      builder: (_) => this,
      fullscreenDialog: false,
    );
  }

  // AddPetCubit cubit;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0.0,
            expandedHeight: screenHeight / 2,
            flexibleSpace: Center(
              child: _AddPhotoButton(),
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
  }
}

class _AddPhotoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // cubit.onTapPetLike(petId: item.id);
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Category',
              helperText: '',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Select pet category';
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
                padding:
                    const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
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
    );
  }
}
