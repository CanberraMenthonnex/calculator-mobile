import 'package:calculator/res/colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: ValueNotifier(GraphQLClient(
          link: HttpLink(
              'https://damp-waterfall.eu-central-1.aws.cloud.dgraph.io/graphql'),
          cache: GraphQLCache())),
      child: MaterialApp(
        title: 'Pokédex',
        theme: ThemeData(
          primaryColor: AppColors.inputContainerBackground,
          accentColor: AppColors.displayContainerBackground,
          primaryColorBrightness: Brightness.light,
        ),
        home: Pokedex(),
      ),
    );
  }
}



class Pokedex extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return Query(
       options: QueryOptions(document: gql('''
        query MyQuery {
        queryPokemon {
          id
          name
        }
        }
              ''')),
       builder: (QueryResult result,
           {Refetch? refetch, FetchMore? fetchMore}) {
         if (result.hasException) {
           return Text('Error');
         } else if (result.isLoading) {
           return Text('Loading');
         }

         List pokemons = (result.data as Map)['queryPokemon'] as List;

         return Scaffold(
           body: ListView.builder(
             itemBuilder: (BuildContext context, int position) {
               var pokemon = pokemons[position];

               return GraphQLConsumer(
                 builder: (GraphQLClient client) {
                   return ListTile(
                     leading: CircleAvatar(
                       child: Image.network(pokemon['imgUrl']),
                       backgroundColor: AppColors.white,
                     ),
                     title: Text(pokemon['name']),
                   );
                 },
               );
             },
             itemCount: pokemons.length,
           ),
         );
       });
 }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class InputButton extends StatelessWidget {
  final String label;
  final ValueChanged<String>? onTap;

  InputButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(label),
      child: Ink(
        height: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.white, width: 0.5),
            color: AppColors.inputContainerBackground),
        child: Center(
          child: Text(
            label,
          ),
        ),
      ),
    );
  }
}

class _CalculatorState extends State<Calculator> {
  @override
  double? input;
  double? previousInput;
  String? symbol;

  static const List<List<String>> grid = <List<String>>[
    <String>["7", "8", "9", "-"],
    <String>["4", "5", "6", "*"],
    <String>["1", "2", "3", "/"],
    <String>["0", ".", "=", "+"],
  ];

  void onItemClicked(String value) {
    print('On Click $value');

    switch (value) {
      case '0':
      case '1':
      case '2':
      case '3':
      case '4':
      case '5':
      case '6':
      case '7':
      case '8':
      case '9':
        onNewDigit(value);
        break;
      case '+':
      case '-':
      case '/':
      case '*':
        onNewSymbol(value);
        break;
      case '=':
        onEquals();
    }

    // Force l'interface à se redessiner
    setState(() {});
  }

  void onNewDigit(String digit) {
    // TODO
  }

  void onNewSymbol(String digit) {
    // TODO
  }

  void onEquals() {
    // TODO
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTextStyle(
        style: TextStyle(color: AppColors.white, fontSize: 22.0),
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: Container(
                color: AppColors.displayContainerBackground,
                alignment: AlignmentDirectional.centerEnd,
                padding: const EdgeInsets.all(22.0),
                child: Text(input?.toString() ?? "0"),
              ),
            ),
            Flexible(
              flex: 8,

              // Column = vertical
              child: Column(
                // Pour chaque nouvelle ligne, on itère sur chaque cellule
                children: grid.map((List<String> line) {
                  return Expanded(
                    child: Row(
                        children: line
                            .map(
                              (String cell) => Expanded(
                                child: InputButton(
                                  label: cell,
                                  onTap: onItemClicked,
                                ),
                              ),
                            )
                            .toList(growable: false)),
                  );
                }).toList(growable: false),
              ),
            )
          ],
        ),
      ),
    );
  }
}
