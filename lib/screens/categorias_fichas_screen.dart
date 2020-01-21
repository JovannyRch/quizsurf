import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:quizsurf/bloc/categorias_bloc.dart';
import 'package:quizsurf/models/categorias_model.dart';

class CategoriasFichasScreen extends StatelessWidget {
  CategoriasBloc _categoriasBloc = new CategoriasBloc();
  @override
  Widget build(BuildContext context) {
    _categoriasBloc.getDatos();
    /* _categoriasBloc.create(new CategoriasModel(
      nombre: 'Inglés',
      descripcion: 'Guía del primer parcial'
    ));
    _categoriasBloc.create(new CategoriasModel(
      nombre: 'Conceptos de programación',
      descripcion: 'Lista de conceptos para estudiar'
    ));
    _categoriasBloc.create(new CategoriasModel(
      nombre: 'Segundo parcial de inglés',
      descripcion: 'Tengo que estudiar chido'
    ));
    _categoriasBloc.create(new CategoriasModel(
      nombre: 'Arquitectura de computadoras',
      descripcion: 'Conceptos a estudiar para el examen'
    )); */
    double ancho = MediaQuery.of(context).size.width;
    double alto = MediaQuery.of(context).size.height;
    return Container(
        child: CustomScrollView(
      slivers: <Widget>[
        const SliverAppBar(
          floating: true,
          expandedHeight: 165,
          backgroundColor: Color(0xFFB4DDE3),
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              '',
              style: TextStyle(fontSize: 18.0, color: Colors.black),
              textAlign: TextAlign.left,
            ),
            background: Image(
              image: AssetImage('images/books2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        StreamBuilder(
          stream: _categoriasBloc.categorias,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  CategoriasModel categoria = snapshot.data[index];
                  print(categoria.nombre);
                  return Dismissible(
                    key: UniqueKey(),
                    child: ListTile(
                      title: Text(categoria.nombre),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.pushNamed(context, '/fichas',
                            arguments: {'categoria': categoria});
                      },
                    ),
                    confirmDismiss: (DismissDirection direction) async {
                      final bool res = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirmar"),
                            content: const Text("Eliminar la guía de estudio "),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                    this
                                        ._categoriasBloc
                                        .deleteData(categoria.id);
                                  },
                                  child: const Text("ELIMINAR")),
                              FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("CANCELAR"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (index) {
                      print("Eliminar");
                      print(categoria.id);
                      //this._categoriasBloc.deleteData(categoria.id);
                    },
                  );
                },
                childCount: snapshot.hasData ? snapshot.data.length : 0,
              ),
            );
          },
        ),
        /*  StreamBuilder(
          stream: _categoriasBloc.categorias ,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(!snapshot.data){
              return CircularProgressIndicator();
            }
            else{
              List<CategoriasModel> categorias = snapshot.data;
              if(categorias.length == 0){
                return Text("No hay categorias creadas");
              }
              else{
                return SliverFixedExtentList(
                  itemExtent: 150.0,
                  delegate: SliverChildListDelegate(
                    [
                      Container(color: Colors.red),
                      Container(color: Colors.purple),
                      Container(color: Colors.green),
                      Container(color: Colors.orange),
                      Container(color: Colors.yellow),
                      Container(color: Colors.pink),
                    ],
                  ),
                );
              }
            }
          },
        ), */
      ],
    ));
  }

  StreamBuilder<List<CategoriasModel>> buildCategoriasStream() {
    return StreamBuilder(
      stream: _categoriasBloc.categorias,
      builder: (BuildContext context,
          AsyncSnapshot<List<CategoriasModel>> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        var categorias = snapshot.data;
        if (categorias.length == 0) {
          return Text("No hay datos");
        }

        return buildListaFichas(categorias);
      },
    );
  }

  ListView buildListaFichas(List<CategoriasModel> categorias) {
    return ListView.builder(
        itemCount: categorias.length,
        itemBuilder: (BuildContext context, int index) {
          CategoriasModel ficha = categorias[index];
          return Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: FlipCard(
              direction: FlipDirection.VERTICAL, // default
              front: FichaComponent(texto: ficha.nombre),
              back: FichaComponent(texto: ficha.nombre),
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
