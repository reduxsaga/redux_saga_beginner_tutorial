import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'actions.dart';
import 'reducer.dart';

void main() {
  // Create store and apply middleware
  final store = Store(
    counterReducer,
    initialState: 0,
  );

  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store store;

  MyApp({required this.store}) : super();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
        store: store,
        child: MaterialApp(
          title: 'Redux Saga Counter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: MyHomePage(title: 'Flutter Redux Saga Counter Demo'),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({required this.title}) : super();

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            StoreConnector<dynamic, String>(
              converter: (store) => store.state.toString(),
              builder: (context, count) {
                return new Text(
                  count,
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            ),
            ElevatedButton(
              onPressed: () => StoreProvider.of(context).dispatch(IncrementAction()),
              child: Text('Increase'),
            ),
            ElevatedButton(
              onPressed: () => StoreProvider.of(context).dispatch(DecrementAction()),
              child: Text('Decrease'),
            ),
            StoreConnector<dynamic, VoidCallback>(
              converter: (store) {
                return () {
                  if (store.state % 2 != 0) {
                    store.dispatch(IncrementAction());
                  }
                };
              },
              builder: (context, callback) {
                return ElevatedButton(
                  onPressed: callback,
                  child: Text('IncreamentIfOdd'),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => StoreProvider.of(context).dispatch(IncrementAction()),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
