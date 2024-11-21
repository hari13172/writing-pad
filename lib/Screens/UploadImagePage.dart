// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class UploadImagePage extends StatefulWidget {
//   @override
//   _UploadImagePageState createState() => _UploadImagePageState();
// }

// class _UploadImagePageState extends State<UploadImagePage> {
//   File? _image;
//   final ImagePicker _picker = ImagePicker();

//   Future<void> _pickImage(ImageSource source) async {
//     final pickedFile = await _picker.pickImage(source: source);

//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Upload Image'),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _image != null
//                 ? Image.file(
//                     _image!,
//                     width: 200,
//                     height: 200,
//                     fit: BoxFit.cover,
//                   )
//                 : Icon(
//                     Icons.image,
//                     size: 100,
//                     color: Colors.grey,
//                   ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => _pickImage(ImageSource.gallery),
//               child: Text('Select Image from Gallery'),
//               style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () => _pickImage(ImageSource.camera),
//               child: Text('Take a Picture'),
//               style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
//             ),
//             SizedBox(height: 20),
//             _image != null
//                 ? ElevatedButton(
//                     onPressed: () {
//                       // Upload the image to the server or perform other actions
//                     },
//                     child: Text('Upload Image'),
//                     style: ElevatedButton.styleFrom(primary: Colors.green),
//                   )
//                 : Container(),
//           ],
//         ),
//       ),
//     );
//   }
// }
