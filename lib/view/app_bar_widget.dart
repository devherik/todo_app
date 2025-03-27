import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:minimalist_todo/viewmodel/home_viewmodel.dart';

class AppBarTextWidget extends StatefulWidget {
  const AppBarTextWidget({super.key, required this.viewmodel});
  final HomeViewmodel viewmodel;

  @override
  State<AppBarTextWidget> createState() => _AppBarTextWidgetState();
}

class _AppBarTextWidgetState extends State<AppBarTextWidget> {
  bool _isArquived = false;
  List<String> pages = ['Ativas', 'Arquivadas'];
  @override
  Widget build(BuildContext context) {
    return Swiper(
      loop: true,
      layout: SwiperLayout.STACK,
      duration: 200,
      scrollDirection: Axis.horizontal,
      itemHeight: 80,
      itemWidth: MediaQuery.of(context).size.width,
      onIndexChanged: (value) async {
        if (!_isArquived) {
          await widget.viewmodel.updateArquived();
        } else {
          await widget.viewmodel.update();
        }
        setState(() => _isArquived = !_isArquived);
      },
      itemBuilder:
          (context, index) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'Minhas tarefas',
                      style: GoogleFonts.ubuntu(
                        fontSize: 24,
                        letterSpacing: 2,
                        color: Theme.of(
                          context,
                        ).colorScheme.tertiary.withAlpha(150),
                      ),
                    ),
                    Text(
                      pages[index],
                      style: GoogleFonts.ubuntu(
                        fontSize: 24,
                        letterSpacing: 2,
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Builder(
                  builder:
                      (context) => IconButton(
                        onPressed: () async {
                          //change the tasks list to the arquived tasks and vice versa
                          if (!_isArquived) {
                            await widget.viewmodel.updateArquived();
                          } else {
                            await widget.viewmodel.update();
                          }
                          setState(() => _isArquived = !_isArquived);
                        },
                        icon: Icon(Iconsax.arrow_swap_horizontal),
                      ),
                ),
              ],
            ),
          ),
      itemCount: pages.length,
    );
  }
}
