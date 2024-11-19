import wollok.game.*
import juego.*

class Boxeador{
    var property vida = 100
    var property estado = quieto
    var property rival

    method image() =  self.tipo() + estado.nombre() + ".png" //la imagen se cambia sola según el estado

   method recibirGolpe() {
        vida = 0.max(vida-10)
        self.estado(golpeado)
        game.schedule(1500, { self.descansar() })
    }

    method recibirGolpeEspecial() {
        vida = 0.max(vida-20)
        self.estado(golpeado)
        game.schedule(1500, { self.descansar() })
    }

    method estaProtegido() = estado.protege()

    method atacar() {
        self.estado(atacando)

        if (not rival.estaProtegido()){
           rival.recibirGolpe() 
        }

        game.schedule(1000, { self.descansar() })
    }

    method atacarEspecial() {
        self.estado(atacandoEspecial)

        if (not rival.estaProtegido()){
           rival.recibirGolpeEspecial() 
        }

        game.schedule(1000, { self.descansar() })
    }

    method cubrirse() {
        self.estado(cubriendo)
        game.schedule(3000, { self.descansar() })
    }

    method descansar() {
        estado = quieto
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
  method protege() = false
}

object atacando {
  method nombre() = "Atacando"
  method protege() = false
}

object atacandoEspecial {
  method nombre() = "AtacandoEspecial"
  method protege() = false
}

object cubriendo {
  method nombre() = "Cubriendo"
  method protege() = true
}

object golpeado {
  method nombre() = "Golpeado"
  method protege() = true
}
object victoria {
  method nombre() = "Victoria"
  method protege() = true
}

object derrota{
    method nombre() = "Derrota"
    method protege() = true
}