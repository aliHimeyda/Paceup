import 'package:flutter/material.dart';
import 'package:paceup/widgets/searchW/searchWprovider.dart';
import 'package:provider/provider.dart';

class SearchBarW extends StatelessWidget {
  const SearchBarW({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Searchwprovider>(context, listen: false);
    final watchp = context.watch<Searchwprovider>();
    return Row(
      children: [
        Expanded(
          child: TextField(
            onTap: () {
              provider.isactive = true;
              provider.change();
            },
            onChanged: (value) {
              // TODO: arama metni değiştiğinde yapılacaklar
            },
            onSubmitted: (_) {
              provider.isactive = false;
              provider.change();
            },
            onTapOutside: (_) {
              FocusScope.of(context).unfocus();
              provider.isactive = false;
              provider.change();
            },
            
            cursorHeight: 20,
            cursorWidth: 1,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Search A Location',
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).primaryColor,
              ),
              isDense: watchp.isactive,
              filled: watchp.isactive,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16), // gap: 16px
        // FILTER BUTTON (48x48, #F6F8FA, radius 50)
        InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (ctx) {
                // Şimdilik boş içerik
                return SizedBox(
                  height: 300,
                  child: Center(
                    child: Text(
                      'Filters',
                      style: Theme.of(ctx).textTheme.titleMedium,
                    ),
                  ),
                );
              },
            );
          },
          borderRadius: BorderRadius.circular(50),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.7,
                color: Theme.of(context).primaryColor,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.tune,
              color: Theme.of(context).primaryColor,
            ), // filtre ikonu
          ),
        ),
      ],
    );
  }
}
