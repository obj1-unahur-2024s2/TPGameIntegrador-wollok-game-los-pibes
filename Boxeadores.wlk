import wollok.game.*

class Boxeador{
    var vida = 100
    var imagenBoxeador

    method pegar(){

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
		keyboard.z().onPressDo{boxeadorJugador.ataque()}
		keyboard.x().onPressDo{boxeadorJugador.cubrir()}
		keyboard.c().onPressDo{boxeadorJugador.ataqueEspecial()}
	}
}

object boxeadorJugador inherits Boxeador{
    var property position = game.at(9,0)

    method initialize(){
        imagenBoxeador = "jugadorBoxeador.JPG"
    }
    
    method image() = imagenBoxeador

    method ataque(){
        imagenBoxeador = "jugadorBoxeadorAtaque.JPG"
    }
    method cubrir(){

    }
    method ataqueEspecial(){

    }
}

