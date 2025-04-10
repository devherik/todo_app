import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

//colors
const green = Color.fromARGB(255, 135, 238, 188);
const red = Color.fromARGB(255, 226, 141, 141);
const blue = Color.fromARGB(255, 84, 189, 238);
var primaryDarkColor = HexColor('4C4B63');
var secondaryDarkColor = HexColor('949396');
var terciaryDarkColor = HexColor('D8E1E9');
var primaryLightColor = HexColor('D8E1E9');
var secondaryLightColor = HexColor('B3C5D7');
var terciaryLightColor = HexColor('4C4B63');
var neutralColor = HexColor('FAFF7F');

//spaces
var verySmallBoxSpace = const SizedBox(height: 12);
var smallBoxSpace = const SizedBox(height: 24);
var mediumBoxSpace = const SizedBox(height: 48);
var largeBoxSpace = const SizedBox(height: 60);
var veryLargeBoxSpace = const SizedBox(height: 96);

//generics
void showToaster(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: Text(message, style: Theme.of(context).textTheme.labelLarge),
      ),
      duration: const Duration(seconds: 1),
      backgroundColor: Theme.of(context).colorScheme.primary,
    ),
  );
}

Future<bool> showUndoToaster(BuildContext context) async {
  bool action = false;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: GestureDetector(
        child: Center(
          child: Text(
            'Toque para desfazer',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        onTap: () async => action = true,
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: Theme.of(context).colorScheme.primary,
    ),
  );
  return action;
}
