import wollok.game.*
import juego.*

class Boxeador{
    var vida = 100
    var estado = quieto
    var property rival

    method image() = "imagenes/" + self.tipo() + estado.nombre() + ".jpg" //la imagen se cambia sola según el estado

    method cambiarEstado(unEstado){
        estado = unEstado
    }

    method recibirGolpe(){
        vida = (vida - 10).max(0)
    }

    //revisar
    method atacar(){
      self.cambiarEstado(atacando)
      if (rival.estado() != cubriendo) rival.recibirGolpe()
      game.schedule(1000, {self.cambiarEstado(quieto)})
    }

    method tipo()
}

object boxeadorJugador inherits Boxeador{
    var property position = game.at(9,0)
    
    method initialize(){
        rival = "agregar rival aca" //el rival actual podría ser asignado al jugador por el nivel, así cambia en cada uno
    }

    override method tipo() = "boxeadorJugador"
}

object rocky inherits Boxeador{
    var property position = game.at(9,7)

    method initialize(){
        rival = boxeadorJugador
    }

    override method tipo() = "rocky"
}

object tyson inherits Boxeador{
    var property position = game.at(9,7)

    method initialize(){
        rival = boxeadorJugador
    }

    override method tipo() = "tyson"
}

//Estados

object quieto {
  method nombre() = "Quieto"
}

object atacando {
  method nombre() = "Atacando"
}

object atacandoEspecial {
  method nombre() = "AtacandoEspecial"
}

object cubriendo {
  method nombre() = "Cubriendo"
}

//Objeto para hacer pruebas hasta que funcione el sistema de niveles
object juegoDePrueba {
	
	method iniciar(){
		game.boardGround("imagenes/ring1.png")
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