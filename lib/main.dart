import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

// Use arrow notation for one-line functions
// or methods
void main() => runApp(MyApp());

//StatelessWidget makes the app itself a widget
class MyApp extends StatelessWidget {
  @override
  //Build method describes how to display the widget
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: RandomWords(),
    );
  }
}

//Write 'stful' and accept the IDE suggestion to
//generate this class
class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  //Class for saving suggested word pairings
  final _suggestions = <WordPair>[];
  //Variable for making the font size larger.
  final _biggerFont = TextStyle(fontSize: 18.0);
  //To save favourites
  final _saved = Set<WordPair>();

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = _saved.map(
                (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        //Actions when the favourite button is pressed
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        //Callback called once per suggested word pairing,
        // to place it into a ListTile row
        itemBuilder:  (context, i) {
          // For odd rows add Divider widget to separate
          // the entries
          if (i.isOdd) return Divider();
          // Calculates the actual number of word pairings
          // in the ListView
          final index = i ~/ 2;
          //Generate 10 more and add them to the suggestions
          //list when the end of available words is reached
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }
  Widget _buildRow(WordPair pair) {
    //To check that a suggestion has not been added to favourites
    final alreadySaved = _saved.contains(pair);
    //To give a good format for each suggestion
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      // To add heart icons after the text
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
        //To interact with the favourite buttons
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        },
    );
  }

}

