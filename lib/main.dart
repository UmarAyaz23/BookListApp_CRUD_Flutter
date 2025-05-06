import 'package:flutter/material.dart';

void main() {
  runApp(const bookListCRUD());
}

class bookListCRUD extends StatelessWidget {
  const bookListCRUD({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book List CRUD',
      home: const homePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Book {
  String title;
  String author;

  Book({required this.title, required this.author});
}

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final List<Book> _bookList = [];

  void _addBook(Book book) {
    setState(() {
      _bookList.add(book);
    });
  }

  void _updateBook(Book book, int index) {
    setState(() {
      _bookList[index] = book;
    });
  }

  void _deleteBook(int index) {
    setState(() {
      _bookList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BOOK LIST CRUD', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueGrey,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: _bookList.length,
              itemBuilder: (BuildContext context, int index) {
                final book = _bookList[index];

                return GestureDetector(
                  onTap: () async {
                    final editedBook = await Navigator.push<Map<String, dynamic>>(
                      context, 
                      MaterialPageRoute(builder: (context) => editBookScreen(book: book, index: index))
                    );

                    if (editedBook != null) {
                      if (editedBook['action'] == 'update'){
                        _updateBook(editedBook['book'], editedBook['index']);
                      
                      } else {
                        _deleteBook(editedBook['index']);
                      }
                    }
                  },

                  child: Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.blueGrey,
                      )
                    ),
                    
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      
                      child: Column (
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Title: ${book.title}',
                            style: TextStyle(color: Colors.blueGrey, fontSize: 18, fontWeight: FontWeight.w300),
                          ),

                          const SizedBox(height: 3,),

                          Text(
                            'Author: ${book.author}',
                            style: TextStyle(color: Colors.blueGrey, fontSize: 14, fontWeight: FontWeight.w200),
                          ),
                        ]
                      )
                    ),
                  )
                );
              },
            ),
            
            const SizedBox(height: 20,),

            ElevatedButton(
              onPressed: () async {
                final newBook = await Navigator.push<Book>(context, MaterialPageRoute(builder: (context) => addNewBookScreen()));

                if (newBook != null) {
                  _addBook(newBook);
                }
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1))
              ),

              child: Text('Add a Book', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),)
            )
          ],
        )
      )
    );
  }
}


class addNewBookScreen extends StatefulWidget {
  const addNewBookScreen({super.key});

  @override
  State<addNewBookScreen> createState() => _addNewBookScreenState();
}

class _addNewBookScreenState extends State<addNewBookScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  void _addNewBook() {
    final title = _titleController.text.trim();
    final author = _authorController.text.trim();

    if (title.isNotEmpty && author.isNotEmpty) {
      final newBook = Book(title: title, author: author);
      Navigator.pop(context, newBook);
    
    } else if (title.isEmpty && author.isNotEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Missing Title'),));
    } else if (title.isNotEmpty && author.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Missing Author'),));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Missing Title & Author'),));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BOOK LIST CRUD', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueGrey,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.blueGrey, fontSize: 18, fontWeight: FontWeight.w300),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueGrey)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueGrey)
                )
              ),
            ),

            const SizedBox(height: 20,),

            TextField(
              controller: _authorController,
              decoration: InputDecoration(
                labelText: 'Author',
                labelStyle: TextStyle(color: Colors.blueGrey, fontSize: 18, fontWeight: FontWeight.w300),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueGrey)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueGrey)
                )
              ),
            ),

            const SizedBox(height: 20,),

            ElevatedButton.icon(
              onPressed: _addNewBook,
              label: const Text('Add Book', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w300)),
              icon: Icon(Icons.add, color: Colors.white, size: 20,),  
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1))
              ),
            )
          ],
        ),
      )
    );
  }
}


class editBookScreen extends StatefulWidget {
  final Book book;
  final int index;

  const editBookScreen({super.key, required this.book, required this.index});

  @override
  State<editBookScreen> createState() => _editBookScreenState();
}

class _editBookScreenState extends State<editBookScreen> {
  late TextEditingController _titleController;
  late TextEditingController _authorController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book.title);
    _authorController = TextEditingController(text: widget.book.author);
  }

  void _confirmEdit() {
    final updatedTitle = _titleController.text.trim();
    final updatedAuthor = _authorController.text.trim();

    if (updatedTitle.isNotEmpty && updatedAuthor.isNotEmpty) {
      final updatedBook = Book(title: updatedTitle, author: updatedAuthor);
      Navigator.pop(
        context, {
          'action': 'update',
          'book': updatedBook,
          'index': widget.index
        }
      );
    }
  }

  void _deleteBook() {
    Navigator.pop(
      context, {
        'action': 'delete',
        'index': widget.index,
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BOOK LIST CRUD', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueGrey,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.blueGrey, fontSize: 18, fontWeight: FontWeight.w300),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueGrey)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueGrey)
                )
              ),
            ),

            const SizedBox(height: 20,),

            TextField(
              controller: _authorController,
              decoration: InputDecoration(
                labelText: 'Author',
                labelStyle: TextStyle(color: Colors.blueGrey, fontSize: 18, fontWeight: FontWeight.w300),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueGrey)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueGrey)
                )
              ),
            ),

            const SizedBox(height: 20,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                ElevatedButton.icon(
                  onPressed: _confirmEdit,
                  label: const Text('Confirm', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w300)),
                  icon: Icon(Icons.check, color: Colors.white, size: 20,),  
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1))
                  ),
                ),

                ElevatedButton.icon(
                  onPressed: _deleteBook,
                  label: const Text('Delete', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w300)),
                  icon: Icon(Icons.delete, color: Colors.white, size: 20,),  
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1))
                  ),
                )
              ],
            )
          ],
        )
      )
    );
  }
}