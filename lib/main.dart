import 'package:calculator_riverpod_example/colors.dart';
import 'package:calculator_riverpod_example/riverpod.dart';
import 'package:calculator_riverpod_example/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  static final String title = 'Calculator';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
          scaffoldBackgroundColor: MyColors.background1,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MainPage(title: title),
      );
}

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({
    @required this.title,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Container(
            margin: EdgeInsets.only(left: 8),
            child: Text(widget.title),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(child: buildResult()),
              Expanded(flex: 2, child: buildButtons())
            ],
          ),
        ),
      );

  Widget buildResult() => Consumer(
        builder: (context, watch, child) {
          final state = watch(calculatorProvider.state);

          return Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  state.equation,
                  overflow: TextOverflow.ellipsis,
                  style:
                      TextStyle(color: Colors.white, fontSize: 36, height: 1),
                ),
                const SizedBox(height: 24),
                Text(
                  state.result,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ],
            ),
          );
        },
      );

  Widget buildButtons() => Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: MyColors.background2,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: <Widget>[
            buildButtonRow('AC', '<', '', '÷'),
            buildButtonRow('7', '8', '9', '⨯'),
            buildButtonRow('4', '5', '6', '-'),
            buildButtonRow('1', '2', '3', '+'),
            buildButtonRow('0', '.', '', '='),
          ],
        ),
      );

  Widget buildButtonRow(
    String first,
    String second,
    String third,
    String fourth,
  ) {
    final row = [first, second, third, fourth];

    return Expanded(
      child: Row(
        children: row
            .map((text) => ButtonWidget(
                  text: text,
                  onClicked: () => onClickedButton(text),
                  onClickedLong: () => onLongClickedButton(text),
                ))
            .toList(),
      ),
    );
  }

  void onClickedButton(String buttonText) {
    final calculator = context.read(calculatorProvider);

    switch (buttonText) {
      case 'AC':
        calculator.reset();
        break;
      case '=':
        calculator.equals();
        break;
      case '<':
        calculator.delete();
        break;
      default:
        calculator.append(buttonText);
        break;
    }
  }

  void onLongClickedButton(String text) {
    final calculator = context.read(calculatorProvider);

    if (text == '<') {
      calculator.reset();
    }
  }
}
