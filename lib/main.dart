import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

void main() {
  runApp(const MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {

  String prevexp = '';
  String accumulator = '';

  final evaluator = const ExpressionEvaluator();
  Expression expression = Expression.parse('0');

  void buttonPressed(String buttonText) {
    if (prevexp.isNotEmpty) {
      setState(() {
        prevexp = '';
      });
    }

    // Reciprocal
    if (buttonText == '1/x') {
      setState(() {
        accumulator = '1/($accumulator)';
      });
    }

    else if (buttonText == 'backspace') {
      setState(() {
        accumulator = accumulator.isNotEmpty ? 
          accumulator.substring(0, accumulator.length - 1) : '';
      });
    }

    // Evaluate
    else if (buttonText == '=') {
      expression = Expression.parse(accumulator);
      setState(() {
        prevexp = accumulator;
        accumulator = evaluator.eval(expression, {}).toString();
      });

    // Clear
    } else if (buttonText == 'CLEAR') {
      setState(() {
        accumulator = '';
      });

    // Add
    } else {
      setState(() {
        accumulator = accumulator + buttonText;
      });
    }
  }

  Widget buildButton(String buttonText, {bool ?darken, IconData ?icon}) {

    Widget label;

    if (icon != null) {
      label = Icon(
        icon, size: 32, color: Colors.white,
      );
    } else {
      label = Text(
        buttonText,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return Expanded(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          margin: EdgeInsets.all(5),
          child: FilledButton(
            style: FilledButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.cyan[darken == null ? 400 : 700],
            ),
            child: label,
            onPressed: () => buttonPressed(buttonText),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator', style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        )),
        backgroundColor: Colors.cyan[700],
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[900],
        child: Column(
          children: <Widget>[
            const Expanded(
              child: Text(''), // I just needed an empty element...
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(
                vertical: 24,
                horizontal: 12,
              ),
              child: Text(
                prevexp.isNotEmpty ? '$prevexp = $accumulator': accumulator,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 100/((accumulator.length+prevexp.length+3)*0.1 +1),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    buildButton('7'),
                    buildButton('8'),
                    buildButton('9'),
                    buildButton('/', darken: true,
                      icon: CupertinoIcons.divide),
                  ],
                ),
                Row(
                  children: [
                    buildButton('4'),
                    buildButton('5'),
                    buildButton('6'),
                    buildButton('*', darken: true,
                      icon: CupertinoIcons.clear_thick),
                  ],
                ),
                Row(
                  children: [
                    buildButton('1'),
                    buildButton('2'),
                    buildButton('3'),
                    buildButton('-', darken: true, 
                      icon: CupertinoIcons.minus),
                  ],
                ),
                Row(
                  children: [
                    buildButton('.'),
                    buildButton('0'),
                    buildButton('00'),
                    buildButton('+', darken: true, 
                      icon: CupertinoIcons.plus),
                  ],
                ),
                Row(
                  children: [
                    buildButton('1/x', darken: true),
                    buildButton('backspace', darken: true,
                      icon: CupertinoIcons.backward),
                    buildButton('CLEAR', darken: true,
                      icon: CupertinoIcons.nosign),
                    buildButton('=', darken: true,
                      icon: CupertinoIcons.equal),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}