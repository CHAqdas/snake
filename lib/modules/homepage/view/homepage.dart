import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:snake/modules/homepage/view/components/food_pixel.dart';
import 'package:snake/modules/homepage/view/components/snake_pixel.dart';
import 'package:snake/utils/button.dart';
import 'components/blank_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum snake_diection { UP, DOWN, RIGHT, LEFT }

class _HomePageState extends State<HomePage> {
  //list of snake position
  List snakepos = [0, 1, 2];

  //SNAKE direction at inital level
  var currentdiretion = snake_diection.RIGHT;

  //grid variables
  int rowsize = 10;

  int totalsize = 100;

  //initial food position
  int foodpos = 57;

  //current score
  int currentscore = 0;

  // gamestarted variable to handle the play button
  bool gamehasstarted = false;

  //start the game
  void startgame() {
    gamehasstarted = true;
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        //for the direction of game
        snakeirection();
        // if game is over
        if (gameover()) {
          timer.cancel();
          showDialog(
              context: context,
              builder: ((context) {
                return AlertDialog(
                  title: const Text("Game Over"),
                  content: Text("Your score is $currentscore"),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            newgame();
                            Navigator.pop(context);
                          },
                          color: Colors.blue,
                          child: const Text("OK"),
                        )
                      ],
                    )
                  ],
                );
              }));
        }
      });
    });
  }

  //movement of snake
  snakeirection() {
    if (currentdiretion == snake_diection.RIGHT) {
      setState(() {
        //moving snake
        if (snakepos.last % rowsize == 9) {
          snakepos.add(snakepos.last + 1 - rowsize);
        } else {
          snakepos.add(snakepos.last + 1);
        }
      });
    } else if (currentdiretion == snake_diection.LEFT) {
      setState(() {
        //moving snake
        if (snakepos.last % rowsize == 0) {
          snakepos.add(snakepos.last - 1 + rowsize);
        } else {
          snakepos.add(snakepos.last - 1);
        }
      });
    } else if (currentdiretion == snake_diection.UP) {
      setState(() {
        //moving snake
        if (snakepos.last < rowsize) {
          snakepos.add(snakepos.last - rowsize + totalsize);
        } else {
          snakepos.add(snakepos.last - rowsize);
        }
      });
    } else if (currentdiretion == snake_diection.DOWN) {
      setState(() {
        //movng snake
        if (snakepos.last + rowsize > totalsize) {
          snakepos.add(snakepos.last + rowsize - totalsize);
        } else {
          snakepos.add(snakepos.last + rowsize);
        }
      });
    }
    if (snakepos.last == foodpos) {
      currentscore++;
      eatfood();
    } else {
      //removing tail
      snakepos.removeAt(0);
    }
  }

  //eating food
  void eatfood() {
    while (snakepos.contains(foodpos)) {
      foodpos = Random().nextInt(totalsize);
    }
  }

  //game is over
  bool gameover() {
    List snakebody = snakepos.sublist(0, snakepos.length - 1);
    if (snakebody.contains(snakepos.last)) {
      return true;
    }
    return false;
  }

  //start a new game
  void newgame() {
    setState(() {
      //list of snake position
      snakepos = [0, 1, 2];

      //SNAKE direction at inital level
      currentdiretion = snake_diection.RIGHT;

      //initial food position
      foodpos = 57;

      //current score
      currentscore = 0;

      // gamestarted variable to handle the play button
      gamehasstarted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          //scores
          Expanded(
            child: Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Your Scores Are :",
                  style: TextStyle(fontSize: 23, color: Colors.white),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  currentscore.toString(),
                  style: const TextStyle(fontSize: 22, color: Colors.white),
                )
              ],
            )),
          ),

          //gridview
          Expanded(
            flex: 3,
            child: Container(
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 0) {
                    currentdiretion = snake_diection.DOWN;
                  } else if (details.delta.dy < 0) {
                    currentdiretion = snake_diection.UP;
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx > 0) {
                    currentdiretion = snake_diection.RIGHT;
                  } else if (details.delta.dx < 0) {
                    currentdiretion = snake_diection.LEFT;
                  }
                },
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: rowsize),
                  itemCount: totalsize,
                  itemBuilder: (context, index) {
                    if (snakepos.contains(index)) {
                      return const SnakePixel();
                    } else if (foodpos == index) {
                      return const FoodPixel();
                    } else {
                      return const BlankPixel();
                    }
                  },
                ),
              ),
            ),
          ),

          //playbutton
          Expanded(
            child: Container(
                child: Center(
                    child: MyButton(
              text: "Play",
              onPressesd: startgame,
              started: gamehasstarted,
            ))),
          ),
        ],
      ),
    );
  }
}
