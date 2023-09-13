import 'package:flutter/material.dart';
import 'package:quiz_app/questions.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  TextEditingController searchController = TextEditingController();
  String searchedValue = '';

  List<Map<String, dynamic>> questionsToShow = List.from(questions);

  void updateCounts(String value) {
    searchedValue = value.toLowerCase();

    List<Map<String, dynamic>> questionsWithAnswerV = [];
    List<Map<String, dynamic>> questionsWithAnswerF = [];

    List<String> searchWords = searchedValue.split(" ").map((word) => word.trim()).toList();

    for (int index = 0; index < questions.length; index++) {
      String questionText = questions[index]['question'].toString().toLowerCase();
      bool containsAllWords = true;

      for (String searchWord in searchWords) {
        if (!questionText.contains(searchWord)) {
          containsAllWords = false;
          break;
        }
      }

      if (containsAllWords) {
        if (questions[index]['answer'] == 'V') {
          questionsWithAnswerV.add(questions[index]);
        } else if (questions[index]['answer'] == 'F') {
          questionsWithAnswerF.add(questions[index]);
        }
      }
    }

    // Sort the lists based on the number of questions containing each answer
    questionsWithAnswerV.sort((a, b) {
      return a['answer'] == 'V' ? -1 : 1;
    });

    // Combine the lists in the desired order
    questionsToShow.clear();
    if (questionsWithAnswerV.length <= questionsWithAnswerF.length) {
      questionsToShow.addAll(questionsWithAnswerV);
      questionsToShow.addAll(questionsWithAnswerF);
    } else {
      questionsToShow.addAll(questionsWithAnswerF);
      questionsToShow.addAll(questionsWithAnswerV);
    }
  }

  @override
  Widget build(BuildContext context) {
    var controller = searchController;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Quiz Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                    ),
                    onChanged: (value) {
                      updateCounts(value);
                      setState(() {
                        if(value.isEmpty){
                          questionsToShow = List.from(questions);

                        }
                      });
                    },
                  ),
                ),
                Container(
                  width: 70,
                  margin: const EdgeInsets.only(left: 10),
                  decoration: const BoxDecoration(color: Colors.red),
                  child: TextButton(
                    child: const Text(
                      'Clear',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      controller.clear();
                      setState(() {
                        searchedValue = '';
                        questionsToShow.clear();
                        questionsToShow.addAll(questions); // Restore original list
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text:  controller.text.isEmpty? ' 0 questions found':'${questionsToShow.length} questions found',
              style: const TextStyle(
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: controller.text.isEmpty? ' 0 veri':'  ${questionsToShow.where((q) => q['answer'] == 'V').length} veri',
                  style: const TextStyle(
                    color: Colors.green,
                  ),
                ),
                TextSpan(
                  text: controller.text.isEmpty? ' 0 falso':'  ${questionsToShow.where((q) => q['answer'] == 'F').length} falso',
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: questionsToShow.length,
              itemBuilder: (context, index) {
                final question = questionsToShow[index]['question'].toString();
                final answer = questionsToShow[index]['answer'].toString();
                final image = questionsToShow[index]['image'].toString();

                return QuizWidget(
                  question: question,
                  answer: answer,
                  image: image,
                  highlightedText: searchedValue,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class QuizWidget extends StatefulWidget {
  QuizWidget({
    Key? key,
    required this.question,
    required this.answer,
    required this.highlightedText,
    this.image,
  }) : super(key: key);

  final String question;
  final String answer;
  String? image;
  final String highlightedText;

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.image.toString() == "noImage"
                ? Container(width: 100, height: 100, color: Colors.white)
                : Container(
              width: 100,
              height: 100,
              child: Image(image: AssetImage(widget.image.toString())),
            ),
            const SizedBox(
              width: 16.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.highlightedText.isEmpty
                      ? Text(widget.question)
                      : highlightText(widget.question, widget.highlightedText),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.answer,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                      widget.answer == 'F' ? Colors.red : Colors.green,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget highlightText(String sentence, String query) {
    List<String> queryWords = query.toLowerCase().trim().split(" ");
    List<TextSpan> textSpans = [];
    List<String> sentenceWords = sentence.toLowerCase().split(" ");

    for (String sentenceWord in sentenceWords) {
      final wordLower = sentenceWord.trim().toLowerCase();
      bool isHighlighted =
      queryWords.any((queryWord) => wordLower.contains(queryWord));

      if (isHighlighted) {
        textSpans.add(
          TextSpan(
            text: sentenceWord,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              backgroundColor: Colors.pink,
            ),
          ),
        );
      } else {
        textSpans.add(
          TextSpan(
            text: sentenceWord,
          ),
        );
      }

      textSpans.add(const TextSpan(text: ' '));
    }

    return RichText(
      text: TextSpan(
        children: textSpans,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
