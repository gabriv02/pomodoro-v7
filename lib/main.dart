import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_timer/api_service.dart';
import 'package:flutter_circular_timer/info.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DemoApp(),
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
    );
  }
}

class DemoApp extends StatefulWidget {
  Info? info;

  @override
  _DemoAppState createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  CountDownController _controller = CountDownController();
  int _duration = 2;
  bool _isPause = false;

  TextEditingController idController = TextEditingController();
  TextEditingController namController = TextEditingController();
  TextEditingController tarController = TextEditingController();

  ApiService apiService = ApiService();
  SharedPreferences? sharedPreferences;

  @override
  // void initState() {
  //   super.initState();
  //   idController.text = widget.info!.api.toString();
  //   namController.text = widget.info!.name.toString();
  //   tarController.text = widget.info!.tarea.toString();
  // }

  bool editable = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pomodoro Timer'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            children: [
              Column(
                children: [
                  SizedBox(height: 30.0),
                  TextField(
                    controller: idController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                        ),
                      ),
                      hintText: "Id",
                      fillColor: Colors.white,
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: namController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                        ),
                      ),
                      hintText: "Nombre",
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: tarController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                        ),
                      ),
                      hintText: "Tarea",
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    width: 200.0,
                    child: ElevatedButton(
                      onPressed: () async {
                        Info data = await apiService
                            .getInfoId(int.parse(idController.text));
                        getData(
                            data, idController, namController, tarController);
                      },
                      child: Text('Obtener tarea'),
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    width: 200.0,
                    child: ElevatedButton(
                      onPressed: () async {
                        Info info = Info(
                          api: 0,
                          name: namController.text.toString(),
                          tarea: tarController.text.toString(),
                        );
                        await apiService.postInfo(info);
                      },
                      child: Text('Agregar tarea'),
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    width: 200.0,
                    child: ElevatedButton(
                      onPressed: () {
                        if (editable) {
                          Info info = Info(
                            api: int.parse(idController.text),
                            name: namController.text,
                            tarea: tarController.text,
                          );
                          //apiService.putPerson(int.parse(_id.text.toString(), ))
                          //Navigator.pop(context);
                        }
                        setState(() {
                          editable = !editable;
                        });
                      },
                      child: const Text('Editar'),
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                    ),
                  ),
                  Center(
                    child: CircularCountDownTimer(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height / 2,
                      duration: _duration,
                      fillColor: Colors.redAccent,
                      controller: _controller,
                      backgroundColor: Colors.white54,
                      strokeWidth: 10.0,
                      strokeCap: StrokeCap.round,
                      autoStart: true,
                      isTimerTextShown: true,
                      isReverse: true,
                      onComplete: () {
                        FlutterRingtonePlayer.play(
                          android: AndroidSounds
                              .notification, //Gabriela aquiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
                          ios: IosSounds
                              .glass, //Gabriela aquiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
                          looping:
                              false, // Android only - API >= 28 /Gabriela aquiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
                          volume:
                              0.1, // Android only - API >= 28/Gabriela aquiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
                          asAlarm:
                              false, // Android only - all APIs/Gabriela aquiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
                        );
                        Alert(
                                context: context,
                                title: 'Done',
                                style: AlertStyle(
                                  isCloseButton: true,
                                  isButtonVisible: false,
                                  titleStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30.0,
                                  ),
                                ),
                                type: AlertType.success)
                            .show();
                      },
                      textStyle: TextStyle(fontSize: 50.0, color: Colors.black),
                      ringColor: Colors.red,
                    ),
                  ),

                  FloatingActionButton.extended(
                      onPressed: () => _controller.restart(duration: _duration),
                      label: Text('restart work timer'),
                      icon: Icon(Icons.restart_alt)),
                  SizedBox(height: 10),

                  FloatingActionButton.extended(
                    onPressed: () {
                      setState(() {
                        if (_isPause) {
                          _isPause = false;
                          _controller.resume();
                        } else {
                          _isPause = true;
                          _controller.pause();
                        }
                      });
                    },
                    icon: Icon(
                      _isPause ? Icons.play_arrow : Icons.pause,
                    ),
                    label: Text(
                      _isPause ? 'Resume' : 'Pause',
                    ),
                  ),
                  SizedBox(height: 10),

                  FloatingActionButton.extended(
                      onPressed: () => _controller.restart(duration: 300),
                      label: Text('rest'),
                      icon: Icon(Icons.restaurant)),
                  SizedBox(height: 10),

//solo lo uso para guiarme en el espacio
                ],
              ),
            ]),
      ),
    );
  }

  getData(
    Info data,
    TextEditingController id,
    TextEditingController nam,
    TextEditingController tar,
  ) {
    id.text = data.api.toString();
    nam.text = data.name.toString();
    tar.text = data.tarea.toString();
  }
}
