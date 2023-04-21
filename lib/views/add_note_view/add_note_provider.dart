import 'package:flutter/material.dart';

import '../../utils/app_color.dart';
import '../../utils/app_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/text_field_widget.dart';


class AddNoteWithProvider extends StatefulWidget {
  const AddNoteWithProvider({super.key});

  @override
  State<AddNoteWithProvider> createState() => _AddNoteWithProviderState();
}

class _AddNoteWithProviderState extends State<AddNoteWithProvider> {
  final _titleController = TextEditingController();

  final _descController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(body: SafeArea(child: Column(children: [],)),
    floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        backgroundColor: kPrimary,
        onPressed: () {
          _showNotesDialog();
        },
        child: const Icon(
          Icons.add,
          color: kWhite,
        ),
      ),
    );
  }

   _showNotesDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Message',
              style: kPoppinBold,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Title',
                    style: kPoppinMedium,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  TextFieldWidget(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Title is required';
                      }
                      return null;
                    },
                    hintText: 'Title',
                    controller: _titleController,
                    isDense: true,
                    hPadding: 10,
                    vPadding: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Description',
                    style: kPoppinMedium,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  TextFieldWidget(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Description is required';
                      }
                      return null;
                    },
                    hintText: 'Description',
                    controller: _descController,
                    isDense: true,
                    hPadding: 10,
                    vPadding: 10,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 40,
                    child: CustomButton(
                      title: 'Submit',
                      ontap: () {
                        if (_formKey.currentState!.validate()) {
                          _createNotes();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
  
   _createNotes() {}
}

