import 'package:flutter/material.dart';
import 'package:speech_to_text2/widgets/float_button.dart';
import 'package:speech_to_text/speech_to_text.dart' ;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TextEditingController controller = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    initSpeech();

  }
  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();

    setState(() {});
    print("--   " + _speechEnabled.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech To Text'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:  FloatButtonWidget(controller:  controller,
        speechText:  _speechToText
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: TextField(
          readOnly: true,
          expands: true,
         style:  TextStyle(
           fontSize: 30,
           color: Colors.grey.shade700,
           fontWeight: FontWeight.bold
         ),
         decoration: const InputDecoration.collapsed(
             hintText: '',

         ),
         maxLines: null,
          cursorHeight: 50,

          textDirection: TextDirection.rtl,
          keyboardType: TextInputType.multiline,
         controller: controller,


        ),
      ),
    );
  }
}
