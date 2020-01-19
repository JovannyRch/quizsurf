import 'package:flutter/material.dart';
import 'package:quizsurf/bloc/fichas_bloc.dart';
import 'package:quizsurf/models/fichas_model.dart';
import 'package:flip_card/flip_card.dart';

class FichasScreen extends StatelessWidget {
  FichasBloc _fichasBloc = new FichasBloc();
  @override
  Widget build(BuildContext context) {
    _fichasBloc.getDatos();
    /* _fichasBloc.create(new FichasModel(
      tema: 'Concepto 6',
      concepto: 'Proident mollit amet deserunt ipsum.'
    )); */
    double ancho = MediaQuery.of(context).size.width;
    double alto = MediaQuery.of(context).size.height;
    return SafeArea(
        child: CustomScrollView(
      slivers: <Widget>[
        const SliverAppBar(
          pinned: true,
          expandedHeight: 200.0,
          backgroundColor: Colors.black,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: false,
            title: Text(
              'Mis fichas',
              style: TextStyle(fontSize: 25.0),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 4.0,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                alignment: Alignment.center,
                color: Colors.teal[100 * (index % 9)],
                child: Text('Grid Item $index'),
              );
            },
            childCount: 20,
          ),
        ),
        SliverFixedExtentList(
          itemExtent: 50.0,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                alignment: Alignment.center,
                color: Colors.lightBlue[100 * (index % 9)],
                child: Text('List Item $index'),
              );
            },
          ),
        ),
      ],
    ));
  }

  StreamBuilder<List<FichasModel>> buildFichasStream() {
    return StreamBuilder(
      stream: _fichasBloc.fichas,
      builder:
          (BuildContext context, AsyncSnapshot<List<FichasModel>> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        var fichas = snapshot.data;
        if (fichas.length == 0) {
          return Text("No hay datos");
        }

        return buildListaFichas(fichas);
      },
    );
  }

  ListView buildListaFichas(List<FichasModel> fichas) {
    return ListView.builder(
        itemCount: fichas.length,
        itemBuilder: (BuildContext context, int index) {
          FichasModel ficha = fichas[index];
          return Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: FlipCard(
              direction: FlipDirection.VERTICAL, // default
              front: FichaComponent(texto: ficha.tema),
              back: FichaComponent(texto: ficha.concepto),
            ),
          );
        });
  }
}

class FichaComponent extends StatelessWidget {
  const FichaComponent({
    Key key,
    @required this.texto,
  }) : super(key: key);
  final String texto;

  @override
  Widget build(BuildContext context) {
    final alto = MediaQuery.of(context).size.height;
    return Card(
      child: Container(
        color: Colors.blueGrey.withOpacity(0.1),
        height: alto * 0.25,
        child: Center(
          child: Text(
            texto,
            style: TextStyle(fontSize: alto * 0.04),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
