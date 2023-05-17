import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn_firebase/utils/app_constant.dart';
import 'package:learn_firebase/utils/app_styles.dart';
import 'package:learn_firebase/views/auth/login_view.dart';
import 'package:learn_firebase/widgets/flush_bar.dart';
import 'package:learn_firebase/widgets/navigation_dialog.dart';
import 'package:learn_firebase/widgets/text_field_widget.dart';
import 'add_note.dart';

class DisplayData extends StatefulWidget {
  const DisplayData({super.key});

  @override
  State<DisplayData> createState() => _DisplayDataState();
}

class _DisplayDataState extends State<DisplayData> {
  final ref = FirebaseFirestore.instance.collection('Notes').snapshots();
  final collectionReference = FirebaseFirestore.instance.collection('Notes');
  final fileterdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'List Screen',
          style: kPoppinMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginView()));
                  });
                },
                child: const Icon(Icons.logout_outlined)),
          )
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPadding),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            TextFieldWidget(
              hintText: 'search',
              controller: fileterdController,
              onTextChanged: (String value) {
                setState(() {});
              },
            ),
            StreamBuilder<QuerySnapshot>(
                stream: ref,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Something went Wrong',
                        style: kPoppinMedium,
                      ),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (ctx, i) {
                          final title =
                              snapshot.data.docs[i]['title'].toString();
                          final id = snapshot.data.docs[i].id.toString();
                          if (fileterdController.text.isEmpty) {
                            return ListTile(
                              leading: CircleAvatar(child: Text('$i')),
                              title: Text(
                                snapshot.data.docs[i]['title'],
                                style: kPoppinRegular,
                              ),
                              subtitle: Text(
                                snapshot.data.docs[i]['description'],
                                style: kPoppinRegular,
                              ),
                              trailing: PopupMenuButton(
                                  icon: const Icon(Icons.more_vert),
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                        value: 'edit',
                                        onTap: () {},
                                        child: ListTile(
                                          title: const Text('Edit'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const AddNote()));
                                          },
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        enabled: true,
                                        onTap: () {},
                                        child: ListTile(
                                          title: const Text('Delete'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            showNavigationDialog(context,
                                                message:
                                                    'Do you really want to delete the item',
                                                buttonText: 'Delete',
                                                navigation: () {
                                              debugPrint(
                                                  snapshot.data.docs[i].id);
                                              collectionReference
                                                  .doc(snapshot
                                                      .data.docs[i]['id']
                                                      .toString())
                                                  .delete()
                                                  .then((value) {
                                                Navigator.pop(context);
                                                getFlushBar(context,
                                                    title:
                                                        'Item Deleted Successfully');
                                              });
                                            },
                                                secondButtonText: 'Cencel',
                                                showSecondButton: true);
                                          },
                                        ),
                                      ),
                                    ];
                                  }),
                            );
                          } else if (title.toLowerCase().contains(
                              fileterdController.text.toLowerCase())) {
                            return ListTile(
                              trailing: PopupMenuButton(itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    value: 'edit',
                                    onTap: () {},
                                    child: const Text('Edit'),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    onTap: () {
                                      showNavigationDialog(context,
                                          message:
                                              'Do you really want to delete the item',
                                          buttonText: 'Delete', navigation: () {
                                        debugPrint(snapshot.data.docs[i].id);
                                        collectionReference
                                            .doc(snapshot.data.docs[i]['id']
                                                .toString())
                                            .delete()
                                            .then((value) {
                                          Navigator.pop(context);
                                          getFlushBar(context,
                                              title:
                                                  'Item Deleted Successfully');
                                        });
                                      },
                                          secondButtonText: 'Cencel',
                                          showSecondButton: true);
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ];
                              }),
                              leading: CircleAvatar(child: Text('$i')),
                              title: Text(
                                snapshot.data.docs[i]['title'],
                                style: kPoppinRegular,
                              ),
                              subtitle: Text(
                                snapshot.data.docs[i]['description'],
                                style: kPoppinRegular,
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        });
                  }
                })
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddNote()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
