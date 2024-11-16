import wollok.game.*
import juego.*

class Boxeador{
    var vida = 100
    var imagenBoxeador
    var estado = quieto
    var property rival

    method image() = imagenBoxeador
    
    method cambiarEstado(unEstado){
        estado = unEstado
        imagenBoxeador = estado.imagenPara(self)
    }

    method recibirGolpe(){
        vida = (vida - 10).max(0)
    }

    method atacar(){
      self.cambiarEstado(atacando)
      estado.imagenPara(self)
      if (rival.estado() != cubriendo) rival.recibirGolpe()
      game.schedule(1000, { // el game.schedule(milliseconds, action) pienso que es mejor que el onTick, porque atacamos, y despues de 1 segundo volvemos a estar quietos
        self.cambiarEstado(quieto)
        estado.imagenPara(self)
      })
    }

}

object boxeadorJugador inherits Boxeador{
    var property position = game.at(9,0)
    
    method initialize(){
        imagenBoxeador = self.imagenDeQuieto()
        rival = "agregar rival aca"
    }

    //Imagenes
    method imagenDeAtaque() = "imagenes/boxeadorJugadorAtaque.JPG"
    method imagenDeCobertura() = "imagenes/boxeadorJugadorCobertura.JPG"
    method imagenDeQuieto() = "imagenes/boxeadorJugador.jpg"
    method imagenDeAtaqueEspecial() = "imagenes/boxeadorJugadorAtaqueEspecial.JPG"
}

object rocky inherits Boxeador{

  method
}

object tyson inherits Boxeador{

}

//Estados

object quieto {
  method imagenPara(boxeador) = boxeador.imagenDeQuieto()
}

object atacando {
  method imagenPara(boxeador) = boxeador.imagenDeAtaque()
}

object atacandoEspecial {
  method imagenPara(boxeador) = boxeador.imagenDeAtaqueEspecial()
}

object cubriendo {
  method imagenPara(boxeador) = boxeador.imagenDeCobertura()
}