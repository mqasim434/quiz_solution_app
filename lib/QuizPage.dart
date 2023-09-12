import 'package:flutter/material.dart';
import 'package:quiz_app/questions.dart';
import 'package:search_highlight_text/search_highlight_text.dart';


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

    for (int index = 0; index < questions.length; index++) {
      if ((questions[index]['question']).toString().toLowerCase().contains(searchedValue)) {
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
    return SearchTextInheritedWidget(
      searchText: searchController.text,
      child: Scaffold(
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
                      onChanged: (value){
                        if(controller.text.isEmpty){
                          totalFound = 0;
                          foundTrue = 0;
                          foundFalse = 0;
                          setState(() {

                          });
                        }
                      },
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: 100,
                        margin: const EdgeInsets.only(left: 10,bottom: 10),
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
                  if (searchController.text.isEmpty) {
                    print(questions.length);
                    return QuizWidget(
                        highlightedText: searchedValue,
                        question: (questions[index]['question']).toString(),
                        answer: (questions[index]['answer']).toString(),
                        image:  (questions[index]['image']).toString()
                    );
                  } else if (((questions[index]['question']).toString())
                      .toLowerCase()
                      .contains(searchedValue.toLowerCase())) {
                    return QuizWidget(
                      highlightedText: searchedValue,
                      question: (questions[index]['question']).toString(),
                      answer: (questions[index]['answer']).toString(),
                      image: (questions[index]['image']).toString(),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
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
                ? Container(width: 100,height: 100,color: Colors.white,)
                :
            Container(width:100,height: 100,child: Image(image: AssetImage(widget.image.toString()))),
            const SizedBox(
                width:
                16.0), // Add spacing between icon and text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.highlightedText.isEmpty
                      ? Text(widget
                      .question) // Display the entire question if no search term
                      : SearchHighlightText(
                    widget.question,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black, // Highlight color
                    ),
                    highlightStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      backgroundColor: Colors.pink,
                    ),
                  ),
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
}
