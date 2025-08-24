import 'package:flutter/material.dart';
import 'package:paceup/data/repositories/userDR.dart';
import 'package:paceup/widgets/loader.dart';
import 'package:paceup/core/theme/colors.dart';
import 'package:paceup/data/datasources/remote_datasource/firebaseservices.dart';
import 'package:paceup/features/login_page/loginpageprovider.dart';
import 'package:provider/provider.dart';

class Loginpage extends StatelessWidget {
  const Loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _mailController = TextEditingController();
    final TextEditingController _adsoyadController = TextEditingController();
    final TextEditingController _IDController = TextEditingController();
    final provider = Provider.of<Loginpageprovider>(context);
    final loaderProvider =  context.watch<Loader>();

    return Scaffold(
      backgroundColor:Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ListView(
              children: [
                const SizedBox(height: 90),
                Text(
                  provider.isLogin ? 'Tekrar hoş geldin!' : 'hoş geldin!',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                const SizedBox(height: 32),
                if (!provider.isLogin)
                  TextField(
                    controller: _adsoyadController,
                    decoration: InputDecoration(
                      labelText: "Adınız ve Soyadınız",
                      border: OutlineInputBorder(),
                    ),
                  ),
                if (!provider.isLogin) const SizedBox(height: 12),
                if (!provider.isLogin)
                  TextField(
                    controller: _IDController,
                    decoration: const InputDecoration(
                      labelText: "ID numarasi (istege bagli)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                if (!provider.isLogin) const SizedBox(height: 12),

                TextField(
                  controller: _mailController,
                  decoration: InputDecoration(
                    labelText: 'E-posta',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: provider.sifreController,
                  obscureText: provider.sifreGizli,

                  decoration: InputDecoration(
                    labelText: 'Şifre',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        provider.sifreGizli
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () => provider.sifreyiGosterGizle(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Şifreni mi unuttun?',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (provider.isLogin) {
                        await girisYap(
                          context,
                          _mailController.text.trim(),
                          provider.sifreController.text.trim(),
                        );
                        _mailController.clear();
                        provider.sifreController.clear();
                      } else {
                        await kayitEkle(
                          context,
                          _adsoyadController.text.trim(),
                          _mailController.text.trim(),
                          provider.sifreController.text.trim(),
                        );
                        _adsoyadController.clear();
                        _mailController.clear();
                        provider.sifreController.clear();
                      }
                    },
                    child: Text(
                      provider.isLogin ? 'Giriş Yap' : 'Kayit Ol',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "veya",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    icon: Image.asset('assets/icons/google.png'),
                    label: Text(
                      "Google ile devam et",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onPressed: () async {
                      await signinwithGoogle(context);
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () {
                      if (provider.isLogin) {
                        provider.isLogin = false;
                        provider.savechanges();
                      } else {
                        provider.isLogin = true;
                        provider.savechanges();
                      }
                    },
                    child: Text.rich(
                      TextSpan(
                        text: provider.isLogin
                            ? 'Hesabın yok mu? '
                            : 'Hesabın var mi? ',
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: provider.isLogin ? 'Kayıt ol' : 'giris yap',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 60,
            left: 0,
            child: Container(
              width: 50,
              height: 50,
              padding: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: MyColors.darkgray,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Image.asset(
                'assets/images/logo.png',
                height: 50,
                width: 50,
              ),
            ),
          ),

           loaderProvider.loading
            ? Provider.of<Loader>(context, listen: false).loader(context)
            : SizedBox(),
        ],
      ),
    );
  }
}

class SosyalButon extends StatelessWidget {
  final String icon;

  const SosyalButon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Image.asset(icon),
    );
  }
}
