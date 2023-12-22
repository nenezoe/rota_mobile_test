import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceToTextScreen extends StatefulWidget {
  @override
  _VoiceToTextScreenState createState() => _VoiceToTextScreenState();
}

class _VoiceToTextScreenState extends State<VoiceToTextScreen> {
  stt.SpeechToText? _speechToText;
  bool _isListening = false;
  String _text = '';

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice to Text'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _text,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _listen,
              child: Text(_isListening ? 'Stop Listening' : 'Start Listening'),
            ),
          ],
        ),
      ),
    );
  }


  void _listen() async {
  if (!_isListening) {
    bool available = await _speechToText!.initialize(
      onStatus: (status) {
         if (status == 'listening') {
          setState(() => _isListening = true);
        } else if (status == 'notListening') {
          setState(() => _isListening = false);
        }
      },
      onError: (error) {
        print('Error: $error');
        _speechToText?.stop();
        setState(() => _isListening = false);
      },
    );

    if (available) {
      _speechToText?.listen(
        onResult: (result) {
          setState(() => _text = result.recognizedWords);
        },
      );
    }
  } else {
    _speechToText?.stop();
  }
}
}
