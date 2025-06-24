import 'package:flutter/material.dart';
import 'package:unwrapper/unwrapper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Unwrapper Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool unwrap = false;

  void _unwrap() {
    setState(() {
      unwrap = !unwrap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            Unwrapper(
              unwrap: unwrap,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Text(
                  'Unwrap is ${unwrap ? "enabled" : "disabled"}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            Unwrapper(
              unwrap: unwrap,
              fallback: Text(
                'This is a fallback widget when unwrapping fails',
                style: TextStyle(color: Colors.red),
              ),
              child: FlutterLogo(),
            ),
            Unwrapper(
              unwrap: unwrap,
              resolver: (Widget child) {
                if (child is CustomWidget) {
                  // If the child is a CustomWidget, return its customChild
                  return child.customChild;
                }
                return null;
              },
              child: CustomWidget(
                color: Colors.lightBlueAccent,
                customChild: Text(
                  'This is a custom widget that can be unwrapped',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.blue,
                      ),
                ),
              ),
            ),
            Unwrapper(
              unwrap: unwrap,
              wrapperBuilder: (child) => ColoredBox(
                color: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: child,
                ),
              ),
              child: Container(
                color: Colors.green,
                child: Text(
                  'This container can be wrapped with padding',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _unwrap,
        tooltip: 'Wrap/Unwrap',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class CustomWidget extends StatelessWidget {
  final Color color;
  final Widget customChild;

  const CustomWidget({
    super.key,
    required this.customChild,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: customChild,
    );
  }
}
