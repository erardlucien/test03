import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Person {
  final String _name;
  final String _surname;
  final int _age;
  final Icon _avatar;
  Person(this._name, this._surname, this._age, this._avatar);
}

class PersonDetail extends StatelessWidget {
  const PersonDetail(
      {required this.person, required this.onPressed, super.key});
  final Person person;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // create a cardview from a person
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.lightBlueAccent[100],
          border: Border.all(color: Colors.blue.shade700, width: 1.2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.blueAccent.shade100,
                    borderRadius: BorderRadius.circular(30)),
                child: person._avatar,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${person._name}'),
                    Text('Surname: ${person._surname}'),
                    Text('Age: ${person._age}'),
                  ],
                ),
              ),
            ],
          ),
          FloatingActionButton(
            onPressed: onPressed,
            elevation: 0,
            mini: true,
            tooltip: 'delete',
            backgroundColor: Colors.transparent,
            shape: const CircleBorder(),
            child: const Icon(Icons.clear, size: 25, color: Colors.red),
          ),
        ],
      ),
    );
  }
}

mixin PersonList {
  static const List<Icon> avatars = [
    Icon(Icons.person, size: 25, color: Colors.white),
    Icon(Icons.person_2, size: 25, color: Colors.white)
  ];
  static List<Person> persons = [
    Person('Loic', 'Mustermann', 36, PersonList.avatars[0]),
    Person('Siri', 'Musterfrau', 45, PersonList.avatars[1]),
    Person('Max', 'Mustermann', 26, PersonList.avatars[0]),
    Person('Ingrid', 'Musterfrau', 18, PersonList.avatars[1]),
    Person('Micheal', 'Mustermann', 56, PersonList.avatars[0]),
    Person('Viviane', 'Musterfrau', 65, PersonList.avatars[1]),
    Person('Tom', 'Mustermann', 23, PersonList.avatars[0]),
    Person('Cindia', 'Musterfrau', 28, PersonList.avatars[1]),
  ];
}

Text msg = const Text('');

class ListPersonDetail extends StatefulWidget {
  const ListPersonDetail({required this.list, super.key});
  final List<Person> list;

  @override
  State<ListPersonDetail> createState() => _ListPersonDetailState();
}

class _ListPersonDetailState extends State<ListPersonDetail> {
  int _counter = 0;
  int _deletedCounter = 0;

  void msgState() {
    setState(() {
      msg;
    });
  }

  Future<Set<Text>> delay() async {
    return await Future.delayed(
        const Duration(seconds: 2), () => {msg = const Text('')});
  }

  void _removePerson(int index) async {
    setState(() {
      Person person = widget.list[index];
      widget.list.removeAt(index);
      ++_deletedCounter;
      msg = Text(
        '${person._name}, ${person._surname} was removed!'
        '\n deletedCounter := $_deletedCounter',
        style: const TextStyle(fontSize: 15, color: Colors.white),
      );
    });
    await delay();
    msgState();
  }

  void _addPerson() async {
    setState(() {
      if (_deletedCounter == PersonList.persons.length) {
        _counter = 0;
        _deletedCounter = 0;
      }

      if(_deletedCounter > -1) {
        msg = const Text(
            'deletedCounter must be 8,\nif you want to add a element!',
            style: TextStyle(fontSize: 15, color: Colors.white));
      }

      if (_counter >= 0 && _counter < PersonList.persons.length) {
        msg = Text(
            '${PersonList.persons[_counter]._name}, ${PersonList.persons[_counter]._surname} was added!'
            '\n counter := ${_counter + 1}',
            style: const TextStyle(fontSize: 15, color: Colors.white));
        widget.list.add(PersonList.persons[_counter]);
        ++_counter;
      }
    });
    await delay();
    msgState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ListView.builder(
            itemCount: widget.list.length + 1,
            itemBuilder: (context, index) {
              return index < widget.list.length
                  ? PersonDetail(
                      person: widget.list[index],
                      onPressed: () => _removePerson(index))
                  : const SizedBox(
                      width: 100,
                      height: 100,
                    );
            }),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: msg.data != ''
                    ? const EdgeInsets.all(10)
                    : const EdgeInsets.all(0),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20)),
                child: msg,
              ),
              FloatingActionButton(
                onPressed: _addPerson,
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                tooltip: 'add',
                child: const Icon(
                  Icons.add,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PersonAdder extends StatelessWidget {
  const PersonAdder({super.key});

  @override
  Widget build(BuildContext context) {
    return ListPersonDetail(list: List.empty(growable: true));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'test03 revisited',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent)),
      home: Scaffold(
        appBar: AppBar(title: const Text('test03_1')),
        body: const PersonAdder(),
      ),
    );
  }
}
