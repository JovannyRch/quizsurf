import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:quizsurf/bloc/categorias_bloc.dart';
import 'package:quizsurf/models/categorias_model.dart';
import 'package:quizsurf/screens/add_categoria_screen.dart';

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
                  if (index == 0)
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => AddCategoriaScreen(),
                            );
                          },
                        ),
                        SizedBox(
                          width: 10.0,
                        )
                      ],
                    );

                  CategoriasModel categoria = snapshot.data[index - 1];
                  return Dismissible(
                    key: UniqueKey(),
                    child: ListTile(
                      title: Hero(
                        tag: '${categoria.id}',
                        child: Text(categoria.nombre),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.pushNamed(context, '/fichas',
                            arguments: {'categoria': snapshot.data[index - 1]});
                      },
                    ),
                    onDismissed: (index) {
                      print(index);
                    },
                  );
                },
                childCount: snapshot.hasData ? snapshot.data.length + 1 : 0,
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
