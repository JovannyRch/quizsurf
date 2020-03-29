import 'package:flutter/material.dart';
import 'package:quizsurf/bloc/fichas_bloc.dart';
import 'package:quizsurf/const/const.dart';
import 'package:quizsurf/models/categorias_model.dart';
import 'package:quizsurf/models/fichas_model.dart';
import 'package:flip_card/flip_card.dart';
import 'package:quizsurf/screens/add_ficha_screen.dart';
import 'package:quizsurf/screens/test_screen.dart';

class FichasScreen extends StatelessWidget {
  FichasBloc _fichasBloc;
  CategoriasModel categoria;
  double ancho;
  double alto;
  Widget opcionesFicha(BuildContext context, int id, FichasModel f) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.delete,
          ),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (builder) {
                  return Container(
                    height: alto * 0.45,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "¿Realmente quieres eliminar la tarjeta? 🧐",
                          style: TextStyle(color: kTextColor, fontSize: 17.0),
                          textAlign: TextAlign.center,
                        ),
                        RaisedButton(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)),
                          onPressed: () {
                            print("Eliminando ficha");
                            _fichasBloc.deleteData(f.id);
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Si",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        RaisedButton(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.grey)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "No",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                    padding: EdgeInsets.all(40.0),
                  );
                });
          },
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            this.showModal(context, f);
          },
        ),
        SizedBox(
          width: 20.0,
        )
      ],
    );
  }

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
      floatingActionButton: FloatingActionButton(
        backgroundColor: kTextColor,
        onPressed: () {
          this.showModal(context, new FichasModel());
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: kMainColor,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: this.alto * 0.1,
              ),
              Center(
                child: Text(
                  "Agrega tu primera tarjeta ",
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "😏",
                style: TextStyle(
                  fontSize: 60.0,
                ),
              )
            ],
          );
        }

        return buildListaFichas(context, fichas);
      },
    );
  }

  ListView buildListaFichas(BuildContext context, List<FichasModel> fichas) {
    return ListView.builder(
        itemCount: fichas.length + 2,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Container(
                width: 80.0,
                child: Column(children: [
                  RaisedButton(
                    color: kTextColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      //side: BorderSide(color: kRosaColor),
                    ),
                    child: Text(
                      "Crear un Test 🤓",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                    onPressed: () {
                      if (fichas.length < 5) {
                        final scaffold = Scaffold.of(context);
                        scaffold.showSnackBar(
                          SnackBar(
                            content: const Text(
                                'Se necesitan 5 fichas para crear el test 🤭'),
                          ),
                        );
                      } else {
                        //Ir al test
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TestScreen(
                                    categoriaId: categoria.id,
                                    nombreCategoria: categoria.nombre,
                                  )),
                        );
                      }
                    },
                  ),
                ]));
          }
          if (index == 1)
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                      "${fichas.length} ${fichas.length == 1 ? 'Ficha' : 'Fichas'}")
                ],
              ),
            );
          FichasModel ficha = fichas[index - 2];
          print(ficha);
          return Column(
            children: <Widget>[
              opcionesFicha(context, categoria.id, ficha),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: FlipCard(
                  direction: FlipDirection.VERTICAL, // default
                  front: FichaComponent(
                    texto: Text(
                      ficha.tema,
                      style: TextStyle(
                        fontSize: alto * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    tipo: 0,
                  ),
                  back: FichaComponent(
                    texto: Text(
                      ficha.concepto,
                      style: TextStyle(fontSize: alto * 0.03),
                      textAlign: TextAlign.center,
                    ),
                    tipo: 1,
                  ),
                ),
              ),
            ],
          );
        });
  }

  void showModal(BuildContext context, FichasModel f) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      builder: (context) => AddFichaScreen(id: this.categoria.id, ficha: f),
    );
  }
}

class FichaComponent extends StatelessWidget {
  const FichaComponent({Key key, @required this.texto, this.tipo})
      : super(key: key);
  final Text texto;
  final int tipo;
  @override
  Widget build(BuildContext context) {
    final alto = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
        20.0,
      )),
      padding: EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 5.0,
      ),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              20.0,
            ),
            color: tipo == 1
                ? Colors.blueGrey.withOpacity(0.1)
                : kTextColor.withOpacity(0.2),
          ),
          height: alto * 0.25,
          child: Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    tipo == 0 ? 'Palabra o ídea' : 'Definicíon',
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              Expanded(
                  child: Center(
                child: texto,
              ))
            ],
          )),
    );
  }
}
