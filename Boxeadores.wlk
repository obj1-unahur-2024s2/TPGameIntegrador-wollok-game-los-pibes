import pantallas.*
import wollok.game.*
import juego.*
import imagenYSonido.*

class Boxeador{
    var property vida = 100
    var property estado = quieto
    var property rival

    method image() =  self.tipo() + estado.nombre() + ".png" //la imagen se cambia sola según el estado
    method probabilidadDeFallar() = 0

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
    method yaNoPelea() = estado.nombre() == "Derrota" || estado.nombre() == "Victoria"
    method estaQuieto() = estado.nombre() == "Quieto"

    method prepararGolpe(tipoDeGolpe){ //tipo 1: golpe normal, tipo 2: golpe especial
        self.estado(preparandoGolpe)
        game.schedule(1200, {
            if(tipoDeGolpe == 1 && estado.nombre() == "PreparandoGolpe"){self.atacar()}
            else if (estado.nombre() == "PreparandoGolpe"){self.atacarEspecial()}
        })
    }

    method atacar() {
        if(!mario.sePuedePelear() || rival.yaNoPelea()) {self.error("")}

        const fallaElGolpe = (0.randomUpTo(self.probabilidadDeFallar())).round() > 1

        if(fallaElGolpe) {
            self.estado(fallando) 
            game.schedule(500, { self.descansar() })
        } 
        else {self.concretarAtaqueNormal()}
    }

    method concretarAtaqueNormal(){
        self.estado(atacando)

        if (!rival.estaProtegido()){
           rival.recibirGolpe()
           pantallaNivel.verificarVida()
           gestorSonidos.sonidoGolpe()
        } else {gestorSonidos.sonidoBloqueo()}

        game.schedule(600, { self.descansar() })
    }

    method atacarEspecial() {
        if(!mario.sePuedePelear() || rival.yaNoPelea()) {self.error("")}

        self.estado(atacando)

        if (!rival.estaProtegido()){
            rival.recibirGolpeEspecial() 
            pantallaNivel.verificarVida()
            gestorSonidos.sonidoGolpeEspecial()
        } else {gestorSonidos.sonidoBloqueo()}

        game.schedule(1000, { self.descansar() })
    }

    method cubrirse() {
        self.estado(cubriendo)
        game.schedule(2000, { self.descansar() })
    }

    method descansar() {
        if(self.yaNoPelea()) {self.error("")}
        estado = quieto
    }

    method reiniciar(){
        vida = 100
        estado = quieto
    }

    method tipo()
}

object boxeadorJugador inherits Boxeador{
    var property position = game.at(6,0)
    
    method initialize(){
        rival = ""
    }

    override method tipo() = "boxeadorJugador"
    override method probabilidadDeFallar() = 2

    override method recibirGolpe() {
        vida = 0.max(vida- 10 * rival.potenciaDeAtaque())
        self.estado(golpeado)
        game.schedule(1500, { self.descansar() })
    }
}

class Oponente inherits Boxeador{
    var property position = game.at(6,4)

    method initialize(){
        rival = boxeadorJugador
    }
    method potenciaDeAtaque()  
}
object joe inherits Oponente{
    override method tipo() = "joe"
    override method potenciaDeAtaque() = 1.5
    override method probabilidadDeFallar() = 4
}
object rocky inherits Oponente{
    override method tipo() = "rocky"
    override method potenciaDeAtaque() = 2
    override method probabilidadDeFallar() = 2
}

object tyson inherits Oponente{
    override method tipo() = "tyson"
    override method potenciaDeAtaque() = 4
}

//Estados

object quieto {
  method nombre() = "Quieto"
  method protege() = false
}

object preparandoGolpe{
    method nombre() = "PreparandoGolpe"
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

object fallando {
  method nombre() = "Fallando"
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