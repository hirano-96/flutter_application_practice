import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  /*
  MyAppで定義したアプリを実行をFlutterに指示
  */
  runApp(MyApp());
}

/*
MyApp内のコードでアプリ全体をセットアップする
MyAppはStatelessWidgetを拡張している
StatelessWidgetは、すべてのFlutterアプリを作成する際のもとになる要素
*/
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

/*
MyAppStateはChangeNotifierを拡張している
ChangeNotifierは、Flutterの状態管理システムの一部
これにより、アプリの状態を管理し、変更を通知することができる
*/
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  /*
  current に新しいランダムな WordPair を再代入します。また、監視している MyAppState に通知するために notifyListeners()（ChangeNotifier) のメソッド）の呼び出しも行います。
  */
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  /*
  周囲の状況が変化するたびに自動的に呼び出される build() メソッドを定義
  →　ウィジェットを常に最新にするため
  */
  Widget build(BuildContext context) {
    /*
    MyHomePage では、watch メソッドを使用してアプリの現在の状態に対する変更を追跡
    */
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    /*
    Scaffoldは、Flutterの標準ウィジェット
    アプリのメインコンテンツを配置するためのコンテナ
    */
    return Scaffold(
      /*Column は、Flutter における非常に基本的なレイアウト ウィジェットです。任意の数の子を従え、それらを上から下へ一列に配置します。デフォルトでは、その子を上に寄せる
      */
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*
            この 2 つ目の Text ウィジェットは appState を取り、そのクラスの唯一のメンバーである current（WordPair）にアクセスします。WordPair には、asPascalCase や asSnakeCase などの便利なゲッターがあります。ここでは asLowerCase を利用しますが、これは別のものに変えても構いません。
            */
            BigCard(pair: pair),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                appState.getNext();
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: style,
        ),
      ),
    );
  }
}
