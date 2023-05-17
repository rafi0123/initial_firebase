import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:learn_firebase/utils/app_constant.dart';
import 'package:learn_firebase/utils/app_styles.dart';
import 'package:learn_firebase/widgets/custom_button.dart';
import 'package:learn_firebase/widgets/custom_loader.dart';
import 'package:learn_firebase/widgets/flush_bar.dart';
import 'package:learn_firebase/widgets/text_field_widget.dart';

class AddNote extends StatefulWidget {
  const AddNote({
    super.key,
   
  });

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
          'Add Notes',
            style: kPoppinMedium,
          )),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(kPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              Text(
                'Title',
                style: kPoppinRegular,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFieldWidget(
                hintText: 'title',
                controller: _titleController,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'description',
                style: kPoppinRegular,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFieldWidget(
                hintText: 'description',
                controller: _descController,
                isMultiline: true,
                keyBordType: TextInputType.multiline,
              ),
              const SizedBox(
                height: 30,
              ),
              CustomButton(
                title: 'Add Note',
                ontap: () {
                  SmartDialog.showLoading(
                    builder: (ctx) => const CustomLoading(
                      type: 2,
                    ),
                  );
                  addNotes();
                },
              )
            ],
          ),
        ),
      )),
    );
  }

  // void updateNotes() {
  //   FirebaseFirestore.instance.doc(widget.id.toString()).update({
  //     'title': widget.title.toString(),
  //     'description': widget.desc.toString()
  //   }).then((value) {
  //     getFlushBar(context, title: 'Updated Successfully');
  //   }).onError((error, stackTrace) {
  //     getFlushBar(context, title: 'Error $error');
  //   });
  // }

  void addNotes() {
    // var userID = FirebaseAuth.instance.currentUser!.uid;
    var id = DateTime.now().millisecondsSinceEpoch;
    FirebaseFirestore.instance.collection('Notes').doc(id.toString()).set({
      'title': _titleController.text.toString(),
      'description': _descController.text.toString(),
      'id': id
    }).then((value) {
      _titleController.clear();
      _descController.clear();
      SmartDialog.dismiss();
      getFlushBar(context, title: "Notes Added Successfully");
    }).onError((error, stackTrace) {
      getFlushBar(context, title: 'Error $error');
    });
  }
}
