import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/home_page.dart';

//ignore: must_be_immutable
class GamePage extends StatefulWidget {
  // const GamePage({super.key});
  String player1;
  String player2;
  GamePage({required this.player1, required this.player2});
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late List<List<String>> _board;
  late String _currentPlayer;
  late String _winner;
  late bool _gameOver;
  @override
  void initState() {
    super.initState();
    _board = List.generate(3, (_) => List.generate(3, (_) => ''));
    _currentPlayer = "X";
    _winner = "";
    _gameOver = false;
  }

  void resetGame() {
    setState(() {
      _board = List.generate(3, (_) => List.generate(3, (_) => ''));
      _currentPlayer = "X";
      _winner = "";
      _gameOver = false;
    });
  }

  void makeMove(int row, int col) {
    if (_board[row][col] != "" || _gameOver) {
      return;
    }
    setState(() {
      _board[row][col] = _currentPlayer;

      if (_board[row][0] == _currentPlayer &&
          _board[row][1] == _currentPlayer &&
          _board[row][2] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      } else if (_board[0][col] == _currentPlayer &&
          _board[1][col] == _currentPlayer &&
          _board[2][col] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      } else if (_board[0][0] == _currentPlayer &&
          _board[1][1] == _currentPlayer &&
          _board[2][2] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      }
      _currentPlayer = _currentPlayer == "X" ? "O" : "X";

      if (!_board.any((row) => row.any((cell) => cell == ""))) {
        _gameOver = true;
        _winner = "It is a Tie";
      }
      if (_winner != "") {
        AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.rightSlide,
            btnOkText: "Play Again",
            title: _winner == "X"
                ? widget.player1 + " Won!"
                : _winner == "O"
                    ? widget.player2 + " Won!"
                    : "It is a Tie",
            btnOkOnPress: () {
              resetGame();
            }).show();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              gap70(),
              turnName(),
              gap20(),
              preboxMaker(),
              gap15(),
              finalbtns(context)
            ],
          ),
        ));
  }

  Row finalbtns(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        resetgame1(),
        restartgame2(context),
      ],
    );
  }

  InkWell restartgame2(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
        widget.player1 = "";
        widget.player2 = "";
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 255, 255, 255),
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: const Text(
          "Restart Game",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  InkWell resetgame1() {
    return InkWell(
      onTap: resetGame,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 255, 255, 255),
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: const Text(
          "Reset Game",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  SizedBox gap15() {
    return const SizedBox(
      height: 15,
    );
  }

  Container preboxMaker() {
    //The error is in this method
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 53, 53, 53),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.all(5),
      child: GridView.builder(
          itemCount: 9,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (context, index) {
            int row = index ~/ 3;
            int col = index % 3;
            return GestureDetector(
              onTap: () => makeMove(row, col),
              child: boxMaker(row, col),
            );
          }),
    );
  }

  Container boxMaker(int row, int col) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 0, 0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          _board[row][col],
          style: TextStyle(
              fontSize: 120,
              fontWeight: FontWeight.bold,
              color: _board[row][col] == "X"
                  ? const Color.fromARGB(255, 255, 17, 0)
                  : const Color.fromARGB(255, 0, 134, 243)),
        ),
      ),
    );
  }

  SizedBox gap20() {
    return const SizedBox(
      height: 20,
    );
  }

  SizedBox turnName() {
    return SizedBox(
      height: 120,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Turn :",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                _currentPlayer == "X"
                    ? widget.player1 + " " + "($_currentPlayer)"
                    : widget.player2 + " " + "($_currentPlayer)",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: _currentPlayer == "X"
                        ? const Color.fromARGB(255, 255, 17, 0)
                        : const Color.fromARGB(255, 0, 140, 255)),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  SizedBox gap70() {
    return const SizedBox(
      height: 70,
    );
  }
}
