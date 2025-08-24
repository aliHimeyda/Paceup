import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paceup/data/repositories/userDR.dart';
import 'package:paceup/routing/paths.dart';
import 'package:paceup/widgets/fluttertoast.dart';
import 'package:paceup/widgets/loader.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    late TextEditingController namecontroller = TextEditingController(
      text: UserDR.currentuser!.fullName,
    );
    late TextEditingController numbercontroller = TextEditingController(
      text: UserDR.currentuser!.mobileNumber,
    );
    late TextEditingController adresscontroller = TextEditingController(
      text: UserDR.currentuser!.adress,
    );

    final primary = Theme.of(context).primaryColor;
    final theme = Theme.of(context);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  // Custom AppBar
                  Row(
                    children: [
                      _BackCircle(onTap: () => Navigator.maybePop(context)),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Profile',
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 48,
                      ), // back düğmesi ile başlık ortalansın
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Body
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _FieldLabel('FULL NAME'),
                          const SizedBox(height: 8),
                          _Input(
                            textcontroller: namecontroller,
                            primary: primary,
                            textInputType: TextInputType.name,
                          ),
                          const SizedBox(height: 16),

                          _FieldLabel('MOBILE NUMBER'),
                          const SizedBox(height: 8),
                          _Input(
                            textcontroller: numbercontroller,
                            primary: primary,
                            textInputType: TextInputType.phone,
                          ),
                          const SizedBox(height: 16),

                          _FieldLabel('ADDRESS'),
                          const SizedBox(height: 8),
                          _Input(
                            textcontroller: adresscontroller,
                            primary: primary,
                            maxLength: 100,
                            minLines: 3,
                            maxLines: 5,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 56,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primary,
                                foregroundColor: Colors.white,
                                shape: const StadiumBorder(),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 12,
                                ),
                                elevation: 0,
                              ),
                              onPressed: () async {
                                final process = await updateUserData(
                                  namecontroller.text,
                                  numbercontroller.text,
                                  adresscontroller.text,
                                  'en',
                                  'light',
                                );
                                if (process) {
                                  fluttertoast(context, 'saved changes');
                                } else {
                                  fluttertoast(
                                    context,
                                    'canceled during processing',
                                  );
                                }
                              },
                              child: const Text('Save Changes'),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Settings list
                          _SettingsItem(title: 'About', onTap: () {}),
                          _Divider(),
                          _SettingsItem(title: 'Settings', onTap: () {}),
                          _Divider(),
                          _SettingsItem(
                            title: 'Logout',
                            showChevron: false,
                            onTap: () async {
                              final process = await signOutuser();
                              if (process) {
                                context.pushReplacement(Paths.loginpage);
                              } else {
                                fluttertoast(
                                  context,
                                  'canceled during processing',
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom primary button
        ),
        context.watch<Loader>().loading
            ? Provider.of<Loader>(context, listen: false).loader(context)
            : SizedBox(),
      ],
    );
  }
}

// ===== Widgets =====

class _BackCircle extends StatelessWidget {
  const _BackCircle({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: const Color(0x268E8E90)), // ~%15 opacity
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.arrow_back, size: 22, color: Colors.black87),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}

class _Input extends StatelessWidget {
  const _Input({
    required this.primary,
    required this.textcontroller,
    this.textInputType,
    this.minLines,
    this.maxLines = 1,
    this.maxLength,
  });
  final TextEditingController textcontroller;
  final Color primary;
  final TextInputType? textInputType;
  final int? minLines;
  final int maxLines;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: Color(0xFFDEDEDE), width: 1),
    );

    return TextFormField(
      onTapOutside: (_) {
        FocusScope.of(context).unfocus();
      },
      controller: textcontroller,
      style: Theme.of(context).textTheme.bodyMedium,
      keyboardType: textInputType,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        counterText: maxLength != null ? null : '',
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem({
    required this.title,
    required this.onTap,
    this.showChevron = true,
  });

  final String title;
  final VoidCallback onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
      trailing: showChevron ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFDEDEDE));
  }
}
