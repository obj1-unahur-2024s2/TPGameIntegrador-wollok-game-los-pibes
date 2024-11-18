import wollok.game.*
import juego.*

class Boxeador{
    var property vida = 100
    var property estado = quieto
    var property rival

    method image() =  self.tipo() + estado.nombre() + ".png" //la imagen se cambia sola según el estado

    method cambiarEstado(unEstado){
        estado = unEstado
    }

   method recibirGolpe() {
        vida = 0.max(vida-10)
    }

    method recibirGolpeEspecial() {
        vida = 0.max(vida-20)
    }

    method atacar() {
        self.cambiarEstado(atacando)
        if (rival.estado() != cubriendo){
           rival.recibirGolpe() 
        }
        game.schedule(1000, { self.cambiarEstado(quieto) })
    }

    method atacarEspecial() {
        self.cambiarEstado(atacandoEspecial)
        if (rival.estado() != cubriendo){
           rival.recibirGolpeEspecial() 
        }
        game.schedule(1000, { self.cambiarEstado(quieto) })
    }
    method tipo()
}

object boxeadorJugador inherits Boxeador{
    var property position = game.at(6,0)
    
    method initialize(){
        rival = "" //el rival actual podría ser asignado al jugador por el nivel, así cambia en cada uno
    }

    override method tipo() = "boxeadorJugador"
}

class Oponente inherits Boxeador{
    var property position = game.at(6,5)

    method initialize(){
        rival = boxeadorJugador
    }
}
object joe inherits Oponente{
    override method tipo() = "joe"
}
object rocky inherits Oponente{
    override method tipo() = "rocky"
}

object tyson inherits Oponente{
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
object victoria {
  method nombre() = "Victoria"
}