// ignore_for_file: unused_local_variable, prefer_const_constructors, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exd_morning/FCM%20Services/fcm_Services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  File? image;
  TextEditingController prodController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Item"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: Text("Back To Home")),
          const SizedBox(
            height: 200,
          ),
          InkWell(
            onTap: () {
              pickerBottomSheet();
            },
            child: Container(
              alignment: Alignment.center,
              width: 150,
              height: 150,
              decoration: image == null
                  ? const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                      image: DecorationImage(
                        image: AssetImage('assets/download.jpg'),
                      ))
                  : BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(image!),
                      )),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          const Text("Product Name"),
          TextField(
            controller: prodController,
          ),
          const Spacer(),
          ElevatedButton(
              onPressed: () {
                FCMServices.displyNotification(
                    title: "This is Test", body: "body");
              },
              child: const Text("Add Item")),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }

  pickerBottomSheet() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 50,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    pickCameraImage();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: const Icon(Icons.camera),
                  ),
                ),
                InkWell(
                  onTap: () {
                    pickGalleryImage();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: const Icon(Icons.image),
                  ),
                ),
              ],
            ),
          );
        });
  }

  pickCameraImage() async {
    print("Iamge Pick....");
    ImagePicker picker = ImagePicker();

    XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    File? imagePath = File(pickedFile!.path);
    print("imagePath: $imagePath");
    setState(() {
      image = imagePath;
    });
  }

  pickGalleryImage() async {
    print("Iamge Pick....");
    ImagePicker picker = ImagePicker();

    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    File? imagePath = File(pickedFile!.path);
    print("imagePath: $imagePath");
    setState(() {
      image = imagePath;
    });
    // cropImage(pickedFile);
  }

  /// Crop Image
  cropImage(filePath) async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: filePath.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedFile != null) {
      setState(() {
        image = croppedFile;
      });
    }
  }

  uploadIamgeIntoStorage(File image) async {
    print("uploading....");
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference reference = storage.ref('img');
      UploadTask uploadTask = reference.putFile(image);
      await Future.value(uploadTask);
      print("upload Done");
      var url = await reference.getDownloadURL();
      print("url :  $url");
      // add product into Firestore
      addProduct(url);
    } catch (e) {
      print("catch e: $e");
    }
  }

  addProduct(imageURL) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    firebaseFirestore.collection('product').doc().set({
      'productId': "1",
      'product name': prodController.text.toString(),
      'product image': imageURL,
    });
    print("Product Post________________________/");
  }
}
