import 'package:flutter/material.dart';
import 'package:tic_tac_toe/constants/appcolor.dart';
import 'package:tic_tac_toe/controller/game_logic.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String lastValue = "X";
  bool gameOver = false;
  int turn = 0;
  String result = "";
  List<int> scoreboard = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ];

  Game game = Game();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    game.board = Game.initGameBoard();
    print(game.board);
  }

  @override
  Widget build(BuildContext context) {
    double boardWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.primaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "It's ${lastValue} turn".toUpperCase(),
              style: TextStyle(color: Colors.white, fontSize: 40),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              width: boardWidth,
              height: boardWidth,
              child: GridView.count(
                crossAxisCount: Game.borderlenth ~/ 3,
                padding: EdgeInsets.all(16.0),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                children: List.generate(Game.borderlenth, (index) {
                  return InkWell(
                    onTap: gameOver
                        ? null
                        : () {
                            if (game.board![index] == "") {
                              setState(() {
                                game.board![index] = lastValue;
                                turn++;
                                gameOver = game.winnerCheck(
                                    lastValue, index, scoreboard, 3);
                                if (gameOver) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            content: Text(
                                                "$result is the winner."),
                                                title: Text("Congratulation"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Ok"))
                                            ],
                                          ));
                                  result = "$lastValue is the winner";
                                } else if (!gameOver && turn == 9) {
                                  result = "It's a Draw";
                                  gameOver = true;
                                }
                                if (lastValue == "X") {
                                  lastValue = "O";
                                } else {
                                  lastValue = "X";
                                }
                              });
                            }
                          },
                    child: Container(
                      width: Game.blocSize,
                      height: Game.blocSize,
                      decoration: BoxDecoration(
                          color: AppColor.secondaryColor,
                          borderRadius: BorderRadius.circular(16.0)),
                      child: Center(
                        child: Text(
                          game.board![index],
                          style: TextStyle(
                              color: game.board![index] == "X"
                                  ? Colors.yellowAccent
                                  : Colors.pink,
                              fontSize: 64),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            Text(
              result,
              style: TextStyle(color: Colors.white, fontSize: 40.0),
            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  game.board = Game.initGameBoard();
                  lastValue = "X";
                  gameOver = false;
                  turn = 0;
                  result = "";
                  scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];
                });
              },
              icon: Icon(Icons.replay),
              label: Text("Repeat the game"),
            ),
          ],
        ),
      ),
    );
  }
}
