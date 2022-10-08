import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/user.dart';
import '../../../providers/users.dart';

// ignore: must_be_immutable
class EditProfilePage extends StatefulWidget {
  User userData;
  EditProfilePage({Key? key, required this.userData}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  User? editedData;
  Future<void> _savePressed(Users userProvider) async {
    _formKey.currentState!.save();
    try {
      await userProvider.updateUserInformation(
          editedData!.name!, editedData!.bio!);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  void _showError(BuildContext context, String contentText) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(contentText),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<Users>(context);
    User user = widget.userData;
    editedData = User(
        email: user.email, name: user.name, bio: user.bio, userId: user.userId);
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              const SizedBox(height: 24),
              const Text(
                'Full Name',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                initialValue: user.name != null
                    ? user.name!.isEmpty
                        ? ''
                        : user.name.toString()
                    : '',
                onSaved: (name) {
                  editedData = User(
                      email: editedData!.email,
                      name: name.toString(),
                      userId: editedData!.userId,
                      bio: editedData!.bio);
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Bio',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Bio',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                initialValue: user.bio != null
                    ? user.bio!.isEmpty
                        ? ''
                        : user.bio.toString()
                    : '',
                maxLines: 5,
                onSaved: (bio) {
                  editedData = User(
                      email: editedData!.email,
                      name: editedData!.name,
                      userId: editedData!.userId,
                      bio: bio);
                },
              ),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                onPressed: () => _savePressed(userProvider),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.deepPurple)),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
