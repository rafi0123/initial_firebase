import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:learn_firebase/utils/app_color.dart';
import 'package:learn_firebase/utils/app_constant.dart';
import 'package:learn_firebase/views/auth/login_view.dart';
import 'package:learn_firebase/widgets/custom_button.dart';
import 'package:learn_firebase/widgets/text_field_widget.dart';
import '../../utils/app_styles.dart';
import '../../widgets/custom_loader.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});
  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _notes = FirebaseFirestore.instance.collection('Posts').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('Posts');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Firebase App',
          style: kPoppinMedium,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: InkWell(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>const LoginView()));
                },
                child: const Icon(Icons.logout_outlined)),
          ),
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: _notes,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Something went wrong'),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return ListView.separated(
                          separatorBuilder: (ctx, i) => const SizedBox(
                                height: 10,
                              ),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, i) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: kWhite,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 4,
                                        spreadRadius: 0,
                                        offset: const Offset(0, 3),
                                        color: kBlack.withOpacity(0.3))
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data!.docs[i]['Title'],
                                        style: kPoppinMedium,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        snapshot.data!.docs[i]['Description'],
                                        style: kPoppinRegular.copyWith(
                                            color: kDefaultIconDarkColor),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () {},
                                            child: const Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Icon(
                                                Icons.edit,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              ref
                                                  .doc(snapshot.data!.docs[i]
                                                      ['docID'])
                                                  .delete()
                                                  .toString();
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Icon(
                                                Icons.delete,
                                                size: 20,
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ]),
                              ),
                            );
                          });
                    }
                  })
            ],
          ),
        ),
      )),
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

  _createNotes() async {
    SmartDialog.showLoading(
      builder: (ctx) => const CustomLoading(
        type: 2,
      ),
    );
    try {
      var docID = FirebaseFirestore.instance.collection('Posts').doc().id;
      await FirebaseFirestore.instance.collection('Posts').doc(docID).set({
        'Title': _titleController.text.toString(),
        'Description': _descController.text.toString(),
        'docID': docID,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'userID': FirebaseAuth.instance.currentUser!.uid,
      }).then((value) {
        Navigator.pop(context);
        _titleController.clear();
        _descController.clear();
        SmartDialog.dismiss();
      });
    } catch (e) {
      SmartDialog.dismiss();
      Navigator.pop(context);
      _titleController.clear();
      _descController.clear();

      e.toString();
    }
  }
}
