import 'package:flutter/material.dart';
import 'package:quizsurf/bloc/fichas_bloc.dart';
import 'package:quizsurf/models/categorias_model.dart';
import 'package:quizsurf/models/fichas_model.dart';
import 'package:flip_card/flip_card.dart';
import 'package:quizsurf/screens/add_ficha_screen.dart';

class FichasScreen extends StatelessWidget {
  FichasBloc _fichasBloc;
  CategoriasModel categoria;
  double ancho;
  double alto;
  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    categoria = data['categoria'];
    _fichasBloc = new FichasBloc();
    _fichasBloc.id_categoria = categoria.id;
    _fichasBloc.getDatos();
    print(categoria.nombre);
    print(categoria.id);
    /*  _fichasBloc.create(new FichasModel(
      tema: 'Concepto 1',
      concepto: 'Proident mollit amet deserunt ipsum.',
      id_categoria: 1
    )); */
    ancho = MediaQuery.of(context).size.width;
    alto = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: '${categoria.id}',
          child: Text(categoria.nombre),
        ),
      ),
      body: buildFichasStream(),
    );
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: this.alto * 0.10),
              Center(
                child: Text(
                  "Aún no has creado ninguna tarjeta",
                  style: TextStyle(fontSize: this.alto * 0.04),
                  textAlign: TextAlign.center,
                ),
              ),
              Center(
                child: Text(
                  "😱",
                  style: TextStyle(fontSize: this.alto * 0.1),
                ),
              ),
              SizedBox(
                height: this.alto * 0.1,
              ),
              Center(
                child: Text(
                  "Agrega tu primera tarjeta 😏",
                  style: TextStyle(
                    fontSize: this.alto * 0.05,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  this.showModal(context);
                },
              )
            ],
          );
        }

        return buildListaFichas(fichas);
      },
    );
  }

  ListView buildListaFichas(List<FichasModel> fichas) {
    return ListView.builder(
        itemCount: fichas.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0)
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    this.showModal(context);
                  },
                )
              ],
            );
          FichasModel ficha = fichas[index - 1];
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

  void showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => AddFichaScreen(id: this.categoria.id),
    );
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
