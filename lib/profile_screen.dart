import 'dart:convert';
import 'dart:developer';
import 'dart:core';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctoc/api/api.dart';
import 'package:ctoc/loginscreen.dart';
import 'package:ctoc/main.dart';
import 'package:ctoc/model/chat_user.dart';
import 'package:ctoc/widgets/chat_user_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'helper/dialogs.dart';

class profilescreen extends StatefulWidget {
  final ChatUser user;
  const profilescreen({super.key, required this.user});

  @override
  State<profilescreen> createState() => _profilescreenState();
}

class _profilescreenState extends State<profilescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile Screen"),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.red,
            onPressed: () async {
              //for showing progress dialog
              Dialogs.ShowProgressbar(context);

              //await APIs.updateActiveStatus(false);

              //sign out from app
              await Api.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
                  //for hiding progress dialog
                  Navigator.pop(context);

                  //for moving to home screen
                  Navigator.pop(context);

                  Api.auth = FirebaseAuth.instance;

                  //replacing home screen with login screen
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => loginscreen()));
                });
              });
            },
            icon: Icon(Icons.logout),
            label: const Text("Logout"),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.height * .05),
          child: Column(
            children: [
              SizedBox(
                width: mq.width,
                height: mq.width * .03,
              ),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .1),
                    child: CachedNetworkImage(
                      width: mq.height * .2,
                      height: mq.height * .2,
                      fit: BoxFit.fill,
                      imageUrl: widget.user.image,
                      // placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: MaterialButton(
                        elevation: 1,
                        shape: CircleBorder(),
                        color: Colors.white,
                        onPressed: () {},
                        child: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                        )),
                  )
                ],
              ),
              SizedBox(
                height: mq.width * .03,
              ),
              Text(
                widget.user.email,
                style: const TextStyle(color: Colors.black54, fontSize: 16),
              ),
              SizedBox(height: mq.height * .05),

              // name input field
              TextFormField(
                initialValue: widget.user.name,
                // onSaved: (val) => APIs.me.name = val ?? '',
                // validator: (val) =>
                //     val != null && val.isNotEmpty ? null : 'Required Field',
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person, color: Colors.blue),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    hintText: 'eg. Happy Singh',
                    label: const Text('Name')),
              ),

              // for adding some space
              SizedBox(height: mq.height * .02),

              // about input field
              TextFormField(
                initialValue: widget.user.about,
                // onSaved: (val) => APIs.me.about = val ?? '',
                // validator: (val) =>
                //     val != null && val.isNotEmpty ? null : 'Required Field',
                decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.info_outline, color: Colors.blue),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    hintText: 'eg. Feeling Happy',
                    label: const Text('About')),
              ),

              // for adding some space
              SizedBox(height: mq.height * .05),

              // update profile button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    minimumSize: Size(mq.width * .5, mq.height * .06)),
                onPressed: () {
                  // if (_formKey.currentState!.validate()) {
                  //   _formKey.currentState!.save();
                  //   APIs.updateUserInfo().then((value) {
                  //     Dialogs.showSnackbar(
                  //         context, 'Profile Updated Successfully!');
                  //   });
                  // }
                },
                icon: const Icon(Icons.edit, size: 28),
                label: const Text('UPDATE', style: TextStyle(fontSize: 16)),
              )
            ],
          ),
        ));
  }
}
