import 'package:flutter/material.dart';
import 'package:quiz_app/questions.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  TextEditingController searchController = TextEditingController();
  String searchedValue = '';
  int totalFound = 0;
  int foundTrue = 0;
  int foundFalse = 0;

  void updateCounts(String value) {
    searchedValue = value.toLowerCase();
    totalFound = 0;
    foundTrue = 0;
    foundFalse = 0;

    List<String> searchWords = searchedValue.split(" ").map((word) => word.trim()).toList();

    for (int index = 0; index < questions.length; index++) {
      String questionText = questions[index]['question'].toString().toLowerCase();
      bool containsAllWords = true;

      for (String searchWord in searchWords) {
        if (!questionText.contains(searchWord)) {
          containsAllWords = false;
          break; // If any word is not found, exit the inner loop
        }
      }

      if (containsAllWords) {
        totalFound++;
        questions[index]['answer'] == 'F' ? foundFalse++ : foundTrue++;
      }
    }
  }


  void searchButtonPressed() {
    updateCounts(searchController.text);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var controller = searchController;
    return Scaffold(
      appBar: AppBar(
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
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      if (controller.text.isEmpty) {
                        totalFound = 0;
                        foundTrue = 0;
                        foundFalse = 0;
                        searchController.clear();
                        searchedValue = value;
                        setState(() {});
                      }
                    },
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: 100,
                      margin: const EdgeInsets.only(left: 10, bottom: 10),
                      decoration: const BoxDecoration(color: Colors.purple),
                      child: TextButton(
                        onPressed: searchButtonPressed,
                        child: const Text(
                          'Search',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      width: 100,
                      margin: const EdgeInsets.only(left: 10),
                      decoration: const BoxDecoration(color: Colors.purple),
                      child: TextButton(
                        child: const Text(
                          'Clear',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          controller.clear();
                          setState(() {
                            searchedValue = '';
                            totalFound = 0;
                            foundTrue = 0;
                            foundFalse = 0;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: '${totalFound.toString()} question found  ',
              style: const TextStyle(
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: '${foundFalse.toString()} false  ',
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
                TextSpan(
                  text: '${foundTrue.toString()} veri',
                  style: const TextStyle(
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index]['question'].toString();
                final answer = questions[index]['answer'].toString();
                final image = questions[index]['image'].toString();

                final questionText = question.toLowerCase();
                final searchText = searchedValue.toLowerCase();
                final searchWords = searchText.split(" ").map((word) => word.trim()).toList();

                // Check if all search words are present in the question text
                bool containsAllWords = true;
                for (String searchWord in searchWords) {
                  if (!questionText.contains(searchWord)) {
                    containsAllWords = false;
                    break; // If any word is not found, exit the loop
                  }
                }

                if (searchText.isEmpty || containsAllWords) {
                  return QuizWidget(
                    question: question,
                    answer: answer,
                    image: image,
                    highlightedText: searchedValue,
                  );
                } else {
                  // If the question does not match the search criteria, return an empty container
                  return Container();
                }
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
    super.key,
    required this.question,
    required this.answer,
    required this.highlightedText,
    this.image,
  });
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
                width:
                16.0), // Add spacing between icon and text
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
                      color: widget.answer == 'F' ? Colors.red : Colors.green,
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
    // Split the query into lowercase words and remove leading/trailing spaces
    print("Query: $query");
    List<String> queryWords = query.toLowerCase().trim().split(" ");
    print("Query Words: $queryWords");

    List<TextSpan> textSpans = [];
    List<String> sentenceWords = sentence.toLowerCase().split(" ");

    for (String sentenceWord in sentenceWords) {
      final wordLower = sentenceWord.trim().toLowerCase();

      // Check if the word contains any of the query words
      bool isHighlighted = queryWords.any((queryWord) => wordLower.contains(queryWord));

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

      textSpans.add(const TextSpan(text: ' ')); // Add a space between words.
    }

    return RichText(
      text: TextSpan(
        children: textSpans,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }


}
