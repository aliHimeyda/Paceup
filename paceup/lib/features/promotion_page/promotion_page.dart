import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paceup/core/theme/colors.dart';
import 'package:paceup/features/login_page/loginpageprovider.dart';
import 'package:paceup/features/promotion_page/promotion_provider.dart';
import 'package:paceup/routing/paths.dart';
import 'package:provider/provider.dart';

class PromotionPage extends StatelessWidget {
  const PromotionPage({
    super.key,
    this.images = const [
      'assets/images/1.png',
      'assets/images/2.png',
      'assets/images/3.png',
    ],
  });
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Column(
          children: [
            Center(
              child: SizedBox(
                height: 300,
                child: PageView.builder(
                  itemCount: images.length,
                  controller: PageController(viewportFraction: 0.8),
                  onPageChanged: (index) {
                    Provider.of<PromotionPageProvider>(
                      context,
                      listen: false,
                    ).setCurrentPage(index);
                  },
                  itemBuilder: (context, index) {
                    return Consumer<PromotionPageProvider>(
                      builder: (context, provider, _) {
                        double scale = provider.currentPage == index
                            ? 1.0
                            : 0.85;
                        double opacity = provider.currentPage == index
                            ? 0.0
                            : 0.4;

                        return TweenAnimationBuilder(
                          tween: Tween<double>(begin: scale, end: scale),
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      images[index],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                  if (opacity > 0)
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white.withOpacity(
                                          opacity,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ufku kovala,Bir yolculuğa çık.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Özelleştirilebilir haritalar, istatistikler ve başarımlarla koşularınızı görsel bir şahesere dönüştürün.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Provider.of<Loginpageprovider>(
                          context,
                          listen: false,
                        ).isLogin = false;
                        context.push(Paths.loginpage);
                      },

                      child: Text(
                        'Başla',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Row(
                      spacing: 3
                      ,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Zaten bir hesabınız var mı?',
                          style: TextStyle(color: Colors.black54),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.push(Paths.loginpage);
                          },
                          child: Text(
                            'Giriş yap',
                            style: TextStyle(
                              color: MyColors.darkorange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
