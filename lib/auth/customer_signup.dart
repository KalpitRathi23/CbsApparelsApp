// import 'package:cbs_apparels/auth/customer_signup.dart';
// ignore_for_file: avoid_print

import 'package:cbs_apparels/providers/auth_repo.dart';
import 'package:cbs_apparels/widgets/auth_widgets.dart';
import 'package:cbs_apparels/widgets/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CustomerRegister extends StatefulWidget {
  const CustomerRegister({Key? key}) : super(key: key);

  @override
  State<CustomerRegister> createState() => _CustomerRegisterState();
}

class _CustomerRegisterState extends State<CustomerRegister> {
  late String name;
  late String email;
  late String password;
  late String profileImage;
  late String _uid;
  bool processing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool passwordVisible = false;

  final ImagePicker _picker = ImagePicker();

  XFile? _imageFile;
  dynamic _pickedImageError;

  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  void _pickImageFromCamera() async {
    try {
      final pickedImage = await _picker.pickImage(
          source: ImageSource.camera,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  void _pickImageFromGallery() async {
    try {
      final pickedImage = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  void signUp() async {
    setState(() {
      processing = true;
    });
    if (_formKey.currentState!.validate()) {
      if (_imageFile != null) {
        try {
          await AuthRepo.signUpWithEmailAndPassword(email, password);
          await AuthRepo.sendEmailVerification();

          firebase_storage.Reference ref = firebase_storage
              .FirebaseStorage.instance
              .ref('cust-images/$email.jpg');

          await ref.putFile(File(_imageFile!.path));
          _uid = AuthRepo.uid;

          profileImage = await ref.getDownloadURL();
          AuthRepo.updateUserName(name);
          AuthRepo.updateProfileImage(profileImage);
          await customers.doc(_uid).set({
            'name': name,
            'email': email,
            'profileimage': profileImage,
            'phone': '',
            'address': '',
            'cid': _uid
          });
          _formKey.currentState!.reset();
          setState(() {
            _imageFile = null;
          });
          await Future.delayed(const Duration(microseconds: 100)).whenComplete(
              () => Navigator.pushReplacementNamed(context, '/customer_login'));
        } on FirebaseAuthException catch (e) {
          setState(() {
            processing = false;
          });
          MyMessageHandler.showSnackBar(_scaffoldKey, e.message.toString());
        }
      } else {
        setState(() {
          processing = false;
        });
        MyMessageHandler.showSnackBar(_scaffoldKey, 'please pick image first');
      }
    } else {
      setState(() {
        processing = false;
      });
      MyMessageHandler.showSnackBar(_scaffoldKey, 'please fill all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const AuthHeaderLabel(headerLabel: 'Sign Up'),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 40),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.purpleAccent,
                              backgroundImage: _imageFile == null
                                  ? null
                                  : FileImage(File(_imageFile!.path)),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    color: Colors.purple,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15))),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    _pickImageFromCamera();
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                    color: Colors.purple,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15))),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.photo,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    _pickImageFromGallery();
                                  },
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your full name';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            name = value;
                          },
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Full Name',
                            hintText: 'Enter your Full Name',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your email ';
                            } else if (value.isValidEmail() == false) {
                              return 'invalid email';
                            } else if (value.isValidEmail() == true) {
                              return null;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            email = value;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Email Address',
                            hintText: 'Enter your email',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your password';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            password = value;
                          },
                          obscureText: passwordVisible,
                          decoration: textFormDecoration.copyWith(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                                icon: Icon(
                                  passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.purple,
                                )),
                            labelText: 'Password',
                            hintText: 'Enter your password',
                          ),
                        ),
                      ),
                      HaveAccount(
                        haveAccount: 'already have account? ',
                        actionLabel: 'Log In',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/customer_login');
                        },
                      ),
                      processing == true
                          ? const CircularProgressIndicator(
                              color: Colors.purple,
                            )
                          : AuthMainButton(
                              mainButtonLabel: 'Sign Up',
                              onPressed: () {
                                signUp();
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// class CustomerRegister extends StatefulWidget {
//   const CustomerRegister({Key? key}) : super(key: key);
//
//   @override
//   State<CustomerRegister> createState() => _CustomerRegisterState();
// }
//
// class _CustomerRegisterState extends State<CustomerRegister> {
//   XFile? _imageFile;
//   dynamic _pickedImageError;
//   final ImagePicker _picker = ImagePicker();
//   CollectionReference customers =
//       FirebaseFirestore.instance.collection('customers');
//
//   void _pickImageFromCamera() async {
//     try {
//       final pickedImage = await _picker.pickImage(
//           source: ImageSource.camera,
//           maxHeight: 300,
//           maxWidth: 300,
//           imageQuality: 95);
//       setState(() {
//         _imageFile = pickedImage;
//       });
//     } catch (e) {
//       setState(() {
//         _pickedImageError = e;
//       });
//       print(_pickedImageError);
//     }
//   }
//
//   void _pickImageFromGallery() async {
//     try {
//       final pickedImage = await _picker.pickImage(
//           source: ImageSource.gallery,
//           maxHeight: 300,
//           maxWidth: 300,
//           imageQuality: 95);
//       setState(() {
//         _imageFile = pickedImage;
//       });
//     } catch (e) {
//       setState(() {
//         _pickedImageError = e;
//       });
//       print(_pickedImageError);
//     }
//   }
//
//   late String name;
//   late String email;
//   late String password;
//   late String profileImage;
//   late String _uid;
//   bool processing = false;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
//       GlobalKey<ScaffoldMessengerState>();
//   bool passwordVisible = true;
//
//   void signUp() async {
//     setState(() {
//       processing = true;
//     });
//     if (_formKey.currentState!.validate()) {
//       if (_imageFile != null) {
//         try {
//           await FirebaseAuth.instance
//               .createUserWithEmailAndPassword(email: email, password: password);
//
//           firebase_storage.Reference ref = firebase_storage
//               .FirebaseStorage.instance
//               .ref('cust-images/$email.jpg');
//
//           await ref.putFile(File(_imageFile!.path));
//           _uid = FirebaseAuth.instance.currentUser!.uid;
//
//           profileImage = await ref.getDownloadURL();
//           AuthRepo.updateUserName(name);
//           AuthRepo.updateProfileImage(profileImage);
//           await customers.doc(_uid).set({
//             'name': name,
//             'email': email,
//             'profileimage': profileImage,
//             'phone': '',
//             'address': '',
//             'cid': _uid
//           });
//           _formKey.currentState!.reset();
//           setState(() {
//             _imageFile = null;
//           });
//           await Future.delayed(const Duration(microseconds: 100)).whenComplete(
//               () => Navigator.pushReplacementNamed(context, '/customer_login'));
//         } on FirebaseAuthException catch (e) {
//           if (e.code == 'weak-password') {
//             setState(() {
//               processing = false;
//             });
//             MyMessageHandler.showSnackBar(
//                 _scaffoldKey, 'Password length should be greater than 5 ');
//           } else if (e.code == 'email-already-in-use') {
//             setState(() {
//               processing = false;
//             });
//             MyMessageHandler.showSnackBar(
//                 _scaffoldKey, 'The account already exists for that email.');
//           }
//         }
//       } else {
//         setState(() {
//           processing = false;
//         });
//         MyMessageHandler.showSnackBar(_scaffoldKey, 'Please pick image first');
//       }
//     } else {
//       setState(() {
//         processing = false;
//       });
//       MyMessageHandler.showSnackBar(_scaffoldKey, 'Please fill all fields');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ScaffoldMessenger(
//       key: _scaffoldKey,
//       child: Scaffold(
//         body: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//               reverse: true,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       const AuthHeaderLabel(
//                         headerLabel: 'Sign Up',
//                       ),
//                       Row(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 20, horizontal: 40),
//                             child: CircleAvatar(
//                               radius: 60,
//                               backgroundColor: Colors.purpleAccent,
//                               backgroundImage: _imageFile == null
//                                   ? null
//                                   : FileImage(File(_imageFile!.path)),
//                             ),
//                           ),
//                           Column(
//                             children: [
//                               Container(
//                                 decoration: const BoxDecoration(
//                                     color: Colors.purple,
//                                     borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(15),
//                                         topRight: Radius.circular(15))),
//                                 child: IconButton(
//                                     onPressed: () {
//                                       _pickImageFromCamera();
//                                     },
//                                     icon: const Icon(
//                                       Icons.camera_alt,
//                                       color: Colors.white,
//                                     )),
//                               ),
//                               const SizedBox(
//                                 height: 6,
//                               ),
//                               Container(
//                                 decoration: const BoxDecoration(
//                                     color: Colors.purple,
//                                     borderRadius: BorderRadius.only(
//                                         bottomLeft: Radius.circular(15),
//                                         bottomRight: Radius.circular(15))),
//                                 child: IconButton(
//                                     onPressed: () {
//                                       _pickImageFromGallery();
//                                     },
//                                     icon: const Icon(
//                                       Icons.photo,
//                                       color: Colors.white,
//                                     )),
//                               )
//                             ],
//                           )
//                         ],
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 10),
//                         child: TextFormField(
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'please enter your full name';
//                             } else {
//                               return null;
//                             }
//                           },
//                           onChanged: (value) {
//                             name = value;
//                           },
//                           // controller: _nameController,
//                           decoration: textFormDecoration.copyWith(
//                               labelText: 'Full Name',
//                               hintText: 'Enter your Full Name'),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 10),
//                         child: TextFormField(
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'please enter your email';
//                             } else if (value.isValidEmail() == false) {
//                               return 'invalid email';
//                             } else if (value.isValidEmail() == true) {
//                               return null;
//                             } else {
//                               return null;
//                             }
//                           },
//                           onChanged: (value) {
//                             email = value;
//                           },
//                           // controller: _emailController,
//                           keyboardType: TextInputType.emailAddress,
//                           decoration: textFormDecoration.copyWith(
//                               labelText: 'Email Address',
//                               hintText: 'Enter your email'),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 10),
//                         child: TextFormField(
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'please enter your password';
//                             } else {
//                               return null;
//                             }
//                           },
//                           onChanged: (value) {
//                             password = value;
//                           },
//                           // controller: _passwordController,
//                           obscureText: passwordVisible,
//                           decoration: textFormDecoration.copyWith(
//                               suffixIcon: IconButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       passwordVisible = !passwordVisible;
//                                     });
//                                   },
//                                   icon: Icon(
//                                     passwordVisible
//                                         ? Icons.visibility_off
//                                         : Icons.visibility,
//                                     color: Colors.purple,
//                                   )),
//                               labelText: 'Password',
//                               hintText: 'Enter your Password'),
//                         ),
//                       ),
//                       HaveAccount(
//                         haveAccount: 'already have account? ',
//                         actionLabel: 'Log In',
//                         onPressed: () {
//                           Navigator.pushReplacementNamed(
//                               context, '/customer_login');
//                         },
//                       ),
//                       processing == true
//                           ? const CircularProgressIndicator(
//                               color: Colors.purple,
//                             )
//                           : AuthMainButton(
//                               mainButtonLabel: 'Sign Up',
//                               onPressed: () {
//                                 signUp();
//                               },
//                             )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
