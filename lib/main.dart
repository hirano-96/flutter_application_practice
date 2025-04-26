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

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

// class MyHomePage extends StatelessWidget {
//   @override
//   /*
//   周囲の状況が変化するたびに自動的に呼び出される build() メソッドを定義
//   →　ウィジェットを常に最新にするため
//   */
//   Widget build(BuildContext context) {
//     /*
//     MyHomePage では、watch メソッドを使用してアプリの現在の状態に対する変更を追跡
//     */
//     var appState = context.watch<MyAppState>();
//     var pair = appState.current;

//     IconData icon;
//     if (appState.favorites.contains(pair)) {
//       icon = Icons.favorite;
//     } else {
//       icon = Icons.favorite_border;
//     }

//     /*
//     Scaffoldは、Flutterの標準ウィジェット
//     アプリのメインコンテンツを配置するためのコンテナ
//     */
//     return Scaffold(
//       /*Column は、Flutter における非常に基本的なレイアウト ウィジェットです。任意の数の子を従え、それらを上から下へ一列に配置します。デフォルトでは、その子を上に寄せる
//       */
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             /*
//             この 2 つ目の Text ウィジェットは appState を取り、そのクラスの唯一のメンバーである current（WordPair）にアクセスします。WordPair には、asPascalCase や asSnakeCase などの便利なゲッターがあります。ここでは asLowerCase を利用しますが、これは別のものに変えても構いません。
//             */
//             BigCard(pair: pair),
//             SizedBox(height: 10),
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     appState.toggleFavorite();
//                   },
//                   icon: Icon(icon),
//                   label: Text('Like'),
//                 ),
//                 SizedBox(width: 10),
//                 ElevatedButton(
//                   onPressed: () {
//                     appState.getNext();
//                   },
//                   child: Text('Next'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ...

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            /*
              SafeArea は、デバイスのディスプレイの端からの安全な領域を確保するウィジェット
              */
            SafeArea(
              child: NavigationRail(
                /*
                  extended: false の行は true に変更できます。そうすることで、アイコンの隣のラベルが表示されます。
                  */
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                ],
                /*
                  選択されたインデックスを示す整数値を指定します。
                  */
                selectedIndex: selectedIndex,
                /*
                  デスティネーションのうち１つが選択されたときに何が起こるか定義
                  */
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            /*
              Expanded は、ウィジェットの幅を最大化します。
              */
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

/*
MyHomePage のすべての内容が新しいウィジェット GeneratorPage に抽出されています。MyHomePage ウィジェットの中で抽出されていないのは Scaffold だけ
*/
class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
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

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}
