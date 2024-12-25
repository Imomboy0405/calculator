import 'package:calculator/widgets.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController _scrollController = ScrollController();
  final _symbolsColumn = ['÷', '×', '–', '+', '='];
  final _symbolsRow = ['C', '⌫', '%'];
  final _symbolsNumber = ['7', '8', '9', '4', '5', '6', '1', '2', '3', '.', '0', '00'];
  String _text = '0';
  String _text1 = '';
  String _text2 = '';
  String _operation = '';
  String _oldOperation = '';
  final List<String> _history = [];

  void _pressNumber(String s) {
    if (_text.length > 18) return;
    _text = _text.replaceAll(' ', '');
    _pressNumberLogic(s);
    if (_text.isNotEmpty) _formatNumber;
    setState(() {});
  }

  void _pressNumberLogic(String s) {
    if (!_text.contains('.') && !_text.contains('-') && double.parse(_text) == 0) {
      _text = '';
    }

    if (_operation == '=') {
      _text1 = '';
      _operation = '';
      if (s == '0' || s == '00' || s == '.') {
        _text = '';
      } else {
        _text = s;
        return;
      }
    } else {
      if (_text1.isEmpty && _operation.isNotEmpty) {
        _text1 = _text;
        if (s == '0' || s == '00' || s == '.') {
          _text = '';
        } else {
          _text = s;
          return;
        }
      } else {
        if (s != '0' && s != '00' && s != '.') {
          _text += s;
          return;
        }
      }
    }

    if (s == '.') {
      if (_text.isEmpty) {
        _text = '0.';
      } else if (_text.characters.last != '.' && !_text.contains('.')) {
        _text += '.';
      }
      return;
    }

    if (s == '00') {
      if (_text.isEmpty) {
        _text = '0';
        return;
      }
      if (_text.contains('.') || double.parse(_text) != 0) _text += '00';
      return;
    }

    if (s == '0') {
      if (_text.isEmpty) {
        _text = '0';
        return;
      }
      if (_text.contains('.') || double.parse(_text) != 0) _text += '0';
    }
  }

  void _pressOperation(String s) {
    _text = _text.replaceAll(' ', '');
    _pressOperationLogic(s);
    if (_text.isNotEmpty) _formatNumber;
    setState(() {});
  }

  void _pressOperationLogic(String s) {
    if (s == 'C') {
      _text = '0';
      _text1 = '';
      _text2 = '';
      _operation = '';
      if (_history.isNotEmpty && !_history.last.contains('=')) _history.removeLast();
      return;
    }

    if (s == 'AC') {
      _history.clear();
      return;
    }

    if (s == '⌫') {
      _text = _text.substring(0, _text.length - 1);
      if (_text.isEmpty) _text = '0';
      return;
    }

    if (s == '–' && _text == '0') {
      _text = '-';
      return;
    }

    if (s == '=') {
      if (_text1.isNotEmpty) {
        if (_operation != '=') {
          _text2 = _text;
        }
        if (_text2.isNotEmpty) _calc();
        if (_history.isNotEmpty && !_history.last.contains('=')) _history.removeLast();
        _history.add('${_formatNumber(_text1)} $_operation ${_formatNumber(_text2)} = ${_formatNumber(_text)}');
        if (_history.length > 10) _history.removeAt(0);
        _text1 = _text;
      }
    } else if (_text != '-') {
      if (_history.isNotEmpty && !_history.last.contains('=')) _history.removeLast();
      _history.add('${_formatNumber(_text)} $s');
      if (_history.length > 10) _history.removeAt(0);
      _text1 = '';
    } else {
      _text = '0';
    }

    if (s != '⌫') _operation = s;

    _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void _calc() {
    late double number;
    if (_operation == '=') _operation = _oldOperation;
    switch (_operation) {
      case '+':
        number = double.parse(_text1) + double.parse(_text2);
        break;
      case '–':
        number = double.parse(_text1) - double.parse(_text2);
        break;
      case '×':
        number = double.parse(_text1) * double.parse(_text2);
        break;
      case '÷':
        number = double.parse(_text1) / double.parse(_text2);
        break;
      case '%':
        if (double.parse(_text1) < 0) {
          number = -(-double.parse(_text1) % double.parse(_text2));
        } else {
          number = double.parse(_text1) % double.parse(_text2);
        }
        break;
    }
    _oldOperation = _operation;
    _text = "${number.remainder(1) == 0 ? number.toInt() : _removeTrailingZeros(number)}";
  }

  get _formatNumber {
    List<String> parts = _text.split('.');

    String wholePart = parts[0];
    String formattedWholePart = _addSpaces(wholePart);

    return _text = parts.length > 1 ? "$formattedWholePart.${parts[1]}" : formattedWholePart;
  }

  String _addSpaces(String input) {
    input = input.replaceAll(' ', '');
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      if (i > 0 && (input.length - i) % 3 == 0 && input[i - 1] != '-') {
        buffer.write(' ');
      }
      buffer.write(input[i]);
    }
    return buffer.toString();
  }

  String _removeTrailingZeros(double input) {
    String fixed = input.toStringAsFixed(7);
    return fixed.contains('.') ? fixed.replaceFirst(RegExp(r'\.?0+$'), '') : fixed;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final lightMode = MediaQuery.of(context).platformBrightness == Brightness.light;

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.primaryColorLight,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // #texts
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.height * .032, vertical: size.height * .02),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // #history
                    Flexible(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: _history
                              .map(
                                (text) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SelectableText(
                                      text,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(color: Colors.grey, fontSize: size.height * .03, fontWeight: FontWeight.w500),
                                    ),
                                    Divider(),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),

                    // #entered_text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _operation,
                          style: myTextStyle(theme, size),
                        ),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: SelectableText(
                              _text,
                              style: myTextStyle(theme, size),
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),

            // #buttons
            Container(
              height: size.height * .6,
              padding: EdgeInsets.all(size.height * .032),
              decoration: BoxDecoration(
                color: theme.primaryColor.withAlpha(123),
                gradient: myGradient(lightMode),
                borderRadius: BorderRadius.only(topRight: Radius.circular(size.height * .04), topLeft: Radius.circular(size.height * .04)),
              ),
              foregroundDecoration: BoxDecoration(color: theme.primaryColorLight.withAlpha(50)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // #other_widgets
                  Flexible(
                    flex: 3,
                    child: Column(
                      children: [
                        // #row_widgets
                        Flexible(
                          child: Container(
                            decoration: myOvalDecoration(theme, size),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: _symbolsRow
                                  .map(
                                    (s) => CustomButton(
                                      size: size,
                                      theme: theme,
                                      text: (s == 'C' && _operation.isEmpty && _text == '0') ? s = 'AC' : s,
                                      onPressed: () => _pressOperation(s),
                                      transparentColor: true,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),

                        // #number_widgets
                        Flexible(
                          flex: 5,
                          child: GridView(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: size.width * .04,
                              mainAxisSpacing: size.height * .031,
                              mainAxisExtent: size.height * .08,
                            ),
                            padding: EdgeInsets.only(top: size.height * .033),
                            physics: NeverScrollableScrollPhysics(),
                            children: _symbolsNumber
                                .map((s) => CustomButton(size: size, theme: theme, text: s, onPressed: () => _pressNumber(s)))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: size.width * .02),

                  // #column_widgets
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: size.height * .005),
                      decoration: myOvalDecoration(theme, size),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _symbolsColumn
                            .map((s) => CustomButton(
                                  size: size,
                                  theme: theme,
                                  text: s,
                                  onPressed: () => _pressOperation(s),
                                  transparentColor: s != '=',
                                ))
                            .toList(),
                      ),
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

  // #text_style
  TextStyle myTextStyle(ThemeData theme, Size size) =>
      TextStyle(color: theme.primaryColorDark, fontSize: size.height * .05, fontWeight: FontWeight.w800);

  // #gradient_bcg
  LinearGradient myGradient(bool lightMode) {
    return LinearGradient(
      begin: Alignment(.7, 2),
      end: Alignment(-.7, -1),
      colors: [
        lightMode ? Color(0xff2D5FDE) : Color(0xff00123F),
        lightMode ? Color(0xff79AFFF) : Color(0xff224E91),
        lightMode ? Color(0xff5ACEFF) : Color(0xff2A7DA1),
        lightMode ? Color(0xb09EE8FF) : Color(0xb042869B),
      ],
    );
  }

  // #oval_decoration
  BoxDecoration myOvalDecoration(ThemeData theme, Size size) {
    return BoxDecoration(
      color: theme.primaryColorLight.withAlpha(76),
      borderRadius: BorderRadius.circular(size.height * .05),
      boxShadow: [
        myBoxShadow(size),
      ],
    );
  }
}
