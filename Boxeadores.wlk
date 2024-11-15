import wollok.game.*

class Boxeador{
    var vida = 100
    var imagenBoxeador
    var estado = quieto
    
    method cambiarEstado(unEstado){
        estado = unEstado
        imagenBoxeador = estado.imagenPara(self)
    }

    method recibirGolpe(){
        vida = (vida - 10).max(0)
    }
}

object juego {
	
	method iniciar(){
		game.boardGround("ring1.png")
		game.height(19)
		game.width(19)
		game.title("Punch out")
		self.personajes()		
		game.start()
	}
	method personajes() {
		game.addVisual(boxeadorJugador)
		keyboard.z().onPressDo{boxeadorJugador.cambiarEstado(atacando)}
		keyboard.x().onPressDo{boxeadorJugador.cambiarEstado(cubriendo)}
		keyboard.c().onPressDo{boxeadorJugador.cambiarEstado(atacandoEspecial)}
	}
}

object boxeadorJugador inherits Boxeador{
    var property position = game.at(9,0)
    
    method initialize(){
        imagenBoxeador = self.imagenDeQuieto()
    }
    
    method image() = imagenBoxeador

    //Imagenes
    method imagenDeAtaque() = "imagenes/boxeadorJugadorAtaque.JPG"
    method imagenDeCobertura() = "imagenes/boxeadorJugadorCobertura.JPG"
    method imagenDeQuieto() = "imagenes/boxeadorJugador.jpg"
    method imagenDeAtaqueEspecial() = "imagenes/boxeadorJugadorAtaqueEspecial.JPG"
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