import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart'as fStorage;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:users_app/global/global.dart';

import 'package:users_app/splashScreen/my_splash_screen.dart';
import 'package:users_app/widgets/loading_dialog.dart';
import '../widgets/custom_text_field.dart';


class RegistrationTabPage extends StatefulWidget
{
  const RegistrationTabPage({super.key});


  @override
  State<RegistrationTabPage> createState() => _RegistrationTabPageState();
}

class _RegistrationTabPageState extends State<RegistrationTabPage> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmPasswordTextEditingController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String downloadUrlImage="";

  XFile? imgXFile;
  final ImagePicker imagePicker = ImagePicker();

  getImageFromGallery() async{
    imgXFile=await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      imgXFile;
    });

  }
  formValidation() async
  {
    if(imgXFile == null) //image is not selected
        {
      Fluttertoast.showToast(msg: "Please select an image.");
    }
    else //image is already selected
        {
      //password is equal to confirm password
      if(passwordTextEditingController.text == confirmPasswordTextEditingController.text)
      {
        //check email, pass, confirm password & name text fields
        if(nameTextEditingController.text.isNotEmpty
            && emailTextEditingController.text.isNotEmpty
            && passwordTextEditingController.text.isNotEmpty
            && confirmPasswordTextEditingController.text.isNotEmpty)
        {
          showDialog(
              context: context,
              builder: (c){
                return LoadingDialogWidget(
                  message: "Registering Your Account ",

                );
              }
          );
          //1.upload image to storage
          String fileName = DateTime.now().microsecondsSinceEpoch.toString();
          String extension = imgXFile!.path.split('.').last; // Extract the file extension
          String storageFileName = '$fileName.$extension'; // Append the extension to the filename
          fStorage.Reference storageRef =fStorage.FirebaseStorage.instance
              .ref()
              .child("usersImages").child(fileName)
              .child(storageFileName);

          fStorage.UploadTask uploadImageTask= storageRef.putFile(File(imgXFile!.path));

          fStorage.TaskSnapshot taskSnapshot = await uploadImageTask.whenComplete((){});

          await taskSnapshot.ref.getDownloadURL().then((urlImage)
          {
            downloadUrlImage = urlImage;


          });

          //2. save the user info to fireStore database
          saveInformationToDatabase();
        }
        else
        {
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Please complete the form. Do not leave any text field empty.");
        }
      }
      else //password is NOT equal to confirm password
          {
        Fluttertoast.showToast(msg: "Password and Confirm Password do not match.");
      }
    }
  }

  saveInformationToDatabase()async {
//  authenticate the User
    User? currentUser;

    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim()
    ).then((auth) {
      currentUser = auth.user;
    }).catchError((errorMessage) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "error Occurred: \n $errorMessage");

    });
    if (currentUser != null) {
      // save the info   to database and save the locally
      saveInfoToFirestoreAndLocally(currentUser!);
    }
  }
  saveInfoToFirestoreAndLocally( User currentUser) async
  {
    // save to fireStore
    FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .set(
        {
      "uid": currentUser.uid,
          "email":currentUser.email,
          "name":nameTextEditingController.text.trim(),
          "photoUrl":downloadUrlImage,
          "status":"approved",
          "userCart":["initialValue"],

    });
    // save Locally
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("email", currentUser.email!);
    await sharedPreferences!.setString("name", nameTextEditingController.text.trim());
    await sharedPreferences!.setString("photoUrl", downloadUrlImage);
    await sharedPreferences!.setStringList("userCart",["initialValue"]);

    Navigator.push(context,MaterialPageRoute(builder: (c)=>MySplashScreen()));

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            const SizedBox(height: 12 ,),
            // get image / Capture image camera




            GestureDetector(
              onTap: () {
                getImageFromGallery();


              },
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width *0.2,
                backgroundColor: Colors.white54,
                backgroundImage: imgXFile == null
                    ? null
                    : FileImage(
                      File(imgXFile!.path)
                ),

                child: imgXFile == null
                    ? Icon(
                  Icons.add_photo_alternate,
                  color: Colors.blueGrey,
                  size: MediaQuery.of(context).size.width *0.2,

                ) : null,
              ),

            ),
            const SizedBox(height: 12,),
            /// input Field
          Form(
            key: formKey,
            child: Column(
               children: [
                 /// 1.Name
                 CustomTextField(
                   textEditingController: nameTextEditingController,
                   iconData: Icons.person,
                   hintText: "Name",
                   isObsecre: false,
                   enabled: true,
                 ),
                 /// 2.Email
                 CustomTextField(
                   textEditingController: emailTextEditingController,
                   iconData: Icons.email,
                   hintText: "e-Mail",
                   isObsecre: false,
                   enabled: true,
                 ),
                 //3.password
                 CustomTextField(
                   textEditingController: passwordTextEditingController,
                   iconData: Icons.password,
                   hintText: "Password",
                   isObsecre: true,
                   enabled: true,
                 ),
                 // 4. Confirm  Pass\
                 CustomTextField(
                   textEditingController: confirmPasswordTextEditingController,
                   iconData: Icons.password,
                   hintText: "Confirm Password ",
                   isObsecre: true,
                   enabled: true,
                 ),
               ],
            ),
          ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                ),
                onPressed: ()
                {
                  formValidation();
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
            ),

            const SizedBox(height: 30,),


          ],
        ),
      ),
    );
  }

}
