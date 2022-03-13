import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' ;
import 'package:speech_to_text/speech_recognition_result.dart';

class FloatButtonWidget extends StatefulWidget {
 final TextEditingController controller;
 final SpeechToText speechText;
   const FloatButtonWidget({Key? key, required this.controller,
     required this.speechText}) : super(key: key);

  @override
  State<FloatButtonWidget> createState() => _FloatButtonWidgetState();
}

class _FloatButtonWidgetState extends State<FloatButtonWidget>
    with SingleTickerProviderStateMixin {
  bool isStart = false;

  late AnimationController controller;
  late Animation<double> valueAnim;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..addListener(() {
        switch (controller.status) {
          case AnimationStatus.completed:
            controller.reverse();
            break;
          case AnimationStatus.dismissed:
            controller.forward();
            break;
          default:
        }
      });
    valueAnim = Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: (context, child) {
        return Transform.scale(
          child: child,
          scale: valueAnim.value,
        );
      },
      child: GestureDetector(
        onTap: () {

           if(!isStart)
             {
               isStart=true;
               controller.forward();
               startListening();

             }
           else {
             stopListening();
             isStart=false;
             controller.reverse().then((value) {
               controller.stop();
             });
             setState(() {});
           }
           setState(() {});
          },
        child: AnimatedContainer(
          height: isStart? 60:70,
          width: isStart ? 100 : 70,
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isStart? 15:40),
              color: Colors.blue,
            ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) => ScaleTransition(
                    scale: child.key == const ValueKey('ic1')
                        ? Tween<double>(begin: 0.0, end: 1).animate(anim)
                        : Tween<double>(begin: 0.0, end: 1.2).animate(anim),
                    child: FadeTransition(
                      opacity: anim,
                      child: child,
                    ),
                  ),
                  child: isStart
                      ? const Icon(
                          Icons.record_voice_over,
                          color: Colors.white,
                          key: ValueKey('ic1'),
                        )
                      : const Icon(
                          Icons.mic,
                          key: ValueKey('ic2'),
                          color: Colors.white,
                        ),
                ),
                Visibility(
                  visible: isStart,
                  child: Container(
                      margin: const EdgeInsets.only(left: 7),
                      child: const Text("Speak")),
                  replacement: Container(),
                )
              ],
            ),
        ),
      ),
      animation: controller,
    );
  }
  void startListening() async {
    widget.controller.clear();
    // var locales = await widget.speechText.locales() 76;


    await widget.speechText.listen(
      localeId:"fa_IR",
        onResult: onResultSpeech
    );

  }
  void onResultSpeech(SpeechRecognitionResult result){
    widget.controller.text = result.recognizedWords;
    setState(() {});
    print(widget.speechText.isListening);

  }
  void stopListening() async {
    await widget.speechText.stop();

  }
}
